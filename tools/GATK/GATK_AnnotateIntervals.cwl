cwlVersion: v1.0
class: CommandLineTool
id: AnnotateIntervals

doc: |
  ANNOTATE AND FILTER INTERVALS with features and subset regions of interest with FilterIntervals
  AnnotateIntervals with GC content

requirements:
  DockerRequirement:
    dockerPull: 'hub.docker.com/broadinstitute/gatk:4.1.5.0'

baseCommand: [gatk, AnnotateIntervals]

inputs:
  ref_genome:
    type: File[]
    inputBinding:
      position: 1
      prefix: "-R"
  exomes_bed
    type: File[]
    inputBinding:
      position: 2
      prefix: "-L"
  imr:
    type: string
    default: OVERLAPPING_ONLY
    inputBinding:
      prefix: -imr


outputs:
  GCannot_table:
    type: File
    outputBinding:
      glob: $(inputs.exomes_bed.basename).annotated.tsv
      prefix: "-O"
