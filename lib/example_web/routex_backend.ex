defmodule My.Attrs do
  @moduledoc false
  defstruct [
    :contact,
    :name,
    :region_display_name,
    locale: "en-001",
    discount: 0
  ]
end

defmodule ExampleWeb.RoutexBackend do
  alias My.Attrs

  use Routex.Backend,
    extensions: [
      Routex.Extension.AttrGetters,
      # auto enabled by SimpleLocale
      #Routex.Extension.Alternatives,
      Routex.Extension.Translations,
      Routex.Extension.Interpolation,
      # Routex.Extension.Cloak,
      Routex.Extension.AlternativeGetters,
      Routex.Extension.VerifiedRoutes,
      Routex.Extension.RouteHelpers,
      Routex.Extension.Assigns,
      Routex.Extension.LiveViewHooks,
      Routex.Extension.Plugs,
      Routex.Extension.RuntimeCallbacks,
      Routex.Extension.Localize.Routes,
      Routex.Extension.Localize.Runtime,
    ],
    region_sources: [:accept_language, :attrs],
    region_params: ["region"],
    language_sources: [:query, :attrs],
    language_params: ["language"],
    locale_sources: [:query, :session, :accept_language, :attrs],
    locale_params: ["locale"],
    translations_backend: ExampleWeb.Gettext,
    locales: [
      {"en-001", %{region_display_name: "Worldwide", contact: "root@example.com", discount: 0.02}},
      {"en-150", %{prefix: "/eu", contact: "europe@example.com", discount: 0.16}},
      {"nl-NL", %{contact: "verkoop@example.nl", discount: 0.25}},
      {"nl-BE", %{prefix: "/nl/be",contact: "handel@example.be", discount: 0.5}},
      {"en-GB", %{contact: "sales@example.com", discount: 0.3}}
    ],
    default_locale: "en-001",
    locale_prefix_sources: :region_display_name,
    runtime_callbacks: [
      {Gettext, :put_locale, [ExampleWeb.Gettext, [:attrs, :language]]},
      {Cldr, :put_locale, [Example.Cldr, [:attrs, :locale]]}
    ],
    cloak_character: ".",
    verified_sigil_routex: "~p",
    verified_sigil_phoenix: "~o",
    verified_url_routex: :url,
    verified_path_routex: :path,
    assigns: %{
      namespace: :namespace,
      attrs: [:discount, :locale, :language, :region_display_name, :contact, :name]
    }
end

# defmodule ExampleWeb.RoutexCldrBackend do
#   alias My.Attrs

#   use Routex.Backend,
#     extensions: [
#       Routex.Extension.Cldr,
#       Routex.Extension.Alternatives,
#       Routex.Extension.Interpolation,
#       Routex.Extension.Translations,

#       Routex.Extension.AttrGetters,
#       Routex.Extension.AlternativeGetters,
#       Routex.Extension.VerifiedRoutes,
#       # Routex.Extension.RouteHelpers,
#       Routex.Extension.Assigns
#     ],
#     cldr_backend: Example.Cldr,
#     # Equivalent of:
#     # alternatives: %{
#     #   "/" => %{
#     #     attrs: %{language: "en", locale: "en", territory: "US"},
#     #     branches: %{
#     #       "/en" => %{language: "en", locale: "en", territory: "US"},
#     #       "/fr" => %{language: "fr", locale: "fr", territory: "FR"},
#     #       "/th" => %{language: "th", locale: "th", territory: "TH"},
#     #       "/zh" => %{language: "zh", locale: "zh", territory: "CN"}
#     #     }
#     #   }
#     # },
#     translations_backend: ExampleWeb.CldrGettext,
#     translations_domain: "cldr_routes",
#     verified_sigil_routex: "~p",
#     verified_sigil_phoenix: "~o",
#     verified_url_routex: :url,
#     verified_path_routex: :path,
#     assigns: %{namespace: :loc, attrs: [:locale, :language, :locale_name]}
# end

defmodule ExampleWeb.RoutexBackendAdmin do
  alias My.Attrs

  use Routex.Backend,
    branches: %{
      "/" => %{
        attrs: %Attrs{name: "Worldwide", contact: "root_admin@example.com"},
        branches: %{
          "/europe" => %{
            attrs: %Attrs{name: "Europe", contact: "europe_admin@example.com"},
            branches: %{
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
    translations_backend: ExampleWeb.AdminGettext,
    translations_domain: "admin_routes",
    verified_sigil_routex: "~p",
    verified_sigil_original: "~o",
    extensions: []
end
