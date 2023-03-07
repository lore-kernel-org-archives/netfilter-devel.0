Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F6F7C678D5
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 12:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjCGM2F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 07:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCGM2E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 07:28:04 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7C05FDD
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 04:27:54 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pZWQ3-0000Ac-Q6; Tue, 07 Mar 2023 13:27:51 +0100
Date:   Tue, 7 Mar 2023 13:27:51 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 05/13] netfilter: nft_nat: add support for
 shifted port-ranges
Message-ID: <20230307122751.GB13059@breakpoint.cc>
References: <20230305121817.2234734-1-jeremy@azazel.net>
 <20230305121817.2234734-6-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230305121817.2234734-6-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> index 5c29915ab028..0517a3efb259 100644
> --- a/net/netfilter/nft_nat.c
> +++ b/net/netfilter/nft_nat.c
> @@ -25,6 +25,7 @@ struct nft_nat {
>  	u8			sreg_addr_max;
>  	u8			sreg_proto_min;
>  	u8			sreg_proto_max;
> +	u8			sreg_proto_base;
>  	enum nf_nat_manip_type  type:8;
>  	u8			family;
>  	u16			flags;
> @@ -58,6 +59,8 @@ static void nft_nat_setup_proto(struct nf_nat_range2 *range,
>  		nft_reg_load16(&regs->data[priv->sreg_proto_min]);
>  	range->max_proto.all = (__force __be16)
>  		nft_reg_load16(&regs->data[priv->sreg_proto_max]);
> +	range->base_proto.all = (__force __be16)
> +		nft_reg_load16(&regs->data[priv->sreg_proto_base]);

Hmmm!  See below.

> -	plen = sizeof_field(struct nf_nat_range, min_proto.all);
> +	plen = sizeof_field(struct nf_nat_range2, min_proto.all);
>  	if (tb[NFTA_NAT_REG_PROTO_MIN]) {
>  		err = nft_parse_register_load(tb[NFTA_NAT_REG_PROTO_MIN],
>  					      &priv->sreg_proto_min, plen);
> @@ -239,6 +243,16 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
>  						      plen);
>  			if (err < 0)
>  				return err;
> +
> +			if (tb[NFTA_NAT_REG_PROTO_BASE]) {
> +				err = nft_parse_register_load
> +					(tb[NFTA_NAT_REG_PROTO_BASE],
> +					 &priv->sreg_proto_base, plen);
> +				if (err < 0)
> +					return err;
> +
> +				priv->flags |= NF_NAT_RANGE_PROTO_OFFSET;

So sreg_proto_base is only set if tb[NFTA_NAT_REG_PROTO_BASE] gets
passed.

So, I would expect that all accesses to priv->sreg_proto_base are
guarded with a 'if (priv->sreg_proto_base)' check.

> @@ -286,7 +300,9 @@ static int nft_nat_dump(struct sk_buff *skb,
>  		if (nft_dump_register(skb, NFTA_NAT_REG_PROTO_MIN,
>  				      priv->sreg_proto_min) ||
>  		    nft_dump_register(skb, NFTA_NAT_REG_PROTO_MAX,
> -				      priv->sreg_proto_max))
> +				      priv->sreg_proto_max) ||
> +		    nft_dump_register(skb, NFTA_NAT_REG_PROTO_BASE,
> +				      priv->sreg_proto_base))

sreg_proto_min/max are only dumped when set, so NFTA_NAT_REG_PROTO_BASE
should not be dumped unconditionally either?
