#!/usr/bin/ruby
require 'sqlite3'

begin
	if ARGV.empty?
		puts "No file path given"
	else
		db = SQLite3::Database.open "test.db"
	
		db.execute "CREATE TABLE IF NOT EXISTS File(Id INTEGER PRIMARY KEY, 
		Name TEXT, Path TEXT)"
	
		ins = db.prepare('INSERT INTO File (Name, Path) VALUES (?,?)')
		ins.execute(ARGV[0].split('\\')[-1], ARGV[0])
	
		stm = db.prepare('SELECT * FROM File')
	end

rescue SQLite3::Exception => e 
    puts "Exception occurred"
    puts e
ensure
	ins.close if ins
	stm.close if stm
    db.close if db
	
end
