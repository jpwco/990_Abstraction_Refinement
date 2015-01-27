def similar_path? ( a_start, a_end, b_start, b_end, boxes )
  a_diff = pos_diff(a_start,a_end,boxes)
  b_diff = pos_diff(b_start,b_end,boxes)
  a_ratios = a_diff.permutation.to_a.map { |arr| calc_ratio(arr) }
  b_ratios = b_diff.permutation.to_a.map { |arr| calc_ratio(arr) }
  (a_ratios & b_ratios).any?
end

def calc_ratio( arr )
  [ (arr.x.zero? || arr.y.zero?) ? 0 : arr.x.to_f/arr.y,
    (arr.y.zero? || arr.z.zero?) ? 0 : arr.y.to_f/arr.z,
    (arr.x.zero? || arr.z.zero?) ? 0 : arr.x.to_f/arr.z  ]
end

def pos_diff ( start_box, end_box, boxes )
  start_coords = boxes[start_box]
  end_coords = boxes[end_box]
  diff(start_coords,end_coords)
end

def diff ( crd1, crd2 )
  [(crd1.x-crd2.x).abs,(crd1.y-crd2.y).abs,(crd1.z-crd2.z).abs]
end
