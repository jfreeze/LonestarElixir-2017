defmodule Lonestarelixir.PageView do
  use Lonestarelixir.Web, :view

  def ics_link(path, opts \\ []) do
    link(to: "#{path}.ics", title: Keyword.get(opts, :title, "Add session to iCal/Outlook")) do
      tag(:img,  height: "32px", src: "/images/ical.png", width: "32px")
    end
  end
end
