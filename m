From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH -next] netfilter: nf_ct_sctp: validate vtag for new
 conntrack entries
Date: Thu, 26 Nov 2015 15:24:11 +0000
Message-ID: <20151126152410.GN16828@macbook.localdomain>
References: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1448478477.git.marcelo.leitner@gmail.com>
 <20151125194234.GA12460@salvia>
 <5656181E.2010001@gmail.com>
 <20151125205830.GC1254@unicorn.suse.cz>
 <20151126095133.GA1612@salvia>
 <20151126141552.GH16828@macbook.localdomain>
 <20151126143328.GC32716@breakpoint.cc>
 <20151126144916.GJ16828@macbook.localdomain>
 <20151126150726.GD32716@breakpoint.cc>
 <20151126151229.GA3412@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Michal Kubecek <mkubecek@suse.cz>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:36575 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751016AbbKZPYQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 10:24:16 -0500
Content-Disposition: inline
In-Reply-To: <20151126151229.GA3412@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.11, Pablo Neira Ayuso wrote:
> On Thu, Nov 26, 2015 at 04:07:26PM +0100, Florian Westphal wrote:
> > I would prefer to NOT force people to use extra connection tracking code
> > for sctp if they don't need it.
> > 
> > Most distributions will ship with all of this as '=m', but IMHO its safe
> > to assume that most users will in fact not use sctp (but conntrack for
> > udp and tcp).
> 
> Enabling features through modprobe seems not to be a good idea
> anymore, now we've got namespaces.

Good point. In fact I never liked that fact that using a module on the
host automatically makes it available to all namespaces. 
 
> We should probably go back to the idea of explicit conntrack
> configuration through rules that we discussed many times before.

I don't think that would solve the problem.

Consider:

-i eth0 -j CT --track
-i eth0 -p sctp --dport 1234 -j ACCEPT
-i eth0 -m state --state ESTABLISHED -j ACCEPT

The explicit tracking rule *still* has no knowledge that the SCTP module
is required. Depending on how the rule is built, there's no difference to
automatic tracking since it might simply be a catch all rule.

Sure, you could require users to enable it manually for each and every
protocol, but I expect we agree that this is not a very nice way.

What we have to do is:

*If* we're using stateful tracking, *and* it is possible that connection
state is based on a user selected connection identity (by using the protocol
specific matches), then we have to enable connection tracking for that
protocol to make sure we don't mix up connections with different identities.

How we enable it is an entirely different question, but it needs to be done
to fullfil what I think is a reasonable expectation of stateful filtering.
