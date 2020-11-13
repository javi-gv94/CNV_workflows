cwlVersion: v1.0
class: CommandLineTool
id: FilterOriginalReadDepth

requirements:
  DockerRequirement:
    dockerPull: 'https://quay.io/repository/biocontainers/xhmm?tag=0.0.0.2016_01_04.cc14e52--h565583a_1&tab=tags'


baseCommand: [xhmm, --matrix]


inputs:
  merged_depth:
    type: File
    inputBinding:
      prefix: '-r'
  outputExcludedTargets:
      type: File
      inputBinding:
        prefix: '-outputExcludedTargets'
  outputExcludedSamples:
      type: File
      inputBinding:
        prefix: '-outputExcludedSamples'


outputs:
  filtered_rawdata:
    type: String
    inputBinding:
      prefix: '-o'
      glob: $(inputs.merged_depth.basename)_filtered.txt


