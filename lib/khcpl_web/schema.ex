defmodule Khcpl.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema
  alias Absinthe.Relay.Connection
  alias Khcpl.{Band,Event}
  alias Khcpl.Repo

  import_types Khcpl.Schema.Types

  node interface do
    resolve_type fn
      %Band{}, _  -> :band
      %Event{}, _ -> :event
      _, _ ->  nil
    end
  end

  connection node_type: :band
  connection node_type: :event

  input_object :event_input_object do
    field :facebook_id, non_null(:integer)
  end

  # This is the type that will be the root of our query,
  # and the entry point into our schema.
  query do
    # field :viewer, :user, description:
    #   "Returns account details that match the id of the tokens passed" do
    #   resolve fn(_,_) -> {:ok, Database.get_viewer()} end
    # end

    connection field :bands, node_type: :band do
      resolve fn
        pagination_args, %{source: _band} ->
          Band
          |> Connection.from_query(&Repo.all/1, pagination_args)
        end
    end

    connection field :events, node_type: :event do
      resolve fn
        pagination_args, %{source: _event} ->
          Event
          |> Connection.from_query(&Repo.all/1, pagination_args)
        end
    end
  end

  mutation do
    payload field :add_event do
      input do
        field :event, :event_input_object
      end

      output do
        field :event, :event
      end

      resolve fn
        # %{email: "test@test.com", password: "password"}, _ -> {:ok, %{success: true}}
        # _, _ -> {:ok, %{success: false}}

        _, _ -> {:ok, %{event: %{id: 1}}}
      end
    end
  end
end
