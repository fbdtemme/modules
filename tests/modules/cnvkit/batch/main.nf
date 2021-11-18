#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { CNVKIT as CNVKIT_TUMORONLY } from '../../../../modules/cnvkit/batch/main.nf' addParams( options: [ 'args': '--reference reference.cnn --method wgs' ] )
include { CNVKIT }               from '../../../../modules/cnvkit/batch/main.nf' addParams( options: [ 'args': '--output-reference reference.cnn' ] )
include { CNVKIT as CNVKIT_WGS } from '../../../../modules/cnvkit/batch/main.nf' addParams( options: [ 'args': '--output-reference reference.cnn --method wgs' ] )

workflow test_cnvkit_tumoronly {
    input = [ [ id:'test'], // meta map
              [ file(params.test_data['homo_sapiens']['illumina']['test2_paired_end_sorted_bam'], checkIfExists: true) ],
              [ ]
            ]
    fasta   = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    reference   = file(params.test_data['generic']['cnn']['reference'], checkIfExists: true)

    CNVKIT_TUMORONLY ( input, [], [], reference )
}

workflow test_cnvkit_hybrid {
    tumorbam = file(params.test_data['sarscov2']['illumina']['test_paired_end_sorted_bam'], checkIfExists: true)
    normalbam = file(params.test_data['sarscov2']['illumina']['test_single_end_sorted_bam'], checkIfExists: true)

    input = [ [ id:'test' ], // meta map
              tumorbam,
              normalbam
            ]
    fasta   = file(params.test_data['sarscov2']['genome']['genome_fasta'], checkIfExists: true)
    targets = file(params.test_data['sarscov2']['genome']['baits_bed'], checkIfExists: true)

    CNVKIT ( input, fasta, targets, [] )
}

workflow test_cnvkit_wgs {
    input = [ [ id:'test'], // meta map
              [ file(params.test_data['homo_sapiens']['illumina']['test2_paired_end_sorted_bam'], checkIfExists: true) ],
              [ file(params.test_data['homo_sapiens']['illumina']['test_paired_end_sorted_bam'], checkIfExists: true) ]
            ]
    fasta   = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)

    CNVKIT_WGS ( input, fasta, [], [] )
}


workflow test_cnvkit_cram {
    input = [ [ id:'test'], // meta map
              [ file(params.test_data['homo_sapiens']['illumina']['test2_paired_end_sorted_cram'], checkIfExists: true) ],
              [ file(params.test_data['homo_sapiens']['illumina']['test_paired_end_sorted_cram'], checkIfExists: true) ]
            ]
    fasta   = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)

    CNVKIT_WGS ( input, fasta, [], [] )
}

