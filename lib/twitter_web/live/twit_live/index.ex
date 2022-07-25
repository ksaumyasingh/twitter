defmodule TwitterWeb.TwitLive.Index do
  use TwitterWeb, :live_view

  alias Twitter.Post
  alias Twitter.Post.Twit

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Post.subscribe()

    {:ok, assign(socket, :twits, list_twits()),temporary_assigns: [twits: []]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Twit")
    |> assign(:twit, Post.get_twit!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Twit")
    |> assign(:twit, %Twit{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Twits")
    |> assign(:twit, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    twit = Post.get_twit!(id)
    {:ok, _} = Post.delete_twit(twit)

    {:noreply, assign(socket, :twits, list_twits())}
  end



  @impl true
  def handle_info({:twit_created, twit}, socket) do
    {:noreply, update(socket, :twits, fn twits -> [twit | twits] end)}
  end

  def handle_info({:twit_updated, twit}, socket) do
    {:noreply, update(socket, :twits, fn twits -> [twit | twits] end)}
  end

  defp list_twits do
    Post.list_twits()
  end
end
