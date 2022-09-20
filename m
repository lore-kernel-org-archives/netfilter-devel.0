Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2837C54EE9
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Sep 2022 23:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiITXYZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Sep 2022 19:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiITXYY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Sep 2022 19:24:24 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A497269E
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Sep 2022 16:24:22 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1oamb9-0005o0-0U; Wed, 21 Sep 2022 01:24:15 +0200
Date:   Wed, 21 Sep 2022 01:24:15 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] netfilter: nft_fib: Fix for rpath check with VRF
 devices
Message-ID: <YypLn4qnEWoi4Ij4@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Miaohe Lin <linmiaohe@huawei.com>, netfilter-devel@vger.kernel.org
References: <20220920212432.4168-1-phil@nwl.cc>
 <YypDOwT2QaHEgXfS@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YypDOwT2QaHEgXfS@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 21, 2022 at 12:48:27AM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Analogous to commit b575b24b8eee3 ("netfilter: Fix rpfilter
> > dropping vrf packets by mistake") but for nftables fib expression:
> > Add special treatment of VRF devices so that typical reverse path
> > filtering via 'fib saddr . iif oif' expression works as expected.
> > 
> > Fixes: f6d0cbcf09c50 ("netfilter: nf_tables: add fib expression")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  net/ipv4/netfilter/nft_fib_ipv4.c | 3 +++
> >  net/ipv6/netfilter/nft_fib_ipv6.c | 7 ++++++-
> >  2 files changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
> > index b75cac69bd7e6..7ade04ff972d7 100644
> > --- a/net/ipv4/netfilter/nft_fib_ipv4.c
> > +++ b/net/ipv4/netfilter/nft_fib_ipv4.c
> > @@ -83,6 +83,9 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
> >  	else
> >  		oif = NULL;
> >  
> > +	if (priv->flags & NFTA_FIB_F_IIF)
> > +		fl4.flowi4_oif = l3mdev_master_ifindex_rcu(oif);
> > +
> >  	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
> >  	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
> >  		nft_fib_store_result(dest, priv, nft_in(pkt));
> > diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
> > index 8970d0b4faeb4..3f860e331580d 100644
> > --- a/net/ipv6/netfilter/nft_fib_ipv6.c
> > +++ b/net/ipv6/netfilter/nft_fib_ipv6.c
> > @@ -170,6 +170,10 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
> >  	else if (priv->flags & NFTA_FIB_F_OIF)
> >  		oif = nft_out(pkt);
> >  
> > +	if ((priv->flags & NFTA_FIB_F_IIF) &&
> > +	    (netif_is_l3_master(oif) || netif_is_l3_slave(oif)))
> > +		fl6.flowi6_oif = oif->ifindex;
> > +
> 
> I was about to apply this, but this initialisation comes before
> nft_fib6_flowi_init(), should this be *after*, or part of
> nft_fib6_flowi_init() function instead?

Oh, I missed that one, sorry. I'll make it part of
nft_fib6_flowi_init() to better align with ip6t_rpfilter.c.

Thanks, Phil
