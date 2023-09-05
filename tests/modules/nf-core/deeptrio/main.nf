#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { DEEPTRIO } from '../../../../modules/nf-core/deeptrio/main.nf'
include { DEEPTRIO as DEEPTRIO_INTERVALS } from '../../../../modules/nf-core/deeptrio/main.nf'

workflow test_deeptrio {

    proband_bam_tuple_ch = Channel.of([
        [id:'proband-test', single_end:false ], // meta map
        file('https://github.com/google/deepvariant/blob/ab068c4588a02e2167051bd9e74c0c9579462b51/deeptrio/testdata/input/HG001.chr20.10_10p1mb_sorted.bam'),
        file('https://github.com/google/deepvariant/blob/ab068c4588a02e2167051bd9e74c0c9579462b51/deeptrio/testdata/input/HG001.chr20.10_10p1mb_sorted.bam.bai'),
        []
    ])

    family1_bam_tuple_ch = Channel.of([
        [id:'family1-test', single_end:false],
        file('https://github.com/google/deepvariant/blob/ab068c4588a02e2167051bd9e74c0c9579462b51/deeptrio/testdata/input/NA12891.chr20.10_10p1mb_sorted.bam'),
        file('https://github.com/google/deepvariant/blob/ab068c4588a02e2167051bd9e74c0c9579462b51/deeptrio/testdata/input/NA12891.chr20.10_10p1mb_sorted.bam.bai'),
        []
    ])

    family2_bam_tuple_ch = Channel.of([
        [id:'family2-test', single_end:false],
        file('https://github.com/google/deepvariant/blob/ab068c4588a02e2167051bd9e74c0c9579462b51/deeptrio/testdata/input/NA12892.chr20.10_10p1mb_sorted.bam'),
        file('https://github.com/google/deepvariant/blob/ab068c4588a02e2167051bd9e74c0c9579462b51/deeptrio/testdata/input/NA12892.chr20.10_10p1mb_sorted.bam.bai'),
        []
    ])

    fasta = [
        [id:'genome'],
        file('https://github.com/google/deepvariant/blob/ab068c4588a02e2167051bd9e74c0c9579462b51/deeptrio/testdata/input/hs37d5.chr20.fa.gz')
    ]

    fai = [
        [id:'genome'],
        file('https://github.com/google/deepvariant/blob/ab068c4588a02e2167051bd9e74c0c9579462b51/deeptrio/testdata/input/hs37d5.chr20.fa.gz.fai')
    ]

    DEEPTRIO(proband_bam_tuple_ch, family1_bam_tuple_ch, family2_bam_tuple_ch, fasta, fai, [[],[]])
}

/*
workflow test_deeptrio_cram_intervals {
    proband_cram_tuple_ch = Channel.of([
        [],
        file(''),
        file(''),
        []
    ])

    family1_cram_tuple_ch = Channel.of([
        [],
        file(''),
        file(''),
        []
    ])

    family2_cram_tuple_ch = Channel.of([
        [],
        file(''),
        file(''),
        []
    ])

    fasta = [
        [],
        file(''),
    ]

    fai = [
        [],
        file('')
    ]

    DEEPTRIO_INTERVALS(proband_cram_tuple_ch, family1_cram_tuple_ch, family2_cram_tuple_ch, fasta, fai, [[],[]])
}

workflow test_deepvariant_fasta_gz {
    proband_bam_tuple_ch = Channel.of([
        [],
        file(''),
        file(''),
        []
    ])

    family1_bam_tuple_ch = Channel.of([
        [],
        file(''),
        file(''),
        []
    ])

    family2_bam_tuple_ch = Channel.of([
        [],
        file(''),
        file(''),
        []
    ])

    fasta_gz = [
        [],
        file('')
    ]

    fasta_gz_fai = [
        [],
        file('')
    ]

    fasta_gz_gzi = [
        [],
        file('')
    ]

    DEEPTRIO(proband_bam_tuple_ch, family1_bam_tuple_ch, family2_bam_tuple_ch, fasta_gz, fasta_gz_fai, fasta_gz_gzi)
}
*/
