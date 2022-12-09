defmodule AdventOfCode.Day08 do
  @dirs [
    {0, -1},
    {0, 1},
    {-1, 0},
    {1, 0}
  ]

  def part1(input) do
    trees = parse_input(input)
    Enum.count(trees, &is_visible?(trees, &1))
  end

  def part2(input) do
    trees = parse_input(input)
    Enum.map(trees, &scenic_score(trees, &1)) |> Enum.max()
  end

  def is_visible?(trees, tree) do
    Enum.reduce_while(@dirs, nil, fn dir, _ ->
      case is_visible_in_direction?(trees, tree, dir) do
        true -> {:halt, true}
        false -> {:cont, false}
      end
    end)
  end

  def is_visible_in_direction?(trees, {{x, y}, h}, {dx, dy}) do
    case Map.get(trees, {x + dx, y + dy}) do
      nil -> true
      h1 when h1 >= h -> false
      _ -> is_visible_in_direction?(trees, {{x + dx, y + dy}, h}, {dx, dy})
    end
  end

  def scenic_score(trees, tree) do
    @dirs
    |> Enum.map(fn dir -> visible_distance(trees, tree, dir) end)
    |> Enum.product()
  end

  def visible_distance(trees, {{x, y}, h}, {dx, dy}) do
    case Map.get(trees, {x + dx, y + dy}) do
      nil -> 0
      h1 when h1 >= h -> 1
      _ -> 1 + visible_distance(trees, {{x + dx, y + dy}, h}, {dx, dy})
    end
  end

  def parse_input(input) do
    lines = String.split(input, "\n", trim: true)

    for {row, x} <- Enum.with_index(lines),
        {col, y} <- Enum.with_index(String.codepoints(row)),
        into: %{} do
      {{x, y}, String.to_integer(col)}
    end
  end
end
