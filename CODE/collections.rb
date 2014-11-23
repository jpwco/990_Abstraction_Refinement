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

def point_crumb_space ( tr_path )
  return tr_path.uniq
end

def make_fuzzy_path ( box_trace, boxes, size )
  return (box_trace.map {|i| find_neighborhood(boxes[i],boxes,size)}).uniq
end 

def fuzzy_crumb_space ( fuzzy_path )
  return fuzzy_path.flatten.uniq
end
