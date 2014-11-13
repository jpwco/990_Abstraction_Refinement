load 'aliases.rb'

def map_to_boxes ( pos_trace, boxes, parts, dims )
  box_trace = []
  pos_trace.each { |pos| box_trace << map_to_box( pos, boxes, parts, dims ) }
  return box_trace
end

def map_to_box ( pos, boxes, parts, dims )
  coords = pos_to_coords(pos, parts, dims)
  return box_index(boxes, coords)
end

def pos_to_coords ( pos, parts, dims )
  coords = [lower_unit_bound(pos.x,parts.x,dims.x),
            lower_unit_bound(pos.y,parts.y,dims.y),
            lower_unit_bound(pos.z,parts.z,dims.z)]
  return coords
end

def box_index ( boxes, coords )
  return boxes.find_index { |box| box == [coords.x, coords.y, coords.z] }
  return box_index
end

def lower_unit_bound ( position, partition_num, dimension )
  relative_pos = position / dimension
  low_bound = (relative_pos * partition_num).floor
  return low_bound
end

def unit_array ( u )
  return [*0..(u-1)]
end

def make_boxes ( parts )
  p_array = parts.map { |p| unit_array(p) }
  boxes = p_array.x.product(p_array.y,p_array.z)
  return boxes
end

###############
### EXAMPLE ###
###############

# x,y,z axes will each be split into 10 parts
@partition_specs   = [10,10,10]
@volume_dimensions = [20,20,20]

# each position event as [x_pos,y_pos,z_pos]
@pos_trace = [
  [2.5,1.5,3.0], 
  [1.5,2.5,0.0],
  [5.2,5.8,2.1],
  [8.1,5.6,4.3],
  [0.1,8.1,6.2]
]
@boxes = make_boxes(@partition_specs)
@box_trace = map_to_boxes(@pos_trace, @boxes, @partition_specs, @volume_dimensions)
