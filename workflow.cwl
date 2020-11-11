cwlVersion: v1.0
class: Workflow
id: CNV_FJD

requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  fastq_files: {type: 'File[]', doc: "FASTQ files"}
  reference_fasta: {type: File, doc: "Reference Genome"}

outputs:
  aligned_bam: {type: 'File[]', outputSource: alignment_to_reference/aligned_bam}
  bed_file: {type: File, outputSource: final_filtering/bed_file}

steps:

  alignment_to_reference:
    run: tools/bwa_mem.cwl
    in:
      reference_genome: reference_fasta
      input_reads: fastq_files
    out: [aligned_bam]

  picard_markduplicates:
    run: tools/picard_markduplicates.cwl
    in:
      input:
        source: alignment_to_reference/Int2
    out: [Int3]

  bam_filtering:
    run: tools/samtools_view.cwl
    in:
      input:
        source: picard_markduplicates/Int3
    out: [Int4]

  cnv_gatk:
    run: tools/gatk.cwl
    in:
      input:
        source: bam_filtering/Int4
    out: [Int5]

  cnv_xhmm:
    run: tools/xhmm.cwl
    in:
      input:
        source: bam_filtering/Int4
    out: [Int6]

  cnv_exomedepth:
    run: tools/exome_depth.cwl
    in:
      input:
        source: bam_filtering/Int4
    out: [Int7]

  cnv_codex:
    run: tools/codex.cwl
    in:
      input:
        source: bam_filtering/Int4
    out: [Int8]

  final_intersection:
    run: tools/bedtools.cwl
    in:
      input_1:
        source: cnv_gatk/Int5
      input_2:
        source: cnv_xhmm/Int6
      input_3:
        source: cnv_exomedepth/Int7
      input_4:
        source: cnv_codex/Int8
    out: [bed_file]
