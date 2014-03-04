From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] parser: support reject unreach|reset
Date: Tue, 4 Mar 2014 09:01:32 +0000
Message-ID: <20140304090132.GD5094@macbook.localnet>
References: <1393881146-12967-1-git-send-email-fw@strlen.de>
 <1393882892.19488.14.camel@ice-age2.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38180 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523AbaCDJBf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:01:35 -0500
Content-Disposition: inline
In-Reply-To: <1393882892.19488.14.camel@ice-age2.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 03, 2014 at 10:41:32PM +0100, Eric Leblond wrote:
> Hello,
> 
> On Mon, 2014-03-03 at 22:12 +0100, Florian Westphal wrote:
> > reject did not allow to use tcp reset instead of icmp unreach.
> 
> I'm currently working on a patchset to support this and also setting the
> ICMP code. But I'm fighting on the ICMP code filtering.
> 
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  After this patch its possibe to do something like
> > 
> >  rule filter output reject reset
> 
> I found syntax a bit short ;) If we add ICMP code support
> and follow the logic:
> 
> rule filter output reject administratively-prohibited
> 
> My plan was to do something like:
> 
> rule filter output reject with tcp reset
> rule filter output reject with icmp|code administratively-prohibited

I really prefer a less bloated syntax. For TCP reset simply stating:

filter output tcp dport 22 reset

is both understandable and contains all necessary information. For ICMP
types I guess we could live with the "with" keyword, although I prefer

filter output reject [ network-unreachable | ... ]

or something like that.

> >  Which makes kernel generate bogus tcp resets in repsonse
> >  to non-tcp packets.
> > 
> >  In iptables this is avoided by making checkentry fail if -p tcp is not
> >  specified when tcp-reset is requested.
> >
> >  How should this be handled in nft?
> 
> Good point. It looks a bit like what Patrick did mention in "Re:
> [nftables RFC PATCH 0/1] implementing icmp code filterin"
> 
> "We do something similar in ct_expr_update_type() for ct expressions."
> 
> Idea is to update the entry and in this case to output an error if we
> don't have tcp. But I'm not sure we can access to the other expressions
> (and henve to the TCP or not info) in that point.

This is actually easier than the ICMP case, the protocol context contains
all necessary information. Unlike iptables we execute statements at the
point where they occur in the rule, so the user is expected to use some
logical ordering in his statements:

"tcp dport ssh reset" instead of "reset tcp dport ssh".

Meaning we have the full protocol context available.
