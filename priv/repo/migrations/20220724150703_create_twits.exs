defmodule Twitter.Repo.Migrations.CreateTwits do
  use Ecto.Migration

  def change do
    create table(:twits) do
      add :username, :string
      add :body, :string
      add :likes_count, :integer
      add :reposts_count, :integer

      timestamps()
    end
  end
end
