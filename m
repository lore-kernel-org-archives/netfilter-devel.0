From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nftables: fix nf_trace always-on with
 XT_TRACE=n
Date: Sun, 16 Feb 2014 10:45:49 +0000
Message-ID: <20140216104549.GC28646@macbook.localnet>
References: <1392504525-21134-1-git-send-email-fw@strlen.de>
 <20140216102003.GA4981@localhost>
 <20140216102824.GC28751@breakpoint.cc>
 <20140216104311.GA3563@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38769 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaBPKpx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 05:45:53 -0500
Content-Disposition: inline
In-Reply-To: <20140216104311.GA3563@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 16, 2014 at 11:43:11AM +0100, Pablo Neira Ayuso wrote:
> On Sun, Feb 16, 2014 at 11:28:24AM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > >  static inline void nf_reset_trace(struct sk_buff *skb)
> > > >  {
> > > > -#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE)
> > > > +#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
> > > 
> > > Perhaps you can add a generic CONFIG_NF_TRACE that is set by xt_trace
> > > and nf_tables?
> > 
> > I could do that, sure, but I don't see the value in doing so.
> > After this patch the only place where we need to test for both
> > are the two places in skbuff.h.
> > 
> > Unless you want to make the nf_trace operations in nftables
> > conditional on CONFIG_NF_TRACE?
> 
> No, that wasn't my intention.
> 
> > OTOH I think that trace support is a very important thing to have and I
> > doubt that compiling it out would save a lot of size.
> > 
> > But sure, if you think it makes sense I can add CONFIG_NF_TRACE and
> > make nf_tables tracing conditional.
> 
> This is just a cosmetic comment, but I can live with that long #if
> line. Leave it up to you to decide.

I intend to make nftables tracing use static keys, unless that turns out
not to reduce the overhead we can keep it unconditionally.
