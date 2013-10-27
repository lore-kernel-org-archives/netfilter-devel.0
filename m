From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack, idle TCP connection and keep-alives
Date: Sun, 27 Oct 2013 18:01:30 +0000
Message-ID: <20131027180129.GC27597@macbook.localnet>
References: <526C22B8.5030102@torlan.ru>
 <20131027153408.GA20634@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: WGH <wgh@torlan.ru>, netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64788 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab3J0SBf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 14:01:35 -0400
Content-Disposition: inline
In-Reply-To: <20131027153408.GA20634@home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 27, 2013 at 08:34:09AM -0700, Phil Oester wrote:
> On Sun, Oct 27, 2013 at 12:14:48AM +0400, WGH wrote:
> > It seems that, when masquerading, conntrack silently drops idle
> > connection after nf_conntrack_tcp_timeout_established seconds. This's
> > pretty terrible, as application inside the network, if it never sends
> > anything, will never know that connection was dropped.
> 
> If this is a problem for you, then increase nf_conntrack_tcp_timeout_established
> to an insanely high value.  You do realize, of course, that the conntrack
> table has a finite number of entries.
>  
> > RFC 5382 gives us a solution to this:
> > > A NAT can check if an endpoint for a session has crashed by sending a
> > > TCP keep-alive packet and receiving a TCP RST packet in response.
> > 
> > However, it I couldn't find such feature in netfilter. It would be
> > pretty nice to have.
> 
> Keepalives should be done in the application, not in the firewall.

Actually I think its a pretty nice idea to reduce breakage introduced
by NATs. There a millions of embedded devices that use very small timeout
values to reduce memory usage, at the cost of frequently breaking idle
connections.
