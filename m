From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/8] netfilter: ipv6: add IPSKB_REROUTED exclusion to
 NF_HOOK/POSTROUTING invocation
Date: Tue, 13 Apr 2010 15:36:26 +0200
Message-ID: <4BC4735A.3050809@trash.net>
References: <1271162268-28131-1-git-send-email-jengelh@medozas.de> <1271162268-28131-3-git-send-email-jengelh@medozas.de> <4BC472A3.90107@trash.net> <alpine.LSU.2.01.1004131533490.32023@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49756 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab0DMNga (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 09:36:30 -0400
In-Reply-To: <alpine.LSU.2.01.1004131533490.32023@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2010-04-13 15:33, Patrick McHardy wrote:
>>> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
>>> index f314ba4..7e10f62 100644
>>> --- a/net/ipv6/ip6_output.c
>>> +++ b/net/ipv6/ip6_output.c
>>> @@ -172,8 +172,9 @@ int ip6_output(struct sk_buff *skb)
>>>  		return 0;
>>>  	}
>>>  
>>> -	return NF_HOOK(NFPROTO_IPV6, NF_INET_POST_ROUTING, skb, NULL, dev,
>>> -		       ip6_finish_output);
>>> +	return NF_HOOK_COND(NFPROTO_IPV6, NF_INET_POST_ROUTING, skb, NULL, dev,
>>> +			    ip6_finish_output,
>>> +			    !(IP6CB(skb)->flags & IPSKB_REROUTED));
>> This needs to use an IP6SKB value to avoid clashes. I've fixed it up
>> as follows:
> 
> Would merging the IPSKB and IP6SKB flags be worth it?
> 

I don't think so, the CB is by definition private to each layer.
