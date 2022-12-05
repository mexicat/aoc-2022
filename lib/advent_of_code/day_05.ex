defmodule AdventOfCode.Day05 do
  def part1(input) do
    {stacks, moves} = parse_input(input)

    Enum.reduce(moves, stacks, &move_stacks/2)
    |> Enum.map_join(fn {_, stack} -> hd(stack) end)
  end

  def part2(input) do
    {stacks, moves} = parse_input(input)

    Enum.reduce(moves, stacks, &move_multiple_stacks/2)
    |> Enum.map_join(fn {_, stack} -> hd(stack) end)
  end

  def move_stacks({0, _, _}, stacks), do: stacks

  def move_stacks({n, from, to}, stacks) do
    [h | t] = stacks[from]
    new_stacks = stacks |> Map.put(from, t) |> Map.update(to, [h], fn list -> [h | list] end)
    move_stacks({n - 1, from, to}, new_stacks)
  end

  def move_multiple_stacks({n, from, to}, stacks) do
    {h, t} = Enum.split(stacks[from], n)
    stacks |> Map.put(from, t) |> Map.update(to, h, fn list -> h ++ list end)
  end

  def parse_input(input) do
    [stacks, moves] = input |> String.split("\n\n", trim: true)

    stacks =
      stacks
      |> String.split("\n", trim: true)
      |> Enum.drop(-1)
      |> Enum.map(fn line ->
        Regex.scan(~r/.{1,4}/, line)
        |> List.flatten()
        |> Enum.map(&String.replace(&1, [" ", "[", "]"], ""))
        |> Enum.with_index(1)
      end)
      |> Enum.reverse()
      |> Enum.reduce(%{}, fn stack, acc ->
        Enum.reduce(stack, acc, fn
          {"", _}, acc -> acc
          {x, index}, acc -> Map.update(acc, index, [x], fn xs -> [x | xs] end)
        end)
      end)

    moves =
      moves
      |> String.split("\n", trim: true)
      |> Enum.map(fn move ->
        [a, b, c] = String.split(move, ["move ", " from ", " to "], trim: true)
        {String.to_integer(a), String.to_integer(b), String.to_integer(c)}
      end)

    {stacks, moves}
  end
end
