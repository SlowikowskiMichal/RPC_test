#!/usr/bin/ruby
require 'sqlite3'

begin
	if ARGV.empty?
		puts "No file path given"
	elsif ARGV.length != 4
		puts "Script requires a file path and 3 result inputs" 
	else		
		db = SQLite3::Database.open "test.db"
		db.execute("PRAGMA Foreign_keys = ON")
		db.execute "CREATE TABLE IF NOT EXISTS File_Result
		(	Id INTEGER PRIMARY KEY,
			FileID INTEGER,
			stdout_str TEXT,
			error_str TEXT,
			status TEXT,
			CONSTRAINT fk_file
				FOREIGN KEY (FileID)
				REFERENCES File(Id)
		)"
		arg = "'" + ARGV[0] + "'"
		val = db.get_first_value "SELECT Id FROM File WHERE Path = #{arg} ORDER BY Id DESC"
		if val != nil
			ins = db.prepare('INSERT INTO File_Result (FileID, stdout_str, error_str, status) VALUES (?,?,?,?)')
			ins.execute(val,ARGV[1],ARGV[2],ARGV[3])
		else
			puts "Specified file was not found"
		end
	end
rescue SQLite3::Exception => e 
    puts "Exception occurred"
    puts e
ensure
	ins.close if ins
	stm.close if stm
    db.close if db	
end