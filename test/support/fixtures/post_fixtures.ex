defmodule Twitter.PostFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Twitter.Post` context.
  """

  @doc """
  Generate a twit.
  """
  def twit_fixture(attrs \\ %{}) do
    {:ok, twit} =
      attrs
      |> Enum.into(%{
        body: "some body",
        likes_count: 42,
        reposts_count: 42,
        username: "some username"
      })
      |> Twitter.Post.create_twit()

    twit
  end
end
