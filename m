From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net-next,RFC 00/13] New fast forwarding path
Date: Fri, 15 Jun 2018 08:03:07 +0200
Message-ID: <20180615060307.fwwc2vnb5rpc464p@gauss3.secunet.de>
References: <20180614141947.3580-1-pablo@netfilter.org>
 <70e4a28c-ccc3-6fd5-0d43-08ae72b7ad1b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>, <netdev@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <70e4a28c-ccc3-6fd5-0d43-08ae72b7ad1b@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 14, 2018 at 08:57:20AM -0700, Eric Dumazet wrote:
> 
> 
> On 06/14/2018 07:19 AM, Pablo Neira Ayuso wrote:
> > Hi,
> > 
> 
> > We have collected performance numbers:
> > 
> >         TCP TSO         TCP Fast Forward
> >         32.5 Gbps       35.6 Gbps
> > 
> >         UDP             UDP Fast Forward
> >         17.6 Gbps       35.6 Gbps
> > 
> >         ESP             ESP Fast Forward
> >         6 Gbps          7.5 Gbps
> > 
> > For UDP, this is doubling performance, and we almost achieve line rate
> > with one single CPU using the Intel i40e NIC. We got similar numbers
> > with the Mellanox ConnectX-4. For TCP, this is slightly improving things
> > even if TSO is being defeated given that we need to segment the packet
> > chain in software. We would like to explore HW GRO support with hardware
> > vendors with this new mode, we think that should improve the TCP numbers
> > we are showing above even more.
> 
> Hi Pablo
> 
> Not very convincing numbers, because it is unclear what traffic patterns were used.
> 
> We normally use packets per second to measure a forwarding workload,
> and it is not clear if you tried a DDOS, or/and a mix of packets being locally
> delivered and packets being forwarded.

Yes, these number need some more explaination. We used my IPsec
forwarding test setup for this. It looks like this:

	   ------------         ------------
	-->| router 1 |-------->| router 2 |--
	|  ------------         ------------  |
	|                                     |
	|       --------------------          |
	--------|Spirent Testcenter|<----------
	        --------------------

The numbers are from single stream forwarding tests, no local delivery.
Packet size in the UDP case was 1460 byte. I used this packet size
because such packets still fit into the mtu when encapsulated by IPsec.

> 
> Presumably adding cache line misses (to probe for flows) will slow down the things.
> 
> I suspect the NIC you use has some kind of bottleneck on sending TSO packets,
> or that you hit the issue that GRO might cook suboptimal packets for forwarding workloads
> (eg setting frag_list)

That might be, I was a bit surprised about the TCP numbers myself.
I was more focused on UDP and IPsec because these don't have
hardware segmentation support. I've just added a TCP handler to
see what happens, the numbers looked ok, so I kept it.

All this is based on the approach I pesented last year at the nefilter
workshop.

> 
> This path series add yet more code to GRO engine which is already very fat
> to the point many people advocate to turn it off.

We tried to stay away from the generic codepath as much as possible.
Currently we need five 'if' statements, two of them are in error
paths (Patch 4).

> Saving cpu cycles on moderate load is not okay if added complexity
> slows down the DDOS (or stress) by 10 % :/

Why 10%?

> 
> To me, GRO is specialized to optimize the non-forwarding case,
> so it is counter-intuitive to base a fast forwarding path on top of it.

It is optimized for the non-forwarding case, but it seems that forwarding
can benefit from that too with very little cost for the non-forwarding case.
