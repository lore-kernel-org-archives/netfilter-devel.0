From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 0/4] Interval overlap detection for named sets
Date: Mon, 25 Apr 2016 13:57:21 +0200
Message-ID: <20160425115721.GB1043@salvia>
References: <1461427720-4939-1-git-send-email-pablo@netfilter.org>
 <20160425103832.GC29560@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51780 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbcDYL75 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 07:59:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7D6FF11481D
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2016 13:59:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 659809D11F
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2016 13:59:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 17D089D11F
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2016 13:59:53 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160425103832.GC29560@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 25, 2016 at 11:38:32AM +0100, Patrick McHardy wrote:
> On 23.04, Pablo Neira Ayuso wrote:
> > Hi,
> > 
> > This patchset adds the missing code to reject overlapping intervals.
> > 
> >  # nft add table ip filter
> >  # nft add set ip filter myset { type ipv4_addr\; flags interval\; }
> >  # nft add chain ip filter output { type filter hook output priority 0\; }
> >  # nft add rule ip daddr @myset counter packets 0 bytes 0
> >  # nft add element ip filter myset { 127.0.0.0/16 }
> > 
> > Then, if you add an overlapping element:
> > 
> >  # nft add element ip filter myset { 127.0.0.0/24 }
> >  <cmdline>:1:31-42: Error: interval overlaps with an existing one
> >  add element ip filter myset { 127.0.0.0/24 }
> >                                ^^^^^^^^^^^^
> > 
> > The new validation code from userspace rejects this to avoid shadowing
> > issues.
> 
> This is actually intended. There is no issue with shadowing since sets only
> contain one statement, present or not present.

There is issue, eg:

# nft add element ip x myset { 1.1.1.0/24 }
# nft add element ip x myset { 1.1.1.1 }
# nft list ruleset
table ip x {
        set myset {
                type ipv4_addr
                flags interval
                elements = { 1.1.1.0, 1.1.1.1}
        }
        ...
}

If we don't reject the above by now, the listing back to userspace is
not consistent. This is not trivial to resolve since the
representation in the kernel (rbtree) are individual nodes. For the
example above we get a representation like:

{ 0.0.0.0/end, 1.1.1.0, 1.1.1.1, 1.1.1.2/end, 1.1.1.255/end }

This is hard to reconstruct from userspace given that intervals are
not easy to identify anymore after this situation.

> For maps something like this does make sense, but for sets it only
> makes it harder to use.
> 
> Generally, we have a conflict resolution based on size, the more specific
> element wins. The assumption being that if you add something generic and
> something more specific, the more specific item is an exception to the
> more generic one.

Conflicts can be resolved through merges from userspace at some point.
Basically the idea is that, when maps are not in place, the smaller
interval will get removed and the new larger one is added in the same
batch, so this happens in the same go. nft can deal with these
overlaps so this is easier to users.

This requires a bit more work on the caching side, but I would like to
provide a more conservative solution by now by rejecting overlaps.
