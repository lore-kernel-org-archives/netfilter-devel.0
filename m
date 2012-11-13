From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: UDP packets sent with wrong source address after routing
 change [AV#3431]
Date: Tue, 13 Nov 2012 17:47:59 +0100
Message-ID: <20121113164759.GA21680@1984>
References: <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org>
 <20121110140720.GA9610@1984>
 <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu>
 <alpine.DEB.2.02.1211121019280.23195@lap-x201>
 <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu>
 <alpine.DEB.2.02.1211121523190.23195@lap-x201>
 <alpine.DEB.2.00.1211122020280.18729@blackhole.kfki.hu>
 <20121112233024.GA15215@1984>
 <alpine.DEB.2.00.1211131704520.21144@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Wilson <chris-netfilter-110904@aptivate.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51346 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780Ab2KMQsE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:48:04 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211131704520.21144@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 13, 2012 at 05:11:11PM +0100, Jozsef Kadlecsik wrote:
> On Tue, 13 Nov 2012, Pablo Neira Ayuso wrote:
> 
> > On Mon, Nov 12, 2012 at 08:34:26PM +0100, Jozsef Kadlecsik wrote:
> > > 
> > > What do you think about this?
> > > 
> > > - add route change notification event to the net core
> > > - add --update-source-address flag to the MASQUERADE target
> > > - add a call for such events to the MASQUERADE target, when
> > >   the flag is enabled
> > > 
> > > The called function then can scan the conntrack table and for every entry 
> > > which has got the update-source-address flag, can check whether the source 
> > > IP address should be changed. Those entries are then deleted.
> > 
> > It seems to me this can be implemented this from user-space. It would
> > require a new working mode for conntrackd that would:
> > 
> > 1) subscribe to route events via rtnl and libmnl.
> > 2) get new interface address for some monitored address, also via rtnl.
> > 3) iterate over the table and remove those entries with outdated IP
> > address.
> > 
> > All the infrastructure is ready, and it would not require any kernel
> > upgrade. What do you think about this approach?
> 
> So far conntrackd implements conntrack replication. It could be extended 
> with such functionality, yes. However, it'd be just good if MASQUERADE 
> would not require an external component (i.e. userspace daemon) to work in 
> all cases.

I see. If the change is more or small and it allows it to work for all
cases, I'll be OK.

> Step 2 does indeed required?

Hm, not really, sorry.

Your plan is to set some flag in ct->status so you can identify those
that you need to kill, is it precise?

Regards.
