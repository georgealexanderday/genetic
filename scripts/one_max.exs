defmodule OneMax do
  @behaviour Problem
  alias Types.Chromosome

  @impl true
  def genotype() do
    genes = for _ <- 1..42, do: Enum.random(0..1)
    %Chromosome{genes: genes, size: 42}
  end

  @impl true
  def fitness_function(chromosome) do
    Enum.sum(chromosome.genes)
  end

  
  # different approaches to termination criteria
  @impl true
  def terminate?([best | _], _, _), do: best.fitness == 42
  @impl true
  def terminate?(_, generation, _), do: generation == 100
  @impl true
  def terminate?(_, _, temperature), do: temperature < 25
end

soln = Genetic.run(OneMax)
IO.write("\n")
IO.inspect(soln)
