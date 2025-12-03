defmodule LabelingIR.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/North-Shore-AI/labeling_ir"

  def project do
    [
      app: :labeling_ir,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "LabelingIR",
      source_url: @source_url,
      homepage_url: @source_url,
      docs: docs(),
      dialyzer: dialyzer(),
      preferred_cli_env: [dialyzer: :dev]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    Shared IR structs for Forge, Anvil, Ingot, and external clients; typed datasets,
    samples, assignments, labels, artifacts, and evaluation runs for labeling workflows.
    """
  end

  defp package do
    [
      name: "labeling_ir",
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url
      },
      maintainers: ["North-Shore-AI"],
      files: ~w(lib assets assets/labeling_ir.svg .formatter.exs mix.exs README.md LICENSE)
    ]
  end

  defp docs do
    [
      main: "LabelingIR",
      extras: ["README.md", "LICENSE"],
      assets: %{"assets" => "assets"},
      logo: "assets/labeling_ir.svg",
      source_ref: "v#{@version}",
      source_url: @source_url,
      groups_for_modules: [
        Core: [
          LabelingIR,
          LabelingIR.Types
        ],
        Schema: [
          LabelingIR.Schema,
          LabelingIR.Schema.Field
        ],
        "Samples and Labels": [
          LabelingIR.Sample,
          LabelingIR.Assignment,
          LabelingIR.Label
        ],
        Artifacts: [
          LabelingIR.Artifact,
          LabelingIR.ArtifactRef
        ],
        "Datasets and Evaluation": [
          LabelingIR.Dataset,
          LabelingIR.EvalRun
        ]
      ]
    ]
  end

  defp dialyzer do
    [
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
      plt_add_apps: [:mix, :ex_unit]
    ]
  end
end
