cwlVersion: v1.0
class: CommandLineTool
id: CNV_XHMM

doc: |
  XHMM CNV calling

requirements:
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerPull: 'https://quay.io/repository/biocontainers/xhmm?tag=0.0.0.2016_01_04.cc14e52--h565583a_1&tab=tags'

    "https://github.com/broadinstitute/gatk-evaluation/blob/master/CNV/gCNV/xhmm/docker/README.md"

steps:


    CollectCoverage per sample
        baseCommand: [ java -jar -Xmx${command_mem_mb}m ${gatk_local_jar} \
            -T DepthOfCoverage -I ${bamlist} -L $BED -R $REF \
            -dt BY_SAMPLE -dcov 5000 -l INFO --omitDepthOutputAtEachBase --omitLocusTable \
            --minBaseQuality 0 --minMappingQuality 20 --start 1 --stop 5000 --nBins 200 \
            --includeRefNSites \
            --countType COUNT_FRAGMENTS \
            -o ${output} ]


        ########################
    
        inputs:
          bam_file:
            type: File[]
            inputBinding:
              prefix: '-I'
          reference:
            type: File[]
            inputBinding:
              prefix: '-R'
          bed_file:
            type: File[]
            inputBinding:
              prefix: '-L'
          output:
            type: int
            inputBinding:
              prefix: '-o'


        outputs:
        output_1: 

        #############






    MergeDepths
        baseCommand: [xhmm  --mergeGATKdepths]


        ########################

        inputs:
           --GATKdepths ${sep=" --GATKdepths " depth_files}
            type: String
            inputBinding:
              position: 1
          output:
            type: File[]
            inputBinding:
              prefix: '-o'


        outputs:
        output_1:

        #############




    GCContentByInterval
        baseCommand: [java -jar /usr/local/bioinfo/gatk/3.8/GenomeAnalysisTK.jar \
                        -T GCContentByInterval -L $BED \
                        -R $REF \
                        -o $output/DATA.locus_GC.txt

                        cat $output/DATA.locus_GC.txt | awk '{if ($2 < 0.1 || $2 > 0.9) print $1}' \
                        >  ${output}/extreme_gc_targets.txt]


        ########################
        

        inputs:
          bed_file:
            type: File[]
            inputBinding:
              prefix: '-L'
          reference:
            type: File[]
            inputBinding:
              prefix: '-R'
          locus_GC:
            type: File[]
            inputBinding:
              prefix: '-o'

        outputs:
        output_1:
        output_2:
        #############



    
    FilterTargetsAndMeanCenter
        baseCommand: [xhmm --matrix -r  ${output}/DATA.1000G.txt --excludeTargets ${output}/extreme_gc_targets.txt  \
                        --centerData --centerType target \
                        -o ${output}/DATA.filtered_centered.${tag}.txt \
                        --outputExcludedTargets ${output}/DATA.filtered_centered.${tag}.txt.filtered_targets.txt \
                        --outputExcludedSamples ${output}/DATA.filtered_centered.${tag}.txt.filtered_samples.txt \
                        --minTargetSize 10 --maxTargetSize 10000 \
                        --minMeanTargetRD 10 --maxMeanTargetRD 500 \
                        --minMeanSampleRD 25 --maxMeanSampleRD 200 \
                        --maxSdSampleRD 150 ]


        ########################

        inputs:
          read_count:
            type: File[]
            inputBinding:
              prefix: '-r'

          excludeTargets:
            type: File[]
            inputBinding:
              prefix: '-excludeTargets'


        outputs:
        output_1:
            outputExcludedTargets:
            type: File[]
            inputBinding:
              prefix: '-outputExcludedTargets'

        output_2:
            outputExcludedTargets:
            type: File[]
            inputBinding:
              prefix: '-outputExcludedTargets'

        output_3:
            filtered_centered:
            type: File[]
            inputBinding:
              prefix: '-o'

        #############


    
    RunPCA
        baseCommand: [xhmm --PCA -r ${output}/DATA.filtered_centered.${tag}.txt --PCAfiles ${output}/DATA.${tag}_PCA]

        ########################

        inputs:
        filtered_centered:
            type: File[]
            inputBinding:
              prefix: '-r'


        outputs:
        output_1:

            panel_of_normals:
            type: String
            inputBinding:
              prefix: '--PCAfiles'
    
        #############




    NormalizeCounts
        baseCommand: [xhmm --normalize -r  ${output}/DATA.filtered_centered.${tag}.txt --PCAfiles ${output}/DATA.${tag}_PCA \
                        --normalizeOutput ${output}/DATA.PCA_normalized.txt \
                        --PCnormalizeMethod PVE_mean --PVE_mean_factor 0.7]


        ########################

        inputs:
        filtered_centered:
            type: File[]
            inputBinding:
            position: "-r"

        panel_of_normals:
            type: File[]
            inputBinding:
            position: '--PCAfiles'

        outputs:
        output_1:
            normalized:
            type: File[]
            inputBinding:
              prefix: '--normalizeOutput'
    

        #############




    FilterAndZScoreCenter
        baseCommand:  [xhmm --matrix -r  ${output}/DATA.PCA_normalized.txt --centerData --centerType sample --zScoreData \
                        -o  ${output}/DATA.PCA_normalized.filtered.sample_zscores.${tag}.txt \
                        --outputExcludedTargets  ${output}/DATA.PCA_normalized.filtered.sample_zscores.${tag}.txt.filtered_targets.txt \
                        --outputExcludedSamples  ${output}/DATA.PCA_normalized.filtered.sample_zscores.${tag}.txt.filtered_samples.txt \
                        --maxSdTargetRD 30]

        ########################

        inputs:
        input:
            type: File[]
            inputBinding:
            position: 2

        outputs:
        output_1:
        #############




    FilterOriginalReadDepth
        baseCommand: [xhmm --matrix -r ${output}/DATA.1000G.txt \
                        --excludeTargets ${output}/DATA.filtered_centered.${tag}.txt.filtered_targets.txt \
                        --excludeTargets ${output}/DATA.PCA_normalized.filtered.sample_zscores.${tag}.txt.filtered_targets.txt \
                        --excludeSamples ${output}/DATA.filtered_centered.${tag}.txt.filtered_samples.txt \
                        --excludeSamples ${output}/DATA.PCA_normalized.filtered.sample_zscores.${tag}.txt.filtered_samples.txt \
                        -o ${output}/DATA.same_filtered.${tag}.txt]


        ########################

        inputs:
        input:
            type: File[]
            inputBinding:
            position: 2

        outputs:
        output_1:
        #############


    DiscoverCNV
        baseCommand: [xhmm --discover -p ${output}/params.txt \
                        -r ${output}/DATA.PCA_normalized.filtered.sample_zscores.${tag}.txt -R ${output}/DATA.same_filtered.${tag}.txt \
                        -c ${output}/DATA.xcnv -a ${output}/DATA.aux_xcnv -s ${output}/DATA]


        ########################

        inputs:
        input:
            type: File[]
            inputBinding:
            position: 2

        outputs:
        output_1:
        #############





    
    GenotypeCNV
        baseCommand: [xhmm --genotype -p ${output}/params.txt \
                        -r ${output}/DATA.PCA_normalized.filtered.sample_zscores.${tag}.txt -R ${output}/DATA.same_filtered.${tag}.txt \
                        -g ${output}/DATA.xcnv -F $REF \
                        -v ${output}/DATA.vcf]

        ########################

        inputs:
        input:
            type: File[]
            inputBinding:
            position: 2

        outputs:
        output_1:

        #############

