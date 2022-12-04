defmodule AdventOfCode.Day04 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.filter(fn {a, b} -> ranges_contained?(a, b) end)
    |> Enum.count()
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.filter(fn {a, b} -> not Range.disjoint?(a, b) end)
    |> Enum.count()
  end

  def ranges_contained?(range1, range2) do
    (range1.first in range2 and range1.last in range2) or
      (range2.first in range1 and range2.last in range1)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",", trim: true)
      |> Enum.map(fn pair ->
        [a, b] = pair |> String.split("-", trim: true)
        String.to_integer(a)..String.to_integer(b)
      end)
      |> List.to_tuple()
    end)
  end
end
