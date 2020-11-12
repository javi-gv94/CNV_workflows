cwlVersion: v1.0
class: CommandLineTool
id: FilterAndZScoreCenter

requirements:
  DockerRequirement:
    dockerPull: 'https://quay.io/repository/biocontainers/xhmm?tag=0.0.0.2016_01_04.cc14e52--h565583a_1&tab=tags'


baseCommand: [xhmm, --matrix, --centerData, --centerType, sample, --zScoreData, --maxSdTargetRD 30]


inputs:
  pca_normalized:
    type: File
    inputBinding:
      prefix: '-r'

outputs:
  filteredNormData:
    type: String
    inputBinding:
      prefix: '-o'

  outputExcludedTargets:
      type: File
      inputBinding:
        prefix: '-outputExcludedTargets'

  outputExcludedSamples:
      type: File
      inputBinding:
        prefix: '-outputExcludedSamples'

