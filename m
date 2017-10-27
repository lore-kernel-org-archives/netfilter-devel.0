From: Yi-Hung Wei <yihung.wei@gmail.com>
Subject: Re: [RFC] connlimit for nftables and limiting ct count by zone
Date: Thu, 26 Oct 2017 17:49:17 -0700
Message-ID: <CAG1aQhJR9OMtxKgW3CQePsGDahbrpUpNk0Srx=RdOnr0_tWmKg@mail.gmail.com>
References: <20171016144254.GA3728@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org, YiHung Wei <yihungw@vmware.com>,
        Justin Pettit <jpettit@vmware.com>, Joe Stringer <joe@ovn.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:43019 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932364AbdJ0Ati (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2017 20:49:38 -0400
Received: by mail-yw0-f175.google.com with SMTP id y75so4481368ywg.0
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2017 17:49:38 -0700 (PDT)
In-Reply-To: <20171016144254.GA3728@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 16, 2017 at 7:42 AM, Florian Westphal <fw@strlen.de> wrote:
> During NFWS we briefly discussed iptables '-m connlimit' and how
> to apply this to nftables.
>
> There is also a use case to make nf_conntrack_max more fine-grained
> by making this setting apply per conntrack zone.
>
> I'd like to ideally resolve both with a single solution.
Thanks for the proposal. It would be great to be able to resolve the
two issues at the same time.


> From nft (user front end) this would look like this:
>
> add rule inet filter input ct state new ct count { ip saddr } gt 100 drop
>
> The part enclosed in { } denotes the key/grouping that should be applied.
>
> e.g.
>
> ct count { ip saddr & 255.255.255.0 }   # count by source network
> ct count { ip saddr & 255.255.255.0 . tcp dport }   # count by source network and service
> ct count { ct zone } # count by zone
Does it mean that all the ct zones will have the same limit? If it is,
shall we extend this syntax to support different limit for different
zone? How would we use nft to get the ct limit and ct count on
particular key ? It may be useful for debugging and monitoring
purpose?

Other than using nft to configure ct limit, if other user space
utilities want to set/get the ct limit or query the current ct count
would there be any API to achieve that?


> For this to work there are several issues that need to be resolved.
>
> 1. xt_connlimit must be split into an iptables part and a 'nf_connlimit'
>    backend.
>
>    nf_connlimit.c would implement the main function:
>
> unsigned int nf_connlimit_count(struct nf_connlimit_data *,
>                                 const struct nf_conn *conn,
>                                 const void *key,
>                                 u16 keylen);
>
> Where 'nf_connlimit_data' is a structure that contains the (internal)
> bookkeeping structure(s), conn is the connection that is to be counted,
> and key/keylen is the (arbitrary) identifier to be used for grouping
> connections.
>
> xt_connlimits match function would then build a 'u32 key[5]' based on
> the options the user provided on the iptables command line, i.e.
> the conntrack zone and then either a source or destination network
> (or address).
It is not clear to me that why we have 'u32 key[5]'. Is it because the
key would be the combination of Ip/ipv6 src or dst address with mask
(up to 16bytes), src or dst port (2 bytes), and ct zone (2 bytes)?

Do we need to specify the order for the key? How do we distinguish the
case where we have zone (u16) as a key vs. dport (u16) as a key?


> 3. Other users, such as ovs, could also call this api, in the case of
> per-zone limiting key would simply be a u16 containing the zone identifier.
I am wondering if there will be APIs to set and get the conntrack
limit on particular key, and also query the ct count on particular key
in the kernel space?


> Right now, connlimit performs garbage collection from the packet path.
> This isn't a big deal now, as we limit based by single ip address or network
> only, the limit will be small.
>
> bookkeeping looks like this:
>
>       Node
>       / \
>    Node  Node  -> conn1 -> conn2 -> conn3
>          /
>       Node
>
> Each node contains a single-linked list of connections that share the
> same source (address/network).
>
> When searching for the Node, all Nodes traversed get garbage-collected,
> i.e. connlimit walks the hlist attached to the node and removes any tuple
> no longer stored in the main conntrack table.  If the node then has
> empty list, it gets erased from the tree.
Thanks for the explanation. It saves me quite some time to understand
the code structure there.


> But if we limit by zone then its entirely reasonable to have a limit
> of e.g.  10k per zone, i.e. each Node could have a list consisting
> of 10k elements.  Walking a 10k list is not acceptable from packet path.
>
> Instead, I propose to store a timestamp of last gc in each node, so
> we can skip intermediate nodes that had a very recent gc run.
>
> If we find the node (zone, source network, etc. etc) that we should
> count the new connection for, then do an on-demand garbage collection.
>
> This is unfortunately required, we don't want to say '150' if the limit
> is 150 then the new connection would be dropped, unless we really still
> have 150 active connections.
>
> To resolve this, i suggest to store the count in the node itself
> (so we do not need to walk the full list of individual connections in the
>  packet path).
>
> The hlist would be replaced with another tree:
>
> This allows us to quickly find out if the tuple we want to count now
> is already stored (e.g. because of address/port reuse) or not.
>
> It also permits us to check all tuples we see while searching for
> the 'new' tuple that should be stored in the subtree and remove those that
> are no longer in the main conntrack table.
> We could also abort a packet-path gc run if we found at least one old
> connection.
I agree that it is inefficient to do GC if we host say 10k connections
in the hlist within a tree node. I think all the aforementioned
optimization mechanisms such as storing 'timestamp' and 'count' in the
tree node, aborting if we find at least one old connections, and
replacing hlist with a tree, are useful. Basically, the first two
techniques will reduce unnecessarily GC on the packet path, and
replacing hlist with a rb_tree will further reduce the insertion time
to the tree node from O(n) to O(log n), i.e. n is # of connections in
the hlist.

Just as you mentioned in the DESTORY event approach. I am wondering if
we can store an extra pointer to the tree node maybe in struct
nf_ct_ext, so that we can associate nf_conn with the tree node and
increase the count when the connection is confirmed, and we will
reduce the count when the connection is destroyed. In this way, with
some extra space, the insertion and updating the count in the tree
node is O(1) and we can get rid of GC scheme. I am not sure how much
effort does it take to modify the conntrack core tho.

Thanks,

-Yi-Hung
