cwlVersion: v1.0
class: CommandLineTool
id: FilterTargetsAndMeanCenter

requirements:
  DockerRequirement:
    dockerPull: 'https://quay.io/repository/biocontainers/xhmm?tag=0.0.0.2016_01_04.cc14e52--h565583a_1&tab=tags'


baseCommand: [xhmm, --mergeGATKdepths, --centerData, --centerType, target, --minTargetSize, 10, --maxTargetSize, 10000, --minMeanTargetRD, 10, --maxMeanTargetRD, 250, --minMeanSampleRD, 25, --maxMeanSampleRD, 200, --maxSdSampleRD, 150]


inputs:
  read_count:
    type: File
    inputBinding:
      prefix: '-r'

  exclude_targets:
    type: File
    inputBinding:
      prefix: '-excludeTargets'


outputs:
  outputExcludedTargets:
      type: File
      outputBinding:
        glob: $(inputs.read_count.basename)_excludedSamples.txt
        prefix: '-outputExcludedTargets'

  outputExcludedSamples:
      type: File
      outputBinding:
        glob: $(inputs.read_count.basename)_excludedSamples.txt
        prefix: '-outputExcludedSamples'

  filtered_centered:
      type: File
      outputBinding:
        glob: $(inputs.read_count.basename)_filtered_centered.txt
        prefix: '-o'



#xhmm --matrix -r  ${output}/DATA.1000G.txt --excludeTargets ${output}/extreme_gc_targets.txt  \
#                        -o ${output}/DATA.filtered_centered.${tag}.txt \
#                        --outputExcludedTargets ${output}/DATA.filtered_centered.${tag}.txt.filtered_targets.txt 
#                        --outputExcludedSamples ${output}/DATA.filtered_centered.${tag}.txt.filtered_samples.txt 
#                        --centerData --centerType target \
#                        --minTargetSize 10 --maxTargetSize 10000 \
#                        --minMeanTargetRD 10 --maxMeanTargetRD 500 \
#                        --minMeanSampleRD 25 --maxMeanSampleRD 200 \
#                        --maxSdSampleRD 150
