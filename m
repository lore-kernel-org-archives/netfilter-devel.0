Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEFD2C43217
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Apr 2022 15:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240156AbiD0PtI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Apr 2022 11:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240612AbiD0PtB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Apr 2022 11:49:01 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1FDCB506F4
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2022 08:45:49 -0700 (PDT)
Date:   Wed, 27 Apr 2022 17:45:45 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Topi Miettinen <toiwoton@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_socket: socket expressions for GID & UID
Message-ID: <YmllKYE4P31FQZFC@salvia>
References: <20220420185447.10199-1-toiwoton@gmail.com>
 <5a292abd-7f2e-728f-5594-86d85fbd1c00@gmail.com>
 <20220425223421.GA14400@breakpoint.cc>
 <ab7923f2-d1e7-ce61-5df8-c05778ef3ebd@gmail.com>
 <20220427054820.GB9849@breakpoint.cc>
 <YmjqN7KtWFMGbiJ9@salvia>
 <b0389581-cf28-13fe-6444-0840958b757a@gmail.com>
 <YmlhokhnOxG8tD7R@salvia>
 <20220427154219.GD9849@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220427154219.GD9849@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 27, 2022 at 05:42:19PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Looks like skb->sk is NULL? Patch attached.
> 
> > diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
> > index 6d9e8e0a3a7d..d6da68a3b739 100644
> > --- a/net/netfilter/nft_socket.c
> > +++ b/net/netfilter/nft_socket.c
> > @@ -59,21 +59,27 @@ static void nft_socket_eval(const struct nft_expr *expr,
> >  			    const struct nft_pktinfo *pkt)
> >  {
> >  	const struct nft_socket *priv = nft_expr_priv(expr);
> > +	u32 *dest = &regs->data[priv->dreg];
> >  	struct sk_buff *skb = pkt->skb;
> > +	const struct net_device *dev;
> >  	struct sock *sk = skb->sk;
> > -	u32 *dest = &regs->data[priv->dreg];
> >  
> >  	if (sk && !net_eq(nft_net(pkt), sock_net(sk)))
> >  		sk = NULL;
> >  
> > -	if (!sk)
> > +	if (nft_hook(pkt) == NF_INET_LOCAL_OUT)
> > +		dev = nft_out(pkt);
> > +	else
> > +		dev = nft_in(pkt);
> 
> I think its better to just NFT_BREAK for NF_INET_LOCAL_OUT && skb->sk == NULL,
> I don't see how nf_sk_lookup_slow_.() could provide meaningful result
> here, they assume packet header daddr/dport are the local, not the
> remote addresses.
> 
> Or, check nft_in(pkt) == NULL || !sk -> BREAK, whatever seems simpler to
> you.

Makes sense.

I'll let you follow up on this.

I'll tag

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220427153333.18424-1-pablo@netfilter.org/

as changed requested too
