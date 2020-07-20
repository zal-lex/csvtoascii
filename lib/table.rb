class Table
  def initialize(data)
    @data = data
    @columns_sizes = Array.new(@data[0].size, 0)
    @types = @data.shift
    @formated_data = format_data
  end

  def to_cmd
    # Make the line divider
    line_divider = '+'
    @columns_sizes.each do |size|
      line_divider.concat("#{'-' * size}+")
    end
    # Start pringing table
    puts "+#{'-' * (@columns_sizes.sum + @columns_sizes.size - 1)}+"
    @formated_data.each do |block|
      block.each do |row|
        print '|'
        row.each { |cell| print "#{cell}|" }
        print "\n"
      end
      puts line_divider
    end
  end

  private

  def format_data
    formated_data = []
    @data.each do |row|
      formated_block = []
      formated_row = []
      sub_strings = []
      row.each_with_index do |cell, index|
        # fomat cells with their types
        new_cell = format_cell(cell, index)
        # calculate max width for columns
        update_cells_sizes(new_cell, index)
        # create substrings rows for parts of string column with whitespaces
        if new_cell.is_a?(Array)
          buffer = new_cell.shift
          buffer, new_cell = new_cell, buffer
          buffer.each do |element|
            sub_string = Array.new(row.size, '')
            sub_string[index] = element
            sub_strings << sub_string
          end
        end
        # concatenate cells into row
        formated_row << new_cell
      end
      # add row into block of data
      formated_block << formated_row
      # add substrings rows into current block of data
      sub_strings.each do |element|
        formated_block << element
      end
      formated_data << formated_block
    end
    # align data in columns
    align_columns(formated_data)
  end

  def update_cells_sizes(cell, index)
    if cell.is_a?(Array)
      cell_size = cell.max_by(&:size).size
      @columns_sizes[index] = cell_size if @columns_sizes[index] < cell_size
    elsif @columns_sizes[index] < cell.size
      @columns_sizes[index] = cell.size
    end
  end

  def format_cell(cell, index)
    case @types[index]
    when 'int'
      cell
    when 'string'
      if cell.strip[' ']
        cell.split(' ')
      else
        cell
      end
    when 'money'
      formated_cell = cell.to_f.ceil(2).to_s.split('.')
      formated_cell[0] = formated_cell[0].reverse.scan(/.{1,3}/).join(' ').reverse
      formated_cell.join(',')
    end
  end

  def align_columns(formated_data)
    formated_data.map do |block|
      block.map do |row|
        row.map.with_index do |cell, index|
          case @types[index]
          when 'int', 'money'
            ' ' * (@columns_sizes[index] - cell.size) + cell
          when 'string'
            if cell.is_a?(Array)
              cell.map { |substr| substr + ' ' * (@columns_sizes[index] - substr.size) }
            else
              cell + ' ' * (@columns_sizes[index] - cell.size)
            end
          end
        end
      end
    end
  end
end
