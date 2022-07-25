defmodule TwitterWeb.TwitLive.Show do
  use TwitterWeb, :live_view

  alias Twitter.Post

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:twit, Post.get_twit!(id))}
  end

  defp page_title(:show), do: "Show Twit"
  defp page_title(:edit), do: "Edit Twit"
end
