require 'optparse'
require 'fileutils'

def get_destination_file(filename, source, destination) 
	destination + filename.sub(source, '')
end

def compare_files(path, source, destination, force_copy=false)
	Dir[path].each do |f|
		if File.file?(f)
			f2 = get_destination_file(f, source, destination)
			if !File.exists?(f2) 
				puts "#{f2} is missing in destination folder. Copy? y/n: "
				copy = gets.chomp.downcase
				puts "copy: #{copy}"
				while copy != 'y' && copy != 'n'
					puts "Wrong entry (#{copy}), try again y/n :"
					copy = gets.chomp.downcase
				end
				if copy == 'y'
          dirname = File.dirname(f2)
					if !File.directory?(dirname)
            FileUtils.makedirs(dirname)
          end
          FileUtils.cp(f, f2)
				end
			end
		else File.directory?(f)
			compare_files(f+'/*', source, destination, force_copy)
		end
	end
end


options = {}
option_parser = OptionParser.new do |opts|
	opts.on("-s SOURCE", "Source folder you want to compare/backup") do |source|
		options[:source] = source
	end

	opts.on("-d DESTINATION", "Destination folder you want to compare/copy to") do |destination|
		options[:destination] = destination
	end

	opts.on("-f", "--force", "Force copying missing files") do
		options[:force] = true
	end
end

option_parser.parse!

if !options[:source] or !options[:destination]
	puts option_parser.to_s
	exit(1)
end	

compare_files(options[:source], options[:source], options[:destination], options[:force_copy])
