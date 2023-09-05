process DEEPTRIO {
    tag "$meta.id"
    label 'process_high'

    container "docker.io/google/deepvariant:deeptrio-latest"

    input:
    tuple val(meta), path(bam_proband), path(proband_index), path(intervals)
    tuple val(meta2), path(bam_family1), path(family1_index), path(intervals)
    tuple val(meta3), path(bam_family2), path(family2_index), path(intervals)
    tuple val(meta4), path(fasta)
    tuple val(meta5), path(fai)
    tuple val(meta6), path(gzi)

    output:
    tuple val(meta), path("${prefix}.proband.vcf.gz")       , emit: proband_vcf
    tuple val(meta), path("${prefix}.family1.vcf.gz")       , emit: family1_vcf
    tuple val(meta), path("${prefix}.family2.vcf.gz")       , emit: family2_vcf
    tuple val(meta), path("${prefix}.proband.vcf.gz.tbi")   , emit: proband_vcf_tbi
    tuple val(meta), path("${prefix}.family1.vcf.gz.tbi")   , emit: family1_vcf_tbi
    tuple val(meta), path("${prefix}.family2.vcf.gz.tbi")   , emit: family2_vcf_tbi
    tuple val(meta), path("${prefix}.proband.g.vcf.gz")     , emit: proband_gvcf
    tuple val(meta), path("${prefix}.family1.g.vcf.gz")     , emit: family1_gvcf
    tuple val(meta), path("${prefix}.family2.g.vcf.gz")     , emit: family2_gvcf
    tuple val(meta), path("${prefix}.proband.g.vcf.gz.tbi") , emit: proband_gvcf_tbi
    tuple val(meta), path("${prefix}.family1.g.vcf.gz.tbi") , emit: family1_gvcf_tbi
    tuple val(meta), path("${prefix}.family2.g.vcf.gz.tbi") , emit: family2_gvcf_tbi
    path "versions.yml"                                     , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    // Exit if running this module with -profile conda / -profile mamba
    if (workflow.profile.tokenize(',').intersect(['conda', 'mamba']).size() >= 1) {
        error "DEEPTRIO module does not support Conda. Please use Docker / Singularity / Podman instead."
    }
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def regions = intervals ? "--regions=${intervals}" : ""

    """
    /opt/deepvariant/bin/deeptrio/run_deeptrio \\
        --ref=${fasta} \\
        --sample_name_proband ${meta.proband} \\
        --sample_name_family1 ${meta.family1} \\
        --sample_name_family2 ${meta.family2} \\
        --reads_proband=${bam_proband} \\
        --reads_family1=${bam_family1} \\
        --reads_family2=${bam_family2} \\
        --output_vcf_proband=${prefix}.proband.vcf.gz \\
        --output_vcf_family1=${prefix}.family1.vcf.gz \\
        --output_vcf_family2=${prefix}.family2.vcf.gz \\
        --output_gvcf_proband=${prefix}.proband.g.vcf.gz \\
        --output_gvcf_family1=${prefix}.family1.g.vcf.gz \\
        --output_gvcf_family2=${prefix}.family2.g.vcf.gz \\
        ${args} \\
        ${regions} \\
        --intermediate_results_dir=. \\
        --num_shards=${task.cpus}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        deeptrio: \$(echo \$(/opt/deepvariant/bin/deeptrio/run_deeptrio --version) | sed 's/^.*version //; s/ .*\$//' )
    END_VERSIONS
    """

    stub:
    // Exit if running this module with -profile conda / -profile mamba
    if (workflow.profile.tokenize(',').intersect(['conda', 'mamba']).size() >= 1) {
        error "DEEPTRIO module does not support Conda. Please use Docker / Singularity / Podman instead."
    }
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}.proband.vcf.gz
    touch ${prefix}.family1.vcf.gz
    touch ${prefix}.family2.vcf.gz
    touch ${prefix}.proband.vcf.gz.tbi
    touch ${prefix}.family1.vcf.gz.tbi
    touch ${prefix}.family2.vcf.gz.tbi
    touch ${prefix}.proband.g.vcf.gz
    touch ${prefix}.family1.g.vcf.gz
    touch ${prefix}.family2.g.vcf.gz
    touch ${prefix}.proband.g.vcf.gz.tbi
    touch ${prefix}.family1.g.vcf.gz.tbi
    touch ${prefix}.family2.g.vcf.gz.tbi

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        deeptrio: \$(echo \$(/opt/deepvariant/bin/deeptrio/run_deeptrio --version) | sed 's/^.*version //; s/ .*\$//' )
    END_VERSIONS
    """
}
