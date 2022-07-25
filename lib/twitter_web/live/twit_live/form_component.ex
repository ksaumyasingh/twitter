defmodule TwitterWeb.TwitLive.FormComponent do
  use TwitterWeb, :live_component

  alias Twitter.Post

  @impl true
  def update(%{twit: twit} = assigns, socket) do
    changeset = Post.change_twit(twit)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"twit" => twit_params}, socket) do
    changeset =
      socket.assigns.twit
      |> Post.change_twit(twit_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"twit" => twit_params}, socket) do
    save_twit(socket, socket.assigns.action, twit_params)
  end

  defp save_twit(socket, :edit, twit_params) do
    case Post.update_twit(socket.assigns.twit, twit_params) do
      {:ok, _twit} ->
        {:noreply,
         socket
         |> put_flash(:info, "Twit updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_twit(socket, :new, twit_params) do
    case Post.create_twit(twit_params) do
      {:ok, _twit} ->
        {:noreply,
         socket
         |> put_flash(:info, "Twit created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
