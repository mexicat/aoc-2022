defmodule AdventOfCode.Day10 do
  @relevant_cycles [20, 60, 100, 140, 180, 220]
  @last_relevant_cycle 220

  def part1(input) do
    program = parse_input(input)
    cpu = CPU.new(program)
    signals = run_and_intercept_signals(cpu)

    Enum.sum(signals)
  end

  def part2(input) do
    program = parse_input(input)
    cpu = CPU.new(program)

    print_screen(cpu, [])
    |> Enum.reverse()
    |> Enum.chunk_every(40)
    |> Enum.map(fn line -> line |> Enum.join() |> IO.puts() end)
  end

  def run_and_intercept_signals(cpu, signals \\ []) do
    cpu = CPU.cycle(cpu)

    case cpu.cycles do
      cycle when cycle in @relevant_cycles ->
        run_and_intercept_signals(cpu, [cpu.x * cpu.cycles | signals])

      cycle when cycle > @last_relevant_cycle ->
        signals

      _ ->
        run_and_intercept_signals(cpu, signals)
    end
  end

  def print_screen(%{program: []}, screen), do: screen

  def print_screen(%{cycles: cycles, x: x} = cpu, screen)
      when rem(cycles, 40) in [x, x + 1, x + 2],
      do: print_screen(CPU.cycle(cpu), ["#" | screen])

  def print_screen(cpu, screen), do: print_screen(CPU.cycle(cpu), [" " | screen])

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line |> String.split(" ", trim: true)
    end)
    |> Enum.map(fn
      [a, b] -> {String.to_atom(a), String.to_integer(b)}
      [a] -> {String.to_atom(a)}
    end)
  end
end

defmodule CPU do
  defstruct x: 1, cycles: 0, current_op: {nil, nil}, program: []

  def new(program), do: %__MODULE__{program: program}

  def cycle(cpu) do
    cpu
    |> Map.update!(:cycles, &(&1 + 1))
    |> run_current_op()
    |> load_next_op()
  end

  def run_current_op(%{current_op: {cycles, op}, cycles: cycles} = cpu),
    do: %{execute_instruction(op, cpu) | current_op: {nil, nil}}

  def run_current_op(cpu), do: cpu

  def load_next_op(%{cycles: cycles, current_op: {nil, nil}, program: [next | rest]} = cpu),
    do: %{cpu | current_op: {cycles + cost(next), next}, program: rest}

  def load_next_op(cpu), do: cpu

  def cost({:noop}), do: 1
  def cost({:addx, _}), do: 2

  def execute_instruction({:noop}, cpu), do: cpu
  def execute_instruction({:addx, n}, cpu), do: Map.update!(cpu, :x, &(&1 + n))
end
