From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 1/4] monitor: Fix printing of range elements in named
 sets
Date: Mon, 17 Jul 2017 19:02:57 +0200
Message-ID: <20170717170257.GS16375@orbyte.nwl.cc>
References: <20170712123658.25363-1-phil@nwl.cc>
 <20170712123658.25363-2-phil@nwl.cc>
 <CAOkSjBhX1=DJuY9M8P0axCQkMyjZyweea9tROnGSHM=WqRq47A@mail.gmail.com>
 <20170712190545.GC16375@orbyte.nwl.cc>
 <20170713182202.GK16375@orbyte.nwl.cc>
 <20170717161234.GA32725@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:55375 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751293AbdGQRC7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 13:02:59 -0400
Content-Disposition: inline
In-Reply-To: <20170717161234.GA32725@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 17, 2017 at 06:12:34PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jul 13, 2017 at 08:22:02PM +0200, Phil Sutter wrote:
> > Just a quick status update: It's a mess. ;)
> 
> OK, let's address problems one by one.
> 
> > There are so many different cases, I actually started drawing flow
> > diagrams (can't remember when I did that last time). In addition to what
> > we discussed already, I realized that via 'nft -f', I can make multiple
> > changes to even different sets within a single transaction - this
> > requires dealing with cached half-open ranges everywhere, not just in
> > NEWGEN callback.
> 
> half-open ranges always start by a NFT_SET_ELEM_INTERVAL_END flag set
> on, eg.

No, they don't. See the end of segtree_linearize() src/segtree.c in
nftables code: EI_F_INTERVAL_END is set for intervals which don't match,
so if the matching interval extends to the end, no element with that
flag set will be inserted.

> # nft --debug=netlink add element x y { 5-65535 }
> element 00000000  : 1 [end]     element 00000500  : 0 [end]

Here, the first element is the "null" element indicating a non-matching
segment from 0 to 4, the second one marks a matching segment from 5 till
the end. That '[end]' marker is printed unconditionally for all
elements.

> > Another trap is 'nft flush set': The elements are reported in
> > reverse order.
> 
> Could you have a look at the function to order elements using the
> mergesort function? It's currently only called for non-intervals by
> now, so it would be good to converge to use it in all cases.

You mean the call to list_expr_sort() in netlink_get_setelems()? It is
not called because interval_map_decompose() (which is called later in
the same function does it's own sorting.

Cheers, Phil
