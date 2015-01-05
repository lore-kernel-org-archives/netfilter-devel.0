From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 2/3] netfilter: nfnetlink: relax strict multicast
 group from netlink_bind
Date: Mon, 5 Jan 2015 12:41:51 +0100
Message-ID: <20150105114151.GA15191@salvia>
References: <1420455986-5800-1-git-send-email-pablo@netfilter.org>
 <1420455986-5800-2-git-send-email-pablo@netfilter.org>
 <20150105112234.GA5741@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58609 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbbAELjH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:39:07 -0500
Content-Disposition: inline
In-Reply-To: <20150105112234.GA5741@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 05, 2015 at 11:22:35AM +0000, Patrick McHardy wrote:
> On 05.01, Pablo Neira Ayuso wrote:
> > Relax the checking that was introduced in 97840cb ("netfilter:
> > nfnetlink: fix insufficient validation in nfnetlink_bind") when the
> > subscription bitmask is used. Existing userspace code code may request
> > to listen to all of the existing netlink groups by setting an all to one
> > subscription group bitmask. Netlink already validates subscription via
> > setsockopt() for us.
> 
> What is the point of doing this? I don't think its particulary
> reasonable to subscribe to ~0 unless you're implementing some kind of
> monitor.

This is how we've been supporting this since the beginning. So
userspace applications could subscribe to ~0 and don't care if the
group exists or not.

After the recent change, those will break. None of the userspace
netfilter codebase actually need this, but other third party
application will break when binding if they were using ~0 for
monitoring.

> We also don't know whether a bitmask or an invalid group number was
> used, so the comment below is at least misleading.
> 
> And, unrelated, but since it went in via netfilter asking anyway, why
> is the group number signed? That doesn't make any sense, it is treated
> as unsigned everywhere else.

That should be changed, yes.

> > diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> > index c6619d4..5082d81 100644
> > --- a/net/netfilter/nfnetlink.c
> > +++ b/net/netfilter/nfnetlink.c
> > @@ -469,8 +469,11 @@ static int nfnetlink_bind(int group)
> >  	const struct nfnetlink_subsystem *ss;
> >  	int type;
> >  
> > +	/* No strict check for groups when subscription bitmask is used, group
> > +	 * binding via setsockopt() already rejects this from netlink.
> > +	 */
> >  	if (group <= NFNLGRP_NONE || group > NFNLGRP_MAX)
> > -		return -EINVAL;
> > +		return 0;
> >  
> >  	type = nfnl_group2type[group];
> >  
> > -- 
> > 1.7.10.4
> > 
