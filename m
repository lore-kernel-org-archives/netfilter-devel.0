From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH][BRIDGE-NETFILTER] fix REJECT for bridged traffic
Date: Fri, 06 Nov 2009 18:33:47 +0100
Message-ID: <4AF45DFB.3070606@pandora.be>
References: <4AF1D08C.2030907@pandora.be> <4AF2E21B.4050801@trash.net> <4AF32544.2060709@pandora.be> <4AF448C8.80701@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from brigitte.telenet-ops.be ([195.130.137.66]:52318 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbZKFRdo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2009 12:33:44 -0500
In-Reply-To: <4AF448C8.80701@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy schreef:
> Bart De Schuymer wrote:
>   
>> Patrick McHardy schreef:
>>     
>>> Also proper ETH_* values please. But I'm wondering, we already save
>>> the entire header in br_nf_post_routing(). Can't that be done earlier
>>> so the upper layers don't have to care about this stuff and can simply
>>> attach the original nf_bridge reference?
>>>
>>>   
>>>       
>> If you don't save the correct MAC address for the newly created skbuff
>> in ipt_REJECT, there is no way to get it back later. Furthermore, if you
>> save the header too early, MAC SNAT and DNAT might have changed the
>> header and you have to resave the header anyway.
>>     
>
> Yes, we need to save it at some point. My idea was that we might be able
> to save it in PREROUTING instead of POSTROUTING and only do
>
> nskb->nf_bridge = nf_bridge_get(oskb->nf_bridge)
>
> in ipt_REJECT and probably also the ICMP code. MAC NAT could be handled
> by updating the bridge info simultaneously.
>
>   
Patrick,

The code creates a new skbuf and the correct source MAC address is lost 
if you don't attach it to the skbuf at that time. How will you know in 
PREROUTING what SMAC to use if you didn't save it when you created the 
skbuf?

cheers,
Bart

-- 
Bart De Schuymer
www.artinalgorithms.be

