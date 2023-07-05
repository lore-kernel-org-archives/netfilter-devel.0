Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A573BEB64DA
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jul 2023 20:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbjGEUMm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 16:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbjGEUMl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 16:12:41 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA06173B;
        Wed,  5 Jul 2023 13:12:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qH8rY-0000L4-6w; Wed, 05 Jul 2023 22:12:32 +0200
Date:   Wed, 5 Jul 2023 22:12:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: prevent OOB access in
 nft_byteorder_eval
Message-ID: <20230705201232.GG3751@breakpoint.cc>
References: <20230705121515.747251-1-cascardo@canonical.com>
 <20230705130336.GD3751@breakpoint.cc>
 <ZKWzx3e6frpSs8bN@quatroqueijos.cascardo.eti.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZKWzx3e6frpSs8bN@quatroqueijos.cascardo.eti.br>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thadeu Lima de Souza Cascardo <cascardo@canonical.com> wrote:
> > > @@ -74,11 +77,11 @@ void nft_byteorder_eval(const struct nft_expr *expr,
> > >  		switch (priv->op) {
> > >  		case NFT_BYTEORDER_NTOH:
> > >  			for (i = 0; i < priv->len / 2; i++)
> > > -				d[i].u16 = ntohs((__force __be16)s[i].u16);
> > > +				d16[i] = ntohs((__force __be16)s16[i]);
> > 
> > This on the other hand... I'd say this should mimic what the 64bit
> > case is doing and use nft_reg_store16() nft_reg_load16() helpers for
> > the register accesses.
> > 
> > something like:
> > 
> > for (i = 0; i < priv->len / 2; i++) {
> >      v16 = nft_reg_load16(&src[i]);
> >      nft_reg_store16(&dst[i], + ntohs((__force __be16)v16));
> > }
> > 
> 
> The problem here is that we cannot index the 32-bit dst and src pointers as if
> they were 16-bit pointers. We will end up with the exact same problem we are
> trying to fix here.
> 
> I can change the code to use the accessors, but they use u32 pointers, so it
> would end up looking like:
> 
>  		case NFT_BYTEORDER_NTOH:
>  			for (i = 0; i < priv->len / 4; i++)
> -				d[i].u32 = ntohl((__force __be32)s[i].u32);
> +				dst[i] = ntohl((__force __be32)src[i]);
>  			break;
>  		case NFT_BYTEORDER_HTON:
>  			for (i = 0; i < priv->len / 4; i++)
> -				d[i].u32 = (__force __u32)htonl(s[i].u32);
> +				dst[i] = (__force __u32)htonl(src[i]);

Ack, thanks.

>  		case NFT_BYTEORDER_NTOH:
> -			for (i = 0; i < priv->len / 2; i++)
> -				d[i].u16 = ntohs((__force __be16)s[i].u16);
> +			for (i = 0; i < priv->len / 2; i++) {
> +				__be16 src16;
> +				src16 = nft_reg_load_be16((u32 *)&s16[i]);
> +				nft_reg_store_be16((u32 *)&d16[i], ntohs(src16));
> +			}

These accessors take a registers' address, not something in-between.

I think your original was better after all and we need to rely on whatever
expression filled the register to have done the right thing.

