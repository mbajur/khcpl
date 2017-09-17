import Logger
import Ecto.Query

defmodule Khcpl.Service.BandcampCrawler do
  def crawl_url(url) do
    Logger.info "Fetching #{url}..."
    response = HTTPoison.get! url, %{}, kackney: [force_redirect: true, follow_redirect: true]
    body     = response.body

    band_url = find_band_url(body)
    [_, match] = band_url

    crawl_profile(match)
  end

  defp crawl_profile(url) do
    url = url |> ensure_https

    Logger.info "Crawling band profile #{url}"

    resp = HTTPoison.get! url
    body = resp.body

    band = %{
      url:       url,
      name:      find_name(body),
      location:  find_location(body),
      bio:       find_bio(body),
      photo_url: find_band_photo(body),
      albums:    find_albums(url, body)
    }
    Logger.info "Done. Fetched #{band.name}"

    persist_band(band)

    band
  end

  def find_band_url(body) do
    Regex.scan(~r/var\ band_url\ \=\ \"(\S+)\"\;/, body)
      |> List.flatten
  end

  defp find_name(body) do
    Floki.find(body, "#band-name-location .title")
      |> Floki.text
  end

  defp find_location(body) do
    Floki.find(body, ".location")
      |> Floki.text
  end

  defp find_bio(body) do
    Floki.find(body, "#bio-text")
      |> Floki.text
  end

  defp find_band_photo(body) do
    Floki.find(body, ".bio-pic .popupImage")
      |> Floki.attribute("href")
      |> Enum.at(0)
  end

  defp find_albums(band_url, body) do
    Floki.find(body, "#discography ul li a.thumbthumb")
      |> Floki.attribute("href")
      |> Enum.map(fn(album) ->
        ensure_album_url_prefix(band_url, album)
      end)
  end

  defp persist_band(band) do
    url   = band.url |> normalize_bandcamp_url
    query = from b in Khcpl.Band, where: b.url == ^url
    one   = Khcpl.Repo.one(query)

    if !one do
      Khcpl.Repo.insert %Khcpl.Band{
        url:        url,
        name:       band.name,
        location:   band.location,
        photo_url:  band.photo_url,
        bio:        band.bio,
        crawled_at: DateTime.utc_now
      }
    else
      Khcpl.Repo.update(
        one
        |> Ecto.Changeset.change(%{
          url:        url,
          name:       band.name,
          location:   band.location,
          photo_url:  band.photo_url,
          bio:        band.bio,
          crawled_at: DateTime.utc_now
        })
      )
    end
  end

  defp ensure_https(url) do
    Regex.replace(~r/http\:/, url, "https:")
  end

  defp ensure_album_url_prefix(band_url, path) do
    "#{band_url}#{path}"
  end

  defp normalize_bandcamp_url(url) do
    URI.parse(url).host
  end
end
