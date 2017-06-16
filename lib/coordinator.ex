defmodule Metex.Coordinator do
  
  def loop(results \\ [], results_expected) do
    receive do
      {:ok, result} ->
        handle_loop(result, results, results_expected)
      :exit ->
        handle_loop(:exit, results)
      _ ->
        handle_loop(results, results_expected)
    end
  end

  defp handle_loop(result, results, results_expected) do
    new_results = [result | results]
    all_results_resolved?(results_expected, new_results)
    loop(new_results, results_expected)
  end

  defp handle_loop(:exit, results) do
    results 
    |> Enum.sort
    |> Enum.join(", ")
    |> IO.puts
  end

  defp handle_loop(results, results_expected) do
    loop(results, results_expected)
  end

  defp all_results_resolved?(expected, new) when expected == :erlang.length(new), do: send(self, :exit)
end