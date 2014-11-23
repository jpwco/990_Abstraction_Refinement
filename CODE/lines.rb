load 'properties.rb'

def endpoints ( boxes, box_1, box_2 )
  return [boxes[box_1],boxes[box_2]]
end

def l_segment ( endpoints )
  #how to represent lines
  return endpoints
end

def make_line_path( box_trace, boxes )
  path = []
  box_trace.each_with_index do |box, i|
    unless box_trace[i+1].nil?
      path << l_segment( endpoints( boxes, box, box_trace[i+1] ))
    end
  end
  return path
end
