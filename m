From: Florian Westphal <fw@strlen.de>
Subject: Re: How to send nf trace notifications to userspace?
Date: Sat, 7 Nov 2015 21:49:44 +0100
Message-ID: <20151107204944.GB24154@breakpoint.cc>
References: <20151106232900.GA24154@breakpoint.cc>
 <20151107163835.GA962@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51636 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752672AbbKGUtq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Nov 2015 15:49:46 -0500
Content-Disposition: inline
In-Reply-To: <20151107163835.GA962@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > However, the code uses nfnetlink_log.  It appears that its
> > unicast only, i.e. its not possible to run another 'nft trace' in parallel
> > and also clashes with ulogd or other running logger.
> > 
> > Thats a non-starter.
> > 
> > So I'm inclined to toss the nfnetlink_log based changes and
> > instead (re-)use the infrastructure that we have for chain, rule, ... notifications.
> 
> Something that integrates tightly with the infrastructure is the way
> to go. I'd suggest you add a new NFNLGRP_NFTABLES_TRACE nfnetlink
> group.

Okay, can do.

> > [...] Also saves us from the 'rule counting' that we're currently
> > doing in kernel.
> 
> I think we'll have to keep that counting around to provide the legacy
> output from the compat layer.

Can you elaborate?  I find scavenging dmesg output rather painful so I
see no reason to keep the current code once the new facility is available.

In any case, i can keep it since I planned to see if we can add static
key to avoid all the 'if (skb->nf_trace)' stuff for the normal case.

But I'd want to see a convincing argument to keep the existing trace
stuff first :-)

> > $ src/nft trace
> > SRC=192.168.7.1 DST=192.168.7.10 LEN=88 TTL=64 ID=39366 PROTO=6 SPT=47028 DPT=22 raw prerouting (# handle 6)
> > ACCEPT raw prerouting
> > filter input (# handle 7)
> >         tcp dport ssh jump foo
> > filter foo (# handle 5)
> >         ip daddr 192.168.7.10
> > filter foo (# handle 6)
> >         counter packets 912 bytes 63619
> > RETURN filter foo
> > filter input (# handle 8)
> >         ip protocol tcp ip daddr 192.168.7.10
> > filter input (# handle 9)
> >         tcp dport ssh accept
> 
> I guess this is a draft proposal, but I think it would be good to have
> a more compact output that can be easily read, eg.

Yes, I have not thought about representation in userspace so far.

On a related note, should that be part of 'nft monitor' or a distinct
command?

My gut feeling was to re-use monitor mode, re-use NFNLGRP_NFTABLES and
just add a new message type (NFT_MSG_TRACE) for it, on the grounds that
tracing is usually off on a production system so I don't see why we would
have to prevent normal event listeners from seeing trace messages.

But, your call.

> matches: filter input tcp dport ssh accept # handle 9

looks more similar to standard '--handle' format, so its definitely
better.  I'll deal with this after all the interface details are hashed
out.

> > Do you think its useful to also dump skb data (i.e. in/outdev,
> > packet payload, etc?)
> 
> Such information is useful to know what packet is matching what rules.
> 
> If we have a way to uniquely identify the packet (probably part of the
> skbuff address as we do with conntrack ID from ctnetlink?), we can
> just dump this packet data and metadata only once when setting
> skb->nf_trace to 1, then from the trace event we only include the
> packet ID that results from matching a rule, so userspace can
> correlate.

Ok, that seems sensible.
What would you suggest?

I'm inclined to go with nested attributes for this, i.e.:

nest = nla_nest_start(skb, NFTA_TRACE_RULE);
..
nla_put_be64(skb, NFTA_RULE_HANDLE, cpu_to_be64(rule->handle)))
nla_put_string( NFTA_RULE_CHAIN, TABLE, etc...
nla_nest_end()

For the first trace message (when skb->nf_trace changes to 1),
this would mean we'd have something like:

nest = nla_nest_start(skb, NFTA_TRACE_PACKET)
 -> NFULA_PACKET_HDR,
 -> NFULA_PREFIX

etc.

I'd see if we can do this by refactoring nfnetlink_log.c to provide
a helper to fill in this nested attibute data to avoid copy&paste of
__build_packet_message().

It could then be called by nft_meta.c when nf_trace is set on an skb.
Downside is that this would create module dependency on nfnetlink_log.

What do you think?
Alternative is to copy&paste, but trim it down to not include all
the info nfnetlink_log offers, f.e. i'm not sure iif, oif, etc are
needed given this can be filtered by setting the nftables meta nftrace
rules appropriately.

This also has implications on nft dependencies -- should it use
libnfnetlink_log?  With reduced attributes-we-log that could be avoided.

