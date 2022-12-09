defmodule AdventOfCode.Day09 do
  def part1(input) do
    {_, visited} =
      input
      |> parse_input()
      |> Enum.reduce({[{0, 0}, {0, 0}], MapSet.new([{0, 0}])}, &move_rope/2)

    MapSet.size(visited)
  end

  def part2(input) do
    {_, visited} =
      input
      |> parse_input()
      |> Enum.reduce({List.duplicate({0, 0}, 10), MapSet.new([{0, 0}])}, &move_rope/2)

    MapSet.size(visited)
  end

  def move_rope({_, 0}, acc), do: acc

  def move_rope({dir, n}, {[h | t], visited}) do
    new_h = to(dir, h)
    new_t = move_tail(t, [new_h])
    new_visited = MapSet.put(visited, List.last(new_t))
    move_rope({dir, n - 1}, {new_t, new_visited})
  end

  def move_tail([], acc), do: Enum.reverse(acc)

  def move_tail([t | rest], [h | _] = acc) do
    new_t = if not adjacent?(h, t), do: towards(h, t), else: t
    move_tail(rest, [new_t | acc])
  end

  def towards({x1, y1}, {x2, y2}) do
    move_x = if x1 - x2 < 0, do: max(x1 - x2, -1), else: min(x1 - x2, 1)
    move_y = if y1 - y2 < 0, do: max(y1 - y2, -1), else: min(y1 - y2, 1)

    {x2 + move_x, y2 + move_y}
  end

  def adjacent?(x, x), do: true
  def adjacent?({x1, y1}, {x2, y2}) when abs(x1 - x2) <= 1 and abs(y1 - y2) <= 1, do: true
  def adjacent?(_, _), do: false

  def to("L", {x, y}), do: {x - 1, y}
  def to("R", {x, y}), do: {x + 1, y}
  def to("U", {x, y}), do: {x, y + 1}
  def to("D", {x, y}), do: {x, y - 1}

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [a, b] = String.split(line, " ", trim: true)
      {a, String.to_integer(b)}
    end)
  end
end
