Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4934C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 22:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbhK3Wj1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 17:39:27 -0500
Received: from mail.netfilter.org ([217.70.188.207]:52150 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344467AbhK3Wj0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 17:39:26 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 964A6607F5;
        Tue, 30 Nov 2021 23:33:46 +0100 (CET)
Date:   Tue, 30 Nov 2021 23:35:58 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nf-next] netfilter: nft_fwd_netdev: Support egress hook
Message-ID: <YaanTiO6yEUdsGK0@salvia>
References: <af1325c0c71ad2786b7fba282a4b21c8fc0cf53c.1636461297.git.lukas@wunner.de>
 <YaacOHx7Gxp2cxlq@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YaacOHx7Gxp2cxlq@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 30, 2021 at 10:48:44PM +0100, Pablo Neira Ayuso wrote:
> Hi Lukas,
> 
> I'm sorry, I just noticed something below.
> 
> On Tue, Nov 09, 2021 at 01:42:01PM +0100, Lukas Wunner wrote:
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > Allow packet redirection to another interface upon egress.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > [lukas: set skb_iif, add commit message]
> > Signed-off-by: Lukas Wunner <lukas@wunner.de>
> > ---
> >  net/netfilter/nft_fwd_netdev.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
> > index cd59afde5b2f..fa9301ca6033 100644
> > --- a/net/netfilter/nft_fwd_netdev.c
> > +++ b/net/netfilter/nft_fwd_netdev.c
> > @@ -27,9 +27,11 @@ static void nft_fwd_netdev_eval(const struct nft_expr *expr,
> >  {
> >  	struct nft_fwd_netdev *priv = nft_expr_priv(expr);
> >  	int oif = regs->data[priv->sreg_dev];
> > +	struct sk_buff *skb = pkt->skb;
> >  
> >  	/* This is used by ifb only. */
> > -	skb_set_redirected(pkt->skb, true);
> > +	skb->skb_iif = skb->dev->ifindex;
> 
> Probably good to set skb->skb_iif only for NF_NETDEV_EGRESS?

Just quickly checked again, from ingress skb->skb_iif ==
skb->dev->ifindex.

Applied to nf-next, thanks.
