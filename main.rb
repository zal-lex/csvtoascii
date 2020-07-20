require 'csv'
require 'pry'
require_relative 'lib/data_parser'
require_relative 'lib/table'

module App
  def self.run
    # getting path to csv file from ARGV
    file_path = ARGV[0]
    if file_path.nil?
      puts 'Please enter the path to the file with data:'
      file_path = STDIN.gets.chomp
    end
    data_parser = DataParser.new
    # asking path to csv file if it wasn`t entered, if extension unsupported or file does not exist
    until File.exist?(file_path) && data_parser.check_type(file_path)
      puts "Please enter the path to the existing file with correct extension (#{data_parser.types.join(', ')}):"
      file_path = STDIN.gets.chomp
    end
    # parsing data from file
    data = data_parser.get_data(file_path)
    # creating Table class object
    table = Table.new(data)
    table.to_cmd
  end
end

App.run
