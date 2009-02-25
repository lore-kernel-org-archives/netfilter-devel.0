From: Patrick McHardy <kaber@trash.net>
Subject: Re: TEE patch [was: ROUTE patch]
Date: Wed, 25 Feb 2009 11:29:41 +0100
Message-ID: <49A51D95.9080009@trash.net>
References: <c122d6890902240059j540fc8dcl529129d7bc5006fe@mail.gmail.com> <alpine.LSU.2.00.0902241031500.30346@fbirervta.pbzchgretzou.qr> <49A3F922.4050508@trash.net> <alpine.LSU.2.00.0902241629550.23542@fbirervta.pbzchgretzou.qr> <49A4133E.4070703@trash.net> <alpine.LSU.2.00.0902251053270.20946@fbirervta.pbzchgretzou.qr> <49A51B26.3050906@trash.net> <alpine.LSU.2.00.0902251120250.20946@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Abhishek Singh <abhishek@abhishekonline.info>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58276 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762310AbZBYK3u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:29:50 -0500
In-Reply-To: <alpine.LSU.2.00.0902251120250.20946@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2009-02-25 11:19, Patrick McHardy wrote:
>   
>> Thanks. About dst_output and reentrancy - using IPSKB_REROUTED to
>> skip the netfilter hooks should work I guess.
>>     
>
> IPv6 is missing IPSKB_REROUTED entirely.
>   

It can be added I assume. For now just IPv4 support would also be fine.

>>> +static bool
>>> +tee_tg_route4(struct sk_buff *skb, const struct xt_tee_tginfo *info)
>>> +{
>>> +	int err;
>>> +	struct rtable *rt;
>>> +	struct flowi fl;
>>> +
>>> +	memset(&fl, 0, sizeof(fl));
>>> +	fl.nl_u.ip4_u.daddr = info->gw.ip;
>>> +	fl.nl_u.ip4_u.scope = RT_SCOPE_UNIVERSE;
>>>       
>> An index is probably useful when you want to mirror packets
>> somewhere outside of regular routing.
>>     
>
> ifindex?
>   

Yes.
