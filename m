From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack, idle TCP connection and keep-alives
Date: Sun, 27 Oct 2013 19:20:19 +0000
Message-ID: <20131027192019.GD32366@macbook.localnet>
References: <526C22B8.5030102@torlan.ru>
 <20131027153408.GA20634@home>
 <20131027180129.GC27597@macbook.localnet>
 <20131027183825.GA17696@macbook.localnet>
 <alpine.DEB.2.10.1310272007460.7234@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Oester <kernel@linuxace.com>, WGH <wgh@torlan.ru>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65182 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab3J0TU0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 15:20:26 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1310272007460.7234@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 27, 2013 at 08:14:19PM +0100, Jozsef Kadlecsik wrote:
> On Sun, 27 Oct 2013, Patrick McHardy wrote:
> 
> > On Sun, Oct 27, 2013 at 06:01:30PM +0000, Patrick McHardy wrote:
> > > On Sun, Oct 27, 2013 at 08:34:09AM -0700, Phil Oester wrote:
> > > > On Sun, Oct 27, 2013 at 12:14:48AM +0400, WGH wrote:
> > > > > It seems that, when masquerading, conntrack silently drops idle
> > > > > connection after nf_conntrack_tcp_timeout_established seconds. This's
> > > > > pretty terrible, as application inside the network, if it never sends
> > > > > anything, will never know that connection was dropped.
> > > > 
> > > > If this is a problem for you, then increase nf_conntrack_tcp_timeout_established
> > > > to an insanely high value.  You do realize, of course, that the conntrack
> > > > table has a finite number of entries.
> > > >  
> > > > > RFC 5382 gives us a solution to this:
> > > > > > A NAT can check if an endpoint for a session has crashed by sending a
> > > > > > TCP keep-alive packet and receiving a TCP RST packet in response.
> > > > > 
> > > > > However, it I couldn't find such feature in netfilter. It would be
> > > > > pretty nice to have.
> > > > 
> > > > Keepalives should be done in the application, not in the firewall.
> > > 
> > > Actually I think its a pretty nice idea to reduce breakage introduced
> > > by NATs. There a millions of embedded devices that use very small timeout
> > > values to reduce memory usage, at the cost of frequently breaking idle
> > > connections.
> > 
> > The downside seems to be that we'd need to keep track of timestamp values
> > to send valid keepalives, which also costs extra memory. I don't think that
> > cost is justifiable for NAT keepalives alone.
> 
> I think a single flag could be sufficient: if the timer in conntrack goes 
> off and the entry is in the ESTABLISHED state and this flag is not set, 
> then send a TCP keepalive packet and start the timer with a short timeout. 
> If we receive the reply packet, then the long ESTABLISHED timeout value 
> can be restored and the flag cleared.

Sure, I think we wouldn't even need that flag, we can just send the keepalive
and set a short timeout. If a RST is received, the connection is killed
anyway, otherwise it will be refreshed with the ESTABLISHED timeout.

But we do need a timestamp value to pass PAWS.
