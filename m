From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH 0/16] introduce libnftables
Date: Wed, 16 Aug 2017 22:42:54 +0200
Message-ID: <20170816204310.3371-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:40732 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752780AbdHPVZq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2017 17:25:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

This patchset adds a basi high level libnftables to nftables code.
It is currently supporting running a command from a buffer or from
a file as well as batch support allowing to chain commands and commit
them at once.

The API is mostly using existing structures such as nft_ctx that are
updated to contain enough information. It also adds a structure
dedicated to batch.

A simple program running a command is the following:

 	nft_global_init();
	nft = nft_context_new();
	nft_context_set_print_func(nft, my_print, buf);
	rc = nft_run_command_from_buffer(nft, CMD, sizeof(CMD));
	if (rc != NFT_EXIT_SUCCESS) {
		nft_get_error(nft, err_buf, sizeof(err_buf));
		printf("%s\n", err_buf);
		return -1;
	}
	nft_context_free(nft);
	nft_global_deinit(); 

Transaction support is similar with:

	nft = nft_context_new();
	batch = nft_batch_start(nft);
	if (nft_batch_add(nft, batch, ADD1, strlen(ADD1)) !=0) {
		printf("FAIL add 1\n");
		goto out;
	}
	if (nft_batch_add(nft, batch, ADD2, strlen(ADD2)) !=0) {
		printf("FAIL add 2\n");
		goto out;
	}
	if (nft_batch_commit(nft, batch) != 0) {
		goto out;
	}

out:	
	nft_batch_free(batch);
	nft_context_free(nft);
	nft_global_deinit();

The library provides a way to get standard output via nft_context_set_print_func
and error handling is done via nft_get_error that get error message in a buffer.

This is early stage code as it does not feature things like set handling but IMO
it can already be used as a starting point to build more things.

BR,
--
Eric
