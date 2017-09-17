import Logger
import Ecto.Query

defmodule CrawlEventWorker do
  def perform(id) do
    token = "EAACEdEose0cBABmXB5ZAvMfPE6OlOhfkJiGL8R1ZAFnXCVwq6D1hbsM5TAMtopFFbYJSWxPkoGGC4ZByTOeZBMqNiyceZCwhxtB0eZCSiLMBjAolkItqnAj7XcYPCZAUQYDjj5gQSgZCHjiROVlfGx3C99GDusVPK7GVZCUaZARqhZAgLZCVdjcufSjEFDK7mZCTSwccZD"

    HTTPoison.start

    Logger.info "Crawling event #{id}"
    resp = HTTPoison.get "https://graph.facebook.com/v2.10/#{id}?access_token=#{token}"
    {result, body} = parse_json(resp)

    Logger.debug "Done. Fetched #{body["name"]}"
    persist_event(body)

    Logger.debug "Looking for bandcamp links..."
    links = Regex.scan(~r/https\:\/\/\w+\.bandcamp.com\/[\w-_\/]*/, body["description"])
      |> List.flatten

    Logger.debug "Links found: #{Enum.join(links, ", ")}"
    Logger.info "Done."

    Enum.each(links, fn link ->
      Logger.info "Querying bandcamp crawl for: #{link}"
      {:ok, jid} = Exq.enqueue(Exq, "bandcamp", CrawlBandcampWorker, [link])
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
    Logger.error "Something went wrong. Please check your internet connection"
  end
end
