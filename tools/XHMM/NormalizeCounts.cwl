cwlVersion: v1.0
class: CommandLineTool
id: NormalizeCounts

requirements:
  DockerRequirement:
    dockerPull: 'https://quay.io/repository/biocontainers/xhmm?tag=0.0.0.2016_01_04.cc14e52--h565583a_1&tab=tags'


baseCommand: [xhmm, --normalize, --PCnormalizeMethod, PVE_mean, --PVE_mean_factor, 0.7]

inputs:
  pca_file:
    type: File
    inputBinding:
      prefix: '--PCAfiles'

  filtered_centered:
    type: File
    inputBinding:
      prefix: '-r'

outputs:
  normalized_counts:
    type: String
    outputBinding:
      prefix: '--normalizeOutput'
      glob: $(inputs.filtered_centered.basename)"_PCAnormalized.txt"



