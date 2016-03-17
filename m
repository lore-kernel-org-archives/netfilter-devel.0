From: Piyush Pangtey <gokuvsvegita@gmail.com>
Subject: Re: [nft PATCH] tests/shell: unload modules between tests
Date: Thu, 17 Mar 2016 23:32:01 +0530
Message-ID: <56EAF119.3070009@gmail.com>
References: <145820368731.17259.3174729391842967272.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:35269 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030383AbcCQSBo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Mar 2016 14:01:44 -0400
Received: by mail-pf0-f176.google.com with SMTP id n5so130422526pfn.2
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2016 11:01:44 -0700 (PDT)
In-Reply-To: <145820368731.17259.3174729391842967272.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 17 March 2016 02:04 PM, Arturo Borrero Gonzalez wrote:
> This patch adjusts the main test script so it unload all nftables
> kernel modules between tests.
> 
> This way we achieve two interesting things:
>  * avoid false errors in some testcases due to module loading order
>  * the module loading/unloading path itself
> 
[....]
> 	test_output=$(NFT=$NFT ${testfile} ${TESTS_OUTPUT} 2>&1)
> @@ -69,4 +90,4 @@ done
>  echo ""
>  msg_info "results: [OK] $ok [FAILED] $failed [TOTAL] $((ok+failed))"
>  
> -$NFT flush ruleset
> +kernel_cleanup
>

I'm getting nonzero return code(1) by this last kernel_cleanup call, maybe.

> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
