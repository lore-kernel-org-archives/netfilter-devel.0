From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Thu, 26 Nov 2015 11:42:53 +0000
Message-ID: <20151126114253.GD16828@macbook.localdomain>
References: <20151124113341.GO2310@macbook.localdomain>
 <20151124151542.GA20972@breakpoint.cc>
 <20151124152649.GK14478@macbook.localdomain>
 <20151124153550.GC20972@breakpoint.cc>
 <20151124154241.GL14478@macbook.localdomain>
 <20151125150640.GE18449@macbook.localdomain>
 <20151125162424.GJ23215@breakpoint.cc>
 <20151125164629.GB30712@macbook.localdomain>
 <20151126105017.GB16828@macbook.localdomain>
 <20151126110329.GB22027@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:34824 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750791AbbKZLm6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 06:42:58 -0500
Content-Disposition: inline
In-Reply-To: <20151126110329.GB22027@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.11, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > Ok here's might current state. I've added an output filter and defined
> > output ordering, so we can surpress some fields and order the remaining
> > ones the way we want. I've also added redundant payload dependency
> > elimination.
> > 
> > Example output looks like this:
> > 
> > trace id 85060d00 arp packet: iif ens3 ether saddr 63:f6:4b:00:54:52 ether daddr c9:4b:a9:00:54:52 arp operation reply arp sha 63:f6:4b:00:54:52 arp sip 192.168.122.1 arp tha c9:4b:a9:00:54:52 arp tip 192.168.122.84
> > 
> > trace id 853ff400 ip packet: iif ens3 ether saddr 63:f6:4b:00:54:52 ether daddr c9:4b:a9:00:54:52 ip saddr 192.168.122.1 ip daddr 192.168.122.84 ip tos 16 ip ttl 64 ip id 38325 ip length 60 tcp sport 46156 tcp dport 10000
> > 
> > trace id 853ffc00 ip packet: oif ens3 ip saddr 192.168.122.84 ip daddr 192.168.122.1 ip tos 16 ip ttl 64 ip id 51655 ip length 40 tcp sport 10000 tcp dport 46156
> > 
> > If people are happy this way I'll start getting it into final shape.
> 
> Please do, looks great!

Great :)

> But note that I'm still busy with v2 of the libnftnl and kernel parts,
> there will be minor changes there.
> 
> 1. VLAN_TAG attr will be removed, I'll insert vlan header after ethernet
> one in the LL_HEADER payload.
> 2. IIF, OIF etc attributes will be removed.  Instead, I plan to reuse
> meta keys for this in a nested TRACE_META attribute.

Both sound like good ideas, however regarding meta we'd have to use the
nft attributes even if we're using the tracing infrastructure for different
subsystems as discussed previously. I guess that would be Ok, just wanted
to mention it.

> Not sure yet how the libnftnl part will look like, I'd prefer to reuse
> meta decoding parts that we have in libnftnl already
> (my thinking was that if we'd want e.g. secmark later we could
>  do so more easily if we'd just reuse meta key values).
> 
> 3. PACKET message type has been removed.  Kernel will insert the HEADER
> payloads in the first message sent from each do_chain invocation.
> 
> I think this will not interfere with your patch too much.

Probably not, should be quite easy to adapt to any interface changes.


BTW, I had a another idea regarding the kernel side. Just mentioning it
in case you find it interesting:

We're currently only sending traces for matching rules. If we get NFT_BREAK
we'll skip sending a trace.

It might also be of interest *why* a rule didn't match. A possibility without
too much overhead would be in the NFT_BREAK case to send:

* a trace message
* the current register contents
* the current *expr

That would allow userspace to look at the first non-matching expression,
determine the meaning of the register contents and show the expression and
the actual contents.

So you'd get a rule, let's say an expression "iif eth0" and the register
content "iif eth1".

Just an idea.
