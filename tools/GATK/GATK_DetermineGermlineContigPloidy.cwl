cwlVersion: v1.0
class: CommandLineTool
id: DetermineGermlineContigPloidy

doc: |
  Call autosomal and allosomal contig ploidy with DetermineGermlineContigPloidy


requirements:
  DockerRequirement:
    dockerPull: 'hub.docker.com/broadinstitute/gatk:4.1.5.0'

baseCommand: [gatk, DetermineGermlineContigPloidy, --verbosity, DEBUG]

inputs:
  exomes_bed
    type: File[]
    inputBinding:
      position: 1
      prefix: "-L"
  count_data:
    type:
      type: array
      items: File[]
      inputBinding:
        prefix: -I
        separate: false
    inputBinding:
      position: 2
  contig-ploidy-priors
    type: File[]
    inputBinding:
      position: 3
      prefix: "--contig-ploidy-priors"
  imr:
    type: string
    default: OVERLAPPING_ONLY
    inputBinding:
      prefix: -imr
  out_prefix:
    type: string
    default: ploidy
    inputBinding:
      prefix: --output-prefix
  out_dir:
    type: string
    default: "out_dir_gatk"


outputs:
  out_dir:
    type: Directory
    outputBinding:
      glob: $(inputs.out_dir)
      prefix: "--output"
