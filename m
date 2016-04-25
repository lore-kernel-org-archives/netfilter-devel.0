From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 0/4] Interval overlap detection for named sets
Date: Mon, 25 Apr 2016 23:32:33 +0200
Message-ID: <20160425213233.GA1584@salvia>
References: <1461427720-4939-1-git-send-email-pablo@netfilter.org>
 <20160425103832.GC29560@macbook.localdomain>
 <20160425115721.GB1043@salvia>
 <20160425165956.GB9987@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35628 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964906AbcDYVcl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 17:32:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id EE6E0C9EDE
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2016 23:32:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CA938CA107
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2016 23:32:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DCCC29D11E
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2016 23:32:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160425165956.GB9987@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 25, 2016 at 05:59:56PM +0100, Patrick McHardy wrote:
> On 25.04, Pablo Neira Ayuso wrote:
> > On Mon, Apr 25, 2016 at 11:38:32AM +0100, Patrick McHardy wrote:
> > > On 23.04, Pablo Neira Ayuso wrote:
> > > > This patchset adds the missing code to reject overlapping intervals.
> > > > 
> > > >  # nft add table ip filter
> > > >  # nft add set ip filter myset { type ipv4_addr\; flags interval\; }
> > > >  # nft add chain ip filter output { type filter hook output priority 0\; }
> > > >  # nft add rule ip daddr @myset counter packets 0 bytes 0
> > > >  # nft add element ip filter myset { 127.0.0.0/16 }
> > > > 
> > > > Then, if you add an overlapping element:
> > > > 
> > > >  # nft add element ip filter myset { 127.0.0.0/24 }
> > > >  <cmdline>:1:31-42: Error: interval overlaps with an existing one
> > > >  add element ip filter myset { 127.0.0.0/24 }
> > > >                                ^^^^^^^^^^^^
> > > > 
> > > > The new validation code from userspace rejects this to avoid shadowing
> > > > issues.
> > > 
> > > This is actually intended. There is no issue with shadowing since sets only
> > > contain one statement, present or not present.
> > 
> > There is issue, eg:
> > 
> > # nft add element ip x myset { 1.1.1.0/24 }
> > # nft add element ip x myset { 1.1.1.1 }
> > # nft list ruleset
> > table ip x {
> >         set myset {
> >                 type ipv4_addr
> >                 flags interval
> >                 elements = { 1.1.1.0, 1.1.1.1}
> >         }
> >         ...
> > }
> > 
> > If we don't reject the above by now, the listing back to userspace is
> > not consistent. This is not trivial to resolve since the
> > representation in the kernel (rbtree) are individual nodes. For the
> > example above we get a representation like:
> > 
> > { 0.0.0.0/end, 1.1.1.0, 1.1.1.1, 1.1.1.2/end, 1.1.1.255/end }
> > 
> > This is hard to reconstruct from userspace given that intervals are
> > not easy to identify anymore after this situation.
> 
> Yes, the 1.1.1.2/end is also incorrect, which is what messes up the
> reconstruction.

It is not only this, if you add this:

192.168.0.100-192.168.0.200

and then later on:

192.168.100.0/24

You get:

{ 0.0.0.0/end, 192.168.0.0, 192.168.0.100, 192.168.0.201/end, 192.168.1.0/end }

and the interval reconstruction back on the listing becomes inconsistent.

On top of that, deletion breaks this even further since the user would
use what nft reconstructs from those overlapping interval (which is
not what explicit inserted). Then, trying to delete element from what
we get back via listing makes this even worse as we end up leaving the
set in more inconsistent state and triggering bogus mismatches.

> For sets its quite easy. If we insert something that is completely overlapped,
> there's nothing to do anyways. We simply do nothing. If we insert somsething
> that extends an interval in one of both directions, we adjust it appropriately.

As I said, this adjustment can be done from userspace by deleting the
previous interval and by adding the new one in the same batch.

> We already do exactly this when adding multiple elements to a set in a single
> step:
> 
> # nft --debug=segtree,netlink filter output ip saddr { 192.168.1.0/24, 192.168.1.100 } counter

Just a side note to be clear: I'm not modifying the behaviour for
anonymous sets in my patches.

> __set%d filter 7
> insert: [c0a80100 c0a801ff]
> insert: [c0a80164 c0a80164]
> split [c0a80100 c0a801ff]
> iter: [c0a80100 c0a80163]
> iter: [c0a80164 c0a80164]
> iter: [c0a80165 c0a801ff]
> list: [00000000 c0a800ff]
> list: [c0a80100 c0a801ff]
> list: [c0a80200 ffffffff]
> 
> __set%d filter 0
> 	element 00000000  : 1 [end]	element 0001a8c0  : 0 [end]	element 0002a8c0  : 1 [end]
> 
> Simply keeping track of the seqtree changes and applying those to the kernel
> should handle this fine.

Assuming the shadowed interval is in the kernel, we can delete it and
add the new one in the same go from the batch.

Assuming the new interval is shadowed by what we have in the kernel,
we can just send no update.

> > > For maps something like this does make sense, but for sets it only
> > > makes it harder to use.
> > > 
> > > Generally, we have a conflict resolution based on size, the more specific
> > > element wins. The assumption being that if you add something generic and
> > > something more specific, the more specific item is an exception to the
> > > more generic one.
> > 
> > Conflicts can be resolved through merges from userspace at some point.
> > Basically the idea is that, when maps are not in place, the smaller
> > interval will get removed and the new larger one is added in the same
> > batch, so this happens in the same go. nft can deal with these
> > overlaps so this is easier to users.
> 
> The conflict resolution policy needs to be discussed. As I explained, we
> already do this, but use a different policy (try adding a map with
> two overlapping ranges). This of course so far only applies when the
> overlapping elements are added in a single step, so using a different
> policy for successive additions might make sense, however its something
> I'd like to discuss first.
>
> > This requires a bit more work on the caching side, but I would like to
> > provide a more conservative solution by now by rejecting overlaps.
> 
> I fully agree for maps for now, but for sets it seems rather simple to do
> a proper adjustment. I can give it a try if you want.

Frankly, I don't see any reason not to push this update.

You can follow up with an incremental update if you want, but I would
like to see this is working in the next release. The current approach
is conservative in the sense that it rejects what can take us to
problems, we can enhance this by making nft smarter in the sense of
allowing this automatic adjustments.

Moreover, note that the rejection of overlapping intervals is
consistent with what we have with the other hashtable set.

# nft add element x y { 1.1.1.1 }
# nft add element x y { 1.1.1.1 }
Error: Element already exists

We can probably introduce a similar behaviour to what we have with
tables, something like:

# nft create element x y { 1.1.1.1 }
# nft create element x y { 1.1.1.1 }
Error: element already exists

Then change the current behaviour to ignore readding of existing
elements:

# nft add element x y { 1.1.1.1 }
# nft add element x y { 1.1.1.1 }

So feel free to follow up on this after my patchset. We'll soon have
tests for this so any improvement will be covered by them.
