cwlVersion: v1.0
class: CommandLineTool
id: MergeDepths

requirements:
  MultipleInputFeatureRequirement: {}
  DockerRequirement:
    dockerPull: 'https://quay.io/repository/biocontainers/xhmm?tag=0.0.0.2016_01_04.cc14e52--h565583a_1&tab=tags'


baseCommand: [xhmm, --mergeGATKdepths]

inputs:
  filesB:
    type:
      type: array
      items: File[]
      inputBinding:
        prefix: -GATKdepths
        separate: false
    inputBinding:
      position: 2

outputs:
  merged_depth:
    type: File
    inputBinding:
      prefix: '-o'
