From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC 2/3] netfilter: add ipv4 reverse path filter match
Date: Tue, 30 Aug 2011 14:41:19 +0200
Message-ID: <20110830124119.GB7548@Chamillionaire.breakpoint.cc>
References: <1314350465-19598-1-git-send-email-fw@strlen.de>
 <1314350465-19598-3-git-send-email-fw@strlen.de>
 <4E5CD8DA.1010204@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:35339 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658Ab1H3MlU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 08:41:20 -0400
Content-Disposition: inline
In-Reply-To: <4E5CD8DA.1010204@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> > main drawback:
> > - additional fib lookup to get oif (used as flow key in reverse lookup)
> 
> As discussed during the workshop, we could just perform input routing
> in the module to get the oif for free. That would require to take care
> of statistics as currently done in ip_rcv_finish() though.

Right.
Any idea on how to solve the 'struct sk_buff *' (ip_route_input) vs.
'const struct sk_buff *' (matches) problem?

We'd have to modify all the match signatures...

> > Other issues:
> > - can't use FORWARD chain because by the time FORWARD is invoked
> >   ipv4 forward path may have already sent icmp messages is response
> >   to to-be-discarded-via-rpfilter packets
> > - using it in PREROUTING may do the wrong thing (e.g. when using
> >   policy routing via mangle PREROUTING)
> 
> Not if you're setting up policy routing keys (marks) before doing
> rp_filter, right? Would require using it in the mangle table of
> course.

Yes that should work as well.
It might be unexpected for some people, though (but this is just a
documentation issue).
