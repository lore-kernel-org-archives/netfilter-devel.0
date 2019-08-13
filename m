Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE9D1C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 19:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B5F120665
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 19:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfHMTUz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 15:20:55 -0400
Received: from correo.us.es ([193.147.175.20]:37144 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfHMTUy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 15:20:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5122DB6327
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 21:20:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4467C1150DF
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 21:20:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 39F5BDA72F; Tue, 13 Aug 2019 21:20:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2AF37DA72F;
        Tue, 13 Aug 2019 21:20:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 21:20:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.218.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F02584265A2F;
        Tue, 13 Aug 2019 21:20:49 +0200 (CEST)
Date:   Tue, 13 Aug 2019 21:20:49 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables 1/4] src: fix jumps on bigendian arches
Message-ID: <20190813192049.enr7yczyngth4s4o@salvia>
References: <20190813184409.10757-1-fw@strlen.de>
 <20190813184409.10757-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813184409.10757-2-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 13, 2019 at 08:44:06PM +0200, Florian Westphal wrote:
> table bla {
>   chain foo { }
>   chain bar { jump foo }
>  }
> }
> 
> Fails to restore on big-endian platforms:
> jump.nft:5:2-9: Error: Could not process rule: No such file or directory
>  jump foo
> 
> nft passes a 0-length name to the kernel.
> 
> This is because when we export the value (the string), we provide
> the size of the destination buffer.
> 
> In earlier versions, the parser allocated the name with the same
> fixed size and all was fine.
> 
> After the fix, the export places the name in the wrong location
> in the destination buffer.
> 
> This makes tests/shell/testcases/chains/0001jumps_0 work on s390x.
> 
> Fixes: 142350f154c78 ("src: invalid read when importing chain name")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/datatype.c | 26 +++++++++++++++++---------
>  src/netlink.c  | 16 +++++++++++++---
>  2 files changed, 30 insertions(+), 12 deletions(-)
> 
> diff --git a/src/datatype.c b/src/datatype.c
> index 28f726f4e84c..6908bc22d783 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -244,10 +244,24 @@ const struct datatype invalid_type = {
>  	.print		= invalid_type_print,
>  };
>  
> -static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
> +static void verdict_jump_chain_print(const char *what, const struct expr *e,
> +				     struct output_ctx *octx)
>  {
>  	char chain[NFT_CHAIN_MAXNAMELEN];

Probably:

        chat chain[NFT_CHAIN_MAXNAMELEN + 1] = {};

to ensure space for \0.

> +	unsigned int len;
> +
> +	memset(chain, 0, sizeof(chain));

remove this memset then.

> +	len = e->len / BITS_PER_BYTE;

        div_round_up() ?

> +	if (len >= sizeof(chain))
> +		len = sizeof(chain) - 1;

Probably BUG() here instead if e->len > NFT_CHAIN_MAXNAMELEN? This
should not happen.

> +
> +	mpz_export_data(chain, e->value, BYTEORDER_HOST_ENDIAN, len);
> +	nft_print(octx, "%s %s", what, chain);
> +}
> +
> +static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
> +{
>  	switch (expr->verdict) {
>  	case NFT_CONTINUE:
>  		nft_print(octx, "continue");
> @@ -257,10 +271,7 @@ static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
>  		break;
>  	case NFT_JUMP:
>  		if (expr->chain->etype == EXPR_VALUE) {
> -			mpz_export_data(chain, expr->chain->value,
> -					BYTEORDER_HOST_ENDIAN,
> -					NFT_CHAIN_MAXNAMELEN);
> -			nft_print(octx, "jump %s", chain);
> +			verdict_jump_chain_print("jump", expr->chain, octx);
>  		} else {
>  			nft_print(octx, "jump ");
>  			expr_print(expr->chain, octx);
> @@ -268,10 +279,7 @@ static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
>  		break;
>  	case NFT_GOTO:
>  		if (expr->chain->etype == EXPR_VALUE) {
> -			mpz_export_data(chain, expr->chain->value,
> -					BYTEORDER_HOST_ENDIAN,
> -					NFT_CHAIN_MAXNAMELEN);
> -			nft_print(octx, "goto %s", chain);
> +			verdict_jump_chain_print("goto", expr->chain, octx);
>  		} else {
>  			nft_print(octx, "goto ");
>  			expr_print(expr->chain, octx);
> diff --git a/src/netlink.c b/src/netlink.c
> index aeeb12eaca93..f8e1120447d9 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -222,17 +222,27 @@ static void netlink_gen_verdict(const struct expr *expr,
>  				struct nft_data_linearize *data)
>  {
>  	char chain[NFT_CHAIN_MAXNAMELEN];

        ...[NFT_CHAIN_MAXNAMELEN + 1] = {};

> +	unsigned int len;
>  
>  	data->verdict = expr->verdict;
>  
>  	switch (expr->verdict) {
>  	case NFT_JUMP:
>  	case NFT_GOTO:
> +		len = expr->chain->len / BITS_PER_BYTE;

                div_round_up()

> +
> +		if (!len)
> +			BUG("chain length is 0");
> +
> +		if (len > sizeof(chain))
> +			BUG("chain is too large (%u, %u max)",
> +			    len, (unsigned int)sizeof(chain));
> +
> +		memset(chain, 0, sizeof(chain));
> +
>  		mpz_export_data(chain, expr->chain->value,
> -				BYTEORDER_HOST_ENDIAN,
> -				NFT_CHAIN_MAXNAMELEN);
> +				BYTEORDER_HOST_ENDIAN, len);
>  		snprintf(data->chain, NFT_CHAIN_MAXNAMELEN, "%s", chain);
> -		data->chain[NFT_CHAIN_MAXNAMELEN-1] = '\0';
>  		break;
>  	}
>  }
> -- 
> 2.21.0
> 
