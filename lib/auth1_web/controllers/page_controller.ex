defmodule Auth1Web.PageController do
  use Auth1Web, :controller

  def index(conn, _params) do
    render(conn, "sample.html")
  end
end
