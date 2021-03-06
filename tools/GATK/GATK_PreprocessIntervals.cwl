cwlVersion: v1.0
class: CommandLineTool
id: PreprocessIntervals

doc: |
  PreprocessIntervals
  PROCESS INTERVALS: For exome data, pad target regions, e.g. with 250 bases.

requirements:
  DockerRequirement:
    dockerPull: 'hub.docker.com/broadinstitute/gatk:4.1.5.0'

baseCommand: [gatk, PreprocessIntervals]

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
  bin-length:
    type: int
    default: 0
    inputBinding:
      prefix: --bin-length
  imr:
    type: string
    default: OVERLAPPING_ONLY
    inputBinding:
      prefix: -imr


outputs:
  processed_bed:
    type: File
    outputBinding:
      glob: $(inputs.exomes_bed.basename).preprocessed.interval_list
      prefix: "-O"
