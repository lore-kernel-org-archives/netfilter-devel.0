From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf 2/3] netfilter: nfnetlink: relax strict multicast
 group from netlink_bind
Date: Mon, 5 Jan 2015 11:43:15 +0000
Message-ID: <20150105114314.GA6499@acer.localdomain>
References: <1420455986-5800-1-git-send-email-pablo@netfilter.org>
 <1420455986-5800-2-git-send-email-pablo@netfilter.org>
 <20150105112234.GA5741@acer.localdomain>
 <20150105114151.GA15191@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34095 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbbAELnT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:43:19 -0500
Content-Disposition: inline
In-Reply-To: <20150105114151.GA15191@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05.01, Pablo Neira Ayuso wrote:
> On Mon, Jan 05, 2015 at 11:22:35AM +0000, Patrick McHardy wrote:
> > On 05.01, Pablo Neira Ayuso wrote:
> > > Relax the checking that was introduced in 97840cb ("netfilter:
> > > nfnetlink: fix insufficient validation in nfnetlink_bind") when the
> > > subscription bitmask is used. Existing userspace code code may request
> > > to listen to all of the existing netlink groups by setting an all to one
> > > subscription group bitmask. Netlink already validates subscription via
> > > setsockopt() for us.
> > 
> > What is the point of doing this? I don't think its particulary
> > reasonable to subscribe to ~0 unless you're implementing some kind of
> > monitor.
> 
> This is how we've been supporting this since the beginning. So
> userspace applications could subscribe to ~0 and don't care if the
> group exists or not.
> 
> After the recent change, those will break. None of the userspace
> netfilter codebase actually need this, but other third party
> application will break when binding if they were using ~0 for
> monitoring.
> 
> > We also don't know whether a bitmask or an invalid group number was
> > used, so the comment below is at least misleading.
> > 
> > And, unrelated, but since it went in via netfilter asking anyway, why
> > is the group number signed? That doesn't make any sense, it is treated
> > as unsigned everywhere else.
> 
> That should be changed, yes.

Assuming you mean both the signedness and the comment, that seems fine.
