Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDAFCC61DA3
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Feb 2023 10:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjBXKwA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Feb 2023 05:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjBXKvp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Feb 2023 05:51:45 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4243E3E087
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Feb 2023 02:51:44 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pVVfy-0005Bv-Kd; Fri, 24 Feb 2023 11:51:42 +0100
Date:   Fri, 24 Feb 2023 11:51:42 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2] netfilter: bridge: introduce broute meta
 statement
Message-ID: <20230224105142.GH26596@breakpoint.cc>
References: <20230224095251.11249-1-sriram.yagnaraman@est.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224095251.11249-1-sriram.yagnaraman@est.tech>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sriram Yagnaraman <sriram.yagnaraman@est.tech> wrote:
> +static void nft_meta_bridge_set_eval(const struct nft_expr *expr,
> +				     struct nft_regs *regs,
> +				     const struct nft_pktinfo *pkt)
> +{
> +	const struct nft_meta *meta = nft_expr_priv(expr);
> +	struct sk_buff *skb = pkt->skb;
> +	u32 *sreg = &regs->data[meta->sreg];
> +	u8 value8;

Some people insist on

> +	const struct nft_meta *meta = nft_expr_priv(expr);
> +	u32 *sreg = &regs->data[meta->sreg];
> +	struct sk_buff *skb = pkt->skb;

Just saying this for future patches, I don't care, so:

Reviewed-by: Florian Westphal <fw@strlen.de>
