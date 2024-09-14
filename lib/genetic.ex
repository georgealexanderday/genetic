defmodule Genetic do
  def run(fitness_function, genotype, max_fitness) do
    population = initialize(genotype)

    population |> evolve(fitness_function, genotype, max_fitness)
  end

  def evolve(population, fitness_function, genotype, max_fitness) do
    population = evaluate(population, fitness_function)
    best = hd(population)
    current_best_fitness = fitness_function.(best)
    IO.write("\rCurrent Best: #{current_best_fitness}")

    case current_best_fitness do
      ^max_fitness ->
        best

      _ ->
        population
        |> select()
        |> crossover()
        |> mutation()
        |> evolve(fitness_function, genotype, max_fitness)
    end
  end

  def initialize(genotype) do
    for _ <- 1..100, do: genotype.()
  end

  def evaluate(population, fitness_function) do
    population
    |> Enum.sort_by(fitness_function, &>=/2)
  end

  def select(population) do
    population
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple(&1))
  end

  def crossover(population) do
    population
    |> Enum.reduce(
      [],
      fn {p1, p2}, acc ->
        cx_point = :rand.uniform(length(p1))
        {{h1, t1}, {h2, t2}} = {Enum.split(p1, cx_point), Enum.split(p2, cx_point)}
        {c1, c2} = {h1 ++ t2, h2 ++ t1}
        [c1, c2 | acc]
      end
    )
  end

  defguardp is_mutant(x) when x < 0.05

  def mutation(population) do
    population
    |> Enum.map(fn chromosome ->
      case :rand.uniform() do
        x when is_mutant(x) -> Enum.shuffle(chromosome)
        _ -> chromosome
      end
    end)
  end
end
