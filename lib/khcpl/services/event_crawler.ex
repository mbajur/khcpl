import Logger
import Ecto.Query
import Khcpl.Service.BandcampCrawler

defmodule Khcpl.Service.EventCrawler do
  def crawl do
    # id    = "1528494680505018"
    id = "1890678421255855"
    token = "EAACEdEose0cBANCEBvUZChlhUnbLAcu0V6bKRM1cz8ZAA0s4Y3UIwDtWtH0NKWSGykUHH3WFuiY6A4jdQAw9hTXTEYuxq0L9FzUE8MouF9EN9Hig7jX9vsAtuooCaP2b5EzCjBDg8JDRbOebnWd3qcIcdKr5DCzgNdRJGtRXFND9QJy8f7vLC2mPBzfPEZD"

    HTTPoison.start

    Logger.info "Crawling event #{id}"
    resp = HTTPoison.get "https://graph.facebook.com/v2.10/#{id}?access_token=#{token}"
    {result, body} = parse_json(resp)

    Logger.debug "Done. Fetched #{body["name"]}"
    persist_event(body)

    Logger.debug "Looking for bandcamp links..."

    links = Regex.scan(~r/https\:\/\/\w+\.bandcamp.com\/[\w-_]*/, body["description"])
      |> List.flatten

    Logger.debug "Links found: #{Enum.join(links, ", ")}"
    Logger.info "Done."

    Enum.each(links, fn link ->
      Khcpl.Service.BandcampCrawler.crawl_url(link)
    end)
  end

  defp persist_event(event) do
    facebook_id = event["id"] |> String.to_integer
    query = from e in Khcpl.Event, where: e.facebook_id == ^facebook_id
    one   = Khcpl.Repo.one(query)

    if !one do
      Logger.debug "Event not found. Creating it."
      Khcpl.Repo.insert %Khcpl.Event{
        name:        event["name"],
        description: event["description"],
        facebook_id: event["id"] |> String.to_integer,
        crawled_at:  DateTime.utc_now
      }
    else
      Logger.debug "Event found. Updating it."
      Khcpl.Repo.update(
        one
        |> Ecto.Changeset.change(%{
          name:        event["name"],
          description: event["description"],
          crawled_at:  DateTime.utc_now
        })
      )
    end
  end

  defp parse_json({:ok, %{status_code: 200, body: body}}) do
    {:ok, Poison.Parser.parse!(body)}
  end

  defp parse_json({_, %{status_code: _, body: body}}) do
    IO.puts "Something went wrong. Please check your internet connection"
  end
end
