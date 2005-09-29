From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: snat bridge routes reply packets
Date: Thu, 29 Sep 2005 16:35:23 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0509291616520.2673@filer.marasystems.com>
References: <dhef0t$mj3$1@sea.gmane.org>
	<Pine.LNX.4.61.0509282147100.8767@filer.marasystems.com>
	<433BA8F6.7000606@ufomechanic.net>
	<Pine.LNX.4.61.0509291155310.25933@filer.marasystems.com>
	<433BDBD7.6030609@ufomechanic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <433BDBD7.6030609@ufomechanic.net>
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

> Precicely, ARP is the problem. Because the de-nat'd return packet of the
> snat'd flow is not on any local bridge subnets, no arp requests are
> made. There are also other reasons for preferring not to make arp requests.

So you do not have routing for the initiating host? Or what is your 
problem more exacly?

> I'm still having difficulty seeing this. I only want to stop routing out
> of the reply when it was bridged in rather than routed in.

There is not really any difference in request/reply to the bridge. Both 
are just packets. One is SNAT:ed, the other DNAT:ed. But it is true that 
conntrack knows reasonably well which direction the packet is flowing 
assuming "normal" traffic flows so it is not impossible.

>>> I was planning to use whether the target mac of the first packet matched
>>> the mac of the incoming physdev as an indicator of bridging or routing,
>>
>> this is not sufficient and would break REDIRECT.
>
> How would it do that?

If you do not reroute DNAT:ed packets then the bridge would deliver the 
packet to the original destination MAC, not to the local host.

Same applies if you DNAT within the local subnet.

> I still want to route on the output of the snat'd packet, I just want to
> avoid routing on the de-nat'd return packets.  I'm not sure how this
> breaks redirects.

For the same reasons the return packets needs to be routed. These packets 
are implicitly DNAT:ed, changing the destination IP to a different IP than 
the sending host ARP:ed for.

>> Yes, in MASQUERADE type flows where the firewall SNATs flows to it's own
>> address it might be possible in certain cases to remember the original
>> "client" MAC address, and avoid the ARP:ing on return traffic. But this
>> is on the assumption that the client network is symmetric. It is
>> possible the traffic was received via an assymetric route where return
>> traffic should go to another MAC address and ARP is required to figure
>> this out.
>
> Yes, this is a strong assumption, we would only do this when snat-ing
> bridged traffic. There may be assymetric bridging which would break, but
> then snat is already broken for bridging.

I would not agree. Both SNAT and DNAT works just fine in bridgeing 
assuming the IP level is properly set up to support the addresses used.

You can not SNAT to an otherwise non-existing IP as there then is no MAC 
address for the receiving host to sent the replies to (no ARP answer when 
the receiving host wants to send reply packets, so it can't).

> This sounds like a good solution, and in my preferred deployment an
> option of the flag would be to "guess" whether or not to route the
> return packet based on my stated criteria.

This "guess" must be done by the administrator when creating the rule, if 
not it gets very confusing.

Thinking this over there actually needs to be several different modes

   - Don't reroute the packet at all. All MAC addressing is preserved as-is 
on each packet. (relevant to both normal IP level iptables and bridgeing)

   - Track the initiating source MAC address, and reroute at MAC level all 
packets in the reply direction to this address. (only relevant to 
bridgeing). But route packets in the forward direction. **

   - Reroute all NAT:ed packets. (the default, what we have today).

One drawback of the proposed solution is that conntrack needs to be 
extended with MAC addressing in each direction.

**) This is only meaningful in MASQUERADE type SNAT setups where the 
bridge does not have routing to all "internal clients".


Regards
Henrik
