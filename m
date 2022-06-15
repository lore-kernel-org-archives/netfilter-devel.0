Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B3A5C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jun 2022 08:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235965AbiFOIsI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jun 2022 04:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345269AbiFOIsG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jun 2022 04:48:06 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230EFE0E8
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2022 01:48:01 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1o1Ogx-0008UF-Vs; Wed, 15 Jun 2022 10:48:00 +0200
Date:   Wed, 15 Jun 2022 10:47:59 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] nft: Exit if nftnl_alloc_expr fails
Message-ID: <Yqmcv7LosxwmO9ZR@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220614164457.4592-1-phil@nwl.cc>
 <YqmEYNjjLO5WKgfr@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqmEYNjjLO5WKgfr@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 15, 2022 at 09:04:00AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jun 14, 2022 at 06:44:57PM +0200, Phil Sutter wrote:
> > In some code-paths, 'reg' pointer remaining unallocated is used later so
> > at least minimal error checking is necessary. Given that a call to
> > nftnl_alloc_expr() should never fail with sane argument, complain and
> > exit if it happens.
> > 
> > Fixes: 7e38890c6b4fb ("nft: prepare for dynamic register allocation")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  iptables/nft-shared.c | 32 +++++++++++++++++---------------
> >  1 file changed, 17 insertions(+), 15 deletions(-)
> > 
> > diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
> > index 27e95c1ae4f38..d603e7c9d663b 100644
> > --- a/iptables/nft-shared.c
> > +++ b/iptables/nft-shared.c
> > @@ -40,15 +40,25 @@ extern struct nft_family_ops nft_family_ops_ipv6;
> >  extern struct nft_family_ops nft_family_ops_arp;
> >  extern struct nft_family_ops nft_family_ops_bridge;
> >  
> > +static struct nftnl_expr *nftnl_expr_alloc_or_die(const char *name)
> 
> better call this:
> 
> xt_nftnl_expr_alloc()
> 
> or such, to not enter nftnl_ namespace, I'd suggest.

ACK, will do.

> > +{
> > +	struct nftnl_expr *expr = nftnl_expr_alloc(name);
> > +
> > +	if (expr)
> > +		return expr;
> > +
> 
> extra line space.

Oh, thanks.
