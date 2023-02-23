Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E05C61DA4
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Feb 2023 23:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjBWXBu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Feb 2023 18:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBWXBu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Feb 2023 18:01:50 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024DA37F29
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Feb 2023 15:01:48 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pVKaw-0001zR-BF; Fri, 24 Feb 2023 00:01:46 +0100
Date:   Fri, 24 Feb 2023 00:01:46 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: bridge: introduce broute meta
 statement
Message-ID: <20230223230146.GD26596@breakpoint.cc>
References: <20230223202246.15640-1-sriram.yagnaraman@est.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223202246.15640-1-sriram.yagnaraman@est.tech>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sriram Yagnaraman <sriram.yagnaraman@est.tech> wrote:
> +void nft_meta_bridge_set_eval(const struct nft_expr *expr,
> +			      struct nft_regs *regs,
> +			      const struct nft_pktinfo *pkt)

static?

> +{
> +		dest = eth_hdr(skb)->h_dest;
> +		if (skb->pkt_type == PACKET_HOST &&
> +		    !ether_addr_equal(skb->dev->dev_addr, dest) &&
> +		    ether_addr_equal(p->br->dev->dev_addr, dest))
> +			skb->pkt_type = PACKET_OTHERHOST;

We already support override of skb->pkt_type, I would prefer
if users to this explicitly from their ruleset if they need it.

> +	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));

I think you need to check for !tb[NFTA_META_KEY] and bail out
before this line.

> +	switch (priv->key) {
> +	case NFT_META_BRI_BROUTE:
> +		len = sizeof(u8);
> +		break;

Can you bail out if this is called from something else
than PREROUTING hook?

You can look at nft_tproxy.c or similar on how to do this.
