require 'csv'
require 'set'

# place any csv file from the havelock sampling
# set in the current directory to be used as "test.csv"
@file = "test.csv"

@start_state; @curr_state
@tr_map = Hash.new
@states = Set.new
@CTRL_STATE = 1
@CURR_TASK  = 44
@SUBSTATE   = 59

def make_start_state(file, start_state, curr_state)
  CSV.foreach(file, headers:true) do |first_row|
    @start_state = [first_row[@CTRL_STATE],first_row[@CURR_TASK],first_row[@SUBSTATE]]
    @states << @start_state
    @curr_state = @start_state
    break
  end
end

def check_transition(curr_st, next_st, hash)
  CSV.foreach(@file, headers:true) do |row|
    state = [row[@CTRL_STATE],row[@CURR_TASK],row[@SUBSTATE]]
    unless @curr_state == state
      @states << state
      make_transition(@curr_state, state, hash)
    end
  end
  return hash
end

def make_transition(curr_st, next_st, transition_table)
  changed_element = find_difference(@curr_state, next_st)
  if transition_table[[@curr_state, next_st]].nil?
    transition_table[[@curr_state, next_st]] = Set.new [changed_element]
  else
    transition_table[[@curr_state, next_st]] << changed_element
  end
  @curr_state = next_st
  return transition_table
end

def find_difference(curr_st, next_st)
  @curr_state.each_with_index do |item, index|
    if item != next_st[index]
      return [index, next_st[index]] 
    end
  end
end

make_start_state(@file, @start_state, @curr_state)
puts "The start state is #{@start_state}"
final_hash = check_transition(@start_state, @curr_state, @tr_map)
puts "There are #{@states.size} states, which are:"
p @states
puts "There are #{final_hash.size} unique transitions in the table, whose contents are:"
p final_hash
