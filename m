From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: rules matching ipv6 prefix addrs
Date: Thu, 04 Nov 2010 10:41:55 -0400
Message-ID: <4CD2C633.3070602@zytor.com>
References: <4CD12B8B.9090506@plouf.fr.eu.org> <20101103.051925.193703726.davem@davemloft.net> <alpine.LNX.2.01.1011031331170.19124@obet.zrqbmnf.qr> <20101103.145503.104044664.davem@davemloft.net> <5ca75042-e809-4439-856a-e3da43cb6c23@email.android.com> <alpine.LNX.2.01.1011032339220.29167@obet.zrqbmnf.qr> <4CD21679.2070508@zytor.com> <4CD29423.6050009@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	David Miller <davem@davemloft.net>,
	pascal.mail@plouf.fr.eu.org, netfilter-devel@vger.kernel.org
To: sclark46@earthlink.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:60238 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab0KDOnq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:43:46 -0400
In-Reply-To: <4CD29423.6050009@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/04/2010 07:08 AM, Stephen Clark wrote:
>>
>> Now, the upstream (ISP-assigned) prefix changes to
>> 2001:6b2f:1705::/48. RA will handle reassigning addresses to actual
>> downstream hosts, but things that explicitly encode IPv6 addresses
>> need to be changed, and that includes ip6tables, in this case these
>> rules now need to refer to 2001:6b2f:1705:0000::/52,
>> 2001:62bf:1705:1000::/52 and so on.
>>
> Won't this break existing tcp connections if all of a sudden you get a
> new address?
>

Yes.  Welcome to the brave new world of IPv6.  One of many reasons why 
IPv6 IMO is seriously misdesigned, but it's what we have and we no 
longer have the time to do anything else.

	-hpa
