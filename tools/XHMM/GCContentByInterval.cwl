cwlVersion: v1.0
class: CommandLineTool
id: GCContentByInterval

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: 'https://quay.io/repository/biocontainers/xhmm?tag=0.0.0.2016_01_04.cc14e52--h565583a_1&tab=tags'


baseCommand: [java -jar ${gatk_local_jar}, -T, GCContentByInterval}


inputs:
  reference:
    type: File
    inputBinding:
      prefix: '-R'
  bed_file:
    type: File
    inputBinding:
      prefix: '-L'

outputs:
  locus_GC:
    type: File
    inputBinding:
      prefix: '-o'






#java -jar /usr/local/bioinfo/gatk/3.8/GenomeAnalysisTK.jar \
#                        -T GCContentByInterval -L $BED \
#                        -R $REF \
#                        -o $output/DATA.locus_GC.txt

#                       cat $output/DATA.locus_GC.txt | awk '{if ($2 < 0.1 || $2 > 0.9) print $1}' \
#                       >  ${output}/extreme_gc_targets.txt]

