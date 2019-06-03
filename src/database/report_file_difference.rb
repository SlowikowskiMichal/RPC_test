#!/usr/bin/ruby
require 'sqlite3'

begin
	if ARGV.length != 2
		puts "Script requires 2 paths for files to compare" 
	elsif ARGV[0] == ARGV[1]
		puts "There is nothing to compare. The files are identical"
	else
		db = SQLite3::Database.open "test.db"
		db.execute("PRAGMA Foreign_keys = ON")
		db.execute "CREATE TABLE IF NOT EXISTS File_Difference
		(	Id INTEGER PRIMARY KEY,
			DifferenceFileID INTEGER,
			ReferenceFileID INTEGER,
			LineText TEXT,
			CONSTRAINT fk_file_newfile
				FOREIGN KEY (DifferenceFileID)
				REFERENCES File(Id),
			CONSTRAINT fk_file_prevfile
				FOREIGN KEY (ReferenceFileID)
				REFERENCES File(Id)
		)"
		arg0 = "'" + ARGV[0] + "'"
		differenceFileID = db.get_first_value "SELECT Id FROM File WHERE Path = #{arg0} ORDER BY Id DESC"
		arg1 = "'" + ARGV[1] + "'"
		referenceFileID = db.get_first_value "SELECT Id FROM File WHERE Path = #{arg1} ORDER BY Id DESC"
		
		if differenceFileID == nil
			puts "First file path does not exist (check first parameter for this script)"
		elsif referenceFileID == nil
			puts "Second file path does not exist (check second parameter for this script)"
		else
			stm = db.prepare('SELECT LineText FROM File_Difference WHERE DifferenceFileID = ?')
			stm2 = db.prepare('SELECT LineText FROM File_Difference WHERE ReferenceFileID = ?')
			rs = stm.execute(differenceFileID)
			puts "Lines ADDED in Received File"
			rs.each do |row|
				puts row.join "\s"
			end
			puts "\nLines REMOVED from Received File"
			rs = stm2.execute(differenceFileID)
			rs.each do |row|
				puts row.join "\s"
			end
		end
	end
rescue SQLite3::Exception => e 
    puts "Exception occurred"
    puts e
ensure
	stm.close if stm
	stm2.close if stm2
    db.close if db	
end