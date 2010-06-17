From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH] netfilter: nf_nat: support user-specified SNAT rules
 in LOCAL_IN
Date: Thu, 17 Jun 2010 09:55:26 +0200
Message-ID: <4C19D4EE.3080906@trash.net>
References: <4C18E90F.30802@trash.net> <alpine.LSU.2.01.1006170924040.12057@obet.zrqbmnf.qr> <4C19D257.5090101@trash.net> <alpine.LSU.2.01.1006170952010.15602@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Netfilter Core Team <coreteam@netfilter.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58443 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607Ab0FQHz3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jun 2010 03:55:29 -0400
In-Reply-To: <alpine.LSU.2.01.1006170952010.15602@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2010-06-17 09:44, Patrick McHardy wrote:
>   
>> Jan Engelhardt wrote:
>>     
>>> I am not sure I follow whatever this is supposed to do.
>>>
>>> Packet from eth0: src=10.0.0.15 dst=10.0.1.22
>>> INPUT#NETMAP will dst transform that to dst=10.0.0.22
>>>       
>> nat/INPUT performs source NAT, not destination NAT.
>>
>>     
>>> POSTROUTING#NETMAP will src transform that to src=10.0.0.15
>>>
>>> Is is this step that makes no sense to me.
>>>       
>> Does it make sense now?
>>     
>
> Somewhat, but there's still
>
>   
>>>> However this doesn't work for packets  destined for the
>>>> machine performing NAT itself
>>>>         
>
> Why would it not? What would cause misdelivery if PREROUTING
> was used instead of INPUT?
>   

PREROUTING performs DNAT. The purpose is to map the two
identical networks to non-clashing networks. Just consider two
connections from the same source address and port number
to the same destination.

