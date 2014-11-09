load 'aliases.rb'

def map_to_boxes ( pos_trace, boxes )
  box_trace = []
  pos_trace.each { |pos| box_trace << map_to_box( pos, boxes ) }
  return box_trace
end

def map_to_box ( pos, boxes )
  box_index = boxes.find_index { |box| 
   ((pos.x >= box.x.lower && pos.x < box.x.upper) &&
    (pos.y >= box.y.lower && pos.y < box.y.upper) &&
    (pos.z >= box.z.lower && pos.z < box.z.upper)) }
  return box_index
end

# INPUT:  - parts is a 3-tuple of # of partitions for each axis
#         - dims is a 3-tuple of dimension magnitudes
# OUTPUT: returns an array of the partitioned boxes of space,
#         where any box = [[x_low,x_up],[y_low,y_up],[z_low,z_up]]
def make_boxes ( parts, dims )
  x_segs = segment(parts.x,dims.x)
  y_segs = segment(parts.y,dims.y)
  z_segs = segment(parts.z,dims.z)
  boxes = x_segs.product(y_segs,z_segs)
  return boxes
end

# returns an array of n segments, where
# each seg = [low_bound_of_seg,up_bound_of_seg]
def segment ( n, entire_length )
  low_bound = 0.0; segments = []
  for i in 1..n
    up_bound = (i.to_f/n) * entire_length
    segments << [low_bound,up_bound]
    low_bound = up_bound
  end
  return segments
end

###############
### EXAMPLE ###
###############

# x,y,z axes will each be split into 10 parts
partition_specs   = [10,10,10]
volume_dimensions = [20,20,20]

# each position event as [x_pos,y_pos,z_pos]
pos_trace = [
  [0.5,0.5,0.0],  #occupying box 0
  [2.5,2.5,0.0],  #occupying box 110
  [5.2,5.8,2.1],  #occupying box 221
  [8.1,5.6,4.3],  #occupying box 422
  [0.1,8.1,6.2]   #occupying box 43
]
puts "Given a position trace of:"; p pos_trace

# with given partitions, there will be 10*10*10=1000 boxes
boxes = make_boxes(partition_specs, volume_dimensions)
# uncomment below to see bounds of box 110
# puts "The bounds of box 110 are:"; p boxes[110] 
box_trace = map_to_boxes(pos_trace,boxes)
puts "The flight path through space-boxes is:"
p box_trace
