Return-Path: <SRS0=UO6N=UP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FFCC46477
	for <netfilter-devel@archiver.kernel.org>; Sun, 16 Jun 2019 23:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79C4820861
	for <netfilter-devel@archiver.kernel.org>; Sun, 16 Jun 2019 23:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbfFPXeB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 16 Jun 2019 19:34:01 -0400
Received: from mail.us.es ([193.147.175.20]:48232 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727238AbfFPXeB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 16 Jun 2019 19:34:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C090E114564
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 01:33:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B123CDA704
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 01:33:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A6D35DA703; Mon, 17 Jun 2019 01:33:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ADFD0DA701;
        Mon, 17 Jun 2019 01:33:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 17 Jun 2019 01:33:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8DC504265A31;
        Mon, 17 Jun 2019 01:33:56 +0200 (CEST)
Date:   Mon, 17 Jun 2019 01:33:56 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] datatype: fix print of raw numerical symbol values
Message-ID: <20190616233356.a3yu333bn4evktn4@salvia>
References: <20190616085549.1087-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190616085549.1087-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jun 16, 2019 at 10:55:49AM +0200, Florian Westphal wrote:
> The two rules:
> arp operation 1-2 accept
> arp operation 256-512 accept
> 
> are both shown as 256-512:
> 
>         chain in_public {
>                 arp operation 256-512 accept
>                 arp operation 256-512 accept
>                 meta mark "1"
>                 tcp flags 2,4
>         }
> 
> This is because range expression enforces numeric output,
> yet nft_print doesn't respect byte order.
> 
> Behave as if we had no symbol in the first place and call
> the base type print function instead.
> 
> This means we now respect format specifier as well:
> 	chain in_public {
>                 arp operation 1-2 accept
>                 arp operation 256-512 accept
>                 meta mark "0x00000001"

Hm, why is "1" turned into "0x00000001"?

I would expect quoted mark means: look at rt_marks.

Thanks!

>                 tcp flags 0x2,0x4
> 	}
> Without fix, added test case will fail:
> 'add rule arp test-arp input arp operation 1-2': 'arp operation 1-2' mismatches 'arp operation 256-512'
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>   Note there is a discrepancy between output when we have a symbol and
>   when we do not.
> 
>   Example, add rule:
>   meta mark "foo"
> 
>   (with '1 "foo"' in rt_marks), nft will print quotes when symbol
>   printing is inhibited via -n, but elides them in case the symbol
>   is not available.

Then, we also need a patch to regard NFT_CTX_OUTPUT_NUMERIC_ALL, right?

>  src/datatype.c                    | 2 +-
>  tests/py/arp/arp.t                | 1 +
>  tests/py/arp/arp.t.payload        | 6 ++++++
>  tests/py/arp/arp.t.payload.netdev | 8 ++++++++
>  4 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/src/datatype.c b/src/datatype.c
> index 8ae3aa1c3f90..d193ccc0a659 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -198,7 +198,7 @@ void symbolic_constant_print(const struct symbol_table *tbl,
>  		nft_print(octx, "\"");
>  
>  	if (nft_output_numeric_symbol(octx))
> -		nft_print(octx, "%" PRIu64 "", val);
> +		expr_basetype(expr)->print(expr, octx);
>  	else
>  		nft_print(octx, "%s", s->identifier);
>  


