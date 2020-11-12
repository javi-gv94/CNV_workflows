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
panel_of_normals:
    type: String
    inputBinding:
      prefix: '--PCAfiles'