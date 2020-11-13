cwlVersion: v1.0
class: CommandLineTool
id: CNVgenotyping

requirements:
  DockerRequirement:
    dockerPull: 'https://quay.io/repository/biocontainers/xhmm?tag=0.0.0.2016_01_04.cc14e52--h565583a_1&tab=tags'


baseCommand: [xhmm, --genotype]


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
  cnv_xcnv:
      type: File
      inputBinding:
        prefix: '-g'
  ref_genome:
    type: File
    inputBinding:
      prefix: '-F'

outputs:
  cnv_vcf:
    type: File
    inputBinding:
      prefix: '-v'
      glob: $(inputs.filtered_normalized_data.basename).vcf