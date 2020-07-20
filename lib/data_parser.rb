class DataParser
  attr_reader :types

  def initialize
    @types = %w[.csv]
  end

  def check_type(file_path)
    types.include?(File.extname(file_path))
  end

  def get_data(file_path)
    CSV.parse(File.read(file_path), { col_sep: ';' })
  end
end
