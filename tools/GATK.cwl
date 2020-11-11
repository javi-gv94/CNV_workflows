cwlVersion: v1.0
class: CommandLineTool
id: GATK_workflow_BP

doc: |
  GATK CNV calling best practices workflow

requirements:
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerPull: 'hub.docker.com/broadinstitute/gatk:4.1.5.0'

steps:
    PreprocessIntervals
        baseCommand: [gatk  .....  ]

        arguments:
        - prefix: "-i"
        ########################

        inputs:
        input:
            type: File[]
            inputBinding:
            position: 2

        outputs:
        output_1:
        #############

    AnnotateIntervals
        baseCommand: [gatk  .....  ]

        arguments:
        - prefix: "-i"
        ########################

        inputs:
        input:
            type: File[]
            inputBinding:
            position: 2

        outputs:
        output_1:
        #############