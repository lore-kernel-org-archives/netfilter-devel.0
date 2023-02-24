Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13A5AC677F1
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Feb 2023 09:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjBXJKI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Feb 2023 04:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjBXJKH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Feb 2023 04:10:07 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D68C222D7
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Feb 2023 01:10:06 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pVU5b-0004af-Jh; Fri, 24 Feb 2023 10:10:03 +0100
Date:   Fri, 24 Feb 2023 10:10:03 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: bridge: introduce broute meta
 statement
Message-ID: <20230224091003.GF26596@breakpoint.cc>
References: <20230223202246.15640-1-sriram.yagnaraman@est.tech>
 <20230223230146.GD26596@breakpoint.cc>
 <DBBP189MB14336D817E987CEBA648123195A89@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DBBP189MB14336D817E987CEBA648123195A89@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sriram Yagnaraman <sriram.yagnaraman@est.tech> wrote:
> > -----Original Message-----
> > From: Florian Westphal <fw@strlen.de>
> > Sent: Friday, 24 February 2023 00:02
> > To: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
> > Cc: netfilter-devel@vger.kernel.org; Florian Westphal <fw@strlen.de>; Pablo
> > Neira Ayuso <pablo@netfilter.org>
> > Subject: Re: [PATCH nf-next] netfilter: bridge: introduce broute meta
> > statement
> > 
> > Sriram Yagnaraman <sriram.yagnaraman@est.tech> wrote:
> > > +void nft_meta_bridge_set_eval(const struct nft_expr *expr,
> > > +			      struct nft_regs *regs,
> > > +			      const struct nft_pktinfo *pkt)
> > 
> > static?
> > 
> > > +{
> > > +		dest = eth_hdr(skb)->h_dest;
> > > +		if (skb->pkt_type == PACKET_HOST &&
> > > +		    !ether_addr_equal(skb->dev->dev_addr, dest) &&
> > > +		    ether_addr_equal(p->br->dev->dev_addr, dest))
> > > +			skb->pkt_type = PACKET_OTHERHOST;
> > 
> > We already support override of skb->pkt_type, I would prefer if users to this
> > explicitly from their ruleset if they need it.
> 
> Ok, that is better, I will remove this chunk.
> 
> > 
> > > +	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
> > 
> > I think you need to check for !tb[NFTA_META_KEY] and bail out before this
> > line.
> 
> We already validate this in nft_meta_bridge_select_ops(), isn’t that enough?

Right, thats enough.

> > > +	switch (priv->key) {
> > > +	case NFT_META_BRI_BROUTE:
> > > +		len = sizeof(u8);
> > > +		break;
> > 
> > Can you bail out if this is called from something else than PREROUTING hook?
> > 
> > You can look at nft_tproxy.c or similar on how to do this.
> 
> nft_meta_set_validate() already checks meta statements can only be used in the PREROUTING hook. Isn't that enough?

It only restricts NFT_META_PKTTYPE.
