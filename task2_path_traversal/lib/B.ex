defmodule B do
  @moduledoc """
    A module that implements functions for
    path planning algorithm and travels the path
    """

    @cell_map %{ 1 => [4],
                  2 => [3, 5],
                  3 => [2],
                  4 => [1, 7],
                  5 => [2, 6, 8],
                  6 => [5, 9],
                  7 => [4, 8],
                  8 => [5, 7],
                  9 => [6]
    }

    @matrix_of_sum [
      ["na","na", 15],
      ["na", "na", 12],
      ["na", 10, "na"]
    ]

  def f(matrix_of_sum \\ @matrix_of_sum) do
    matrix_of_sum
    |>List.flatten()
    |>Enum.with_index(fn element, index -> {index+1, element} end)
    |>Enum.filter(fn {_index,element} -> is_integer(element) end)
    |>Enum.reduce([],fn {index,_element},acc -> acc ++ [index] end)
  end
  def i(cell_map \\ @cell_map ,start \\ 1,goal \\ 5) do
    # neighbor = Map.fetch!(cell_map,start)
    i(cell_map, start, goal,[],Map.fetch!(cell_map,start),[])
  end
  defp i(_,start,goal,_,_,path) when start == goal do
    path++[start]
  end
  defp i(cell_map,start,goal,visited,[],path) when start != goal do
    new_path = path -- [start]
    previous = List.last(new_path)
    new_visited = visited ++ [start]

    # IO.inspect(previous,label: "previous for #{start}")
    # IO.inspect(new_path,label: "new_path for #{start}")
    # IO.inspect(new_visited,label: "new_visited for #{start}")
    i(cell_map,previous,goal,new_visited,Map.fetch!(cell_map,previous)--new_visited,new_path)
  end
  defp i(cell_map,start,goal,visited,neighbor,path) do
    path = path -- [start]
    for i <- neighbor do
      if Enum.member?(visited,i) == false do
        new_visited = visited ++ [start]
        new_path = path ++ [start]
        # IO.inspect(new_path,label: "new_path for #{start}")
        # IO.inspect(new_visited,label: "new_visited for #{start}")
        i(cell_map,i,goal,new_visited,Map.fetch!(cell_map,i)--new_visited,new_path)
      end
    end
    |>List.flatten()
    |>Enum.uniq()
  end

  def g(list,cell_map,path \\ [])
  def g([_h|[]],_cell_map,path) do
    path
  end
  def g(list, cell_map,path) do
    [h|t] = list
    rem = closest(h,t,cell_map)
    target = List.first(rem)
    path = path ++ [i(cell_map,h,target)]
    g(rem,cell_map,path)
  end
  def closest(a,list,cell_map) do
    Enum.sort(list, &(length(i(cell_map,a,&1)) <= length(i(cell_map,a,&2))))
  end
end
