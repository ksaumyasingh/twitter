defmodule TwitterWeb.TwitLive.TwitComponent do
  use TwitterWeb, :live_component
  def render(assigns) do
   ~H"""
   <div id="twit-{ @twit.id }" class="twit">
    <div class="row">
      <div class="column column-10">
        <div class="twit-avatar"></div>
      </div>
      <div class="column column-90 twit-body">
        <b>@<%= @twit.username %></b>
        <br/>
        <%= @twit.body %>
      </div>
    </div>
    <div class="row">
      <div class="column">
      <a href="#" phx-click="like" phx-target="{ @myself }">
        <i class='far fa-heart' style='color:red'></i> <%= @twit.likes_count %>
      </a>
      </div>
      <div class="column">
      <a href="#" phx-click="repost" phx-target="{ @myself }">
        <i class='fas fa-retweet' style='color:blue'></i> <%= @twit.reposts_count %>
      </a>
      </div>
      <div class="column">
        <%= live_patch to: Routes.twit_index_path(@socket, :edit, @twit.id) do %>
          <i class="fa fa-edit" style="color:black"></i>
        <% end %>
        <%= link to: "#", phx_click: "delete", phx_value_id: @twit.id, data: [confirm: "Are you sure?"] do %>
          <i class="material-icons" style="font-size:16px;color:red">delete</i>
        <% end %>
    </div>
    </div>
   </div>
   """
  end

    def handle_event("like", _, socket) do
      Twitter.Post.inc_likes(socket.assigns.twit)
      {:noreply, socket}
    end

    def handle_event("repost", _, socket) do
      Twitter.Post.inc_reposts(socket.assigns.twit)
      {:noreply, socket}
    end
end
