From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Change proposal for consistent "skb->pkt_type" after re-injection
Date: Wed, 30 Jun 2004 21:53:11 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406302134220.13036-100000@filer.marasystems.com>
References: <20040630193025.GC1520@rie.rie.priv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, <bus@fgan.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Christian Riechmann <riechmann@fgan.de>
In-Reply-To: <20040630193025.GC1520@rie.rie.priv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 30 Jun 2004, Christian Riechmann wrote:

> > Correct, and ip_queue does not have an option to let the userspace return 
> > a new packet type. But there is other iptables modules allowing you to do 
> > this kind of thing either before or after the packet is sent to ip_queue.
> 
> Maybe you can give me a pointer which are these modules.

Looking... seems I remember wrongly. Can't find any.

> My understanding of TUN is that it offers only 1_to_1 and not 1_to_n
> connections which I do need (IP/TCP packets have to be encapsulated within
> UDP packets, which are broadcasted to the neighbor hosts). That is why I
> did not yet overtake this proposal you made some weeks ago.

This is incorrect. TUN offers a virtual network device at either the IP or 
Ethernet layers, giving userspace full control to inject packets at these 
layers as if they were coming from a real network device and also the 
ability to read packets as if they were sent to a real network device. 

Yes, intercepting broadcasts via a TUN device is a little tricky but if
you make a bridge with the real network device then this is also fully
doable. The TUN device obviously needs to be in TAP mode (Ethernet) for 
bridgeing to work.

The initial target application for TUN was simple userspace tunnelling of
networks, but it is by no means limited to this functionality. TUN is a
network device where the transmission layer is implemented by userspace
instead of wires. In all other aspects it is and behaves like any other
network device.

What you route/forward to a TUN device gets delivered to the userspace
application, and what the userspace application writes to the TUN device
gets processed/forwarded by the kernel. In TAP mode the packet type is 
controlled by the Ethernet address type in the exact same manner as on a 
real Ethernet device, in TUN mode only PACKET_HOST injection is possible 
(direct link to the IP layer).

Regards
Henrik
