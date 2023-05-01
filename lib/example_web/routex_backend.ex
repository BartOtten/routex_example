defmodule My.Attrs do
  @moduledoc false
  defstruct [:contact, :name, locale: "en"]
end

defmodule ExampleWeb.RoutexBackend do
  alias My.Attrs

  use Routex,
    extensions: [
      Routex.Extension.Alternatives,
      Routex.Extension.Translations,
      # Routex.Extension.Cloak,
      Routex.Extension.AttrGetters,
      Routex.Extension.AlternativeGetters,
      Routex.Extension.VerifiedRoutes,
      Routex.Extension.RouteHelpers,
      Routex.Extension.Assigns
    ],
    alternatives: %{
      "/" => %{
        attrs: %Attrs{name: "Worldwide", contact: "root@example.com"},
        scopes: %{
          "/europe" => %{
            attrs: %Attrs{name: "Europe", contact: "europe@example.com"},
            scopes: %{
              "/nl" => %{
                attrs: %Attrs{
                  name: "The Netherlands",
                  locale: "nl",
                  contact: "verkoop@example.nl"
                }
              },
              "/be" => %{
                attrs: %Attrs{name: "Belgium", locale: "nl", contact: "handel@example.be"}
              }
            }
          },
          "/gb" => %{attrs: %Attrs{name: "Great Britain", contact: "sales@example.com"}}
        }
      }
    },
    translations_backend: ExampleWeb.Gettext,
    cloak_character: ".",
    verified_sigil_routex: "~p",
    verified_sigil_original: "~o",
    assigns: %{namespace: :loc, attrs: [:scope_helper, :locale, :contact, :name]}
end

defmodule ExampleWeb.RoutexBackendAdmin do
  alias My.Attrs

  use Routex,
    scopes: %{
      "/" => %{
        attrs: %Attrs{name: "Worldwide", contact: "root_admin@example.com"},
        scopes: %{
          "/europe" => %{
            attrs: %Attrs{name: "Europe", contact: "europe_admin@example.com"},
            scopes: %{
              "/nl" => %{
                attrs: %Attrs{
                  name: "The Netherlands",
                  locale: "nl",
                  contact: "administratie@example.nl"
                }
              }
            }
          },
          "/gb" => %{
            attrs: %Attrs{name: "Great Britain", contact: "administration@example.com"}
          }
        }
      }
    },
    translations_backend: ExampleWeb.Gettext,
    translations_domain: "admin_routes",
    verified_sigil_routex: "~p",
    verified_sigil_original: "~o",
    extensions: []
end
