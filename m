From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: rules matching ipv6 prefix addrs
Date: Thu, 04 Nov 2010 10:41:46 -0400
Message-ID: <4CD2C62A.50805@zytor.com>
References: <4CD12B8B.9090506@plouf.fr.eu.org> <20101103.051925.193703726.davem@davemloft.net> <alpine.LNX.2.01.1011031331170.19124@obet.zrqbmnf.qr> <20101103.145503.104044664.davem@davemloft.net> <5ca75042-e809-4439-856a-e3da43cb6c23@email.android.com> <alpine.LNX.2.01.1011032339220.29167@obet.zrqbmnf.qr> <4CD21679.2070508@zytor.com> <alpine.LNX.2.01.1011040943200.4050@obet.zrqbmnf.qr> <051c8c45-58d9-420c-aa86-41cb0c75a05a@email.android.com> <alpine.LNX.2.01.1011041252410.17937@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, pascal.mail@plouf.fr.eu.org,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:60239 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab0KDOnq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:43:46 -0400
In-Reply-To: <alpine.LNX.2.01.1011041252410.17937@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/04/2010 07:53 AM, Jan Engelhardt wrote:
> On Thursday 2010-11-04 12:36, H. Peter Anvin wrote:
>
>> Guess what... other services like DNS needs to deal with this too, and
>> so far has not; this is part of what needs to happen before nontrivial
>> scale IPv6 deployment happens...
>
> Despite what the RFCs say, IPv6 has big enough an address space that
> static addresses (prefixes) are much more likely to be handed out.
>

Uhm... no.  The reason we'll see dynamic prefixes isn't because of lack 
of address space but because of mandatory route aggregation (which *is* 
being implemented from the start) -- to keep BGP6 and the core routing 
tables from melting down.

> Nevertheless, did you consider
>
>>> ip6tables -A FORWARD -d 0:0:0:1000::/0:0:0:ffff::
>>>
>>> to ignore the changing prefix part.

I did, but it means reducing the level of protection given; I'd consider 
it an emergency hack.

	-hpa
