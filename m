From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: Re: [PATCH 1/1] bridge: detect NAT66 correctly and change MAC address
Date: Fri, 09 Jan 2015 01:05:27 +0100
Message-ID: <54AF1B47.7020601@wvnet.at>
References: <1417813945-5050-1-git-send-email-bernhard.thaler@wvnet.at> <20141223140343.GA17171@salvia> <20141223141318.GA17379@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, sven@open-mesh.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smarthost2.wvnet.at ([62.212.174.131]:48470 "EHLO
	smarthost2.wvnet.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbbAIAFa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2015 19:05:30 -0500
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by smarthost1.wvnet.at (Postfix) with ESMTP id BEC38FCF589
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Jan 2015 01:05:27 +0100 (CET)
In-Reply-To: <20141223141318.GA17379@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry for not coming back to you for so long.

Here is my current status:
	-> I am still looking into the "fragmentation problem"
	-> but I need some more time for a patch

However, after working on the issue I am more and more convinced that
you should take the first patch "[PATCH 1/1] bridge: detect NAT66
correctly and change MAC address" solving the NAT66 MAC address problem
now and I will definitely split solving the "fragmentation problem" into
a separate patch.
The "fragmentation problem" is a different issue and affects any bridge
setup even it does not do any NAT66 I fear.

It may be obvious for some (for me it was not in the beginning),
but the "fragmentation problem" does not even need any NAT rule to be
configured to come into being.

I configured a simple bridge like that:

modprobe br_netfilter
brctl addbr br0
brctl addif br0 eth0
brctl addif br0 eth2
ifconfig eth0 up
ifconfig eth2 up
ifconfig br0 up

with a node having an IPv6 address on each end.

I started to do a "ping6 -s 8000 fd01:2345:6789:1::2" between the two
nodes interconnected by this bridge. These fragmented packets work fine
at the beginning but AS SOON AS I do a

ip6tables -t nat -nvL

on the machine hosting the bridge it stops to transmit fragmented
packets. I do not even need to add a single rule to trigger the problem.
A normal ping without need to fragment such as "ping6
fd01:2345:6789:1::2" still works through the bridge (tested with
net-next from 20150102).

This is why I think it is worth taking the NAT66 mac address patch as it
is now to have this one completely different NAT66 problem solved.

I will focus on the "fragmentation problem" independently with a simple
setup / error description as stated above as this will make it easier
for anyone to review / test the fragmentation patch in the end as well.

Regards,
Bernhard

On 23.12.2014 15:13, Pablo Neira Ayuso wrote:
> On Tue, Dec 23, 2014 at 03:03:43PM +0100, Pablo Neira Ayuso wrote:
>> On Fri, Dec 05, 2014 at 10:12:25PM +0100, Bernhard Thaler wrote:
>>> diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
>>> index c190d22..73ea96a 100644
>>> --- a/net/bridge/br_netfilter.c
>>> +++ b/net/bridge/br_netfilter.c
>> [...]
>>> +static int br_nf_pre_routing_finish_ipv6(struct sk_buff *skb)
>>> +{
>>> +	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
>>> +	struct rtable *rt;
>>> +	struct net_device *dev = skb->dev;
>>> +
>>> +	if (nf_bridge->mask & BRNF_PKT_TYPE) {
>>> +		skb->pkt_type = PACKET_OTHERHOST;
>>> +		nf_bridge->mask ^= BRNF_PKT_TYPE;
>>> +	}
>>> +	nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;
>>
>> There is no fragmentation handling here. Actually, not your fault, the
>> original br_nf_pre_routing_finish_ipv6() doesn't consider this case.
>>
>> I can take this patch, it doesn't do any worse than the existing code,
>> but probably you want to have a look at this.
> 
> A bit more info if you have a look at this: br_netfilter fragmentation
> handling is poorly designed, basically it may modify original fragment
> boundaries and a bridge shouldn't do that. But this is how this has
> been working since long time ago.
> 
