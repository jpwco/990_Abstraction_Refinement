require 'csv'
require 'fileutils'
load 'aliases.rb'

# MAIN METHOD
#########################################################################

def clean_data ( trace_dir )
  puts "cleaning data"
  puts "making 'temp_csv' directory to store positional .csv traces"
  make_temp_csv_directory
  Dir.foreach(trace_dir) do |file|
    next if file.start_with?('.')
    read(full_path(trace_dir,file), trace_dir)
  end
end

# READING/WRITING CSV AND BAG FILES
#########################################################################

# returns an implicitly timestamped
# 3-column .csv file
def read ( file, trace_dir )
  extension = File.extname(file)
  case extension
  when '.csv' then read_csv(file)
  when '.bag' then read_bag(file,trace_dir)
  else abort("file extension #{extension} not supported")
  end
end

def read_csv ( file )
  puts 'reading csv'
  xyz_columns = find_positional_columns(file)
  write_positional_csv(file, xyz_columns)
end

def read_bag ( bag_file, trace_dir )
  puts 'reading bag file'
  make_bag_to_csv_directory
  csv_file = bag_to_csv(bag_file,trace_dir)
  read_csv(csv_file)
end

def bag_to_csv ( bag_file, trace_dir )
  puts 'running bag_to_csv'
  system("bag2csv.py #{bag_file}")
  basename = File.basename(bag_file,'.bag')
  csv_file = basename+'.csv'
  system("mv #{trace_dir}/#{csv_file} bag_to_csv")
  return "bag_to_csv/#{csv_file}"
end

def find_positional_columns ( file )
  header = CSV.read(file).first
  x_col = header.index {|col| col.include?('subject_pose__translation_x') unless col.nil?}
  y_col = header.index {|col| col.include?('subject_pose__translation_y') unless col.nil?}
  z_col = header.index {|col| col.include?('subject_pose__translation_z') unless col.nil?}
  return [x_col, y_col, z_col]
end

def grab_column_data ( file, xyz_columns )
  x_data = []; y_data = []; z_data = []
  CSV.foreach(file) {|row| x_data << row[xyz_columns[0]]}
  CSV.foreach(file) {|row| y_data << row[xyz_columns[1]]}
  CSV.foreach(file) {|row| z_data << row[xyz_columns[2]]}
  return [x_data, y_data, z_data].transpose
end

def write_positional_csv ( file, xyz_columns )
  puts 'creating and writing a csv file with 3 columns to the pos_csv directory'
  refined_csv = grab_column_data(file,xyz_columns)
  file_string = file.split('/').last
  CSV.open('temp_csv/'+file_string, 'ab') do |csv|
    refined_csv.each do |row|
        csv << row
    end
  end
end

# SETUP/TEARDOWN FOR TEMP DIRECTORIES
#########################################################################

def make_temp_csv_directory
  unless File.directory?('temp_csv')
    FileUtils.mkdir_p('temp_csv')
  end
end

def make_bag_to_csv_directory
  unless File.directory?('bag_to_csv')
    FileUtils.mkdir_p('bag_to_csv')
  end
end

# NORMALIZE POSITIONAL DATA
#########################################################################

def normalize_positional_data ( trace_dir )
  negs= negative_values(trace_dir)
  norm = make_normalizing_array(negs)
  normalize_traces(trace_dir, norm)
end

def negative_values ( trace_dir )
  negs = [0,0,0]
  Dir.foreach(trace_dir) do |file|
    next if file.start_with?('.')
    neg = find_neg_values(trace_dir+'/'+file)
    if neg.x < negs.x then negs[0] = neg.x end
    if neg.y < negs.y then negs[1] = neg.y end
    if neg.z < negs.z then negs[2] = neg.z end
  end
  return mins
end

def find_neg_values ( file )
  x_min = 0; y_min = 0; z_min = 0
  CSV.foreach(file, headers:true) do |row|
    x = row[0].to_f; y = row[1].to_f; z = row[2].to_f
    if x < x_min then x_min = x end
    if y < y_min then y_min = y end
    if z < z_min then z_min = z end
  end
  return [x_min, y_min, z_min]
end

def make_normalizing_array ( mins )
  return mins.map {|coord| coord.floor.abs}
end

def normalize_traces ( trace_dir, norm )
  puts 'normalizing all the traces'
  Dir.foreach(trace_dir) do |file|
    next if (file.start_with?('.') || file.end_with?('_norm.csv'))
    normalize_trace(full_path(trace_dir,file), norm)
  end  
end

def normalize_trace ( file, norm )
  puts 'normalizing single trace file'
  csv_arr = [] 
  CSV.foreach(file, headers:true) do |row|
    x = row[0].to_f; y = row[1].to_f; z= row[2].to_f
    csv_arr << [x+norm.x,y+norm.y,z+norm.z]
  end
  norm_file = add_tag_to_file(file,'_norm')
  CSV.open(norm_file, 'w') do |csv|
    csv_arr.each do |row|
      csv << row
    end
  end
end

def add_tag_to_file ( file_string, tag )
  extension = File.extname(file_string)
  file_string.slice!(extension)
  return file_string+tag+extension 
end

def full_path(dir,file)
  return dir+'/'+file
end

# INFER GLOBAL DIMENSIONS
#########################################################################

def get_global_dimensions ( normalized_trace_dir )
  maxs = max_values(normalized_trace_dir)
  return [maxs.x.ceil, maxs.y.ceil, maxs.z.ceil]
end

def min_values ( trace_dir )
  mins = []
  first_file = true
  Dir.foreach(trace_dir) do |file|
    next if file.start_with?('.')
    if (first_file)
      mins = find_min_values(trace_dir+'/'+file)
      first_file = false
    else
      min = find_min_values(trace_dir+'/'+file)
      if min.x < mins.x then mins[0] = min.x end
      if min.y < mins.y then mins[1] = min.y end
      if min.z < mins.z then mins[2] = min.z end
    end
  end
  return mins
end

def max_values ( trace_dir )
  maxs = []
  first_file = true
  Dir.foreach(trace_dir) do |file|
    next if file.start_with?('.')
    if (first_file)
      maxs = find_max_values(trace_dir+'/'+file)
      first_file = false
    else
      max = find_max_values(trace_dir+'/'+file)
      if max.x > maxs.x then maxs[0] = max.x end
      if max.y > maxs.y then maxs[1] = max.y end
      if max.z > maxs.z then maxs[2] = max.z end
    end
  end
  return maxs
end

def find_min_values ( file )
  x_min = 0; y_min = 0; z_min = 0
  first_row = true
  CSV.foreach(file, headers:true) do |row|
    if (first_row)
      x_min = row[0].to_f; y_min = row[1].to_f; z_min = row[2].to_f
      first_row = false
    else
      x = row[0].to_f; y = row[1].to_f; z = row[2].to_f
      if x < x_min then x_min = x end
      if y < y_min then y_min = y end
      if z < z_min then z_min = z end
    end
  end
  return [x_min, y_min, z_min]
end

def find_max_values ( file )
  x_max = 0; y_max = 0; z_max = 0
  first_row = true
  CSV.foreach(file, headers:true) do |row|
    if (first_row)
      x_max = row[0].to_f; y_max = row[1].to_f; z_max = row[2].to_f
      first_row = false
    else
      x = row[0].to_f; y = row[1].to_f; z = row[2].to_f
      if x > x_max then x_max = x end
      if y > y_max then y_max = y end
      if z > z_max then z_max = z end
    end
  end
  return [x_max, y_max, z_max]
end
