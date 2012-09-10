From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix out-of-bounds access in nat addr
 selection
Date: Mon, 10 Sep 2012 11:14:57 +0200
Message-ID: <20120910091457.GA5484@1984>
References: <1346875828-14054-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39196 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab2IJJPA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:15:00 -0400
Content-Disposition: inline
In-Reply-To: <1346875828-14054-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 05, 2012 at 10:10:28PM +0200, Florian Westphal wrote:
> include/linux/jhash.h:138:16: warning: array subscript is above array bounds
> [jhash2() expects the number of u32 in the key]

Applied to -next, thanks Florian.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> Only affects -next.
> note that I also get same warning for hash_by_src(); but
> hash = jhash2((u32 *)&tuple->src, sizeof(tuple->src) / sizeof(u32),
> 	      tuple->dst.protonum ^ zone ^ nf_conntrack_hash_rnd);
> looks correct to me.

It also seems correct to me, that tuple->src is 5*4 bytes long.

I'm not hitting any warning with gcc-4.7 though.
