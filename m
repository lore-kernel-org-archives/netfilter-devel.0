From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [RFC PATCH] netfilter: nf_nat: support user-specified SNAT rules
 in LOCAL_IN
Date: Thu, 17 Jun 2010 10:58:09 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006171056080.23461@obet.zrqbmnf.qr>
References: <4C18E90F.30802@trash.net> <alpine.LSU.2.01.1006170924040.12057@obet.zrqbmnf.qr> <4C19D257.5090101@trash.net> <alpine.LSU.2.01.1006170952010.15602@obet.zrqbmnf.qr> <4C19D4EE.3080906@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Netfilter Core Team <coreteam@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51754 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932663Ab0FQI6L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:58:11 -0400
In-Reply-To: <4C19D4EE.3080906@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-06-17 09:55, Patrick McHardy wrote:

>Jan Engelhardt wrote:
>> On Thursday 2010-06-17 09:44, Patrick McHardy wrote:
>>   
>>> Jan Engelhardt wrote:
>>>     
>>>> I am not sure I follow whatever this is supposed to do.
>>>>
>>>> Packet from eth0: src=10.0.0.15 dst=10.0.1.22
>>>> INPUT#NETMAP will dst transform that to dst=10.0.0.22
>>>>       
>>> nat/INPUT performs source NAT, not destination NAT.
>>>
>>>     
>>>> POSTROUTING#NETMAP will src transform that to src=10.0.0.15
>>>>
>>>> Is is this step that makes no sense to me.
>>>>       
>>> Does it make sense now?
>>>     
>>
>> Somewhat, but there's still
>>
>>   
>>>>> However this doesn't work for packets  destined for the
>>>>> machine performing NAT itself
>>>>>         
>>
>> Why would it not? What would cause misdelivery if PREROUTING
>> was used instead of INPUT?
>>   
>
>PREROUTING performs DNAT. The purpose is to map the two
>identical networks to non-clashing networks. Just consider two
>connections from the same source address and port number
>to the same destination.
>

If veth0 has 10.0.0.0/24 and veth1 has 10.0.0.0/24,
wouldn't Linux's ARP mechanism already be confused, in
that it only sends ARP to the first network matching
the subnet?
