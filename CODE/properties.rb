load 'boxes.rb'

def moves? ( box_trace )
  box_trace.uniq.size > 1
end

def returns_home? ( box_trace )
  home = box_trace.first
  box_trace.each_index.select { |i| (box_trace[i] == home) && (i>0) && (box_trace[i-1] != home) }
end

#all but home revisits
def revisit_map ( bt )
  revisit_map = {}
  rv_boxes = bt.select { |b| bt.count(b) > 1 }.uniq
  rv_boxes.each { |b| revisit_map[b] = (bt.each_index.select{|i| (bt[i]==b) && (i>0) && (bt[i-1]!=bt[i])}) }
  revisit_map.delete_if { |key,value| value.size < 2 }
  return revisit_map
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

def point_crumb_ind? ( a_space, b_space )
  (a_space & b_space).empty?
end

def fuzzy_crumb_ind? ( a_space, b_space )
  (a_space & b_space).empty?
end

def is_there? ( pos, trace, time_frame, boxes )
  pos == (boxes[trace[time_frame]])
end
