cwlVersion: v1.0
class: CommandLineTool
id: CollectReadCounts

doc: |
  Collect raw counts data (1 PER SAMPLE/BAM). 

requirements:
  DockerRequirement:
    dockerPull: 'hub.docker.com/broadinstitute/gatk:4.1.5.0'

baseCommand: [gatk, CollectReadCounts]

inputs:
  ref_genome:
    type: File[]
    inputBinding:
      position: 1
      prefix: -R
  exomes_bed
    type: File[]
    inputBinding:
      position: 2
      prefix: -L
  bam_files:
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
  file_format:
    type: string
    default: TSV
    inputBinding:
      prefix: --format

outputs:
  count_data:
    type: array
      items: File[]
    outputBinding:
      glob: $(inputs.bam_files.basename)_alignment.bam.tsv
      prefix: "-O"
