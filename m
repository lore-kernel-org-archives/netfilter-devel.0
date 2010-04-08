From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH/RFC 3/5] bridge-netfilter: simplify IP DNAT and fix IP
 DNAT on encapsulated packets
Date: Thu, 08 Apr 2010 15:27:44 +0200
Message-ID: <4BBDD9D0.1010402@pandora.be>
References: <4BB207A8.6000608@pandora.be> <4BBDCCAB.8050704@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:39822 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab0DHN1x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Apr 2010 09:27:53 -0400
In-Reply-To: <4BBDCCAB.8050704@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Bart De Schuymer wrote:
>   
>> bridge-netfilter: simplify IP DNAT and fix IP DNAT on encapsulated packets
>>
>> - Add some code in br_device.c::br_dev_xmit() which enables the
>> removal of br_netfilter.c::br_nf_local_out(). The function
>> br_nf_local_out() was needed because the PF_BRIDGE::LOCAL_OUT hook
>> could be called when IP DNAT happens on to-be-bridged traffic. The
>> new scheme eliminates this mess.
>> - Speed up IP DNAT. To obtain the correct destination MAC address,
>> neigh_hh_output() or dst->neighbour->output() is called. In both
>> cases this results in the queueing of the packet. However, if dst->hh
>> is available, we already know the MAC address so we can just copy it
>> instead, removing the need for neigh_hh_output(). This MAC address is
>> copied in the new function neigh_hh_bridge().
>> - fix IP DNAT on vlan- or pppoe-encapsulated traffic: The functions
>> neigh_hh_output() or dst->neighbour->output() overwrite the complete
>> Ethernet header, although we only need the destination MAC address.
>> For encapsulated packets, they ended up overwriting the encapsulating
>> header. The new code copies the Ethernet source MAC address and
>> protocol number before calling dst->neighbour->output(). The Ethernet
>> source MAC and protocol number are copied back in place in 
>> br_nf_pre_routing_finish_bridge_slow(). This also makes the IP DNAT 
>> more transparent because in the old scheme the source MAC of the 
>> bridge was copied into the source address in the Ethernet header. We 
>> also let skb->protocol equal ETH_P_IP resp. ETH_P_IPV6 during the 
>> execution of the PF_INET resp. PF_INET6 hooks.
>>     
>
> Besides patch 5 these all look fine to me. Regarding this one,
> the individual changes don't seem to strictly depend on each
> other. Would it be possible to split this up further to make
> review (and potentially bisections) easier?
>   
That should be possible, I think. I'll have a look at it in the near future.

Bart

-- 
Bart De Schuymer
www.artinalgorithms.be

