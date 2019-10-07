shell.executable("bash")

configfile: "config.yaml"

rule all:
    input:
        expand("{repeat}-{genome}-hits.pdf", repeat=config["repeat"], genome=config["genome"])
        # expand("{repeat}-{genome}-blast.tsv", repeat=config["repeat"], genome=config["genome"])

rule makeblastdb:
    input:
        config["genome"]+".fa"
    output:
        "{}.fa.nhr".format(config["genome"]),
        "{}.fa.nin".format(config["genome"]),
        "{}.fa.nsq".format(config["genome"])
    shell: "makeblastdb -in {input} -dbtype nucl"

rule blast:
    input:
        "{repeat}.fasta",
        "{genome}.fa",
        "{}.fa.nhr".format(config["genome"]),
        "{}.fa.nin".format(config["genome"]),
        "{}.fa.nsq".format(config["genome"])
    output:
        "{repeat}-{genome}-blast.tsv"
    shell: """
        blastn -dust no -soft_masking false -query {input[0]} -db {input[1]} -outfmt 6 > {output}
    """
    
rule parse_blast_output:
    input:
        "{repeat}-{genome}-blast.tsv"
    output:
        "{repeat}-{genome}-parsed-blast.bed"
    shell: """
        awk -v OFS="\t" -f ifelse_blast_to_BED.sh {input} | sort -k1,1 -k2,2n -k3,3n | \
            bedtools merge -i - > {output}
    """
    
rule plot_hits:
    input:
        "{repeat}-{genome}-parsed-blast.bed"
    output:
        "{repeat}-{genome}-hits.pdf"
    shell: """
        Rscript hits_from_BED3.R {input} {output}
    """
