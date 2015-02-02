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
