From: Amin Azez <azez@ufomechanic.net>
Subject: Re: snat bridge routes reply packets
Date: Thu, 29 Sep 2005 09:42:30 +0100
Message-ID: <433BA8F6.7000606@ufomechanic.net>
References: <dhef0t$mj3$1@sea.gmane.org>
	<Pine.LNX.4.61.0509282147100.8767@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0509282147100.8767@filer.marasystems.com>
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

Thanks for your interesting response;

Henrik Nordstrom wrote:
> On Wed, 28 Sep 2005, Amin Azez wrote:
> 
>> I have a bridge setup snat'ing some IP's that aren't actually on the
>> bridge subnet.
>>
>> That works fine except that the nat code doesn't know what to do with
>> the de-snat'd packets and tries to send them to the default gateway.
>>
>> This makes sense, but it's routing, not bridging.
> 
> As soon as you NAT a packet in bridge-netfilter it is intercepted and
> given to routing, no longer bridged. This to allow REDIRECT and a number
> of other highly interesting applications of NAT.
> 
> Yes, this causes a bit of headache if your bridge does not have correct
> routing, but it's a fairly small price to pay for a wealth of
> interesting functionality which would not be possible if the bridge did
> not reroute packets after applying NAT.

True enough, the outward bound snat'd packet is routed. The bridge does
have correct routing for the snat'd items.

> At a first glance one could think that SNAT would not need to do this,
> but then you realize that by SNAT:in you break the IP-MAC relation of
> the traffic flow, especially in the return direction which is a DNAT
> operation.  Doing DNAT without rerouting does not make much sense as the
> packets would then still be delivered to the same destination MAC, and
> things like REDIRECT would not be possible.

I am curious about this.

It is a change of the response dnat that I am suggesting. The DNAT
packets need delivering to the original MAC/IP/PHYSDEV in bridging mode,
and in routing mode the routing stack will probably find the same
MAC/IP/PHYSDEV using its routing tricks and ARP. In bridging mode the
routing code cannot find this.

This is, I admin, using iptables as a partial bridge/router when
snat'ing; however the outward packets ARE handled fine, I want to fix up
the return packets.

>> 1) Am I nuts?
> 
> 
> No. Just on a different angle than how the bridge-netfilter integration
> is designed wrt NAT.

Heh.  I think I could permit the reverse snat'ing in bridge mode without
damaging the other behaviour.

I was planning to use whether the target mac of the first packet matched
the mac of the incoming physdev as an indicator of bridging or routing,
but then I wondered if the interface merely being in promiscuous mode
would cause trouble, but I don't think so; but maybe I should do IP
checks instead and bridging is where the dest IP address of the first
packet doesn't match the ip address of the devices (not physdev) it came
in on?

Anyway, although this is not how the bridge-netfilter integration was
planned, do you think my proposal is sound?

Sam
