defmodule Twitter.Post.Twit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "twits" do
    field :body, :string
    field :likes_count, :integer, default: 0
    field :reposts_count, :integer, default: 0
    field :username, :string, default: "saumya"

    timestamps()
  end

  @doc false
  def changeset(twit, attrs) do
    twit
    |> cast(attrs, [:body])
    |> validate_required([:body])
    |> validate_length(:body, min: 2, max: 50)
  end
end
