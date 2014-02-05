From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_tables: fix racy rule deletion
Date: Wed, 5 Feb 2014 16:48:42 +0000
Message-ID: <20140205164842.GA32405@macbook.localnet>
References: <1390655031-4115-1-git-send-email-pablo@netfilter.org>
 <20140205154843.GA31493@macbook.localnet>
 <20140205163806.GA4575@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58296 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbaBEQsq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 11:48:46 -0500
Content-Disposition: inline
In-Reply-To: <20140205163806.GA4575@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 05, 2014 at 05:38:06PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Feb 05, 2014 at 03:48:46PM +0000, Patrick McHardy wrote:
> > On Sat, Jan 25, 2014 at 02:03:51PM +0100, Pablo Neira Ayuso wrote:
> > > As a side effect, we save memory as we don't need rcu_head per rule
> > > anymore.
> > 
> > We can also save some memory for now unnecessary families in the private
> > structs since we have the context available during destruction again.
> 
> Right, that was only needed with when we were using call_rcu. I'll
> revisit that.

I already have a patch which does this for expressions which can now
use pkt->hook_ops->pf queued. Since its quite similar, I'll just add
it to my patch once your patch is in the tree.

> > I have to admit this all seems slightly confusing to me, we now have three
> > synhronize_rcu()s in this function, are all those really needed?
> 
> There are only two to separate the different stages. To my
> understanding, the first one ensures that all packets has left the
> previous generation before we start purging out old rules. Then, the
> second one makes sure that no packets are still checking the old rule
> genmask that have just been deleted, so we can safely release it.
> 
> Before this patch, we only needed one since we were using call_rcu
> after deleting the rules from the list.

I'll have another look now, thanks.
