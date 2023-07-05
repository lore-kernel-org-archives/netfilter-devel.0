Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19569EB64DA
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jul 2023 13:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbjGENDk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 09:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjGENDj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 09:03:39 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D81FDA;
        Wed,  5 Jul 2023 06:03:38 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qH2AS-0006HS-Pv; Wed, 05 Jul 2023 15:03:36 +0200
Date:   Wed, 5 Jul 2023 15:03:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: prevent OOB access in
 nft_byteorder_eval
Message-ID: <20230705130336.GD3751@breakpoint.cc>
References: <20230705121515.747251-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230705121515.747251-1-cascardo@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thadeu Lima de Souza Cascardo <cascardo@canonical.com> wrote:
> When evaluating byteorder expressions with size 2, a union with 32-bit and
> 16-bit members is used. Since the 16-bit members are aligned to 32-bit,
> the array accesses will be out-of-bounds.
> 
> It may lead to a stack-out-of-bounds access like the one below:

Yes, this is broken.

> Using simple s32 and s16 pointers for each of these accesses fixes the
> problem.

I'm not sure this is correct.  Its certainly less wrong of course.

> Fixes: 96518518cc41 ("netfilter: add nftables")
> Cc: stable@vger.kernel.org
> Reported-by: Tanguy DUBROCA (@SidewayRE) from @Synacktiv working with ZDI
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> ---
>  net/netfilter/nft_byteorder.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
> index 9a85e797ed58..aa16bd2e92e2 100644
> --- a/net/netfilter/nft_byteorder.c
> +++ b/net/netfilter/nft_byteorder.c
> @@ -30,11 +30,14 @@ void nft_byteorder_eval(const struct nft_expr *expr,
>  	const struct nft_byteorder *priv = nft_expr_priv(expr);
>  	u32 *src = &regs->data[priv->sreg];
>  	u32 *dst = &regs->data[priv->dreg];
> -	union { u32 u32; u16 u16; } *s, *d;
> +	u32 *s32, *d32;
> +	u16 *s16, *d16;
>  	unsigned int i;
>  
> -	s = (void *)src;
> -	d = (void *)dst;
> +	s32 = (void *)src;
> +	d32 = (void *)dst;
> +	s16 = (void *)src;
> +	d16 = (void *)dst;
>  
>  	switch (priv->size) {
>  	case 8: {
> @@ -62,11 +65,11 @@ void nft_byteorder_eval(const struct nft_expr *expr,
>  		switch (priv->op) {
>  		case NFT_BYTEORDER_NTOH:
>  			for (i = 0; i < priv->len / 4; i++)
> -				d[i].u32 = ntohl((__force __be32)s[i].u32);
> +				d32[i] = ntohl((__force __be32)s32[i]);
>  			break;
>  		case NFT_BYTEORDER_HTON:
>  			for (i = 0; i < priv->len / 4; i++)
> -				d[i].u32 = (__force __u32)htonl(s[i].u32);
> +				d32[i] = (__force __u32)htonl(s32[i]);
>  			break;

Ack, this looks better, but I'd just use src[i] and dst[i] rather than
the weird union pointers the original has.

> @@ -74,11 +77,11 @@ void nft_byteorder_eval(const struct nft_expr *expr,
>  		switch (priv->op) {
>  		case NFT_BYTEORDER_NTOH:
>  			for (i = 0; i < priv->len / 2; i++)
> -				d[i].u16 = ntohs((__force __be16)s[i].u16);
> +				d16[i] = ntohs((__force __be16)s16[i]);

This on the other hand... I'd say this should mimic what the 64bit
case is doing and use nft_reg_store16() nft_reg_load16() helpers for
the register accesses.

something like:

for (i = 0; i < priv->len / 2; i++) {
     v16 = nft_reg_load16(&src[i]);
     nft_reg_store16(&dst[i], + ntohs((__force __be16)v16));
}

[ not even compile tested ]

Same for the htons case.

On a slightly related note, some of the nftables test cases create bogus
conversions, e.g.:

# src/nft --debug=netlink add rule ip6 t c 'ct mark set ip6 dscp << 2 |
# 0x10'
ip6 t c
  [ payload load 2b @ network header + 0 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]	// NO-OP! should be reg 1, 2, 2) I presume?

I'd suggest to add a patch for nf-next that rejects such crap.
