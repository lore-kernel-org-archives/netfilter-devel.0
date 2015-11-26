From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH -next] netfilter: nf_ct_sctp: validate vtag for new
 conntrack entries
Date: Thu, 26 Nov 2015 16:54:26 +0100
Message-ID: <20151126155426.GA4108@salvia>
References: <20151125194234.GA12460@salvia>
 <5656181E.2010001@gmail.com>
 <20151125205830.GC1254@unicorn.suse.cz>
 <20151126095133.GA1612@salvia>
 <20151126141552.GH16828@macbook.localdomain>
 <20151126143328.GC32716@breakpoint.cc>
 <20151126144916.GJ16828@macbook.localdomain>
 <20151126150726.GD32716@breakpoint.cc>
 <20151126151229.GA3412@salvia>
 <20151126152410.GN16828@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Michal Kubecek <mkubecek@suse.cz>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35242 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbbKZPyf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 10:54:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BA43F129260
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2015 16:54:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A9F5DDA862
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2015 16:54:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C0B02DA807
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2015 16:54:31 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151126152410.GN16828@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 26, 2015 at 03:24:11PM +0000, Patrick McHardy wrote:
> Consider:
> 
> -i eth0 -j CT --track
> -i eth0 -p sctp --dport 1234 -j ACCEPT
> -i eth0 -m state --state ESTABLISHED -j ACCEPT
> 
> The explicit tracking rule *still* has no knowledge that the SCTP module
> is required. Depending on how the rule is built, there's no difference to
> automatic tracking since it might simply be a catch all rule.
> 
> Sure, you could require users to enable it manually for each and every
> protocol, but I expect we agree that this is not a very nice way.
> 
> What we have to do is:
> 
> *If* we're using stateful tracking, *and* it is possible that connection
> state is based on a user selected connection identity (by using the protocol
> specific matches), then we have to enable connection tracking for that
> protocol to make sure we don't mix up connections with different identities.

There are OSPF routers in active-active HA setups outthere that still
need to rely on stateless filtering. Think of asymmetric paths.
Conntrack needs to see packets in both directions.

IMO we should skip enabling things by default. When we enable things
by default someone else follow up later on with some scenario we
didn't consider and then we've got problems. I think we should go in
the direction of explicit configurations, we already do this for
conntrack helpers.
