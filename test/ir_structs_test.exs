defmodule LabelingIR.StructsTest do
  use ExUnit.Case, async: true

  alias LabelingIR.{
    Artifact,
    ArtifactRef,
    Assignment,
    Dataset,
    EvalRun,
    Label,
    Sample,
    Schema
  }

  describe "Artifact" do
    test "builds with required fields and defaults" do
      artifact =
        %Artifact{
          id: "a1",
          url: "https://example.com/a1.png",
          filename: "a1.png",
          artifact_type: :image
        }

      assert artifact.mime == nil
      assert artifact.expires_at == nil
      assert artifact.metadata == %{}
    end

    test "enforces required keys" do
      assert_raise ArgumentError, fn -> struct!(Artifact, %{}) end
    end
  end

  describe "ArtifactRef" do
    test "stores id and optional version" do
      ref = %ArtifactRef{artifact_id: "a1", version: "v1"}
      assert ref.artifact_id == "a1"
      assert ref.version == "v1"
    end

    test "enforces required keys" do
      assert_raise ArgumentError, fn -> struct!(ArtifactRef, %{}) end
    end
  end

  describe "Sample" do
    test "builds with payload and metadata defaults" do
      sample =
        %Sample{
          id: "s1",
          tenant_id: "t1",
          namespace: "ns1",
          pipeline_id: "p1",
          payload: %{"text" => "hello"},
          artifacts: [],
          metadata: %{source: "forge"},
          lineage_ref: %{trace: "abc"},
          created_at: ~U[2024-01-01 00:00:00Z]
        }

      assert sample.payload["text"] == "hello"
      assert sample.artifacts == []
      assert sample.metadata[:source] == "forge"
      assert sample.namespace == "ns1"
      assert sample.lineage_ref == %{trace: "abc"}
    end

    test "enforces required keys" do
      assert_raise ArgumentError, fn -> struct!(Sample, %{}) end
    end
  end

  describe "Dataset" do
    test "supports slices and source refs" do
      ds =
        %Dataset{
          id: "ds1",
          tenant_id: "t1",
          namespace: "eval",
          version: "v1",
          slices: [%{name: "train", sample_ids: ["s1"], filter: %{}}],
          source_refs: [%ArtifactRef{artifact_id: "a1"}],
          metadata: %{},
          lineage_ref: %{dataset: "trace"},
          created_at: ~U[2024-01-01 00:00:00Z]
        }

      assert [%{name: "train"}] = ds.slices
      assert [%ArtifactRef{}] = ds.source_refs
      assert ds.namespace == "eval"
      assert ds.lineage_ref == %{dataset: "trace"}
    end

    test "enforces required keys" do
      assert_raise ArgumentError, fn -> struct!(Dataset, %{}) end
    end
  end

  describe "Schema" do
    test "holds fields and optional component_module" do
      field = %Schema.Field{name: "coherence", type: :scale, required: true, min: 1, max: 5}

      schema =
        %Schema{
          id: "schema1",
          tenant_id: "t1",
          namespace: "default",
          fields: [field],
          component_module: "Acme.Components"
        }

      assert schema.component_module == "Acme.Components"
      assert [%Schema.Field{name: "coherence"}] = schema.fields
      assert schema.namespace == "default"
    end

    test "enforces required keys" do
      assert_raise ArgumentError, fn -> struct!(Schema, %{}) end
    end
  end

  describe "Assignment" do
    test "includes sample and schema" do
      sample =
        %Sample{
          id: "s1",
          tenant_id: "t1",
          pipeline_id: "p1",
          payload: %{},
          artifacts: [],
          metadata: %{},
          created_at: ~U[2024-01-01 00:00:00Z]
        }

      schema =
        %Schema{
          id: "schema1",
          tenant_id: "t1",
          fields: [%Schema.Field{name: "coherence", type: :scale}]
        }

      assignment =
        %Assignment{
          id: "asst1",
          queue_id: "q1",
          tenant_id: "t1",
          namespace: "acme",
          sample: sample,
          schema: schema,
          existing_labels: [],
          lineage_ref: %{trace: "assignment"},
          metadata: %{priority: "normal"}
        }

      assert assignment.sample.id == "s1"
      assert assignment.schema.id == "schema1"
      assert assignment.metadata[:priority] == "normal"
      assert assignment.namespace == "acme"
      assert assignment.lineage_ref == %{trace: "assignment"}
    end

    test "enforces required keys" do
      assert_raise ArgumentError, fn -> struct!(Assignment, %{}) end
    end
  end

  describe "Label" do
    test "captures values and metadata" do
      label =
        %Label{
          id: "lbl1",
          assignment_id: "asst1",
          sample_id: "s1",
          queue_id: "q1",
          tenant_id: "t1",
          namespace: "acme",
          user_id: "user1",
          values: %{"coherence" => 4},
          time_spent_ms: 12_000,
          created_at: ~U[2024-01-01 00:00:00Z],
          lineage_ref: %{trace: "label"}
        }

      assert label.values["coherence"] == 4
      assert label.notes == nil
      assert label.metadata == %{}
      assert label.namespace == "acme"
      assert label.lineage_ref == %{trace: "label"}
    end

    test "enforces required keys" do
      assert_raise ArgumentError, fn -> struct!(Label, %{}) end
    end
  end

  describe "EvalRun" do
    test "supports human or model runs" do
      run =
        %EvalRun{
          id: "eval1",
          tenant_id: "t1",
          namespace: "evalns",
          dataset_id: "ds1",
          slice: "validation",
          model_ref: nil,
          run_type: :human,
          metrics: %{"accuracy" => 0.9},
          artifacts: [%ArtifactRef{artifact_id: "a1"}],
          lineage_ref: %{trace: "eval"},
          created_at: ~U[2024-01-01 00:00:00Z]
        }

      assert run.run_type == :human
      assert [%ArtifactRef{}] = run.artifacts
      assert run.namespace == "evalns"
      assert run.lineage_ref == %{trace: "eval"}
    end

    test "enforces required keys" do
      assert_raise ArgumentError, fn -> struct!(EvalRun, %{}) end
    end
  end
end
