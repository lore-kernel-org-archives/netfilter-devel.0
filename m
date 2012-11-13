From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Tue, 13 Nov 2012 17:11:11 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211131704520.21144@blackhole.kfki.hu>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984> <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu> <alpine.DEB.2.02.1211121019280.23195@lap-x201> <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu> <alpine.DEB.2.02.1211121523190.23195@lap-x201> <alpine.DEB.2.00.1211122020280.18729@blackhole.kfki.hu>
 <20121112233024.GA15215@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Chris Wilson <chris-netfilter-110904@aptivate.org>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:56900 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab2KMQLM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:11:12 -0500
In-Reply-To: <20121112233024.GA15215@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 13 Nov 2012, Pablo Neira Ayuso wrote:

> On Mon, Nov 12, 2012 at 08:34:26PM +0100, Jozsef Kadlecsik wrote:
> > 
> > What do you think about this?
> > 
> > - add route change notification event to the net core
> > - add --update-source-address flag to the MASQUERADE target
> > - add a call for such events to the MASQUERADE target, when
> >   the flag is enabled
> > 
> > The called function then can scan the conntrack table and for every entry 
> > which has got the update-source-address flag, can check whether the source 
> > IP address should be changed. Those entries are then deleted.
> 
> It seems to me this can be implemented this from user-space. It would
> require a new working mode for conntrackd that would:
> 
> 1) subscribe to route events via rtnl and libmnl.
> 2) get new interface address for some monitored address, also via rtnl.
> 3) iterate over the table and remove those entries with outdated IP
> address.
> 
> All the infrastructure is ready, and it would not require any kernel
> upgrade. What do you think about this approach?

So far conntrackd implements conntrack replication. It could be extended 
with such functionality, yes. However, it'd be just good if MASQUERADE 
would not require an external component (i.e. userspace daemon) to work in 
all cases.

Step 2 does indeed required?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
