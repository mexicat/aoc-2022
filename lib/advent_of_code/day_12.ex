defmodule AdventOfCode.Day12 do
  @dirs [
    {0, -1},
    {0, 1},
    {-1, 0},
    {1, 0}
  ]

  def part1(input) do
    grid = parse_input(input)
    start = Enum.find(grid, fn {_, v} -> v == ?S end) |> elem(0)
    best = Enum.find(grid, fn {_, v} -> v == ?E end) |> elem(0)
    graph = make_graph(grid)
    path = Graph.dijkstra(graph, start, best)
    length(path) - 1
  end

  def part2(input) do
    grid = parse_input(input)
    start = Enum.filter(grid, fn {_, v} -> v == ?a end)
    best = Enum.find(grid, fn {_, v} -> v == ?E end) |> elem(0)
    graph = make_graph(grid)

    Enum.reduce(start, [], fn {{x, y}, _}, acc ->
      case Graph.dijkstra(graph, {x, y}, best) do
        nil -> acc
        path -> [length(path) - 1 | acc]
      end
    end)
    |> Enum.min()
  end

  def make_graph(grid) do
    Enum.reduce(grid, Graph.new(), fn {{x, y}, h}, graph ->
      Enum.reduce(@dirs, graph, fn {x1, y1}, graph ->
        case Map.get(grid, {x + x1, y + y1}) do
          ?S when h == ?a or h == ?b ->
            graph
            |> Graph.add_edge({x, y}, {x + x1, y + y1})
            |> Graph.add_edge({x + x1, y + y1}, {x, y})

          ?E when h == ?z or h == ?y ->
            graph |> Graph.add_edge({x, y}, {x + x1, y + y1})

          h1 when h1 <= h + 1 and h1 > ?a ->
            graph |> Graph.add_edge({x, y}, {x + x1, y + y1})

          _ ->
            graph
        end
      end)
    end)
  end

  def parse_input(input) do
    lines = String.split(input, "\n", trim: true)

    for {row, y} <- Enum.with_index(lines),
        {col, x} <- Enum.with_index(String.to_charlist(row)),
        into: %{} do
      {{x, y}, col}
    end
  end
end
