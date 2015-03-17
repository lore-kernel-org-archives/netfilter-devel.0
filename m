From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 2/3] parser: allow to reorder chain options
Date: Tue, 17 Mar 2015 12:42:31 +0000
Message-ID: <20150317124230.GN21401@acer.localdomain>
References: <1426594385-24063-1-git-send-email-pablo@netfilter.org>
 <1426594385-24063-2-git-send-email-pablo@netfilter.org>
 <20150317121514.GM21401@acer.localdomain>
 <20150317122932.GA16527@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41684 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbbCQMmf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2015 08:42:35 -0400
Content-Disposition: inline
In-Reply-To: <20150317122932.GA16527@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17.03, Pablo Neira Ayuso wrote:
> On Tue, Mar 17, 2015 at 12:15:14PM +0000, Patrick McHardy wrote:
> > On 17.03, Pablo Neira Ayuso wrote:
> > > This allows all possible combinations to work:
> > > 
> > >  nft add chain filter input { type filter hook input priority 0 \; }
> > >  nft add chain filter input { priority 0 type filter hook input \; }
> > 
> > 
> > I don't object to being able to change the order of type and hook,
> > but priority logically belongs to the hook keyword, why change this?
> 
> When displaying the chain configuration, this shows in order.
> 
> But we're humans and I don't see a good reason why we should force
> humans to order things in some specific way.

I can see multiple reasons.

First one is, it logically belongs together since the priority is a
property of the hook, similar to that "prefix" belongs to "log" and
"rate" belongs to limit. We (I presume) agree that
"log rate limit 1/sec prefix bla" isn't something we want to support.
In fact this is just the mess that we had in iptables and which
created a lot of problems in the parser.

Which brings us to the second point, having a strict grammar makes
it easier to avoid conflicts in the grammar. I don't suppose we
will ever need a priority which is a property of the type, but
with this patch, it would be impossible.

Next is the confusion created by a loose grammar. If you consider
iproute2, if things don't work people start to google, they find
an example where a different, but equivalent keyword is used,
they get even more confused and start wasting their time be
reordering things or replacing keywords with equivalent ones.

And I simply don't see what we gain by doing this. In fact I don't
even buy that "human" argument, I think its easier to remember
a single well defined case than this exception, which is in fact
also an exception to what we do anywhere else in nftables.

My personal opinion is actually that type and hook should use a
stmt_seperator since they are two seperate things.
