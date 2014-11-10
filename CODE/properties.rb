#check for interference
def space_independence ( traces )
  independence_arr = Array.new(traces.size, true)
  traces.each_with_index do |trace, tr|
    trace.each_with_index do |pos, j|
      traces.each_with_index do |other_trace, o_tr|
        if pos == other_trace[j]
          unless tr == o_tr
            #puts "space independence violated by trace #{o_tr} at position #{j}"
            independence_arr[tr] = false
          end
        end 
      end
    end
  end
  return independence_arr
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

puts "Space independence table for given concurrent traces:"
puts
p space_independence(@concurrent_traces)
puts
puts "Mobility map as hash; given successive traces of a single entity"
puts "outer_hash keys   : boxes found in any of the traces"
puts "           values : inner_hash"
puts "inner_hash keys   : boxes found succeeding current box in trace"
puts "           values : number of succession occurrences"
puts
p make_mobility_map(@succ_traces)
