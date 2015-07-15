From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next v2 0/6] netfilter: xtables: improve jumpstack
 handling
Date: Wed, 15 Jul 2015 19:17:49 +0200
Message-ID: <20150715171749.GA4707@salvia>
References: <1436889071-3637-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, eric.dumazet@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54497 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbbGORMG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2015 13:12:06 -0400
Content-Disposition: inline
In-Reply-To: <1436889071-3637-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 14, 2015 at 05:51:05PM +0200, Florian Westphal wrote:
> During NFWS 2015 Eric Dumazet suggested various ideas to make
> the xtables table traverser function setup less expensive.
> 
> In particular, the *_do_table functions keep track of the current
> stack pointer.
> 
> It appears that we can simplify this to always start from 0
> (therefore allowing us to avoid the save/restore) provided we make sure
> that we use an alternate jump stack when we enter the traverser recursively
> via TEE target.
> 
> This implements some of Erics ideas.

Series from 1 to 5 applied.

> NOTE1: The last patch may break valid iptables rulesets.
> Its the clasic question wheter we're willing to reject bizarre ruleset
> or not.  If this patch is acceptable, we can avoid one more dereference
> by using percpu allocation for the jumpstack as follow work.

If we take this patch into the tree, I'd wait for quite some time to
make sure nobody barfs to us with problems, so we can revert it.

Otherwise, the (unlikely) scenario would require several reverts in a
row, starting from this to further suggested enhancements, right?
