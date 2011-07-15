From: Adam Roach <adam@nostrum.com>
Subject: Re: NAT66 : A first implementation
Date: Thu, 14 Jul 2011 21:29:13 -0500
Message-ID: <4E1FA5F9.3040006@nostrum.com>
References: <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr><4E1F1902.9020605@student.ulg.ac.be><alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr> <20110714.161717.1387261665409519132.davem@davemloft.net> <6F5DE7538AFCDA45A114F5E7510424A7028D1BBE@hq-exchange01.bytemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, jengelh@medozas.de,
	T.Moes@student.ulg.ac.be, netfilter-devel@vger.kernel.org
To: Jeff Haran <jharan@bytemobile.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shaman.nostrum.com ([72.232.179.90]:58848 "EHLO nostrum.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964788Ab1GOC5Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jul 2011 22:57:16 -0400
In-Reply-To: <6F5DE7538AFCDA45A114F5E7510424A7028D1BBE@hq-exchange01.bytemobile.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 7/14/11 19:48, Jul 14, Jeff Haran wrote:

> People will use IPv6 NAT if they perceive its benefits outweigh its
> costs.
>
> Its costs will be significant. All that connection state tracking will
> translate to more hardware. Managing multiple, possibly overlapping,
> private network address spaces will mean more administrative headaches.
>
> The benefit, hiding IPv6 address of hosts and routers in internal
> networks, is I suspect less tangible. NAT in of itself doesn't provide
> enough security to be relied upon solely, so you need firewalls in any
> case. And unlike IPv4, you can't argue that you have to use NAT because
> of lack of address space.
>
> I think maybe we will get lucky. The bean counters may well keep the
> specter of IPv6 NAT at bay. 8^)

I haven't had time to look at the thesis or implementation under 
discussion, so I don't know what it does. However, I do want to point 
out that the properties you describe are not necessarily true of all 
IPv6 NAT approaches. If you look at RFC 6296 
(http://tools.ietf.org/html/rfc6296), you'll see that it does not 
require connection state tracking (or, indeed, any state tracking 
whatsoever). It even does some really clever manipulations that prevent 
it from having to recalculate packet checksums.

The handling of NAT between private address spaces -- even overlapping 
private address spaces -- is similarly clever (see section 2.2), and it 
even handles the multihoming case that Jan was insisting doesn't work 
(see section 2.4).

You are correct that NAT and firewalls are very different things, and 
the technique described in RFC 6296 makes this fact abundantly clear. It 
does so by removing the properties most IPv4 NATs have which people 
mistook for security features. It is a great conceptual untangling, 
which should help dispel this common misconception.

In terms of the tangible benefits... I'll defer to language in the RFC 
itself: "[This technique] provides a useful alternative to the 
complexities and costs imposed by multihoming using provider-independent 
addressing and the routing and network management issues of overlaid ISP 
address space." In medium to large enterprises, this can be a 
*substantial* operational cost reduction. Cost savings, coupled with 
stateless translation (== barely more hardware than you need for simple 
routing) start to tip the equation a bit.

So, really, before we do the whole "NATS BAD!" dogpile again, I'd 
encourage people take an unprejudiced look at the technique described in 
RFC 6296. There may actually be a place for NPTv6 in netfilter after all.

/a
