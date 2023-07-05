Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB0C2EB64DA
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jul 2023 13:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjGENuX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 09:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjGENuW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 09:50:22 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4FC58F7;
        Wed,  5 Jul 2023 06:50:21 -0700 (PDT)
Date:   Wed, 5 Jul 2023 15:50:17 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_tables: prevent OOB access in
 nft_byteorder_eval
Message-ID: <ZKV1GZrKp6kf4IeU@calendula>
References: <20230705121515.747251-1-cascardo@canonical.com>
 <20230705130336.GD3751@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230705130336.GD3751@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 05, 2023 at 03:03:36PM +0200, Florian Westphal wrote:
> Thadeu Lima de Souza Cascardo <cascardo@canonical.com> wrote:
> > When evaluating byteorder expressions with size 2, a union with 32-bit and
> > 16-bit members is used. Since the 16-bit members are aligned to 32-bit,
> > the array accesses will be out-of-bounds.
> > 
> > It may lead to a stack-out-of-bounds access like the one below:
> 
> Yes, this is broken.
> 
> > Using simple s32 and s16 pointers for each of these accesses fixes the
> > problem.
> 
> I'm not sure this is correct.  Its certainly less wrong of course.
> 
> > Fixes: 96518518cc41 ("netfilter: add nftables")
> > Cc: stable@vger.kernel.org
> > Reported-by: Tanguy DUBROCA (@SidewayRE) from @Synacktiv working with ZDI
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > ---
> >  net/netfilter/nft_byteorder.c | 17 ++++++++++-------
> >  1 file changed, 10 insertions(+), 7 deletions(-)
> > 
> > diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
> > index 9a85e797ed58..aa16bd2e92e2 100644
> > --- a/net/netfilter/nft_byteorder.c
> > +++ b/net/netfilter/nft_byteorder.c
> > @@ -30,11 +30,14 @@ void nft_byteorder_eval(const struct nft_expr *expr,
> >  	const struct nft_byteorder *priv = nft_expr_priv(expr);
> >  	u32 *src = &regs->data[priv->sreg];
> >  	u32 *dst = &regs->data[priv->dreg];
> > -	union { u32 u32; u16 u16; } *s, *d;
> > +	u32 *s32, *d32;
> > +	u16 *s16, *d16;
> >  	unsigned int i;
> >  
> > -	s = (void *)src;
> > -	d = (void *)dst;
> > +	s32 = (void *)src;
> > +	d32 = (void *)dst;
> > +	s16 = (void *)src;
> > +	d16 = (void *)dst;
> >  
> >  	switch (priv->size) {
> >  	case 8: {
> > @@ -62,11 +65,11 @@ void nft_byteorder_eval(const struct nft_expr *expr,
> >  		switch (priv->op) {
> >  		case NFT_BYTEORDER_NTOH:
> >  			for (i = 0; i < priv->len / 4; i++)
> > -				d[i].u32 = ntohl((__force __be32)s[i].u32);
> > +				d32[i] = ntohl((__force __be32)s32[i]);
> >  			break;
> >  		case NFT_BYTEORDER_HTON:
> >  			for (i = 0; i < priv->len / 4; i++)
> > -				d[i].u32 = (__force __u32)htonl(s[i].u32);
> > +				d32[i] = (__force __u32)htonl(s32[i]);
> >  			break;
> 
> Ack, this looks better, but I'd just use src[i] and dst[i] rather than
> the weird union pointers the original has.

Agreed.

> > @@ -74,11 +77,11 @@ void nft_byteorder_eval(const struct nft_expr *expr,
> >  		switch (priv->op) {
> >  		case NFT_BYTEORDER_NTOH:
> >  			for (i = 0; i < priv->len / 2; i++)
> > -				d[i].u16 = ntohs((__force __be16)s[i].u16);
> > +				d16[i] = ntohs((__force __be16)s16[i]);
> 
> This on the other hand... I'd say this should mimic what the 64bit
> case is doing and use nft_reg_store16() nft_reg_load16() helpers for
> the register accesses.
> 
> something like:
> 
> for (i = 0; i < priv->len / 2; i++) {
>      v16 = nft_reg_load16(&src[i]);
>      nft_reg_store16(&dst[i], + ntohs((__force __be16)v16));
> }
> [ not even compile tested ]
> 
> Same for the htons case.
> 
> On a slightly related note, some of the nftables test cases create bogus
> conversions, e.g.:
> 
> # src/nft --debug=netlink add rule ip6 t c 'ct mark set ip6 dscp << 2 |
> # 0x10'
> ip6 t c
>   [ payload load 2b @ network header + 0 => reg 1 ]
>   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]

This is accessing an 8 bit-field that spans 2 bytes.

>   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]

Shift should come _after_ byteorder.

>   [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]	// NO-OP! should be reg 1, 2, 2) I presume?

Yes, this should be length=2.

I'll take a look at this bytecode bug.

> I'd suggest to add a patch for nf-next that rejects such crap.
