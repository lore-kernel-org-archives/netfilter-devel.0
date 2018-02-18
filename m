From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC 0/4] net: add bpfilter
Date: Sun, 18 Feb 2018 01:35:15 +0100
Message-ID: <20180218003515.GD13493@breakpoint.cc>
References: <20180216134023.15536-1-daniel@iogearbox.net>
 <20180217121145.GI7843@nataraja>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        alexei.starovoitov@gmail.com
To: Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56580 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751083AbeBRAio (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Feb 2018 19:38:44 -0500
Content-Disposition: inline
In-Reply-To: <20180217121145.GI7843@nataraja>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Harald Welte <laforge@gnumonks.org> wrote:
> I believe _if_ one wants to use the approach of "hiding" eBPF behind
> iptables, then either
[..]
> b) you must introduce new 'tables', like an 'xdp' table which then has
>    the notion of processing very early in processing, way before the
>    normal filter table INPUT processing happens.

In nftables. the netdev ingress hook location could be used for this,
but right, iptables has no equivalent.

netdev ingress is interesting from an hw-offload point of view,
unlike all other netfilter hooks its tied to a specific network interface
rather than owned by the network namespace.

A rule like (yes i am making this up)
limit 10000 byte/s

cannot be offloaded because it affects all packets going through
the system, i.e. you'd need to share state among all nics which i think
won't work :-)

Same goes for any other match/target that somehow contains (global)
state and was added to the 'classic' iptables hook points.
(exception: rule restricts interface via '-i foo').


Note well: "offloaded != ebpf" in this case.

I see no reasons why ebpf cannot be used in either iptables or
nftables.  How to get there is obviously a different beast.

For iptables, I think we should put it in maintenance mode and
focus on nftables, for many reasons outlined in other replies.

And how to best make use of ebpf+nftables

In ideal world, nftables would have used (e)bpf from the start.
But, well, its not an ideal world (iirc nft origins are just a bit
too old).

That doesn't mean that we can't leverage ebpf from nftables.
Its just a question of where it makes sense and where it doesn't,
f.e. i see no reason to replace c code with ebpf just 'because you can'.

Speedup?  Good argument.
Feature enhancements that could use ebpf programs? Another good
argument.

I guess there are a lot more.

So I'd like to second Haralds question.

What is the main goal?

For nftables, I believe most important ones are:
- make kernel keeper/owner of all rules
- allow userspace to learn of rule addition/deletion
- provide fast matching (no linear evaluation of rules,
native sets with jump and verdict maps)
- provide a single tool instead of ip/ip6/arp/ebtables
- unified ipv4/ipv6 matching
- backwards compat and/or translation infrastructure


But once these are reached, we will hopefully have more:
- offloading (hardware)
- speedup via JIT compilation
- feature enhancements such as matching arbitrary packet
contents

I suspect you see that ebpf might be a fit and/or help us with
all of these things.

So, once I understand what your goals are I might be better able
to see how nftables could fit into the picture, as you can see
I did a lot of guesswork :-)
