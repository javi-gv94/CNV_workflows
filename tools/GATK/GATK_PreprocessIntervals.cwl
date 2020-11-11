cwlVersion: v1.0
class: CommandLineTool
id: PreprocessIntervals

doc: |
  PreprocessIntervals

requirements:
  DockerRequirement:
    dockerPull: 'hub.docker.com/broadinstitute/gatk:4.1.5.0'

baseCommand: [gatk, PreprocessIntervals]

arguments:
    - prefix: "-R"
    valueFrom: $(inputs.ref_genome[0])

    - prefix: "-L"
    valueFrom: $(inputs.exomes_bed[0])


inputs:
  ref_genome:
    type: File[]
    inputBinding:
      position: 1
  exomes_bed
    type: File[]
    inputBinding:
      position: 2
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
