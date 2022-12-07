defmodule Task2PathTraversal do
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

  @doc """
  #Function name:
          get_locations
  #Inputs:
          A 2d matrix namely matrix_of_sum containing two digit numbers
  #Output:
          List of locations of the valid_sum which should be in ascending order
  #Details:
          To find the cell locations containing valid_sum in the matrix
  #Example call:
          Check Task 2 Document
  """
  def get_locations(matrix_of_sum \\ @matrix_of_sum) do
        matrix_of_sum
        |>List.flatten()
        |>Enum.with_index(fn element, index -> {index+1, element} end)
        |>Enum.filter(fn {_index,element} -> is_integer(element) end)
        |>Enum.reduce([],fn {index,_element},acc -> acc ++ [index] end)
  end

  @doc """
  #Function name:
          cell_traversal
  #Inputs:
          cell_map which contains all paths as well as the start and goal locations
  #Output:
          List containing the path from start to goal location
  #Details:
          To find the path from start to goal location
  #Example call:
          Check Task 2 Document
  """
  def cell_traversal(cell_map \\ @cell_map, start, goal) do
        i(cell_map, start, goal,[],Map.fetch!(cell_map,start),[])
  end
  defp i(_,start,goal,_,_,path) when start == goal do
        path++[start]
      end
      defp i(cell_map,start,goal,visited,[],path) when start != goal do
        new_path = path -- [start]
        previous = List.last(new_path)
        new_visited = visited ++ [start]
        i(cell_map,previous,goal,new_visited,Map.fetch!(cell_map,previous)--new_visited,new_path)
      end
      defp i(cell_map,start,goal,visited,neighbor,path) do
        path = path -- [start]
        for i <- neighbor do
          if Enum.member?(visited,i) == false do
            new_visited = visited ++ [start]
            new_path = path ++ [start]
            i(cell_map,i,goal,new_visited,Map.fetch!(cell_map,i)--new_visited,new_path)
          end
        end
        |>List.flatten()
        |>Enum.uniq()
      end

  @doc """
  #Function name:
          traverse
  #Inputs:
          a list (this will be generated in grid_traversal function) and the cell_map
  #Output:
          List of lists containing paths starting from the 1st cell and visiting every cell containing valid_sum
  #Details:
          To find shortest path from first cell to all valid_sum’s locations
  #Example call:
          Check Task 2 Document
  """
  def traverse(list, cell_map) do
        g(list,cell_map,[])
  end
  def g(list,cell_map,path \\ [])
  def g([_h|[]],_cell_map,path) do
    path
  end
  def g(list, cell_map,path) do
    [h|t] = list
    modified_tail = closest(h,t,cell_map)
    target = List.first(modified_tail)
    path = path ++ [cell_traversal(cell_map,h,target)]
    g(modified_tail,cell_map,path)
  end
  def closest(a,list,cell_map) do
    Enum.sort(list, &(length(cell_traversal(cell_map,a,&1)) <= length(cell_traversal(cell_map,a,&2))))
  end
  @doc """
  #Function name:
          grid_traversal
  #Inputs:
          cell_map and matrix_of_sum
  #Output:
          List of keyword lists containing valid_sum locations along with paths obtained from traverse function
  #Details:
          Driver function which calls the get_locations and traverse function and returns the output in required format
  #Example call:
          Check Task 2 Document
  """
  def grid_traversal(cell_map \\ @cell_map,matrix_of_sum \\ @matrix_of_sum) do
    [1] ++ get_locations(matrix_of_sum)
    |> traverse(cell_map)
    |> Enum.map(fn path_list ->
        [{ Enum.at(path_list, -1)
           |> Integer.to_string()
           |> String.to_atom(), path_list}]
        end)
  end

end
