defmodule A do
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

  def i(matrix_of_sum \\ @matrix_of_sum) do
    matrix_of_sum
    |>List.flatten()
    |>Enum.with_index(fn element, index -> {index+1, element} end)
    |>Enum.filter(fn {_index,element} -> is_integer(element) end)
    |>Enum.reduce([],fn {index,_element},acc -> acc ++ [index] end)
  end
  def f(cell_map \\ @cell_map, start \\ 1, goal \\ 9, visited \\ List.duplicate(false,10),path \\ [],collection \\ [])
  def f(_cell_map, start, goal, _visited, path,_collection) when start == goal do
    final_path = path++[goal]
    IO.inspect(final_path,label: "final answer")
  end
  # def f(_cell_map, start, goal, _visited, path) when start == goal do
  #   path |> Enum.reverse() |> tl() |> Enum.reverse()
  # end
  # def f(cell_map, a, goal) when cell_map[a] == [] do
  #   :nil
  # end
  def f(cell_map , start , goal, visited,path,collection) do
    visited = List.replace_at(visited,start,true)
    # IO.inspect(start)


    value = for i <- 1..length(Map.fetch!(cell_map,start)) do
      # IO.inspect(i)
      next = Enum.at(Map.fetch!(cell_map,start),i-1)
      # IO.inspect(next,label: "next")
      # IO.inspect(visited,label: "visited")
      if Enum.at(visited,next) == false do
        # path ++ [next+1]
        path = path ++ [start]
        j = f(cell_map,next,goal,visited,path,collection)
        if List.last(j)==goal do
          collection = j
          IO.inspect(collection,label: "j1 found")
        end
        # end
        # else
          #   path |> Enum.reverse() |> tl() |> Enum.reverse()
      else
        path = path -- [start]
        IO.inspect(path,label: "path from else found")
      end
    end
    IO.inspect(collection,label: "collection stack found")
    collection
    # Enum.flat_map(value,&[[value | &1], &1])
    # collection = collection ++ value
    # Enum.each(1..length(Map.fetch!(cell_map,start)),fn i->

    #   # IO.inspect(i)
    #   next = Enum.at(Map.fetch!(cell_map,start),i-1)
    #   # IO.inspect(next,label: "next")
    #   # IO.inspect(visited,label: "visited")
    #   if Enum.at(visited,next) == false do
    #     # path ++ [next+1]
    #     path ++ f(cell_map,next,goal,visited,path)
    #   end
    # end)
    # IO.inspect(path)
    # List.flatten(value)
    # Enum.filter(value,fn x -> !(Enum.at(x,-1) == nil) end)
    # path++value
    # IO.inspect(value, label: "value")
    # IO.inspect(collection, label: "collection")
    # path
    # path ++ [start]
    # visited = List.replace_at(visited,start,false)
    # IO.inspect(final_path,label: "fin")
  end
end
