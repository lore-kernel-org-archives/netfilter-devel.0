From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nfnetlink and conntrack extension question
Date: Wed, 30 Nov 2011 19:22:09 +0100
Message-ID: <20111130182209.GB20336@1984>
References: <1322668453.4443.24.camel@nessa.odu>
 <alpine.LNX.2.01.1111301756450.9557@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: KOVACS Krisztian <hidden@balabit.hu>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47469 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab1K3SWR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Nov 2011 13:22:17 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1111301756450.9557@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 30, 2011 at 06:05:13PM +0100, Jan Engelhardt wrote:
> 
> On Wednesday 2011-11-30 16:54, KOVACS Krisztian wrote:
> >
> >There are two things remaining that prevent us doing simple out-of-tree
> >kernel module builds:
> >
> >     1. We use nfnetlink for the userspace->kernelspace communication.
> >        This works beautifully, however, since NFNL_SUBSYS_COUNT is a
> >        compile-time constant there's no way of registering a subsystem
> >        with an ID not known at compile time.
> 
> You can't even snatch a number because the arrays are just sized
> __foobar_max-ly, and those may all be used.
> 
> >My question is whether or not removing those limitations and allowing
> >runtime registration of both nfnetlink subsystems and conntrack
> >extensions would be acceptable upstream? That way out-of-tree modules
> >could possibly use those features without having to resort to patching
> >and recompiling the kernel.
> 
> As for 1, you can use genetlink, just as I do for the copy of ipset
> in xtables-addons. Being forced to use nfnetlink has been point of
> much discussion and ultimately, nobody was able to provide a
> technical reason on why nfnetlink is better.

Well, few differences. With genetlink:

* you have to send a message to look up for the ID first (to guess the
  multicast group and subsystem IDs).

* you don't know how many users will using the genetlink bus. You'll
  have to share the bandwidth with them.

And to finish, for netfilter, the policy is to use the NETLINK_NEFILTER
bus which is where *all* netfilter subsystem reside.

genetlink is a bit more bloated than nfnetlink IMO.

I like the idea that you cannot register out-of-tree modules using
nfnetlink. I like things in mainstream (or look for some alternative
to get them it).

> The last argument made by nfnl proponents was that NETLINK_NETFILTER
> was free of multicast messages from other uninteresting subsystems
> (e.g. block layer), but I am questioning on whether genl really
> forces you to receive (and then ignore) uninteresting mcast messages,
> given one has to explicitly subscribe to nlgroups in the first place
> anyway.

No, if you subscribe to mcast messages that you're interested, you
won't get messages for other multicast groups.
