load 'transformations.rb'

# Methods
#####################################################

def test_translation ( trace_1, trace_2 )
  t1 = Time.now
  exact_translation?(trace_1, trace_2)
  t2 = Time.now
  delta = t2 - t1
  puts "Elapsed time of translation on trace of size #{trace_1.size} : #{delta} sec"
end

def test_scaling ( trace_1, trace_2 )
  t1 = Time.now
  exact_scale?(trace_1, trace_2)
  t2 = Time.now
  delta = t2 - t1
  puts "Elapsed time of scaling on trace of size #{trace_1.size} : #{delta} sec"
end

def test_rotation ( trace_1, trace_2 )
  t1 = Time.now
  rotation?(trace_1, trace_2)
  t2 = Time.now
  delta = t2 - t1
  puts "Elapsed time of rotation on trace of size #{trace_1.size} : #{delta} sec"
end

# Tests
#####################################################

def repeat_pattern(array, repeat_size)
  big_array = []
  repeat_size.times {|i| array.each {|elem| big_array << elem} }
  return big_array
end

a = [[0,1,0],[0,2,0]]; b = [[0,3,0],[0,4,0]]
a_big = repeat_pattern(a,10000)
b_big = repeat_pattern(b,10000)

test_translation(a_big, b_big)

a = [[0,3,2],[1,4,5]]; b = [[0,6,4],[2,8,10]]
a_big = repeat_pattern(a,10000)
b_big = repeat_pattern(b,10000)

test_scaling(a_big, b_big)

a = [[1,0,1],[2,0,1]]; b = [[1,0,-1],[2,0,-1]]
a_big = repeat_pattern(a,10000)
b_big = repeat_pattern(b,10000)

test_rotation(a_big, b_big)
