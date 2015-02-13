load 'aliases.rb'
# simple versions of translate, scale, rotate

# TRANSLATE
#######################################################################

def exact_translation? ( coord_trace_1, coord_trace_2 )
  return false if coord_trace_1.size != coord_trace_2.size
  return each_step_equivalent?(coord_trace_1, coord_trace_2)
end

def each_step_equivalent? ( ct1, ct2 )
  ct1.each_with_index do |b, i|
    return true if ct1[i+1].nil?
    step_description_1 = coordinate_difference(ct1[i],ct1[i+1])
    step_description_2 = coordinate_difference(ct2[i],ct2[i+1])
    return false if step_description_1 != step_description_2
  end
end

def coordinate_difference ( c1, c2 )
  return c2.zip(c1).map { |pair|  pair.reduce(&:-) }
end


# SCALE
#######################################################################
# NOTE: this implementation assumes the coordinate trace is 'well-behaved',
#       meaning no teleports and no diagonal transitions

def exact_scale? ( coord_trace_a, coord_trace_b )
  map_a = build_line_segment_map(coord_trace_a)
  map_b = build_line_segment_map(coord_trace_b)
  return false if map_a.size != map_b.size
  a_scale = map_a.first.seg_length
  b_scale = map_b.first.seg_length
  ratio = a_scale / b_scale.to_f
  map_a.each_with_index do |c, i|
    if ((map_a[i].direction  != map_b[i].direction) ||
        (map_a[i].seg_length != ratio * map_b[i].seg_length))
      return false
    end
  end
  return true
end

def build_line_segment_map ( coord_trace )
  segment_map = []
  curr_direction = nil; next_direction = nil
  coord_trace.each_with_index do |c, i|
    return segment_map if coord_trace[i+1].nil?
    next_direction = get_direction(coord_trace[i],coord_trace[i+1])
    if (next_direction != curr_direction && next_direction != :no_change)
      segment_map << [1,next_direction]
      curr_direction = next_direction
    elsif (next_direction == curr_direction)
      segment_map.last[0] += 1
    end
  end
end

def get_direction ( c1, c2 )
  diff = coordinate_difference(c1,c2)
  return :x_plus  if diff.x > 0
  return :x_minus if diff.x < 0
  return :y_plus  if diff.y > 0
  return :y_minus if diff.y < 0
  return :z_plus  if diff.z > 0
  return :z_minus if diff.z < 0
  return :no_change
end


# ROTATE
#######################################################################

require 'Matrix'

# We will only look at quarter-rotations right now;
# when I used the actual sin function with PI/2, 
# there were floating point approximation problems
def sin(degree)
  case degree
  when 0   then  0
  when 90  then  1
  when 180 then  0
  when 270 then -1
  when 360 then  0
  end
end

def cos(degree)
  case degree
  when 0   then  1
  when 90  then  0
  when 180 then -1
  when 270 then  0
  when 360 then  1
  end
end

# You can rotate a (trace) matrix in three dimensional
# space by multiplying the below rotation matrix by 
# that column (trace) matrix
#
# This formula was taken from the wikipedia on 
# "Rotation Matrix"
def rotation_matrix(x,y,z,t)
  return Matrix.rows([
    [ x*x*(1-cos(t))+cos(t),   y*x*(1-cos(t))-z*sin(t), z*x*(1-cos(t))+y*sin(t) ],
    [ x*y*(1-cos(t))+z*sin(t), y*y*(1-cos(t))+cos(t),   z*y*(1-cos(t))-x*sin(t) ],
    [ x*z*(1-cos(t))-y*sin(t), y*z*(1-cos(t))+x*sin(t), z*z*(1-cos(t))+cos(t)   ]
  ])
end

##########################################################

def ninety_rotation(x,y,z)
  return rotation_matrix(x,y,z,90)
end

def one_eighty_rotation(x,y,z)
  return rotation_matrix(x,y,z,180)
end

def two_seventy_rotation(x,y,z)
  return rotation_matrix(x,y,z,270)
end

def equivalent?(trace_1, trace_2)
  return trace_1 == trace_2
end

##########################################################

def x_unit_vector
  return [1,0,0]
end

def y_unit_vector
  return [0,1,0]
end

def z_unit_vector
  return [0,0,1]
end

##########################################################

def rotation_about_x? ( tr1_matrix, tr2_matrix )
  if tr1_matrix == ninety_rotation(*x_unit_vector) * tr2_matrix
    return "90 degree rotation about x"
  elsif tr1_matrix == one_eighty_rotation(*x_unit_vector) * tr2_matrix
    return "180 degree rotation about x"
  elsif tr1_matrix == two_seventy_rotation(*x_unit_vector) * tr2_matrix
    return "270 degree rotation about x"
  else
    return "no rotation about x"
  end
end

def rotation_about_y? ( tr1_matrix, tr2_matrix )
  if tr1_matrix == ninety_rotation(*y_unit_vector) * tr2_matrix
    return "90 degree rotation about y"
  elsif tr1_matrix == one_eighty_rotation(*y_unit_vector) * tr2_matrix
    return "180 degree rotation about y"
  elsif tr1_matrix == two_seventy_rotation(*y_unit_vector) * tr2_matrix
    return "270 degree rotation about y"
  else
    return "no rotation about y"
  end
end

def rotation_about_z? ( tr1_matrix, tr2_matrix )
  if tr1_matrix == ninety_rotation(*z_unit_vector) * tr2_matrix
    return "90 degree rotation about z"
  elsif tr1_matrix == one_eighty_rotation(*z_unit_vector) * tr2_matrix
    return "180 degree rotation about z"
  elsif tr1_matrix == two_seventy_rotation(*z_unit_vector) * tr2_matrix
    return "270 degree rotation about z"
  else
    return "no rotation about z"
  end
end

##########################################################

def rotation? ( trace_1, trace_2 )
  if equivalent?(trace_1,trace_2) then return "equivalent traces" end

  tr1_matrix = Matrix.columns(trace_1)
  tr2_matrix = Matrix.columns(trace_2)
  
  puts rotation_about_x?(tr1_matrix, tr2_matrix)
  puts rotation_about_y?(tr1_matrix, tr2_matrix)
  puts rotation_about_z?(tr1_matrix, tr2_matrix)
end
