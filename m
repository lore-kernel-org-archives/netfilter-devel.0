From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ctnetlink: fix refcnt leak in
 dying/unconfirmed list dumper
Date: Mon, 16 Jun 2014 13:12:03 +0200
Message-ID: <20140616111203.GA25217@localhost>
References: <1402220483-10565-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, brouer@redhat.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40429 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbaFPLMK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:12:10 -0400
Content-Disposition: inline
In-Reply-To: <1402220483-10565-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 08, 2014 at 11:41:23AM +0200, Florian Westphal wrote:
> 'last' keeps track of the ct that had its refcnt bumped during previous
> dump cycle.  Thus it must not be overwritten until end-of-function.
> 
> Another (unrelated, theoretical) issue: Don't attempt to bump refcnt of a conntrack
> whose reference count is already 0.  Such conntrack is being destroyed
> right now, its memory is freed once we release the percpu dying spinlock.
> 
> Fixes: b7779d06 ('netfilter: conntrack: spinlock per cpu to protect special lists.')
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  With this patch I do not see any more stale entries on the dying list with eache evictor
>  not being scheduled.  Such 'leaked' entries are easy to spot since their 'use' count
>  is growing, i.e. invoking conntrack -L dying repeatedly yields 'use=$bignum++' output.

Applied, thanks Florian!
