#!/usr/bin/ruby
require 'sqlite3'

begin
	if ARGV.length != 2
		puts "Script requires 2 paths for files to compare" 
	elsif ARGV[0] == ARGV[1]
		puts "There is nothing to compare. The files are identical"
	else
		db = SQLite3::Database.open "./resources/database_folder/test.db"
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
			puts "Received file path does not exist (check first parameter for this script)"
		elsif referenceFileID == nil
			puts "Reference file path does not exist (check second parameter for this script)"
		else
			ins = db.prepare("INSERT INTO File_Difference (DifferenceFileID, ReferenceFileID, LineText)
			VALUES(?,?,?)")
			newFile = File.readlines(ARGV[0])
			previousFile = File.readlines(ARGV[1])
			
			diff = newFile - previousFile
			if diff.empty?
				puts "There is nothing to compare. The files are identical"
			else
				diff.each do |row|
					ins.execute(differenceFileID, referenceFileID, row) # added lines
				end
				
				diff2 = previousFile - newFile
				diff2.each do |row|
					ins.execute(referenceFileID, differenceFileID, row) # removed lines
				end
			end
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
