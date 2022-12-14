defmodule AdventOfCode.Day03 do
  @priorities (Enum.with_index(?a..?z, 1) ++ Enum.with_index(?A..?Z, 27)) |> Enum.into(%{})

  def part1(input) do
    input
    |> parse_input()
    |> Enum.map(fn rucksack ->
      common = rucksack |> split_rucksack() |> find_common_item()
      @priorities[common]
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.chunk_every(3)
    |> Enum.map(fn rucksacks ->
      common = find_common_item(rucksacks)
      @priorities[common]
    end)
    |> Enum.sum()
  end

  def find_common_item(comps) do
    comps |> Enum.map(&MapSet.new/1) |> Enum.reduce(&MapSet.intersection/2) |> Enum.at(0)
  end

  def split_rucksack(rucksack) do
    rucksack |> Enum.split(div(length(rucksack), 2)) |> Tuple.to_list()
  end

  def parse_input(input) do
    input |> String.split("\n", trim: true) |> Enum.map(&String.to_charlist/1)
  end
end
