From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: snat bridge routes reply packets
Date: Thu, 29 Sep 2005 12:11:36 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0509291155310.25933@filer.marasystems.com>
References: <dhef0t$mj3$1@sea.gmane.org>
	<Pine.LNX.4.61.0509282147100.8767@filer.marasystems.com>
	<433BA8F6.7000606@ufomechanic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <433BA8F6.7000606@ufomechanic.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 29 Sep 2005, Amin Azez wrote:

> It is a change of the response dnat that I am suggesting. The DNAT
> packets need delivering to the original MAC/IP/PHYSDEV in bridging mode,
> and in routing mode the routing stack will probably find the same
> MAC/IP/PHYSDEV using its routing tricks and ARP. In bridging mode the
> routing code cannot find this.

More likely ARP is your problem.

When you SNAT to another address on the LAN you need to make sure there is 
something answering to ARP on that address, if not the receiving station 
won't be able to ARP for the MAC where to send return traffic.

> Heh.  I think I could permit the reverse snat'ing in bridge mode without
> damaging the other behaviour.

If the problem is what I suspect then "fixing" the NAT to not route the 
traffic won't make much difference.

> I was planning to use whether the target mac of the first packet matched
> the mac of the incoming physdev as an indicator of bridging or routing,

this is not sufficient and would break REDIRECT.

> but then I wondered if the interface merely being in promiscuous mode
> would cause trouble, but I don't think so; but maybe I should do IP
> checks instead and bridging is where the dest IP address of the first
> packet doesn't match the ip address of the devices (not physdev) it came
> in on?

this too would break REDIRECT.

the thing with NAT:ing in the bridge is that you change the IP addressing 
of the packet. As the IP addressing is changed there is a very high 
probability it needs to be rerouted. Bridgeing and preserving the MAC is 
in many cases not correct.

Yes, in MASQUERADE type flows where the firewall SNATs flows to it's own 
address it might be possible in certain cases to 
remember the original "client" MAC address, and avoid the ARP:ing on 
return traffic. But this is on the assumption that the client network is 
symmetric. It is possible the traffic was received via an assymetric route 
where return traffic should go to another MAC address and ARP is required 
to figure this out.

> Anyway, although this is not how the bridge-netfilter integration was
> planned, do you think my proposal is sound?

I see only two approaches. Either the current behaviour relying on routing 
being correctly configured, or an explicit flag in each NAT rule telling 
if the packets in this session should be rerouted or not moving the burden 
to the firewall administrator. Actually this flag might be good for 
iptables in general to optimize NAT performance slightly and not only when 
using bridge-netfilter. The constant rerouting of packets in a NAT session 
is a significant overhead and often it can be priorly known (by the admin) 
that this rerouting is not needed for the traffic flows in question.

But I strongly suspect your problems is not at all related to routing. It 
would only be routing related if your bridge does not have correct routing 
info for either the source or destination. If you have routing for both 
source and destination then your problem is almost certainly not routing 
related but most likely ARP related.

Regards
Henrik
