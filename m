Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388AFC678D5
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 12:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjCGMht (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 07:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjCGMhs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 07:37:48 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31527C978
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 04:37:41 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pZWZY-0000EP-Hd; Tue, 07 Mar 2023 13:37:40 +0100
Date:   Tue, 7 Mar 2023 13:37:40 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 12/13] netfilter: nft_redir: deduplicate eval
 call-backs
Message-ID: <20230307123740.GD13059@breakpoint.cc>
References: <20230305121817.2234734-1-jeremy@azazel.net>
 <20230305121817.2234734-13-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230305121817.2234734-13-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> nft_redir has separate ipv4 and ipv6 call-backs which share much of
> their code, and an inet one switch containing a switch that calls one of
> the others based on the family of the packet.  Merge the ipv4 and ipv6
> ones into the inet one in order to get rid of the duplicate code.
> 
> Const-qualify the `priv` pointer since we don't need to write through
> it.
> 
> Set the `NF_NAT_RANGE_PROTO_SPECIFIED` flag once during init, rather
> than on every eval.

Reviewed-by: Florian Westphal <fw@strlen.de>

> -	struct nft_redir *priv = nft_expr_priv(expr);
> +	const struct nft_redir *priv = nft_expr_priv(expr);
>  	struct nf_nat_range2 range;
>  
>  	memset(&range, 0, sizeof(range));
>  	if (priv->sreg_proto_min) {
> -		range.min_proto.all = (__force __be16)nft_reg_load16(
> -			&regs->data[priv->sreg_proto_min]);
> -		range.max_proto.all = (__force __be16)nft_reg_load16(
> -			&regs->data[priv->sreg_proto_max]);
> -		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
> +		range.min_proto.all = (__force __be16)
> +			nft_reg_load16(&regs->data[priv->sreg_proto_min]);
> +		range.max_proto.all = (__force __be16)
> +			nft_reg_load16(&regs->data[priv->sreg_proto_max]);
>  	}
>  
>  	range.flags |= priv->flags;

Nit: This could be updated to 'range.flags = priv->flags'
