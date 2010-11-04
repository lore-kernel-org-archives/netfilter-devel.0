From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: rules matching ipv6 prefix addrs
Date: Thu, 04 Nov 2010 10:42:15 -0400
Message-ID: <4CD2C647.2000608@zytor.com>
References: <4CD12B8B.9090506@plouf.fr.eu.org> <20101103.051925.193703726.davem@davemloft.net> <alpine.LNX.2.01.1011031331170.19124@obet.zrqbmnf.qr> <20101103.145503.104044664.davem@davemloft.net> <5ca75042-e809-4439-856a-e3da43cb6c23@email.android.com> <alpine.LNX.2.01.1011032339220.29167@obet.zrqbmnf.qr> <4CD21679.2070508@zytor.com> <4CD29F24.70804@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:60240 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab0KDOnr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:43:47 -0400
In-Reply-To: <4CD29F24.70804@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/04/2010 07:55 AM, Pascal Hambourg wrote:
>
>> Consider for example the case where I get from my ISP the netblock
>> 2001:0db8:ac10::/48.  I subnet this internally with subnet numbers
>> prefixed by /52 security domains, i.e 2001:0db8:ac10:0000::/52,
>> 2001:0db8:ac10:1000::/52 and so forth.
>
> /52 is quite unusual. AFAIK stateless autoconfiguration requires a
> prefix length of /64.
>

The implication in the example is that the /52 security domains each 
contain a number of /64 subnets.

>> Accordingly, my ip6tables would
>> contain rules as to what kind of traffic can flow between these prefixes.
>>
>> Now, the upstream (ISP-assigned) prefix changes to 2001:6b2f:1705::/48.
>> RA will handle reassigning addresses to actual downstream hosts, but
>> things that explicitly encode IPv6 addresses need to be changed, and
>> that includes ip6tables, in this case these rules now need to refer to
>> 2001:6b2f:1705:0000::/52, 2001:62bf:1705:1000::/52 and so on.
>
> Are you talking about rules on the router which subnets the block, or on
> downstream hosts ?
> Also, is each subnet prefix on a separate link ?
> Could you provide an example of such rules ?

I'm talking about rules on the internal router(s) which separate the 
security domains.  I can probably come up with a concrete ruleset, but 
it'll take a few days since I'm travelling at the moment.

	-hpa
