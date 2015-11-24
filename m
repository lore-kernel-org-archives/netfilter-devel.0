From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Tue, 24 Nov 2015 11:39:38 +0100
Message-ID: <20151124103938.GB3014@salvia>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-4-git-send-email-fw@strlen.de>
 <20151124102445.GE2683@salvia>
 <20151124103105.GE1740@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46601 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbbKXKjp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:39:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9B9B3DA860
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:39:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8DA40DA81D
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:39:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DB3C2DA877
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:39:39 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151124103105.GE1740@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 24, 2015 at 11:31:05AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
> > > index dabf5ed..69bdd9a 100644
> > > --- a/net/netfilter/nf_tables_core.c
> > > +++ b/net/netfilter/nf_tables_core.c
> > > @@ -55,6 +55,7 @@ static void __nft_trace_packet(const struct nft_pktinfo *pkt,
> > >  		     rulenum);
> > >  }
> > >  
> > > +static bool prefer_native_trace __read_mostly;
> > >  struct static_key nft_trace_enabled __read_mostly;
> > >  EXPORT_SYMBOL_GPL(nft_trace_enabled);
> > >  
> > > @@ -69,7 +70,13 @@ static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
> > >  		if (!pkt->skb->nf_trace)
> > >  			return;
> > >  		nf_tables_trace_notify(pkt, chain, rule, verdict, type);
> > > -		__nft_trace_packet(pkt, chain, rulenum, type);
> > > +		if (prefer_native_trace)
> > > +			return;
> > > +
> > > +		if (nfnetlink_has_listeners(pkt->net, NFNLGRP_NFTABLES))
> > > +			prefer_native_trace = true;
> > > +		else
> > > +			__nft_trace_packet(pkt, chain, rulenum, type);
> > 
> > For this very specific case I prefer a sysctl that we can remove
> > moving forward, then remove this code and default to the new tracing
> > infrastructure once we have indications that adoption of this new
> > tracing infrastructure has been massively adopted instead of the
> > existing one.
> 
> So you're saying
> 
> sysctl nft_old_trace = 1;
> 
> and then do
> 
> nf_tables_trace_notify(..)
> if (nft_old_trace)
> 	__nft_trace_packet();
> 
> ?

What I'm trying to avoid is the initial race that we'll have.

I mean, with this approach the user will likely enable the tracing
from the rule, then will launch nft trace. In that case, he will be
getting traces from the old way for a little while until you get one
process subscribed to this.
