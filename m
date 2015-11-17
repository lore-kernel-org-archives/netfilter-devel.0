From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC] netfilter: nf_tables: extend tracing infrastructure
Date: Tue, 17 Nov 2015 12:04:29 +0100
Message-ID: <20151117110429.GD14892@breakpoint.cc>
References: <20151109133608.GD8098@macbook.localdomain>
 <1447343209-28029-1-git-send-email-fw@strlen.de>
 <20151116215635.GA6601@salvia>
 <20151117000352.GC14892@breakpoint.cc>
 <20151117104003.GA16707@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42440 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136AbbKQLEb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Nov 2015 06:04:31 -0500
Content-Disposition: inline
In-Reply-To: <20151117104003.GA16707@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Nov 17, 2015 at 01:03:52AM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> [...]
> > > 
> > > BTW, any reason to remove the existing infrastructure? It's been there
> > > since almost the beginning (this would break users that are expecting
> > > the existing behaviour).
> > 
> > No specific reason, but I question the need to keep it around.
> > Once we have native tooling there should be no reason whatsover
> > to wade through dmesg output + manual matching of rules...
> 
> It is not only dmesg.
> 
> You can also configure this thing to send trace messages through
> nfnetlink_log through group 0.
> 
> > its just a PITA and thats why I removed it -- 'nft monitor trace'
> > (or whatever, I've not decided on what nft side should look like)
> > would be much simpler/easier to use.
> 
> It's always a PITA to keep extra code around to keep things
> compatible, but there is no other way to deprecate things.
> 
> Don't forget this tracing infrastructure has been there for nearly two
> years.

Hmm, I had hoped that we can just ignore that since its not an abi
and lack of these printks would apply some gentle pressure to switch to
native nft ;)

> > Wouldn't it make more sense to convince people to go with real nft
> > rather than the compat layer?
> 
> I wish there could be a way to "convice" users to move in a quick way,
> but there is not. We can just provide something better and wait for
> quite some time to deprecate things.

I have no idea how to make this nice :-(

I don't want to clutter dmesg/nfnetlink_log when someone is using nft trace.

So I'd propose to just check in the kernel trace event path if there is
a nfnl group, and if there is one, disable the printk forever:

if (old && nfnetlink_has_listeners(pkt->net, NFNLGRP_NFTABLES))
        old = false;

I see no other way to really make this play nice.  Any other ideas?
I'd rather not add yet another sysctl toggle...

On a different note, here is how userspace output looks like at the
moment:

# src/nft -a monitor trace
trace event ip packet src 192.168.7.1 dst 192.168.7.10 len 96 ttl 64 id 31765 proto 6 sport 53434 dport 22
trace event ip raw prerouting rule verdict continue
trace rule tcp dport ssh limit rate 1/second nftrace set 1 # handle 2
trace event ip raw prerouting policy verdict accept
trace event ip filter input rule verdict jump
trace rule ip saddr . tcp dport vmap { } # handle 7
trace event ip filter test rule verdict accept
trace rule accept # handle 4
add rule ip filter input ip protocol icmp accept # handle 15
trace event ip packet src 192.168.7.1 dst 192.168.7.10 len 52 ttl 64 id 28163 proto 6 sport 53420 dport 22
trace event ip raw prerouting rule verdict continue
trace rule tcp dport ssh limit rate 1/second nftrace set 1 # handle 2
trace event ip raw prerouting policy verdict accept
trace event ip filter input rule verdict jump
delete rule ip filter input handle 10
trace rule ip saddr . tcp dport vmap { } # handle 7
trace event ip filter test rule verdict accept
trace rule accept # handle 4
trace event ip packet src 192.168.7.1 dst 192.168.7.10 len 52 ttl 64 id
^C

Input on how to improve this welcome.
Most of the formatting is done via libnfnetlink helpers.

Main other point is (what we discussed earlier) -- how to match up
packet + the traced rules when several packets are traced at the same
time.

The kernel already provides a 32bit id value, based on skb address.
Simple solution would be to just print that id as well, e.g.

trace event packet 0x12345 src 192.168.7.1 dst 192.168.7.10 len 52 ttl 64 id 28163 proto 6 sport 53420 dport 22
trace rule packet 0x12345 tcp dport ssh ...
trace event packet 0x42 src 192.168.1.1 dst 10...

is that good enough or do you see a better/nicer solution?

Thanks!
