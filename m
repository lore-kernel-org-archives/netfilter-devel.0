From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2] netfilter: nft_hash: bug fixes and resizing
Date: Fri, 28 Feb 2014 14:35:43 +0000
Message-ID: <20140228143542.GA6813@macbook.localnet>
References: <1393595283-7036-1-git-send-email-kaber@trash.net>
 <1393595283-7036-2-git-send-email-kaber@trash.net>
 <1393597454.26794.62.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	josh@joshtriplett.org, paulmck@linux.vnet.ibm.com
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34968 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbaB1Ofr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Feb 2014 09:35:47 -0500
Content-Disposition: inline
In-Reply-To: <1393597454.26794.62.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 28, 2014 at 06:24:14AM -0800, Eric Dumazet wrote:
> On Fri, 2014-02-28 at 13:48 +0000, Patrick McHardy wrote:
> 
> > +
> > +static struct nft_hash_table *nft_hash_tbl_alloc(unsigned int nbuckets)
> > +{
> > +	struct nft_hash_table *tbl;
> > +	size_t size;
> > +
> > +	size = sizeof(*tbl) + nbuckets * sizeof(tbl->buckets[0]);
> > +	tbl = kzalloc(size, GFP_KERNEL);
> > +	if (tbl == NULL)
> > +		tbl = vzalloc(size);
> 
> There is no limit on nbuckets ?

I'm not sure whether we want a limit. The promise is to deliver O(1)
lookup performance. If the user adds millions of elements, this will
require a bit of memory. The hash might also not be the best set
implementation in that case, the (upcoming) array mapped trie will
do a lot better if it can be used.

> You might consider using __GFP_REPEAT | __GFP_NOWARN

Thanks, I'll change it.
