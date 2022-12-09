defmodule AdventOfCode.Day07 do
  def part1(input) do
    {_, graph} =
      input
      |> parse_input()
      |> make_tree()

    graph
    |> Graph.vertices()
    |> Enum.map(&get_total_size(graph, &1))
    |> Enum.reject(&(&1 > 100_000))
    |> Enum.sum()
  end

  def part2(input) do
    {_, graph} =
      input
      |> parse_input()
      |> make_tree()

    sizes =
      graph
      |> Graph.vertices()
      |> Enum.map(&get_total_size(graph, &1))
      |> Enum.sort()

    used = Enum.at(sizes, -1)
    total = 70_000_000
    available = total - used
    needed = 30_000_000 - available

    Enum.find(sizes, &(&1 >= needed))
  end

  def make_tree(input) do
    Enum.reduce(input, {[], Graph.new()}, fn cmd, {current_path, graph} ->
      cond do
        String.starts_with?(cmd, "cd /") ->
          {["/"], graph |> Graph.add_vertex(["/"])}

        String.starts_with?(cmd, "cd ..") ->
          {Enum.drop(current_path, 1), graph}

        String.starts_with?(cmd, "cd ") ->
          [_, dir] = String.split(cmd, [" ", "\n"], trim: true)
          new_path = [dir | current_path]

          graph =
            graph
            |> Graph.add_vertex(new_path)
            |> Graph.add_edge(current_path, new_path)

          {new_path, graph}

        String.starts_with?(cmd, "ls") ->
          filelist = cmd |> String.split("\n", trim: true) |> Enum.drop(1)
          total_size = parse_file_sizes(filelist)
          {current_path, graph |> Graph.label_vertex(current_path, total_size)}
      end
    end)
  end

  def get_total_size(graph, vertex) do
    my_size = Graph.vertex_labels(graph, vertex) |> List.first()

    children_size =
      graph
      |> Graph.out_neighbors(vertex)
      |> Enum.map(&get_total_size(graph, &1))
      |> Enum.sum()

    my_size + children_size
  end

  def parse_file_sizes(files) do
    files
    |> Enum.reject(fn f -> String.starts_with?(f, "dir") end)
    |> Enum.map(fn f ->
      f |> String.split(" ", trim: true) |> Enum.at(0) |> String.to_integer()
    end)
    |> Enum.sum()
  end

  def parse_input(input) do
    input |> String.split("$ ", trim: true)
  end
end
