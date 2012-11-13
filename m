From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Tue, 13 Nov 2012 16:25:30 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211131619040.21144@blackhole.kfki.hu>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984> <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu> <alpine.DEB.2.02.1211121019280.23195@lap-x201> <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu> <alpine.DEB.2.02.1211121523190.23195@lap-x201> <alpine.DEB.2.00.1211122020280.18729@blackhole.kfki.hu>
 <20121112233024.GA15215@1984> <50A257C8.8050700@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Chris Wilson <chris-netfilter-110904@aptivate.org>,
	netfilter-devel@vger.kernel.org
To: Stephen Clark <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:51607 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab2KMPZd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:25:33 -0500
In-Reply-To: <50A257C8.8050700@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 13 Nov 2012, Stephen Clark wrote:

> On 11/12/2012 06:30 PM, Pablo Neira Ayuso wrote:
> > 
> > On Mon, Nov 12, 2012 at 08:34:26PM +0100, Jozsef Kadlecsik wrote:
> > > On Mon, 12 Nov 2012, Chris Wilson wrote:
> > > 
> > > > I propose that:
> > > > 
> > > > * when the packet matches an existing conntrack rule, and
> > > > 
> > > > * is sent out of an interface that does not list the packet's new
> > > > (SNAT-to)
> > > > source address as one of its IP addresses (i.e. if this were a new
> > > > connection, MASQUERADE would not choose this source address), and
> > > > 
> > > > * the --update-source-address flag is set on the MASQUERADE target
> > > > 
> > > > then update the source address on the conntrack rule to the new one.
> > > > 
> > > > That's the same thing that would happen if we deleted the conntrack
> > > > entry
> > > > first: MASQUERADE would choose a new source address and save it in the
> > > > new
> > > > conntrack entry.
> > > What do you think about this?
> > > 
> > > - add route change notification event to the net core
> > > - add --update-source-address flag to the MASQUERADE target
> > > - add a call for such events to the MASQUERADE target, when
> > >    the flag is enabled
> > > 
> > > The called function then can scan the conntrack table and for every entry
> > > which has got the update-source-address flag, can check whether the source
> > > IP address should be changed. Those entries are then deleted.
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
> > 
> A similar problem exists in the following scenario:
> You have two upstream isp that you are doing load balancing by having multiple
> default routes:
> default
>         nexthop via 66.xxx.xxx.xxx  dev eth1 weight 1
>         nexthop via 205.xxx.xxx.xxx  dev eth2 weight 1
> On one of the external interface you have a DNAT to
> an internal server on a private address. The DNAT makes
> a conntrack entry that is going to in effect do a SNAT on reponses
> from the internal server back out to the internet, but the load balancing
> decision on routing happens before this implicit SNAT so you have packets
> trying to go out an interface where the source address does not fall in the
> subnet of that interface.

In my opinion this is a broken network design. The DNAT should not depend 
on the external interface, problem solved.
 
> Why is routing decision done before the SNAT?

Because that is the natural place: this way OUTPUT and FORWARD can be 
separated and we can use the original source IP addresses in the rules.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
