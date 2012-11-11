From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: UDP packets sent with wrong source address after routing
 change [AV#3431]
Date: Sun, 11 Nov 2012 13:23:44 +0100
Message-ID: <20121111122344.GA2212@1984>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201>
 <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org>
 <20121110140720.GA9610@1984>
 <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@inai.de>,
	Chris Wilson <chris@aptivate.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52456 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab2KKMXt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:23:49 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 10, 2012 at 10:47:55PM +0100, Jozsef Kadlecsik wrote:
> On Sat, 10 Nov 2012, Jan Engelhardt wrote:
> 
> > On Saturday 2012-11-10 15:07, Pablo Neira Ayuso wrote:
> > 
> > >On Thu, Nov 08, 2012 at 06:37:24PM +0000, Chris Wilson wrote:
> > >[...]
> > >> >>Another option which doesn't violate layering might be to update
> > >> >>the NAT rule when the outgoing address is known (after routing),
> > >> >
> > >> >That is what MASQUERADE is usually for.
> > >> 
> > >> Unfortunately I am using MASQUERADE and this still happens. If it
> > >> could just be fixed in the MASQUERADE target that would be a big
> > >> win.
> > >
> > >MASQUERADE already cleans up the entries in the conntrack table once
> > >you get your device down, that code is still there in 2.6.18:
> > >
> > >http://lxr.linux.no/#linux+v2.6.18/net/ipv4/netfilter/ipt_MASQUERADE.c#L111
> > 
> > It looks like it only catches the case of a changing ifindex.
> > 
> > That may work for PPP links, but if you access the 'net over an
> > Ethernet-looking link as is (thankfully) done by cable ISPs,
> > the interface will never go away.
> > 
> > The DHCP client will simply change one or more addresses on it -- and
> > at the same time I wonder if that makes it a "you should run
> > conntrack -F or something from your dhclient.script" case.
> 
> That's also handled by the MASQUERADE target: if the device was downed or 
> its address deleted, the corresponding conntrack entries are cleaned up.
> 
> But the thread is drifted from the original cases:
> 
> > This only seems to happen when you're using a UDP device behind a Linux
> > NAT router, and your routing to the destination host changes, because:
> >
> > * You bring up a VPN tunnel and the SIP destination is at the other end 
> > of that tunnel; or
> 
> This case is not handled by MASQUERADE.
> 
> > * Your default route changes because you failover to another provider.
> 
> And this case is also not handled if the original default route device is 
> still healthy, that is for example when you use some dynamic routing 
> protocol which detects failure in the routing path.
> 
> I do not see any simple solution except to delete any NATed entry 
> unconditionally when the routing changes. But that can easily be too much 
> and may kill valid entries.

I do not see it either and flushing the entire table seems to me like
way too much.

My suggestion is to use conntrack -D ... including the appropriate
selectors to delete only affected entries, and those selectors depend
on the setup.
