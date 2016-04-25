From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 0/4] Interval overlap detection for named sets
Date: Mon, 25 Apr 2016 17:59:56 +0100
Message-ID: <20160425165956.GB9987@macbook.localdomain>
References: <1461427720-4939-1-git-send-email-pablo@netfilter.org>
 <20160425103832.GC29560@macbook.localdomain>
 <20160425115721.GB1043@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56610 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721AbcDYRAC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 13:00:02 -0400
Content-Disposition: inline
In-Reply-To: <20160425115721.GB1043@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.04, Pablo Neira Ayuso wrote:
> On Mon, Apr 25, 2016 at 11:38:32AM +0100, Patrick McHardy wrote:
> > On 23.04, Pablo Neira Ayuso wrote:
> > > This patchset adds the missing code to reject overlapping intervals.
> > > 
> > >  # nft add table ip filter
> > >  # nft add set ip filter myset { type ipv4_addr\; flags interval\; }
> > >  # nft add chain ip filter output { type filter hook output priority 0\; }
> > >  # nft add rule ip daddr @myset counter packets 0 bytes 0
> > >  # nft add element ip filter myset { 127.0.0.0/16 }
> > > 
> > > Then, if you add an overlapping element:
> > > 
> > >  # nft add element ip filter myset { 127.0.0.0/24 }
> > >  <cmdline>:1:31-42: Error: interval overlaps with an existing one
> > >  add element ip filter myset { 127.0.0.0/24 }
> > >                                ^^^^^^^^^^^^
> > > 
> > > The new validation code from userspace rejects this to avoid shadowing
> > > issues.
> > 
> > This is actually intended. There is no issue with shadowing since sets only
> > contain one statement, present or not present.
> 
> There is issue, eg:
> 
> # nft add element ip x myset { 1.1.1.0/24 }
> # nft add element ip x myset { 1.1.1.1 }
> # nft list ruleset
> table ip x {
>         set myset {
>                 type ipv4_addr
>                 flags interval
>                 elements = { 1.1.1.0, 1.1.1.1}
>         }
>         ...
> }
> 
> If we don't reject the above by now, the listing back to userspace is
> not consistent. This is not trivial to resolve since the
> representation in the kernel (rbtree) are individual nodes. For the
> example above we get a representation like:
> 
> { 0.0.0.0/end, 1.1.1.0, 1.1.1.1, 1.1.1.2/end, 1.1.1.255/end }
> 
> This is hard to reconstruct from userspace given that intervals are
> not easy to identify anymore after this situation.

Yes, the 1.1.1.2/end is also incorrect, which is what messes up the
reconstruction.

For sets its quite easy. If we insert something that is completely overlapped,
there's nothing to do anyways. We simply do nothing. If we insert somsething
that extends an interval in one of both directions, we adjust it appropriately.

We already do exactly this when adding multiple elements to a set in a single
step:

# nft --debug=segtree,netlink filter output ip saddr { 192.168.1.0/24, 192.168.1.100 } counter

__set%d filter 7
insert: [c0a80100 c0a801ff]
insert: [c0a80164 c0a80164]
split [c0a80100 c0a801ff]
iter: [c0a80100 c0a80163]
iter: [c0a80164 c0a80164]
iter: [c0a80165 c0a801ff]
list: [00000000 c0a800ff]
list: [c0a80100 c0a801ff]
list: [c0a80200 ffffffff]

__set%d filter 0
	element 00000000  : 1 [end]	element 0001a8c0  : 0 [end]	element 0002a8c0  : 1 [end]

Simply keeping track of the seqtree changes and applying those to the kernel
should handle this fine.

> > For maps something like this does make sense, but for sets it only
> > makes it harder to use.
> > 
> > Generally, we have a conflict resolution based on size, the more specific
> > element wins. The assumption being that if you add something generic and
> > something more specific, the more specific item is an exception to the
> > more generic one.
> 
> Conflicts can be resolved through merges from userspace at some point.
> Basically the idea is that, when maps are not in place, the smaller
> interval will get removed and the new larger one is added in the same
> batch, so this happens in the same go. nft can deal with these
> overlaps so this is easier to users.

The conflict resolution policy needs to be discussed. As I explained, we
already do this, but use a different policy (try adding a map with
two overlapping ranges). This of course so far only applies when the
overlapping elements are added in a single step, so using a different
policy for successive additions might make sense, however its something
I'd like to discuss first.

> This requires a bit more work on the caching side, but I would like to
> provide a more conservative solution by now by rejecting overlaps.

I fully agree for maps for now, but for sets it seems rather simple to do
a proper adjustment. I can give it a try if you want.
