cwlVersion: v1.0
class: CommandLineTool
id: CollectCoverage

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: 'https://quay.io/repository/biocontainers/xhmm?tag=0.0.0.2016_01_04.cc14e52--h565583a_1&tab=tags'


baseCommand: [java -jar ${gatk_local_jar}, -T, DepthOfCoverage, -dt, BY_SAMPLE, -dcov, 5000, -l, INFO, --omitDepthOutputAtEachBase, --omitLocusTable, --minBaseQuality, 0, --minMappingQuality, 20, --start, 1, --stop, 5000, --nBins, 200, --includeRefNSites,  --countType, COUNT_FRAGMENTS ]


arguments: 
  - prefix: "-o"
    valueFrom: $(inputs.bam_file.nameroot).bam


inputs:
  bam_file:
    type: File
    inputBinding:
      prefix: '-I'
  ref_genome:
    type: File
    inputBinding:
      prefix: '-R'
  bed_file:
    type: File
    inputBinding:
      prefix: '-L'


outputs:
  depth_file:
    type: File
    outputBinding:
      glob: $(inputs.out_prefix)".sample_interval_summary"
    secondaryFiles:
      - $(inputs.out_prefix)".sample_interval_statistics"
      - $(inputs.out_prefix)".sample_summary"
      - $(inputs.out_prefix)".sample_statistics"



#java -jar /usr/local/bioinfo/gatk/3.8/GenomeAnalysisTK.jar \
#-T DepthOfCoverage \
#-I ${bam} -L $BED \
#-R $REF \
#-dt BY_SAMPLE -dcov 5000 -l INFO --omitDepthOutputAtEachBase --omitLocusTable \
#--minBaseQuality 0 --minMappingQuality 20 --start 1 --stop 5000 --nBins 200 \
#--includeRefNSites \
#--countType COUNT_FRAGMENTS \
#-o ${prefix}



