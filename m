From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH] netfilter: nf_nat: support user-specified SNAT rules
 in LOCAL_IN
Date: Thu, 17 Jun 2010 09:44:23 +0200
Message-ID: <4C19D257.5090101@trash.net>
References: <4C18E90F.30802@trash.net> <alpine.LSU.2.01.1006170924040.12057@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Netfilter Core Team <coreteam@netfilter.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58274 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab0FQHo2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jun 2010 03:44:28 -0400
In-Reply-To: <alpine.LSU.2.01.1006170924040.12057@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-06-16 17:09, Patrick McHardy wrote:
>   
>>    
>>    This works well, but is needlessly complicated for cases where only
>>    a single SNAT/DNAT mapping needs to be applied to these packets. In that
>>    case, all that needs to be done is to assign each network to a seperate
>>    zone and perform NAT as usual. However this doesn't work for packets
>>    destined for the machine performing NAT itself since its corrently not
>>    possible to configure SNAT mappings for the LOCAL_IN chain.
>>    
>>    Example usage with two identical networks (192.168.0.0/24) on eth0/eth1:
>>    
>>    # assign packets from each interface to a seperate zone and mark them for NAT
>>    
>>    iptables -t raw -A PREROUTING -i eth0 -j CT --zone 1
>>    iptables -t raw -A PREROUTING -i eth0 -j MARK --set-mark 1
>>    iptables -t raw -A PREROUTING -i eth1 -j CT --zone 2
>>    iptabels -t raw -A PREROUTING -i eth1 -j MARK --set-mark 2
>>    
>>    # SNAT packets to private networks: eth0 -> 10.0.0.0/24, eth1 -> 10.0.1.0/24
>>    
>>    iptables -t nat -A INPUT       -m mark --mark 1 -j NETMAP --to 10.0.0.0/24
>>    iptables -t nat -A POSTROUTING -m mark --mark 1 -j NETMAP --to 10.0.0.0/24
>>    iptables -t nat -A INPUT       -m mark --mark 2 -j NETMAP --to 10.0.1.0/24
>>    iptables -t nat -A POSTROUTING -m mark --mark 2 -j NETMAP --to 10.0.1.0/24
>>     
>
> I am not sure I follow whatever this is supposed to do.
>
> Packet from eth0: src=10.0.0.15 dst=10.0.1.22
> INPUT#NETMAP will dst transform that to dst=10.0.0.22

nat/INPUT performs source NAT, not destination NAT.

> POSTROUTING#NETMAP will src transform that to src=10.0.0.15
>
> Is is this step that makes no sense to me.

Does it make sense now?

