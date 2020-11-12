cwlVersion: v1.0
class: Workflow
id: GATK_workflow_BP

doc: |
  GATK CNV calling best practices workflow

requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  ##

outputs:
  ##

steps:

  PreprocessIntervals:
    run: GATK_PreprocessIntervals.cwl
    in:
      ref_genome: reference_fasta
      exomes_bed: exome_files
    out: [processed_bed]
  
  AnnotateIntervals:
    run: AnnotateIntervals.cwl
    in:
      ref_genome: reference_fasta
      exomes_bed: PreprocessIntervals/processed_bed
    out: [GCannot_table]

 