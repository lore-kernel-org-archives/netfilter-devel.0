From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH] netfilter: nf_nat: support user-specified SNAT rules
 in LOCAL_IN
Date: Tue, 22 Jun 2010 09:20:39 +0200
Message-ID: <4C206447.2040900@trash.net>
References: <4C18E90F.30802@trash.net> <alpine.LSU.2.01.1006170924040.12057@obet.zrqbmnf.qr> <4C19D257.5090101@trash.net> <alpine.LSU.2.01.1006170952010.15602@obet.zrqbmnf.qr> <4C19D4EE.3080906@trash.net> <alpine.LSU.2.01.1006171056080.23461@obet.zrqbmnf.qr> <4C1A3DA0.2060804@trash.net> <alpine.LSU.2.01.1006201007241.24800@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Netfilter Core Team <coreteam@netfilter.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41858 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab0FVHUo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jun 2010 03:20:44 -0400
In-Reply-To: <alpine.LSU.2.01.1006201007241.24800@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2010-06-17 17:22, Patrick McHardy wrote:
>   
>>>  
>>>       
>>>> PREROUTING performs DNAT. The purpose is to map the two
>>>> identical networks to non-clashing networks. Just consider two
>>>> connections from the same source address and port number
>>>> to the same destination.
>>>>         
>>> If veth0 has 10.0.0.0/24 and veth1 has 10.0.0.0/24,
>>> wouldn't Linux's ARP mechanism already be confused, in
>>> that it only sends ARP to the first network matching
>>> the subnet?
>>>       
>> This patch is intended to be used *without* looping packets through
>> veth. But good point, I chose that example to simplify things, the
>> use case I'm interested in is actually tunnels. Apparently it wasn't
>> the best possible example :)
>>     
>
> Now you completely lost me. Without separate namespaces and veth
> to exchange packets between them,
>
> # ip a
> 8: iptnl1: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1480 qdisc noqueue state UNKNOWN 
>     link/ipip 5.6.7.8 peer 1.2.3.4
>     inet 10.0.0.1/24 scope global iptnl1
> 9: iptnl2: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1480 qdisc noqueue state UNKNOWN 
>     link/ipip 5.6.7.8 peer 9.10.11.12
>     inet 10.0.0.1/24 scope global iptnl2
>
> # ip r
> 10.0.0.0/24 dev iptnl1  proto kernel  scope link  src 10.0.0.1 
> 10.0.0.0/24 dev iptnl2  proto kernel  scope link  src 10.0.0.1 
>
> will lead to exclusive delivery to iptnl1 for packets that originate
> from the router itself.
> ...
> Seems sufficient.
>   

How is that sufficient for talking to both networks?

