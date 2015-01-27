#!/usr/bin/env ruby

require 'fileutils'
load 'preprocessing.rb'

#########################################################################

@single = @multiple = false
@trace_dir

def check_arguments
  puts "checking arguments"
  missing_arguments = (ARGV.size < 2)

  if (missing_arguments)
    abort ("Syntax: ./run.rb <directory of traces> <-s single | -m multiple > [options]")
  end

  @trace_dir = ARGV[0]
  if (!Dir.exist?(@trace_dir)) 
    abort("Cannot find directory '#{@trace_dir}'")
  elsif (Dir[@trace_dir].empty?)
    abort("'#{@trace_dir}' is empty")
  end

  actor_flag = ARGV[1]
  if (actor_flag == '-s')
    @single = true
  elsif (actor_flag == '-m')
    @multiple = true
  else
    abort("Second argument given as '-s' for single actors, '-m' for multiple actors.")
  end
end

#########################################################################
                    
check_arguments     
clean_data(@trace_dir)
#map_traces_to_boxes        
#make_inferences
#print_truth_tables
