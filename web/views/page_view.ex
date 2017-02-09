defmodule Lonestarelixir.PageView do
  alias Lonestarelixir.GoogleCalendarParamsCache

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
          |> GoogleCalendarParamsCache.from()
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

  def ics_link(path) do
    link(to: "#{path}.ics", title: "Add session to iCal/Outlook") do
      tag(:img,  height: "32px", src: "/images/ical.png", width: "32px")
    end
  end
end
