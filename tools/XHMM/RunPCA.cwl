cwlVersion: v1.0
class: CommandLineTool
id: RunPCA

requirements:
  DockerRequirement:
    dockerPull: 'https://quay.io/repository/biocontainers/xhmm?tag=0.0.0.2016_01_04.cc14e52--h565583a_1&tab=tags'


baseCommand: [xhmm --PCA]

inputs:
filtered_centered:
    type: File
    inputBinding:
      prefix: '-r'


outputs:
pca_file:
    type: String
    outputBinding:
      prefix: '--PCAfiles'
      glob: $(inputs.filtered_centered.basename)"_PCA.txt"
