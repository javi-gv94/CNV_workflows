cwlVersion: v1.0
class: Workflow
id: XHMM_workflow

doc: |
  XHMM CNV calling

requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  bam_files: {type: 'File[]', doc: "BAM files"}
  reference_fasta: {type: File, doc: "Reference Genome"}
  exome_bed: {type: File, doc: "WES Target File"}
  params: {type: File, doc: "Parameters File"}

outputs:
  bed_file: {type: File, outputSource: final_filtering/bed_file}



steps:

  CollectCoverage: # For each array
    run: CollectCoverage.cwl
    in:
      bam_file: exome_bam
      ref_genome: reference_fasta
      bed_file: exome_bed
    out: [depth_file]
  

  MergeDepths:
    run: MergeDepths.cwl
    in:
      input:
        source: CollectCoverage/depth_file  # must be an array
    out: [merged_depth]


  GCContentByInterval:
    run: GCContentByInterval.cwl
    in:
      ref_genome: reference_fasta
      bed_file: exome_bed
    out: [locus_GC]
  

  FilterTargetsAndMeanCenter:
    run: FilterTargetsAndMeanCenter.cwl
    in:
      input1:
        source: merged_depth: MergeDepths/merged_depth 
      input2:
        source: Cexclude_targets: GCContentByInterval/locus_GC
    out: [outputExcludedTargets]
    out: [outputExcludedSamples]
    out: [filtered_centered]


  RunPCA:
    run: RunPCA.cwl
    in:
      input:
        source:FilterTargetsAndMeanCenter/filtered_centered
    out: [pca_file]
  

  NormalizeCounts:
      run: NormalizeCounts.cwl
      in:
        input1:
          source:RunPCA/pca_file
        input2:
          source:FilterTargetsAndMeanCenter/filtered_centered
      out: [normalized_counts]
    


  FilterAndZScoreCenter:
    run: FilterAndZScoreCenter.cwl
    in:
      input:
        source: NormalizeCounts/normalized_counts 
    out: [outputExcludedTargets]
    out: [outputExcludedSamples]
    out: [filtered_centered]



  FilterOriginalReadDepth:
    run: FilterOriginalReadDepth.cwl
    in:
      input1:
        source:MergeDepths/merged_depth
      input2:
        source:FilterAndZScoreCenter/outputExcludedTargets
      input3:
        source:FilterAndZScoreCenter/outputExcludedSamples
    out: [filtered_rawdata]



  CNVdetection:
    run: CNVdetection.cwl
    in:
      bam_file: params
      input2:
        source:FilterAndZScoreCenter/filtered_normalized
      input3:
        source:FilterOriginalReadDepth/filtered_raw
    out: [filtered_rawdata]




  CNVgenotyping:
    run: CNVgenotyping.cwl
    in:
      bam_file: params
      input2:
        source:FilterAndZScoreCenter/filtered_normalized
      input3:
        source:FilterOriginalReadDepth/filtered_raw
      ref_genome: reference_fasta
    out: [cnv_vcf]

















 