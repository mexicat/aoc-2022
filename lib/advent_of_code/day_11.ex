defmodule AdventOfCode.Day11 do
  def part1(input) do
    game = parse_input(input)
    level_fn = fn level -> div(level, 3) end

    Enum.reduce(1..20, game, fn _, game -> rnd(game, level_fn) end)
    |> Enum.map(fn {_, monkey} -> monkey.inspected end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  def part2(input) do
    game = parse_input(input)
    d = game |> Enum.map(fn {_, monkey} -> monkey.divisible_by end) |> VeryAdvancedMath.lcm()
    level_fn = fn level -> rem(level, d) end

    Enum.reduce(1..10000, game, fn _, game -> rnd(game, level_fn) end)
    |> Enum.map(fn {_, monkey} -> monkey.inspected end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  # i cannot use "round" :(
  def rnd(game, level_fn) do
    Enum.reduce(0..(map_size(game) - 1), game, fn monkey_id, game ->
      turn(monkey_id, game, level_fn)
    end)
  end

  def turn(monkey_id, game, level_fn) do
    monkey = game[monkey_id]

    Enum.reduce(monkey.items, game, fn item, game ->
      game =
        Map.update!(game, monkey_id, fn monkey ->
          %{monkey | items: tl(monkey.items), inspected: monkey.inspected + 1}
        end)

      level = item |> monkey.operation.() |> level_fn.()

      case rem(level, monkey.divisible_by) == 0 do
        true -> throw_to(monkey.if_true, level, game)
        false -> throw_to(monkey.if_false, level, game)
      end
    end)
  end

  # no longer used because it is sloooow. but it worked!
  def operation(old, op) do
    {res, _} = Code.eval_string(op, old: old)
    res
  end

  def throw_to(monkey_id, item, game) do
    monkey = game[monkey_id]
    Map.put(game, monkey_id, %{monkey | items: Enum.reverse([item | monkey.items])})
  end

  def parse_operation("* old"), do: fn x -> x * x end

  def parse_operation("* " <> n) do
    n = String.to_integer(n)
    fn x -> x * n end
  end

  def parse_operation("+ " <> n) do
    n = String.to_integer(n)
    fn x -> x + n end
  end

  def parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn line ->
      [a, b, c, d, e, f] =
        String.split(
          line,
          [
            "\n",
            "  ",
            "Monkey ",
            "Starting items: ",
            "Operation: new = old ",
            "Test: divisible by ",
            "If true: throw to monkey ",
            "If false: throw to monkey "
          ],
          trim: true
        )

      {a |> String.at(0) |> String.to_integer(),
       %{
         items: b |> String.split(", ", trim: true) |> Enum.map(&String.to_integer/1),
         operation: parse_operation(c),
         divisible_by: d |> String.to_integer(),
         if_true: e |> String.to_integer(),
         if_false: f |> String.to_integer(),
         inspected: 0
       }}
    end)
    |> Map.new()
  end
end

defmodule VeryAdvancedMath do
  def gcd(a, 0), do: a
  def gcd(0, b), do: b
  def gcd(a, b), do: gcd(b, rem(a, b))

  def lcm(0, 0), do: 0
  def lcm(a, b), do: div(a * b, gcd(a, b))
  def lcm(lst), do: Enum.reduce(lst, &lcm/2)
end
