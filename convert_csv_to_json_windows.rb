module CsvToJsonConvertor
  require 'csv'
  require 'json'

  puts "Please enter the name of the CSV file."
  name_csv = gets.chomp

  @hash = []

  data = Array.new
  CSV.foreach("./#{name_csv}.csv", { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
    data << row.to_hash
  end

  groupby_uuid = data.group_by {|h| h[:uuid_rubysketch_use_only]}

  def self.yes_no(lite)
    if lite == 'Yes'
      return true
    else
      return false
    end
  end

  def self.lite_position(lite_position)
    if lite_position == 'Bottom'
      return 1
    else
      return 2
    end
  end

  def self.create_hash(data)
    sizes_hash = data.map{|i|
      {
        'name': i[:window_name],
        'height': "#{i[:height]}",
        'width': "#{i[:width]}",
        'top_height': "#{i[:top_height]}",
        'lite': yes_no(i[:lite]),
        'lite_height': "#{i[:lite_height]}",
        'lite_mullions': yes_no(i[:lite_mullions]),
        "lite_position": lite_position(i[:lite_position]),
        'panels_single': i[:panels_sgl],
        'panels_double': i[:panels_dbl],
        'bays': i[:bays],
        'horizontal_panels': i[:h_panels],
        'vertical_panels': i[:v_panels],
      }
    }

    windows_hash = {
      'uuid' => data[0][:uuid_rubysketch_use_only],
      'window_type': data[0][:window_type],
      'range': data[0][:range],
      'unit': data[0][:units],
      'sizes': sizes_hash
    }
    @hash << windows_hash
  end

  hash = groupby_uuid.keys.each{|k|
    data = groupby_uuid[k]
    create_hash(data)
  }

  File.open("./#{name_csv}.json","w") do |f|
    f.write(JSON.pretty_generate(@hash))
  end

  puts 'Your json file has been created successfully.'
end