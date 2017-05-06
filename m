From: Florian Westphal <fw@strlen.de>
Subject: Re: How to reinject a packet (skb) at some later point in time
Date: Sat, 6 May 2017 21:40:09 +0200
Message-ID: <20170506194009.GB20672@breakpoint.cc>
References: <CAJEV1ijznokQj78RNXTRxMnrnRTBtoWZUVwcB4k7JHYb9FfLJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pavel Vajarov <pavel@x3me.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36304 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751396AbdEFTkb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 May 2017 15:40:31 -0400
Content-Disposition: inline
In-Reply-To: <CAJEV1ijznokQj78RNXTRxMnrnRTBtoWZUVwcB4k7JHYb9FfLJw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pavel Vajarov <pavel@x3me.net> wrote:
> pending SYN packets. As far as I thought about it, the problems come
> from two things:
> 1. The kernel functionality in net/netfilter/nfnetlink_queue.c usues
> linked list to store pending packets and it doesn't perform well when
> we need to search by packet id there when the user space issues
> NF_ACCEPT verdict at some time later.

I think you should change our in kernel nfnetlink_queue backend
to use a single hash table to store nf_entry.

You can use rhashtable, and hash via

hash(netns, queueid, packetid, secret);

to avoid the linear searches in kernel.
This will unfortunately need repeated lookups for the VERDICT_BATCH
case though so we might end up needing two hash tables (2nd one would
a rhlist one that just hashes lists via hash(netns, queueid, secret),
used by VERDICT_BATCH.

This will need new resource counting to avoid table overload
by single consumer, however the current packet-counting is broken
and has to be replaced by a skb->truesize based counting anyway.

> 2. There are input SYN re-transmits which goes to the user space
> simply to be dropped (NF_DROP) because the original SYN packet with
> the same (src ip:port -> dst ip:port) is still waiting it's verdict,
> and there is no point keeping the re-transmitted SYN packets.

It might be possible to avoid that by combining nfqueue with -m
hashlimit and a small timeout (or nft flow statement) instead.

Or do you consider that too broken?

Idea is something like this:

1. rule that drops syn packets already in hash
2. rule to add syn packets to hash
3. rule to queue syn packets
4. rule to delete syn packets from hash

4) would be triggered post nf_reinject().

> I think, I can implement most of the logic in iptables target module
> which will return NF_STOLEN for the packets which it want's to be
> checked. So my main question is how to reinject such packets later
> because I do not have there nf_hook_state with okfn to call, as the
> the net/netfilter/nf_queue.c does on nf_reinject.

There was some effort to move NF_QUEUE out of the core completely, see

https://patchwork.ozlabs.org/patch/681785/

I think all the problems indicated there are fixable.

So, I think there are several possible solutions for this issue,
including making so we can have a 2nd queueing backend, however I'd
prefer to fix/extend what we have.

The assumption for linked-list is that out-of-order reinjects are
a bad idea (i.e., first entry will be the correct one) but in your case
you're only queueing SYNs so there is no data reordering.

I think we should focus on figuring out how to make that work
without adding a 2nd queueing backend though.
