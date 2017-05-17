From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 04/10] tests: fix up meta l4proto change for ip6
 family
Date: Wed, 17 May 2017 20:36:53 +0200
Message-ID: <20170517183653.GC26089@breakpoint.cc>
References: <20170509155122.26356-1-fw@strlen.de>
 <20170509155122.26356-5-fw@strlen.de>
 <20170516102225.GA19858@salvia>
 <20170516105221.GD16290@breakpoint.cc>
 <20170517181345.GA23132@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49512 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751566AbdEQShd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 May 2017 14:37:33 -0400
Content-Disposition: inline
In-Reply-To: <20170517181345.GA23132@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > What would you expect in these cases (note, ip family):
> > 
> > a) add rule filter input meta l4proto icmpv6
> > b) add rule filter input meta l4proto icmpv6 icmpv6 type echo-request
> > c) add rule filter input icmpv6 type echo-request
> >
> > with master only a) is accepted.
> > With patch #1 of the series, b) is also accepted.
> 
> b) and c) are equivalent. Since c) should generate both the meta
> protocol and the meta l4proto dependency.

Hmm.  I suspect you mean c) should be rejected?
(ip family!), so user would have to specify

> Then, we should allow this too:
> 
>         meta protocol ip meta l4proto icmpv6

Explicitly to indicate ip->protocol == 58 is asked for.

> so we can match IPv4 packets that container ICMPv6 packet. I know,
> this is crazy, but we should users to match this. A handcrafted packet
> may look like that.

Yes and yeas.

> I think this logic should be placed somewhere at payload_gen_dependency().

Ok, I will rework this series accordingly, i.e.:

add rule filter input icmpv6 type echo-request

will:
- pull in meta l4proto dependency for ip6 family
- pull in meta l4proto dependency PLUS ipv6 dependency in
inet/bridge/netdev families
- fail with invalid protocol base error in ip family

the last case should work in ip family iff user specifies
the nexthdr value specifically.

Does that seem ok to you?

Thanks,
Florian

