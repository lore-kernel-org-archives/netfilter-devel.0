From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nftables: fix nf_trace always-on with
 XT_TRACE=n
Date: Sun, 16 Feb 2014 11:43:11 +0100
Message-ID: <20140216104311.GA3563@localhost>
References: <1392504525-21134-1-git-send-email-fw@strlen.de>
 <20140216102003.GA4981@localhost>
 <20140216102824.GC28751@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47474 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbaBPKnQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 05:43:16 -0500
Content-Disposition: inline
In-Reply-To: <20140216102824.GC28751@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 16, 2014 at 11:28:24AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >  static inline void nf_reset_trace(struct sk_buff *skb)
> > >  {
> > > -#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE)
> > > +#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
> > 
> > Perhaps you can add a generic CONFIG_NF_TRACE that is set by xt_trace
> > and nf_tables?
> 
> I could do that, sure, but I don't see the value in doing so.
> After this patch the only place where we need to test for both
> are the two places in skbuff.h.
> 
> Unless you want to make the nf_trace operations in nftables
> conditional on CONFIG_NF_TRACE?

No, that wasn't my intention.

> OTOH I think that trace support is a very important thing to have and I
> doubt that compiling it out would save a lot of size.
> 
> But sure, if you think it makes sense I can add CONFIG_NF_TRACE and
> make nf_tables tracing conditional.

This is just a cosmetic comment, but I can live with that long #if
line. Leave it up to you to decide.
