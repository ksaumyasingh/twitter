defmodule Twitter.Post do
  @moduledoc """
  The Post context.
  """

  import Ecto.Query, warn: false
  alias Twitter.Repo

  alias Twitter.Post.Twit

  @doc """
  Returns the list of twits.

  ## Examples

      iex> list_twits()
      [%Twit{}, ...]

  """
  def list_twits do
    Repo.all(from t in Twit, order_by: [desc: t.id])
  end

  def inc_likes(%Twit{id: id}) do
    {1, [twit]} =
      from(t in Twit, where: t.id == ^id, select: t)
      |> Repo.update_all(inc: [likes_count: 1])

    broadcast({:ok, twit}, :twit_updated)
  end

  def inc_reposts(%Twit{id: id}) do
    {1, [twit]} =
      from(t in Twit, where: t.id == ^id, select: t)
      |> Repo.update_all(inc: [reposts_count: 1])

    broadcast({:ok, twit}, :twit_updated)
  end

  @doc """
  Gets a single twit.

  Raises `Ecto.NoResultsError` if the Twit does not exist.

  ## Examples

      iex> get_twit!(123)
      %Twit{}

      iex> get_twit!(456)
      ** (Ecto.NoResultsError)

  """
  def get_twit!(id), do: Repo.get!(Twit, id)

  @doc """
  Creates a twit.

  ## Examples

      iex> create_twit(%{field: value})
      {:ok, %Twit{}}

      iex> create_twit(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_twit(attrs \\ %{}) do
    %Twit{}
    |> Twit.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:twit_created)
  end

  @doc """
  Updates a twit.

  ## Examples

      iex> update_twit(twit, %{field: new_value})
      {:ok, %Twit{}}

      iex> update_twit(twit, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_twit(%Twit{} = twit, attrs) do
    twit
    |> Twit.changeset(attrs)
    |> Repo.update()
    |>broadcast(:twit_created)
  end

  @doc """
  Deletes a twit.

  ## Examples

      iex> delete_twit(twit)
      {:ok, %Twit{}}

      iex> delete_twit(twit)
      {:error, %Ecto.Changeset{}}

  """
  def delete_twit(%Twit{} = twit) do
    Repo.delete(twit)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking twit changes.

  ## Examples

      iex> change_twit(twit)
      %Ecto.Changeset{data: %Twit{}}

  """
  def change_twit(%Twit{} = twit, attrs \\ %{}) do
    Twit.changeset(twit, attrs)
  end

  @spec subscribe :: :ok | {:error, {:already_registered, pid}}
  def subscribe do
    Phoenix.PubSub.subscribe(Twitter.PubSub, "twits")
  end

  defp broadcast({:error, _reason}= error, _event), do: error
  defp broadcast({:ok, twit}, event) do
    Phoenix.PubSub.broadcast(Twitter.PubSub, "twits", {event, twit})
    {:ok, twit}
  end
end
