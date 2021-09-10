version 1.0
task mosdepth {
    input {
        File bam_or_cram_input
        File bam_or_cram_index
        String outputRoot
        File ref
        File ref_fasta_index
        File ref_dict
        Int mem_gb
        Int addtional_disk_size = 20 
        Int machine_mem_size = 15
   		Int disk_size = ceil(size(bam_or_cram_input, "GB")) + addtional_disk_size

    }

	command {
		bash -c "echo ~{bam_or_cram_input}; samtools-1.13 ; [ -f ~{bam_or_cram_input}.crai ] || samtools-1.13  index ~{bam_or_cram_input} ; /usr/local/bin/mosdepth -n -t 1 --by 1000 --fasta ~{ref} ~{outputRoot} ~{bam_or_cram_input}"
	}

	output {
		File coverageBed = "~{outputRoot}.regions.bed.gz"
		File globalDistOutput="~{outputRoot}.mosdepth.global.dist.txt"
		File distOutput="~{outputRoot}.mosdepth.region.dist.txt"
		File summaryOutput="~{outputRoot}.mosdepth.summary.txt"
		

	}

	runtime {
		docker: "quay.io/jlanej/mosdepth-docker:sha256:11f5d9fa42c23e12e22ac46cc1d8a40ee1a215694d9911e1a3c6275572043765"
		memory: mem_gb + "GB"
		disks: "local-disk " + disk_size + " HDD"
	}

	meta {
		author: "jlanej"
	}
}

workflow mosdepthWorkflow {
    input {
        File bam_or_cram_input
        File bam_or_cram_index
        String outputRoot
        File ref
        File ref_fasta_index
        File ref_dict
        Int mem_gb
    }
	call mosdepth { 
		input:
	 bam_or_cram_input=bam_or_cram_input,
	 bam_or_cram_index=bam_or_cram_index,
	 outputRoot=outputRoot,
	 ref=ref,
	 ref_fasta_index=ref_fasta_index,
	 ref_dict=ref_dict,
	 mem_gb=mem_gb 
	}
}

#		
