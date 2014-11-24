require 'csv'

#@file = "line_mod.csv"
@file = "crosses_mod.csv"

@X     = 0
@Y     = 1
@Z     = 2
@x_adj = 3
@y_adj = 2

def make_pos_array(file,x,y,z,x_adj,y_adj)
  pos = []
  CSV.foreach(file, headers:true) do |row|
    unless row[x].nil?
      pos << [row[x].to_f.round(1)+x_adj,row[y].to_f.round(1)+y_adj,row[z].to_f.round(1)]
    end
  end
  return pos
end 

@pos = make_pos_array(@file,@X,@Y,@Z,@x_adj,@y_adj)
@partitions = [15,17,6]
@dimensions = [7.5,8.5,3.0]
