defmodule Metex.Worker do
  
  @apikey "b03676716ea37864a16cb2af011b1376"
  
  def temperature_of(location) do
    url_for(location) 
    |> HTTPoison.get 
    |> parse_response
    |> case do
      {:ok, temp} ->
        "#{location}: #{temp} °F"
      :error ->
        "#{location} not found"
    end
  end

  defp url_for(location) do
    location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{@apikey}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body
    |> JSON.decode!
    |> compute_temperature
  end

  defp parse_response(_) do
    :error
  end

  defp compute_temperature(json) do
    try do
      temp = (json["main"]["temp"] * 9/5 - 459.67) |> Float.round(1)
      {:ok, temp}
    rescue
      _ -> :error
    end
  end
end