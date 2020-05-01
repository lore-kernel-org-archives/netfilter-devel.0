Return-Path: <SRS0=Z556=6P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9761C4724C
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 19:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA6192173E
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 19:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgEAT1I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 May 2020 15:27:08 -0400
Received: from correo.us.es ([193.147.175.20]:45686 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbgEAT1I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 May 2020 15:27:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 635BF11EB8A
        for <netfilter-devel@vger.kernel.org>; Fri,  1 May 2020 21:27:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 552882132B
        for <netfilter-devel@vger.kernel.org>; Fri,  1 May 2020 21:27:06 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4AC18DA7B2; Fri,  1 May 2020 21:27:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3F657DA788;
        Fri,  1 May 2020 21:27:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 01 May 2020 21:27:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1FA434301DE1;
        Fri,  1 May 2020 21:27:04 +0200 (CEST)
Date:   Fri, 1 May 2020 21:27:03 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Michael Braun <michael-dev@fami-braun.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] datatype: fix double-free resulting in
 use-after-free in datatype_free
Message-ID: <20200501192703.GC13722@salvia>
References: <20200501154819.2984-1-michael-dev@fami-braun.de>
 <20200501154819.2984-3-michael-dev@fami-braun.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501154819.2984-3-michael-dev@fami-braun.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 01, 2020 at 05:48:18PM +0200, Michael Braun wrote:
> nft list table bridge t
> table bridge t {
>         set s4 {
>                 typeof ip saddr . ip daddr
>                 elements = { 1.0.0.1 . 2.0.0.2 }
>         }
> }
> =================================================================
> ==24334==ERROR: AddressSanitizer: heap-use-after-free on address 0x6080000000a8 at pc 0x7fe0e67df0ad bp 0x7ffff83e88c0 sp 0x7ffff83e88b8
> READ of size 4 at 0x6080000000a8 thread T0
>     #0 0x7fe0e67df0ac in datatype_free nftables/src/datatype.c:1110
>     #1 0x7fe0e67e2092 in expr_free nftables/src/expression.c:89
>     #2 0x7fe0e67a855e in set_free nftables/src/rule.c:359
>     #3 0x7fe0e67b2f3e in table_free nftables/src/rule.c:1263
>     #4 0x7fe0e67a70ce in __cache_flush nftables/src/rule.c:299
>     #5 0x7fe0e67a71c7 in cache_release nftables/src/rule.c:305
>     #6 0x7fe0e68dbfa9 in nft_ctx_free nftables/src/libnftables.c:292
>     #7 0x55f00fbe0051 in main nftables/src/main.c:469
>     #8 0x7fe0e553309a in __libc_start_main ../csu/libc-start.c:308
>     #9 0x55f00fbdd429 in _start (nftables/src/.libs/nft+0x9429)
> 
> 0x6080000000a8 is located 8 bytes inside of 96-byte region [0x6080000000a0,0x608000000100)
> freed by thread T0 here:
>     #0 0x7fe0e6e70fb0 in __interceptor_free (/usr/lib/x86_64-linux-gnu/libasan.so.5+0xe8fb0)
>     #1 0x7fe0e68b8122 in xfree nftables/src/utils.c:29
>     #2 0x7fe0e67df2e5 in datatype_free nftables/src/datatype.c:1117
>     #3 0x7fe0e67e2092 in expr_free nftables/src/expression.c:89
>     #4 0x7fe0e67a83fe in set_free nftables/src/rule.c:356
>     #5 0x7fe0e67b2f3e in table_free nftables/src/rule.c:1263
>     #6 0x7fe0e67a70ce in __cache_flush nftables/src/rule.c:299
>     #7 0x7fe0e67a71c7 in cache_release nftables/src/rule.c:305
>     #8 0x7fe0e68dbfa9 in nft_ctx_free nftables/src/libnftables.c:292
>     #9 0x55f00fbe0051 in main nftables/src/main.c:469
>     #10 0x7fe0e553309a in __libc_start_main ../csu/libc-start.c:308
> 
> previously allocated by thread T0 here:
>     #0 0x7fe0e6e71330 in __interceptor_malloc (/usr/lib/x86_64-linux-gnu/libasan.so.5+0xe9330)
>     #1 0x7fe0e68b813d in xmalloc nftables/src/utils.c:36
>     #2 0x7fe0e68b8296 in xzalloc nftables/src/utils.c:65
>     #3 0x7fe0e67de7d5 in dtype_alloc nftables/src/datatype.c:1065
>     #4 0x7fe0e67df862 in concat_type_alloc nftables/src/datatype.c:1146
>     #5 0x7fe0e67ea852 in concat_expr_parse_udata nftables/src/expression.c:954
>     #6 0x7fe0e685dc94 in set_make_key nftables/src/netlink.c:718
>     #7 0x7fe0e685e177 in netlink_delinearize_set nftables/src/netlink.c:770
>     #8 0x7fe0e685f667 in list_set_cb nftables/src/netlink.c:895
>     #9 0x7fe0e4f95a03 in nftnl_set_list_foreach src/set.c:904
> 
> SUMMARY: AddressSanitizer: heap-use-after-free nftables/src/datatype.c:1110 in datatype_free
> Shadow bytes around the buggy address:
>   0x0c107fff7fc0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   0x0c107fff7fd0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   0x0c107fff7fe0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   0x0c107fff7ff0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   0x0c107fff8000: fa fa fa fa fd fd fd fd fd fd fd fd fd fd fd fd
> =>0x0c107fff8010: fa fa fa fa fd[fd]fd fd fd fd fd fd fd fd fd fd
>   0x0c107fff8020: fa fa fa fa fd fd fd fd fd fd fd fd fd fd fd fd
>   0x0c107fff8030: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
>   0x0c107fff8040: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
>   0x0c107fff8050: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
>   0x0c107fff8060: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
> Shadow byte legend (one shadow byte represents 8 application bytes):
>   Addressable:           00
>   Partially addressable: 01 02 03 04 05 06 07
>   Heap left redzone:       fa
>   Freed heap region:       fd
>   Stack left redzone:      f1
>   Stack mid redzone:       f2
>   Stack right redzone:     f3
>   Stack after return:      f5
>   Stack use after scope:   f8
>   Global redzone:          f9
>   Global init order:       f6
>   Poisoned by user:        f7
>   Container overflow:      fc
>   Array cookie:            ac
>   Intra object redzone:    bb
>   ASan internal:           fe
>   Left alloca redzone:     ca
>   Right alloca redzone:    cb
> ==24334==ABORTING
> ---
>  src/datatype.c   | 2 ++
>  src/expression.c | 2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/src/datatype.c b/src/datatype.c
> index 095598d9..0110846f 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -1083,6 +1083,8 @@ struct datatype *datatype_get(const struct datatype *ptr)
>  
>  void datatype_set(struct expr *expr, const struct datatype *dtype)
>  {
> +	if (dtype == expr->dtype)
> +		return; // do not free dtype before incrementing refcnt again

This makes sense indeed. If the same dtype is set, then turning this
to noop is fine.

The problem you describe (use-after-free) happens in this case, right?

        datatype_set(expr, expr->dtype);

Or am I missing anything?

>  	datatype_free(expr->dtype);
>  	expr->dtype = datatype_get(dtype);
>  }
> diff --git a/src/expression.c b/src/expression.c
> index 6605beb3..a6bde70f 100644
> --- a/src/expression.c
> +++ b/src/expression.c
> @@ -955,7 +955,7 @@ static struct expr *concat_expr_parse_udata(const struct nftnl_udata *attr)
>  	if (!dtype)
>  		goto err_free;
>  
> -	concat_expr->dtype = dtype;
> +	concat_expr->dtype = datatype_get(dtype);

This is also good indeed.

Thanks.
