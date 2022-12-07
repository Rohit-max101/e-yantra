defmodule D do
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
  def f(cell_map \\ @cell_map, start \\ 1, goal \\ 9)
  def f(_cell_map, a, goal) when a == goal do
    [goal]
  end
  # def f(cell_map, a, goal) when cell_map[a] == [] do
  #   :nil
  # end
  def f(cell_map, start, goal) do
    path = [start]
    current_path = [start]
    a = Enum.at(cell_map |> Map.fetch!(start),0)
    IO.inspect(current_path ++ [a])
    new_map = Map.update!(cell_map, a, fn list -> list -- [start] end)
    IO.inspect(a)
    IO.inspect(new_map)
    # Enum.each(cell_map,fn %{x => a} ,
    # if Map.fetch!(new_map,a) == [] && a != goal do
    #   []
    # else
    #   path ++ f(new_map, a, goal)
    # end
  end
end
