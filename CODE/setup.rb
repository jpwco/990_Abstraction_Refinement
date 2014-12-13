load 'properties.rb'

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

@boxes = make_boxes(@partition_specs)
@bt1 = map_to_boxes(@pos_trace, @partition_specs, @volume_dimensions)
@bt2 = [100, 11, 221, 421, 44]
@bt3 = [1, 400, 10, 22, 418]
@bt4 = [999,999,999,999,999]
@traces = [@bt1,@bt2,@bt3,@bt4]

=begin
puts "Mobility map as hash; given successive traces of a single entity"
puts "outer_hash keys   : boxes found in any of the traces"
puts "           values : inner_hash"
puts "inner_hash keys   : boxes found succeeding current box in trace"
puts "           values : number of succession occurrences"
p make_mobility_map(@succ_traces)
=end

