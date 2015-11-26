From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH -next] netfilter: nf_ct_sctp: validate vtag for new
 conntrack entries
Date: Thu, 26 Nov 2015 16:02:27 +0000
Message-ID: <20151126160227.GQ16828@macbook.localdomain>
References: <5656181E.2010001@gmail.com>
 <20151125205830.GC1254@unicorn.suse.cz>
 <20151126095133.GA1612@salvia>
 <20151126141552.GH16828@macbook.localdomain>
 <20151126143328.GC32716@breakpoint.cc>
 <20151126144916.GJ16828@macbook.localdomain>
 <20151126150726.GD32716@breakpoint.cc>
 <20151126151229.GA3412@salvia>
 <20151126152410.GN16828@macbook.localdomain>
 <20151126155426.GA4108@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Michal Kubecek <mkubecek@suse.cz>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:36834 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751309AbbKZQCc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 11:02:32 -0500
Content-Disposition: inline
In-Reply-To: <20151126155426.GA4108@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.11, Pablo Neira Ayuso wrote:
> On Thu, Nov 26, 2015 at 03:24:11PM +0000, Patrick McHardy wrote:
> > Consider:
> > 
> > -i eth0 -j CT --track
> > -i eth0 -p sctp --dport 1234 -j ACCEPT
> > -i eth0 -m state --state ESTABLISHED -j ACCEPT
> > 
> > The explicit tracking rule *still* has no knowledge that the SCTP module
> > is required. Depending on how the rule is built, there's no difference to
> > automatic tracking since it might simply be a catch all rule.
> > 
> > Sure, you could require users to enable it manually for each and every
> > protocol, but I expect we agree that this is not a very nice way.
> > 
> > What we have to do is:
> > 
> > *If* we're using stateful tracking, *and* it is possible that connection
> > state is based on a user selected connection identity (by using the protocol
> > specific matches), then we have to enable connection tracking for that
> > protocol to make sure we don't mix up connections with different identities.
> 
> There are OSPF routers in active-active HA setups outthere that still
> need to rely on stateless filtering. Think of asymmetric paths.
> Conntrack needs to see packets in both directions.

Sure. I'm saying *if* we're using stateful filtering. I don't intend to
force it upon anyone.

> IMO we should skip enabling things by default. When we enable things
> by default someone else follow up later on with some scenario we
> didn't consider and then we've got problems. I think we should go in
> the direction of explicit configurations, we already do this for
> conntrack helpers.

Well as I already said, it doesn't solve anything regarding this problem,
so how is it relevant?
