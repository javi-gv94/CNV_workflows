cwlVersion: v1.0
class: CommandLineTool
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
      reference_genome: reference_fasta
      input_reads: fastq_files
    out: [aligned_bam]

 