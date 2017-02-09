defmodule Lonestarelixir.PageView do
  use Lonestarelixir.Web, :view

  # Constants

  @ical_date_time_regex ~r/(?<year>\d{4})(?<month>\d{2})(?<day>\d{2})T(?<hour>\d{2})(?<minute>\d{2})(?<second>\d{2})/

  # Functions

  def calendar_cells(ics_path) do
      [
        content_tag(:td) do
          ics_link(ics_path)
        end,
        content_tag(:td) do
          ics_path
          |> google_calendar_params_from_ics_path()
          |> google_calendar_link()
        end
      ]
  end

  def google_calendar_link(params = %{dates: dates, text: text}) when is_binary(dates) and is_binary(text) do
    encoded_query = params
                    |> Map.merge(
                         %{
                           "action" => "TEMPLATE",
                           "location" =>
                             "Norris Conference Centers - Austin, 2525 W Anderson Ln #365, Austin, TX 78757, USA"
                         }
                       )
                    |> URI.encode_query()
    link(to: "https://calendar.google.com/calendar/render?#{encoded_query}",
         rel: "noopener noreferrer",
         target: "_blank",
         title: "Add session to Google Calendar") do
      tag(:img, height: "32px", src: "/images/google-calendar.png", width: "32px")
    end
  end

  def google_calendar_params_from_ics_path(ics_path) do
    "web/static/assets#{ics_path}.ics"
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

  def ics_link(path, opts \\ []) do
    link(to: "#{path}.ics", title: Keyword.get(opts, :title, "Add session to iCal/Outlook")) do
      tag(:img,  height: "32px", src: "/images/ical.png", width: "32px")
    end
  end

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
