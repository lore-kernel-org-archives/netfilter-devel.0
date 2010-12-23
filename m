From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Thu, 23 Dec 2010 18:10:05 +0000
Message-ID: <4D13907D.3040301@googlemail.com>
References: <4D138C02.3050905@googlemail.com>	<20101223.095545.183057798.davem@davemloft.net>	<4D138E46.7090207@googlemail.com> <20101223.100653.115946740.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kadlec@blackhole.kfki.hu, dennisml@conversis.de,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20101223.100653.115946740.davem@davemloft.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


>> What do you mean by 'puts the ports in a different location'? Clarify
>> please.
>>     
>
> Look at the proto_ports_offset() function in the kernel if you don't
> believe me.
>   
I've never stated that I do not believe you - I just asked for a 
clarification. After looking at the example below I am still unclear 
what your point is (call me daft if you like!).

> static inline int proto_ports_offset(int proto)
> {
> 	switch (proto) {
> 	case IPPROTO_TCP:
> 	case IPPROTO_UDP:
> 	case IPPROTO_DCCP:
> 	case IPPROTO_ESP:	/* SPI */
> 	case IPPROTO_SCTP:
> 	case IPPROTO_UDPLITE:
> 		return 0;
> 	case IPPROTO_AH:	/* SPI */
> 		return 4;
> 	default:
> 		return -EINVAL;
> 	}
> }
>   
