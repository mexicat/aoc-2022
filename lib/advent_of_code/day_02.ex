defmodule AdventOfCode.Day02 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.reduce(0, fn [opp, me], acc -> match(opp, me) + score(me) + acc end)
  end

  def part2(input) do
    input |> parse_input() |> Enum.reduce(0, fn [opp, me], acc -> winner(opp, me) + acc end)
  end

  # ughhh

  def match("A", "X"), do: 3
  def match("A", "Y"), do: 6
  def match("A", "Z"), do: 0
  def match("B", "X"), do: 0
  def match("B", "Y"), do: 3
  def match("B", "Z"), do: 6
  def match("C", "X"), do: 6
  def match("C", "Y"), do: 0
  def match("C", "Z"), do: 3

  def score("X"), do: 1
  def score("Y"), do: 2
  def score("Z"), do: 3

  def winner("A", "Z"), do: 6 + score("Y")
  def winner("B", "Z"), do: 6 + score("Z")
  def winner("C", "Z"), do: 6 + score("X")
  def winner("A", "Y"), do: 3 + score("X")
  def winner("B", "Y"), do: 3 + score("Y")
  def winner("C", "Y"), do: 3 + score("Z")
  def winner("A", "X"), do: 0 + score("Z")
  def winner("B", "X"), do: 0 + score("X")
  def winner("C", "X"), do: 0 + score("Y")

  def parse_input(input) do
    input |> String.split("\n", trim: true) |> Enum.map(&String.split/1)
  end
end
