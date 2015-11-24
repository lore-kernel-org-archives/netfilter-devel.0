From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Tue, 24 Nov 2015 11:31:05 +0100
Message-ID: <20151124103105.GE1740@breakpoint.cc>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-4-git-send-email-fw@strlen.de>
 <20151124102445.GE2683@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58458 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754386AbbKXKbG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:31:06 -0500
Content-Disposition: inline
In-Reply-To: <20151124102445.GE2683@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
> > index dabf5ed..69bdd9a 100644
> > --- a/net/netfilter/nf_tables_core.c
> > +++ b/net/netfilter/nf_tables_core.c
> > @@ -55,6 +55,7 @@ static void __nft_trace_packet(const struct nft_pktinfo *pkt,
> >  		     rulenum);
> >  }
> >  
> > +static bool prefer_native_trace __read_mostly;
> >  struct static_key nft_trace_enabled __read_mostly;
> >  EXPORT_SYMBOL_GPL(nft_trace_enabled);
> >  
> > @@ -69,7 +70,13 @@ static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
> >  		if (!pkt->skb->nf_trace)
> >  			return;
> >  		nf_tables_trace_notify(pkt, chain, rule, verdict, type);
> > -		__nft_trace_packet(pkt, chain, rulenum, type);
> > +		if (prefer_native_trace)
> > +			return;
> > +
> > +		if (nfnetlink_has_listeners(pkt->net, NFNLGRP_NFTABLES))
> > +			prefer_native_trace = true;
> > +		else
> > +			__nft_trace_packet(pkt, chain, rulenum, type);
> 
> For this very specific case I prefer a sysctl that we can remove
> moving forward, then remove this code and default to the new tracing
> infrastructure once we have indications that adoption of this new
> tracing infrastructure has been massively adopted instead of the
> existing one.

So you're saying

sysctl nft_old_trace = 1;

and then do

nf_tables_trace_notify(..)
if (nft_old_trace)
	__nft_trace_packet();

?
