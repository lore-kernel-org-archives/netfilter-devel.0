From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: UDP packets sent with wrong source address after routing
 change [AV#3431]
Date: Tue, 13 Nov 2012 00:30:24 +0100
Message-ID: <20121112233024.GA15215@1984>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201>
 <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org>
 <20121110140720.GA9610@1984>
 <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu>
 <alpine.DEB.2.02.1211121019280.23195@lap-x201>
 <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu>
 <alpine.DEB.2.02.1211121523190.23195@lap-x201>
 <alpine.DEB.2.00.1211122020280.18729@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Wilson <chris-netfilter-110904@aptivate.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42701 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135Ab2KLXa3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:30:29 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211122020280.18729@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Mon, Nov 12, 2012 at 08:34:26PM +0100, Jozsef Kadlecsik wrote:
> On Mon, 12 Nov 2012, Chris Wilson wrote:
> 
> > I propose that:
> > 
> > * when the packet matches an existing conntrack rule, and
> > 
> > * is sent out of an interface that does not list the packet's new (SNAT-to)
> > source address as one of its IP addresses (i.e. if this were a new
> > connection, MASQUERADE would not choose this source address), and
> > 
> > * the --update-source-address flag is set on the MASQUERADE target
> > 
> > then update the source address on the conntrack rule to the new one.
> > 
> > That's the same thing that would happen if we deleted the conntrack entry
> > first: MASQUERADE would choose a new source address and save it in the new
> > conntrack entry.
> 
> What do you think about this?
> 
> - add route change notification event to the net core
> - add --update-source-address flag to the MASQUERADE target
> - add a call for such events to the MASQUERADE target, when
>   the flag is enabled
> 
> The called function then can scan the conntrack table and for every entry 
> which has got the update-source-address flag, can check whether the source 
> IP address should be changed. Those entries are then deleted.

It seems to me this can be implemented this from user-space. It would
require a new working mode for conntrackd that would:

1) subscribe to route events via rtnl and libmnl.
2) get new interface address for some monitored address, also via rtnl.
3) iterate over the table and remove those entries with outdated IP
address.

All the infrastructure is ready, and it would not require any kernel
upgrade. What do you think about this approach?

Regards.
