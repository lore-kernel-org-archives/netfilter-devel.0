From: Florian Westphal <fw@strlen.de>
Subject: [RFC] connlimit for nftables and limiting ct count by zone
Date: Mon, 16 Oct 2017 16:42:54 +0200
Message-ID: <20171016144254.GA3728@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: YiHung Wei <yihungw@vmware.com>,
        Justin Pettit <jpettit@vmware.com>, Joe Stringer <joe@ovn.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36024 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752360AbdJPOnL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Oct 2017 10:43:11 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

During NFWS we briefly discussed iptables '-m connlimit' and how
to apply this to nftables.

There is also a use case to make nf_conntrack_max more fine-grained
by making this setting apply per conntrack zone.

I'd like to ideally resolve both with a single solution.

>From nft (user front end) this would look like this:

add rule inet filter input ct state new ct count { ip saddr } gt 100 drop

The part enclosed in { } denotes the key/grouping that should be applied.

e.g.

ct count { ip saddr & 255.255.255.0 }   # count by source network
ct count { ip saddr & 255.255.255.0 . tcp dport }   # count by source network and service
ct count { ct zone } # count by zone

For this to work there are several issues that need to be resolved.

1. xt_connlimit must be split into an iptables part and a 'nf_connlimit'
   backend.

   nf_connlimit.c would implement the main function:

unsigned int nf_connlimit_count(struct nf_connlimit_data *,
				const struct nf_conn *conn,
				const void *key,
				u16 keylen);

Where 'nf_connlimit_data' is a structure that contains the (internal)
bookkeeping structure(s), conn is the connection that is to be counted,
and key/keylen is the (arbitrary) identifier to be used for grouping
connections.

xt_connlimits match function would then build a 'u32 key[5]' based on
the options the user provided on the iptables command line, i.e.
the conntrack zone and then either a source or destination network
(or address).

2. nftables can add a very small function to nft_ct.c expression that
hands a source register off as *key, and places result (the number of
connections) into a destination register.

In the iptables/nftables case, the struct nf_connlimit_data * would be
attached to the match/expression, i.e. there can be multiple such
count-functions at the same time.

3. Other users, such as ovs, could also call this api, in the case of
per-zone limiting key would simply be a u16 containing the zone identifier.

However, 2 and 3 make further internal changes necessary.

Right now, connlimit performs garbage collection from the packet path.
This isn't a big deal now, as we limit based by single ip address or network
only, the limit will be small.

bookkeeping looks like this:

      Node
      / \
   Node  Node  -> conn1 -> conn2 -> conn3
         /
      Node

Each node contains a single-linked list of connections that share the
same source (address/network).

When searching for the Node, all Nodes traversed get garbage-collected,
i.e. connlimit walks the hlist attached to the node and removes any tuple
no longer stored in the main conntrack table.  If the node then has
empty list, it gets erased from the tree.

But if we limit by zone then its entirely reasonable to have a limit
of e.g.  10k per zone, i.e. each Node could have a list consisting
of 10k elements.  Walking a 10k list is not acceptable from packet path.

Instead, I propose to store a timestamp of last gc in each node, so
we can skip intermediate nodes that had a very recent gc run.

If we find the node (zone, source network, etc. etc) that we should
count the new connection for, then do an on-demand garbage collection.

This is unfortunately required, we don't want to say '150' if the limit
is 150 then the new connection would be dropped, unless we really still
have 150 active connections.

To resolve this, i suggest to store the count in the node itself
(so we do not need to walk the full list of individual connections in the
 packet path).

The hlist would be replaced with another tree:

This allows us to quickly find out if the tuple we want to count now
is already stored (e.g. because of address/port reuse) or not.

It also permits us to check all tuples we see while searching for
the 'new' tuple that should be stored in the subtree and remove those that
are no longer in the main conntrack table.
We could also abort a packet-path gc run if we found at least one old
connection.

A work queue will take care of periodically scanning the main tree
and all sub-trees.  This workqueue would not disable bh for long times
as to not impact normal network processing.

I also considered an in-kernel notifier api for DESTROY events instead
of a gc scheme but it seems it would be more complicated (and
requires changes in the conntrack core).  We would also need to generate
such a destroy even for all conntracks, and not just those that were
committed to the main table.

nftables flow (dynset) or set infrastructure doesn't appear to be of any
use since they address different problem/use cases
(unless I missed something obvious).

Thoughts?
