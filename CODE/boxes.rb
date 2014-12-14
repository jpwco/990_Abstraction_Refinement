load 'aliases.rb'

def map_to_boxes ( pos_trace, cube_size, dims )
  box_trace = []
  new_dims = cube_dims(cube_size,dims)
  parts = cube_parts(cube_size,new_dims)
  boxes = make_boxes(parts)
  pos_trace.each { |pos| box_trace << map_to_box( pos, boxes, parts, new_dims ) }
  return box_trace
end

def map_to_coords ( pos_trace, parts, dims )
  coord_trace = []
  pos_trace.each { |pos| coord_trace << pos_to_coords( pos, parts, dims ) }
  return coord_trace
end

def map_to_box ( pos, boxes, parts, dims )
  coords = pos_to_coords(pos, parts, dims)
  return box_index(boxes, coords)
end

def timestamp_map ( trace, box_trace )
  hash = {}
  box_trace.each_with_index { |box,i| hash[trace[i].time] = [box,trace[i].yaw] }
  return hash
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

def cube_dims ( cube_size, dims )
  new_dims = []
  rough_parts = dims.map { |dim| dim/cube_size.to_f }
  rough_parts.each { |rp| (rp%1 == 0) ? new_dims << rp*cube_size : new_dims << (rp.to_i+1)*cube_size }
  return new_dims
end

def cube_parts ( cube_size, dims )
  dims.map { |d| (d/cube_size).to_i }
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
