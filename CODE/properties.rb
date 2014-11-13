load 'boxes.rb'

#check for interference
def point_independence_table ( traces )
  # truth table as 2D array initialized to false
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
  # truth table as 2D array initialized to false
  fuzzy_ind_table = Array.new(traces.size) { Array.new(traces.size, true) }
  traces.each_with_index do |trace, tr_id|
    trace.each_with_index do |box_1, time_frame|
      traces.each_with_index do |other_trace, o_tr_id|
        box_2 = other_trace[time_frame]
        unless tr_id == o_tr_id
          if boundary_overlap?(boxes[box_1],boxes[box_2],boxes,bound_size)
            puts "fuzzy independence violated by trace #{o_tr_id} at time #{time_frame}"
            fuzzy_ind_table[tr_id][o_tr_id] = false
          end
        end 
      end
    end
  end
  return fuzzy_ind_table
end

def point_crumb_table ( traces, boxes )
  # truth table as 2D array initialized to false
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
  # truth table as 2D array initialized to false
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

def make_mobility_map ( succ_traces )
  moves = {}
  succ_traces.each do |ind_trace|
    for i in 0..(ind_trace.size-2)
      moves = add_move(ind_trace[i],ind_trace[i+1],moves)
    end
  end
  return moves
end

def add_move ( pos, next_pos, moves )
  if moves[pos].nil?
    moves[pos] = { next_pos => 1 }
  else
    if moves[pos][next_pos].nil?
      moves[pos][next_pos] = 1
    else
      moves[pos][next_pos] += 1
    end
  end
  return moves
end

def find_neighborhood ( box, boxes, size )
  neighborhood = []
  for x_c in (box.x - size)..(box.x + size)
    for y_c in (box.y - size)..(box.y + size)
      for z_c in (box.z - size)..(box.z + size)
        neighborhood << box_index(boxes,[x_c,y_c,z_c])
      end
    end
  end
  return neighborhood.compact
end

def path? ( a, b, path )
  source = path.find_index(a)
  path[source..-1].include?(b)
end

def same_box? ( box1, box2 )
  box1 == box2
end

def boundary_overlap? ( box_a, box_b, boxes, bound_size )
  a_shell = find_neighborhood(box_a, boxes, bound_size)
  b_shell = find_neighborhood(box_b, boxes, bound_size)
  (a_shell & b_shell).any?
end

def contains? ( box_a, a_bound, box_b, b_bound, boxes )
  a_shell = find_neighborhood(box_a, boxes, bound_size)
  b_shell = find_neighborhood(box_b, boxes, bound_size)
  (b_shell - a_shell).empty?
end

def point_crumb_space ( tr_path )
  return tr_path.uniq
end

def make_fuzzy_path ( box_trace, boxes, size )
  return (box_trace.map {|i| find_neighborhood(boxes[i],boxes,size)}).uniq
end 

def fuzzy_crumb_space ( fuzzy_path )
  return fuzzy_path.flatten.uniq
end

def point_crumb_ind? ( a_space, b_space )
  (a_space & b_space).empty?
end

def fuzzy_crumb_ind? ( a_space, b_space )
  (a_space & b_space).empty?
end

#############
## EXAMPLE ##
#############

# below are traces moving through a
# 3x3x3 space partitioned by unit cubes

# box-traces from separate entities
# moving concurrently
@concurrent_traces = [
  [0,1,2,3,2,1,0],
  [3,4,5,6,2,4,3],
  [1,2,3,4,5,6,7]
]

# box-traces from successive runs
# of a single entity
@succ_traces = [
  [0,1,1,1,2,4,4,5],
  [0,0,1,1,4,5,5,6],
  [0,1,4,5,4,5,6,6]
]

@bt2 = [100, 11, 221, 421, 44]
@bt3 = [1, 400, 10, 22, 418]
@bt4 = [999,999,999,999,999]

=begin
puts "Mobility map as hash; given successive traces of a single entity"
puts "outer_hash keys   : boxes found in any of the traces"
puts "           values : inner_hash"
puts "inner_hash keys   : boxes found succeeding current box in trace"
puts "           values : number of succession occurrences"
p make_mobility_map(@succ_traces)
=end
