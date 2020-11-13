cwlVersion: v1.0
class: CommandLineTool
id: FilterIntervals

doc: |
  FilterIntervals based on GC-content and cohort extreme counts


requirements:
  DockerRequirement:
    dockerPull: 'hub.docker.com/broadinstitute/gatk:4.1.5.0'

baseCommand: [gatk, FilterIntervals]

inputs:
  exomes_bed
    type: File[]
    inputBinding:
      position: 1
      prefix: "-L"
  annot_intervals
    type: File[]
    inputBinding:
      position: 2
      prefix: "--annotated-intervals"
  count_data:
    type:
      type: array
      items: File[]
      inputBinding:
        prefix: -I
        separate: false
    inputBinding:
      position: 3
  imr:
    type: string
    default: OVERLAPPING_ONLY
    inputBinding:
      prefix: -imr


outputs:
  filtered_bed:
    type: File
    outputBinding:
      glob: "cohort.gc.filtered.interval_list"
      prefix: "-O"
