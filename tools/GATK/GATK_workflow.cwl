cwlVersion: v1.0
class: Workflow
id: gCNV_GATK_workflow_BP

doc: |
  GATK CNV calling best practices workflow

requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  ##

outputs:
  ##

steps:

  PreprocessIntervals:
    run: GATK_PreprocessIntervals.cwl
    in:
      ref_genome: reference_fasta
      exomes_bed: exome_files
    out: [processed_bed]
  
  AnnotateIntervals:
    run: GATK_AnnotateIntervals.cwl
    in:
      ref_genome: reference_fasta
      exomes_bed: PreprocessIntervals/processed_bed
    out: [GCannot_table]

  CollectReadCounts:
    run: GATK_CollectReadCounts.cwl
    in:
      ref_genome: reference_fasta
      exomes_bed: PreprocessIntervals/processed_bed
      bam_files: samples_bams
    out: [count_data]

  FilterIntervals:
    run: GATK_FilterIntervals.cwl
    in:
      exomes_bed: PreprocessIntervals/processed_bed
      annot_intervals: AnnotateIntervals/GCannot_table
      count_data: CollectReadCounts/count_data
    out: [filtered_bed]
  
  DetermineGermlineContigPloidy:
    run: GATK_DetermineGermlineContigPloidy.cwl
    in:
      exomes_bed: FilterIntervals/filtered_bed
      count_data: CollectReadCounts/count_data
      contig-ploidy-priors: priors_file
    out: [out_dir]

  IntervalListTools:
    run: GATK_IntervalListToolsy.cwl
    in:
      exomes_bed: FilterIntervals/filtered_bed
    out: [out_dir]


 