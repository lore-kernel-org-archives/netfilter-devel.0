From: Christian Riechmann <riechmann@fgan.de>
Subject: Re: Change proposal for consistent "skb->pkt_type" after re-injection
Date: Mon, 5 Jul 2004 21:34:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040705193414.GA985@rie.rie.priv>
References: <20040630193025.GC1520@rie.rie.priv> <Pine.LNX.4.44.0406302134220.13036-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, bus@fgan.de
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0406302134220.13036-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik,

thanks for your detailed information about TUN. As you pointed out,
the usage of TUN to solve my problem is not so quite easy as it seems
to me when using iptables and ip6tables. But we will look at your
proposal to find out, whether it would lead to a simpler and more suitable
implementation.

Nevertheless,
as iptables/ip6tables do not forbid and/or do not refuse to re-inject
an address-modified (multicast/broadcast to unicast address) packet,
IMHO, it is good programming method to guarantee the CONSISTENCY
between the preset indicator (e.g. skb->pkt_type) and the address
within the re-injected packet.

The other way to guarantee consistency would be, that a re-injection
of such packets are refused. This would need some additional tests as well.

Therefore,
why not a patch which resets skb->pkt_type according to the address of
the re-injected packet?

Best Regards

Christian


On 2004-06-30 21:53:11 +0200, Henrik Nordstrom wrote:
> On Wed, 30 Jun 2004, Christian Riechmann wrote:
> 
> > > Correct, and ip_queue does not have an option to let the userspace return 
> > > a new packet type. But there is other iptables modules allowing you to do 
> > > this kind of thing either before or after the packet is sent to ip_queue.
> > 
> > Maybe you can give me a pointer which are these modules.
> 
> Looking... seems I remember wrongly. Can't find any.
> 
> > My understanding of TUN is that it offers only 1_to_1 and not 1_to_n
> > connections which I do need (IP/TCP packets have to be encapsulated within
> > UDP packets, which are broadcasted to the neighbor hosts). That is why I
> > did not yet overtake this proposal you made some weeks ago.
> 
> This is incorrect. TUN offers a virtual network device at either the IP or 
> Ethernet layers, giving userspace full control to inject packets at these 
> layers as if they were coming from a real network device and also the 
> ability to read packets as if they were sent to a real network device. 
> 
> Yes, intercepting broadcasts via a TUN device is a little tricky but if
> you make a bridge with the real network device then this is also fully
> doable. The TUN device obviously needs to be in TAP mode (Ethernet) for 
> bridgeing to work.
> 
> The initial target application for TUN was simple userspace tunnelling of
> networks, but it is by no means limited to this functionality. TUN is a
> network device where the transmission layer is implemented by userspace
> instead of wires. In all other aspects it is and behaves like any other
> network device.
> 
> What you route/forward to a TUN device gets delivered to the userspace
> application, and what the userspace application writes to the TUN device
> gets processed/forwarded by the kernel. In TAP mode the packet type is 
> controlled by the Ethernet address type in the exact same manner as on a 
> real Ethernet device, in TUN mode only PACKET_HOST injection is possible 
> (direct link to the IP layer).
> 
> Regards
> Henrik
> 
> 

-- 
Christian Riechmann    E-Mail: riechmann@fgan.de
c/o FGAN/FKIE          Tel: (+49) 228/9435 345,378
Neuenahrer Strasse 20  Fax: (+49) 228/9435 685
D-53343 Wachtberg, Germany
