From: David Miller <davem@davemloft.net>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Thu, 23 Dec 2010 10:06:53 -0800 (PST)
Message-ID: <20101223.100653.115946740.davem@davemloft.net>
References: <4D138C02.3050905@googlemail.com>
	<20101223.095545.183057798.davem@davemloft.net>
	<4D138E46.7090207@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kadlec@blackhole.kfki.hu, dennisml@conversis.de,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: mr.dash.four@googlemail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51671
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752958Ab0LWSGY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Dec 2010 13:06:24 -0500
In-Reply-To: <4D138E46.7090207@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Mr Dash Four <mr.dash.four@googlemail.com>
Date: Thu, 23 Dec 2010 18:00:38 +0000

> 
>>>> If you need to match the same port both with TCP and UDP, then add it
>>>> to the set twice, with the proper protocols.
>>>>         
>>> I've already dealt with this - I do not see the need to add 2x as many
>>> elements to a set when, in reality, I am not interested in matching
>>> the protocol part.
>>>     
>>
>> You must, every protocol puts the ports in a different location.
>>   
> What do you mean by 'puts the ports in a different location'? Clarify
> please.

Look at the proto_ports_offset() function in the kernel if you don't
believe me.

static inline int proto_ports_offset(int proto)
{
	switch (proto) {
	case IPPROTO_TCP:
	case IPPROTO_UDP:
	case IPPROTO_DCCP:
	case IPPROTO_ESP:	/* SPI */
	case IPPROTO_SCTP:
	case IPPROTO_UDPLITE:
		return 0;
	case IPPROTO_AH:	/* SPI */
		return 4;
	default:
		return -EINVAL;
	}
}
