From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC] connlimit for nftables and limiting ct count by zone
Date: Mon, 30 Oct 2017 11:40:18 +0100
Message-ID: <20171030104018.GA6593@breakpoint.cc>
References: <20171016144254.GA3728@breakpoint.cc>
 <CAG1aQhJR9OMtxKgW3CQePsGDahbrpUpNk0Srx=RdOnr0_tWmKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        YiHung Wei <yihungw@vmware.com>,
        Justin Pettit <jpettit@vmware.com>, Joe Stringer <joe@ovn.org>
To: Yi-Hung Wei <yihung.wei@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41374 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751917AbdJ3Kkm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Oct 2017 06:40:42 -0400
Content-Disposition: inline
In-Reply-To: <CAG1aQhJR9OMtxKgW3CQePsGDahbrpUpNk0Srx=RdOnr0_tWmKg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yi-Hung Wei <yihung.wei@gmail.com> wrote:
> On Mon, Oct 16, 2017 at 7:42 AM, Florian Westphal <fw@strlen.de> wrote:
> > From nft (user front end) this would look like this:
> >
> > add rule inet filter input ct state new ct count { ip saddr } gt 100 drop
> >
> > The part enclosed in { } denotes the key/grouping that should be applied.
> >
> > e.g.
> >
> > ct count { ip saddr & 255.255.255.0 }   # count by source network
> > ct count { ip saddr & 255.255.255.0 . tcp dport }   # count by source network and service
> > ct count { ct zone } # count by zone
> Does it mean that all the ct zones will have the same limit?

Yes, for now.  I in nft the right hand side of compare operations in nft
needs to be an immediate.

> shall we extend this syntax to support different limit for different
> zone?

No, I don't think we should do this at the moment.

I think we could possible use maps to fetch values based on a key, e.g.

nft add map filter zonelimits { type typeof(ct zone) : typeof(ct count); flags interval\;}
nft add element filter zonelimits { 1-100 : 50000 }
nft add element filter zonelimits { 101 : 60000 }

nft add rule filter prerouting \
  ct count { ip saddr & 255.255.255.0 } gt { ct zone }

None of this is implemented or planned, just an idea.

Don't think we should bother about this at this time and
focus on the conntrack counting infrastructure first.

> How would we use nft to get the ct limit and ct count on
> particular key ? It may be useful for debugging and monitoring
> purpose?

Really?  So far my impression was that ovs does not wish
to interact with nft in any way.

> Other than using nft to configure ct limit, if other user space
> utilities want to set/get the ct limit or query the current ct count
> would there be any API to achieve that?

I think that ovs would hook into the api that nft uses.
Its up to the user to make sure that whatever limits are configured in
nft don't mess with ovs.

The other alternative of course is to add a new family and stick
NF_HOOK() calls into ovs...

> > 1. xt_connlimit must be split into an iptables part and a 'nf_connlimit'
> >    backend.
> >
> >    nf_connlimit.c would implement the main function:
> >
> > unsigned int nf_connlimit_count(struct nf_connlimit_data *,
> >                                 const struct nf_conn *conn,
> >                                 const void *key,
> >                                 u16 keylen);
> >
> > Where 'nf_connlimit_data' is a structure that contains the (internal)
> > bookkeeping structure(s), conn is the connection that is to be counted,
> > and key/keylen is the (arbitrary) identifier to be used for grouping
> > connections.
> >
> > xt_connlimits match function would then build a 'u32 key[5]' based on
> > the options the user provided on the iptables command line, i.e.
> > the conntrack zone and then either a source or destination network
> > (or address).
> It is not clear to me that why we have 'u32 key[5]'. Is it because the
> key would be the combination of Ip/ipv6 src or dst address with mask
> (up to 16bytes), src or dst port (2 bytes), and ct zone (2 bytes)?

Yes, xt_connlimit would have

u32 key[5];

key[0] = zone;
key[1] = iphdr->saddr;

nf_connlimit_count, ... key, 8);

key[2], [3], [4] are only needed for ipv6.

> Do we need to specify the order for the key? How do we distinguish the
> case where we have zone (u16) as a key vs. dport (u16) as a key?

The key is opaque to the backend, it just needs to this for memcmp.

> > 3. Other users, such as ovs, could also call this api, in the case of
> > per-zone limiting key would simply be a u16 containing the zone identifier.
> I am wondering if there will be APIs to set and get the conntrack
> limit on particular key,

No, this would not be provided by that backend, as the backend doesn't
know how the result is used.  It just returns the number of connections
that match the current key.

> and also query the ct count on particular key
> in the kernel space?

For what purpose would that be needed?

> Just as you mentioned in the DESTORY event approach. I am wondering if
> we can store an extra pointer to the tree node maybe in struct
> nf_ct_ext, so that we can associate nf_conn with the tree node and
> increase the count when the connection is confirmed, and we will
> reduce the count when the connection is destroyed. In this way, with
> some extra space, the insertion and updating the count in the tree
> node is O(1) and we can get rid of GC scheme. I am not sure how much
> effort does it take to modify the conntrack core tho.

There could be dozens of connlimit trees.

For example, a user could configure per-zone limit and a per-host limit
at the same time.
