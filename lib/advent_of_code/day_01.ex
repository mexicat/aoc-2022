defmodule AdventOfCode.Day01 do
  def part1(input) do
    input |> parse_input() |> Enum.map(&Enum.sum/1) |> Enum.max()
  end

  def part2(input) do
    input |> parse_input() |> Enum.map(&Enum.sum/1) |> Enum.sort() |> Enum.take(-3) |> Enum.sum()
  end

  def parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn elf -> elf |> String.split() |> Enum.map(&String.to_integer/1) end)
  end
end
