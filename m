From: Luca Landi <l.landi@gif.it>
Subject: Re: Bug with conntracks created arbitrarily through netlink
Date: Thu, 25 Sep 2008 10:56:38 +0200
Message-ID: <1222332998.6891.7.camel@quasar>
References: <1222278224.8300.87.camel@quasar>  <48DA8055.8070501@trash.net>
	 <1222287997.6546.22.camel@quasar>  <48DAA600.4010802@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpauth.interhost.it ([194.242.61.185]:57337 "EHLO
	smtpauth.interhost.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbYIYI4l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2008 04:56:41 -0400
In-Reply-To: <48DAA600.4010802@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Il giorno mer, 24/09/2008 alle 22.41 +0200, Patrick McHardy ha scritto: 
> Don't remove netfilter-devel from the CC list please.

Sorry, I hit "reply to sender" instead of "reply to all"

> > However, my point is that in case of a manually created conntrack we
> > could avoid enabling the be-liberal logic, because the subsystem _will_
> > see the true first packet of the tracked connection eventually (the SYN
> > in case of a tcp stream, but conceptually speaking the equivalent should
> > apply to any proto), and thus should be able to set up proper tracking.
> > Am I wrong?
> 
> No, thats correct. However the structure of the code doesn't allow
> to do that easily since the ->new function is only called when
> initializing a new conntrack at runtime. It might be possible to
> move invocation up to resolve_normal_ct and make it dependant on
> the connection state, 

Yes, I've done precisely that. Split init_conntrack in two separate
functions: create_conntrack and setup_conntrack. Where was
init_conntrack now lies create_conntrack which only does alloc and
insertion into the unconfirmed hash table. Immediately below that there
already was the connection's status tracking, and in the IP_CT_NEW case
is just where I added the call to setup_conntrack, which does all the
rest that was previously (before my modify) done by init_conntrack (with
relationship and helper setup wrapped around an "already set up" check
in order not to override nor duplicate what netlink could have done
already).

Yesterday before writing to you I tested it for 1 hour in production on
a box which deals with hundreds new connections per second, thousands
established connections at any given moment (it's a smtp proxy). It
worked seamlessly. That box never deals with related conns though, nor
helpers, so I could not test those cases. Also, I had to leave office
and not felt confident enough to leave everything unattended. I'll put
it back in production when I'll be present on-site for one full day
long.

> it mainly depends on whether the other
> functions called during initialization need that state from ->new.
> They should not I think, but I haven't checked.

With the code setup said above, the resulting run-path for a new
conntrack created automatically acts like before, as if everything was
still in the same block of code, with the only addition of the
conntrack's status bits checks-and-sets now in between. Those
checks-and-sets do not seem to need any state from ->new (nor from
relation and helper setup).

Admittedly one drawback is that this code setup does not make it very
clear that you must not put anything that needs state from ->new and
friends in the run-path between create_conntrack and setup_conntrack.

> Then you could also
> invoke it based on some other condition controlable through ctnetlink.

Naturally you could. If it was my choice though I'd go for a solution
which makes it simpler for userspace, and let daddy kernel take care of
the dirtiest work. At least as a default behavior.


