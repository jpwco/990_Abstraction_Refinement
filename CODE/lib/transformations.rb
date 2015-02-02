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
  return c1.zip(c2).map { |pair|  pair.reduce(&:-) }
end


# SCALE
#######################################################################


# ROTATE
#######################################################################
