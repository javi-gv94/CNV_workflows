cwlVersion: v1.0
class: CommandLineTool
id: IntervalListTools

doc: |
  Make Interval lists for scattering


requirements:
  DockerRequirement:
    dockerPull: 'hub.docker.com/broadinstitute/gatk:4.1.5.0'

baseCommand: [gatk, IntervalListTools]

inputs:
  exomes_bed
    type: File[]
    inputBinding:
      position: 1
      prefix: "--INPUT"
  subdiv_mode:
    type: string
    default: INTERVAL_COUNT
    inputBinding:
      prefix: --SUBDIVISION_MODE
  subdiv_mode:
    type: int
    default: 5000
    inputBinding:
      prefix: --SCATTER_CONTENT
  out_dir:
    type: string
    default: "out_dir_gatk"


outputs:
  out_dir:
    type: Directory
    outputBinding:
      glob: $(inputs.out_dir)/scatter
      prefix: "--OUTPUT"
