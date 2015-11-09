From: Patrick McHardy <kaber@trash.net>
Subject: Re: How to send nf trace notifications to userspace?
Date: Mon, 9 Nov 2015 13:36:08 +0000
Message-ID: <20151109133608.GD8098@macbook.localdomain>
References: <20151106232900.GA24154@breakpoint.cc>
 <20151107163835.GA962@salvia>
 <20151107204944.GB24154@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:48071 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751372AbbKINgM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 08:36:12 -0500
Content-Disposition: inline
In-Reply-To: <20151107204944.GB24154@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07.11, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Do you think its useful to also dump skb data (i.e. in/outdev,
> > > packet payload, etc?)
> > 
> > Such information is useful to know what packet is matching what rules.
> > 
> > If we have a way to uniquely identify the packet (probably part of the
> > skbuff address as we do with conntrack ID from ctnetlink?), we can
> > just dump this packet data and metadata only once when setting
> > skb->nf_trace to 1, then from the trace event we only include the
> > packet ID that results from matching a rule, so userspace can
> > correlate.
> 
> Ok, that seems sensible.
> What would you suggest?
> 
> I'm inclined to go with nested attributes for this, i.e.:
> 
> nest = nla_nest_start(skb, NFTA_TRACE_RULE);
> ..
> nla_put_be64(skb, NFTA_RULE_HANDLE, cpu_to_be64(rule->handle)))
> nla_put_string( NFTA_RULE_CHAIN, TABLE, etc...
> nla_nest_end()
> 
> For the first trace message (when skb->nf_trace changes to 1),
> this would mean we'd have something like:
> 
> nest = nla_nest_start(skb, NFTA_TRACE_PACKET)
>  -> NFULA_PACKET_HDR,
>  -> NFULA_PREFIX
> 
> etc.
> 
> I'd see if we can do this by refactoring nfnetlink_log.c to provide
> a helper to fill in this nested attibute data to avoid copy&paste of
> __build_packet_message().
> 
> It could then be called by nft_meta.c when nf_trace is set on an skb.
> Downside is that this would create module dependency on nfnetlink_log.

On dumping the packet meta data - one idea would be to have the user
specify what he is interested in using the existing expressions. We
could simply dump that data to the registers and include the raw data
in the message, nft has enough information to decode it. The upside
would be that we don't have to unconditionally include all data and
the user can also dump "unusual" parts in case he's interested in them.
