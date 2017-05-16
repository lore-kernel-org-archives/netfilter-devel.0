From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 04/10] tests: fix up meta l4proto change for ip6
 family
Date: Tue, 16 May 2017 12:52:21 +0200
Message-ID: <20170516105221.GD16290@breakpoint.cc>
References: <20170509155122.26356-1-fw@strlen.de>
 <20170509155122.26356-5-fw@strlen.de>
 <20170516102225.GA19858@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41560 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752296AbdEPKxA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2017 06:53:00 -0400
Content-Disposition: inline
In-Reply-To: <20170516102225.GA19858@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, May 09, 2017 at 05:51:16PM +0200, Florian Westphal wrote:
> > After previous commit nft generates meta l4proto for ipv6 dependencies
> > instead of checking the (first) nexthdr value.
> > 
> > This fixes up all tests cases accordingly except one which fails with
> > 
> > ip6/reject.t: ... 12: 'ip6 nexthdr 6 reject with tcp reset' mismatches 'meta l4proto 6 reject with tcp reset'
> > This will be fixed by removing the implicit dependency in a followup patch.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>

[..]
> >  # icmpv6 type echo-request
> >  bridge test-bridge input
> > -  [ payload load 2b @ link header + 12 => reg 1 ]
> > -  [ cmp eq reg 1 0x0000dd86 ]
> > -  [ payload load 1b @ network header + 6 => reg 1 ]
> > +  [ meta load l4proto => reg 1 ]
> >    [ cmp eq reg 1 0x0000003a ]
> >    [ payload load 1b @ transport header + 0 => reg 1 ]
> >    [ cmp eq reg 1 0x00000080 ]
> 
> I think this is not correct.
> 
> Before this patch, we restricted this to match on IPv6 traffic.

Right.

> Now, we can match an IPv4 packet carrying an ICMPv6 protocol, this is
> obviously handcrafted (incorrect) packet, but this rule would match.

Yes.  I am not sure what the correct or desired behaviour is.

Simply speaking we're asked to check if transport protocol is 58, and
thats what this does.

If you prefer special-casing this I can look into it, probably
best thing is to inject 'meta nfproto ip6' test.

What would you expect in these cases (note, ip family):

a) add rule filter input meta l4proto icmpv6
b) add rule filter input meta l4proto icmpv6 icmpv6 type echo-request
c) add rule filter input icmpv6 type echo-request

with master only a) is accepted.
With patch #1 of the series, b) is also accepted.

> So I think the implicit check for IPv6 via ethertype should still
> remain there, right?

Maybe, I am not sure.

> What patch are these test updates related to? Is it 1/10?

2 and 3 (mainly 2, patch 3 gets rid of useless extra dependency,
so fixing this up after 2 means I need another fixup patch after 3).

If you prefer that I can do this, no problem.
