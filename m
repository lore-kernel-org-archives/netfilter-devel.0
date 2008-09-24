From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bug with conntracks created arbitrarily through netlink
Date: Wed, 24 Sep 2008 22:41:36 +0200
Message-ID: <48DAA600.4010802@trash.net>
References: <1222278224.8300.87.camel@quasar>  <48DA8055.8070501@trash.net> <1222287997.6546.22.camel@quasar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Luca Landi <l.landi@gif.it>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47803 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbYIXUlk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:41:40 -0400
In-Reply-To: <1222287997.6546.22.camel@quasar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Don't remove netfilter-devel from the CC list please.

Luca Landi wrote:
> Il giorno mer, 24/09/2008 alle 20.00 +0200, Patrick McHardy ha scritto:
> 
>> We're automatically enabling the be-liberal logic for picked up
>> connections nowadays,
> 
> Currently (as of 2.6.26.5) as well as on the ubuntu's kernel that's done
> only by tcp_new(), not by tcp_in_window()

Indeed. You're able to specify that flag from userspace though.

> However, my point is that in case of a manually created conntrack we
> could avoid enabling the be-liberal logic, because the subsystem _will_
> see the true first packet of the tracked connection eventually (the SYN
> in case of a tcp stream, but conceptually speaking the equivalent should
> apply to any proto), and thus should be able to set up proper tracking.
> Am I wrong?

No, thats correct. However the structure of the code doesn't allow
to do that easily since the ->new function is only called when
initializing a new conntrack at runtime. It might be possible to
move invocation up to resolve_normal_ct and make it dependant on
the connection state, it mainly depends on whether the other
functions called during initialization need that state from ->new.
They should not I think, but I haven't checked. Then you could also
invoke it based on some other condition controlable through ctnetlink.
