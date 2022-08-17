defmodule GenxWeb.Views.ErrorHelpersTest do
  use ExUnit.Case

  alias Ecto.Changeset
  alias GenxWeb.ErrorHelpers
  alias Phoenix.HTML.Form
  alias Phoenix.HTML.FormData
  alias Phoenix.HTML.Tag

  describe "error_tag/2" do
    test "returns a span with the error details for the given field" do
      assert %{name: ""} |> build_form() |> ErrorHelpers.error_tag(:name) == [
               Tag.content_tag(:span, "can't be blank",
                 class: "invalid-feedback",
                 phx_feedback_for: "user[name]"
               )
             ]

      assert %{name: "a"} |> build_form() |> ErrorHelpers.error_tag(:name) == [
               Tag.content_tag(:span, "should be at least 3 character(s)",
                 class: "invalid-feedback",
                 phx_feedback_for: "user[name]"
               )
             ]
    end

    @spec build_form(map) :: Form.t()
    defp build_form(params) do
      data = %{}
      types = %{name: :string}

      {data, types}
      |> Changeset.cast(params, Map.keys(types))
      |> Changeset.validate_required(:name)
      |> Changeset.validate_length(:name, min: 3)
      |> Map.put(:action, :insert)
      |> FormData.to_form(as: :user)
    end
  end
end
