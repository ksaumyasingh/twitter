defmodule TwitterWeb.TwitLive.TwitComponent do
  use TwitterWeb, :live_component
  def render(assigns) do
   ~L"""
   <div id="twit-<%= @post.id %>" class="twit">
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
        <i class='far fa-heart' style='color:red'></i> <%= @twit.likes_count %>
      </div>
      <div class="column">
        <i class='fas fa-retweet' style='color:blue'></i> <%= @twit.reposts_count %>
      </div>
      <div class="column">
        <%= live_patch to: Routes.twit_index_path(@socket, :edit, @post.id) do %>
          <i class="material-icons" id="del" style="color:red"></i>
        <% end %>
        <%= link to: "#", phx_click: "delete", phx_value_id: @post.id, data: [confirm: "Are you sure?"] do %>
        <i class="material-icons" id="del" style="color:red"></i>
        <% end %>
      </div>
    </div>
   </div>
   """
  end
end
