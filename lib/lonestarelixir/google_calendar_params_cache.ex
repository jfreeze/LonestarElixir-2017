defmodule Lonestarelixir.GoogleCalendarParamsCache do
  @moduledoc """
  Caches the results of `google_calendar_params_from_ics_path/1`, so that each `ics_path` is only read once.
  """

  use GenServer

  # Functions

  ## Client Functions

  def from_disk(ics_path) do
  #"/apppriv/static#{ics_path}.ics"
  #"/app/LonestarElixir/priv/static#{ics_path}.ics"
  Path.join(:code.priv_dir(:lonestarelixir), "static#{ics_path}.ics")
    |> File.stream!()
    |> Enum.reduce(
         %{},
         fn
           "BEGIN:VALARM\n", acc ->
             {:alarm, acc}
           "END:VALARM\n", {:alarm, acc} ->
             acc
           _, {:alarm, acc} ->
             {:alarm, acc}
           "DTSTART:" <> date_start, acc ->
             Map.put(acc, :dates, String.trim_trailing(date_start))
           "DTEND:" <> date_end, acc = %{dates: date_start} ->
             %{acc | dates: "#{date_start}/#{String.trim_trailing(date_end)}"}
           "DESCRIPTION:" <> description_line, acc ->
             {:details, Map.put(acc, :details, [trim_ics_line(description_line)])}
           " " <> description_line, {:details, acc = %{details: description_lines}} ->
             {:details, %{acc | details: [trim_ics_line(description_line) | description_lines]}}
           _, {:details, acc = %{details: description_lines}} ->
             %{acc | details: ics_lines_to_string(description_lines)}
           "SUMMARY:" <> summary_line, acc ->
             {:text, Map.put(acc, :text, [trim_ics_line(summary_line)])}
           " " <> summary_line, {:text, acc = %{text: summary_lines}} ->
             {:text, %{acc | text: [trim_ics_line(summary_line) | summary_lines]}}
           _, {:text, acc = %{text: summary_lines}} ->
             %{acc | text: ics_lines_to_string(summary_lines)}
           _, acc ->
             acc
         end
       )
  end

  def from(ics_path), do: GenServer.call(__MODULE__, {:get, ics_path})

  ## GenServer callbacks

  def handle_call({:get, ics_path}, _from, google_calendar_params_by_ics_path) do
    case Map.fetch(google_calendar_params_by_ics_path, ics_path) do
      {:ok, google_calendar_params} ->
        {:reply, google_calendar_params, google_calendar_params_by_ics_path}
      :error ->
        google_calendar_params = from_disk(ics_path)
        {:reply, google_calendar_params, Map.put(google_calendar_params_by_ics_path, ics_path, google_calendar_params)}
    end
  end

  def init([]), do: {:ok, %{}}

  ## Supervisor.worker callbacks

  def start_link(), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  ## Private Functions

  defp trim_ics_line(ics_line), do: String.trim_trailing(ics_line, "\n")

  defp ics_lines_to_string(ics_lines) do
    ics_lines
    |> Enum.reverse()
    |> Enum.join()
    |> String.trim_trailing()
    |> String.replace(~r/\\,/, ",")
    |> String.replace("\\n", "\n")
  end
end
