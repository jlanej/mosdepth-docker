version 1.0
task mosdepth {
    input {
        File bam_or_cram_input
        File bam_or_cram_index
        String outputRoot
        File referenceGenome
        Int mem_gb
    }

	command {	
		bash -c "ls;echo $PWD;/usr/local/bin/mosdepth -n -t 1 --by 1000 --fasta ${referenceGenome} ${outputRoot} ${bam_or_cram_input}"
	}

	output {
		File coverageBed = "~{outputRoot}.bed.gz"
	}

	runtime {
		docker: "quay.io/jlanej/mosdepth-docker:sha256:81597cee5532de6206a9572d5ede31ae7b492675588e9a161fe1a6426babe494"
		memory: mem_gb + "GB"	}

	meta {
		author: "jlanej"
	}
}

workflow mosdepthWorkflow {
    input {
        File bam_or_cram_input
        File bam_or_cram_index
        String outputRoot
        File referenceGenome
        Int mem_gb
    }
	call mosdepth { input: bam_or_cram_input=bam_or_cram_input,bam_or_cram_index=bam_or_cram_index,outputRoot=outputRoot,referenceGenome=referenceGenome, mem_gb=mem_gb }
}

#		
