defmodule ExampleWeb.PageController do
  use ExampleWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # # so skip the default app layout.
     url = current_url(conn)

     conn
    |> assign(:url, url)
    |> render(:home, layout: false)
  end
end
