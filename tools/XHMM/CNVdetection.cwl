cwlVersion: v1.0
class: CommandLineTool
id: CNVdetection

requirements:
  DockerRequirement:
    dockerPull: 'https://quay.io/repository/biocontainers/xhmm?tag=0.0.0.2016_01_04.cc14e52--h565583a_1&tab=tags'


baseCommand: [xhmm, --discover]


inputs:

  params:
    type: File
    inputBinding:
      prefix: '-p'
  filtered_normalized_data:
    type: File
    inputBinding:
      prefix: '-r'
  filtered_raw_data:
      type: File
      inputBinding:
        prefix: '-R'

outputs:
  cnv_xcnv:
    type: String
    inputBinding:
      prefix: '-c'
      glob: $(inputs.filtered_normalized_data.basename).xcnv

  cnv_aux_xcnv:
    type: String
    inputBinding:
      prefix: '-a'
      glob: $(inputs.filtered_normalized_data.basename).aux_xcnv

  cnv:
    type: String
    inputBinding:
      prefix: '-s'
      glob: $(inputs.filtered_normalized_data.basename).data
