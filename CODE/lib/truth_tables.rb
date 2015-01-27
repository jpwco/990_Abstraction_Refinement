load 'properties.rb'

#check for interference
def point_independence_table ( traces )
  point_ind_table = Array.new(traces.size) { Array.new(traces.size, true) }
  traces.each_with_index do |trace, tr_id|
    trace.each_with_index do |box_1, time_frame|
      traces.each_with_index do |other_trace, o_tr_id|
        box_2 = other_trace[time_frame]
        unless tr_id == o_tr_id
          if box_1 == box_2
            #puts "space independence violated by trace #{o_tr} at position #{j}"
            point_ind_table[tr_id][o_tr_id] = false
          end
        end
      end
    end
  end
  return point_ind_table
end

def fuzzy_independence_table ( traces, boxes, bound_size )
  fuzzy_ind_table = Array.new(traces.size) { Array.new(traces.size, true) }
  traces.each_with_index do |trace, tr_id|
    trace.each_with_index do |box_1, time_frame|
      traces.each_with_index do |other_trace, o_tr_id|
        box_2 = other_trace[time_frame]
        unless ((box_1.nil? || box_2.nil?) || (tr_id == o_tr_id))
          if boundary_overlap?(boxes[box_1],boxes[box_2],boxes,bound_size)
            fuzzy_ind_table[tr_id][o_tr_id] = false
          end
        end
      end
    end
  end
  return fuzzy_ind_table
end

def point_crumb_table ( traces, boxes )
  point_crumb_table = Array.new(traces.size) { Array.new(traces.size, true) }

  p_crumb_space = traces.map{ |tr| point_crumb_space(tr) }
  p_crumb_space.each_with_index do |pcs_1, i_1|
    p_crumb_space.each_with_index do |pcs_2, i_2|
      point_crumb_table[i_1][i_2] = point_crumb_ind?(pcs_1,pcs_2)
    end 
  end 
  return point_crumb_table
end

def fuzzy_crumb_table ( traces, boxes, bound_size )
  fuzzy_crumb_table = Array.new(traces.size) { Array.new(traces.size, true) }
  fuzzy_traces = traces.map {|tr| make_fuzzy_path(tr,boxes,bound_size)}

  f_crumb_space = fuzzy_traces.map{ |ftr| fuzzy_crumb_space(ftr) }
  f_crumb_space.each_with_index do |fcs_1, i_1|
    f_crumb_space.each_with_index do |fcs_2, i_2|
      fuzzy_crumb_table[i_1][i_2] = fuzzy_crumb_ind?(fcs_1,fcs_2)
    end 
  end 
  return fuzzy_crumb_table
end
