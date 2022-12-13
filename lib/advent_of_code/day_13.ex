defmodule AdventOfCode.Day13 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {[a, b], i}, acc ->
      case compare(a, b) do
        true -> acc + i
        false -> acc
      end
    end)
  end

  def part2(input) do
    sorted =
      (input <> "[[2]]\n[[6]]")
      |> parse_input()
      # i don't really want to change parse_input...
      |> Enum.concat()
      |> Enum.sort(&compare/2)

    (Enum.find_index(sorted, &(&1 == [[2]])) + 1) * (Enum.find_index(sorted, &(&1 == [[6]])) + 1)
  end

  def compare(x, x), do: :cont
  def compare(left, right) when is_integer(left) and is_integer(right), do: left < right
  def compare(left, right) when is_integer(left) and is_list(right), do: compare([left], right)
  def compare(left, right) when is_list(left) and is_integer(right), do: compare(left, [right])
  def compare([], _), do: true
  def compare(_, []), do: false

  def compare([left | tleft], [right | tright]) do
    case compare(left, right) do
      :cont -> compare(tleft, tright)
      x -> x
    end
  end

  def parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("\n", trim: true)
      |> Enum.map(fn x ->
        {res, _} = Code.eval_string(x)
        res
      end)
    end)
  end
end
