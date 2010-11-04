From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: rules matching ipv6 prefix addrs
Date: Thu, 4 Nov 2010 20:24:17 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011042021040.16729@obet.zrqbmnf.qr>
References: <4CD12B8B.9090506@plouf.fr.eu.org> <20101103.051925.193703726.davem@davemloft.net> <alpine.LNX.2.01.1011031331170.19124@obet.zrqbmnf.qr> <20101103.145503.104044664.davem@davemloft.net> <5ca75042-e809-4439-856a-e3da43cb6c23@email.android.com>
 <alpine.LNX.2.01.1011032339220.29167@obet.zrqbmnf.qr> <4CD21679.2070508@zytor.com> <4CD29423.6050009@earthlink.net> <4CD2C633.3070602@zytor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: sclark46@earthlink.net, David Miller <davem@davemloft.net>,
	pascal.mail@plouf.fr.eu.org, netfilter-devel@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40939 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab0KDTYS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:24:18 -0400
In-Reply-To: <4CD2C633.3070602@zytor.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-11-04 15:41, H. Peter Anvin wrote:
> On 11/04/2010 07:08 AM, Stephen Clark wrote:
>>>
>>> Now, the upstream (ISP-assigned) prefix changes to
>>> 2001:6b2f:1705::/48. RA will handle reassigning addresses to actual
>>> downstream hosts, but things that explicitly encode IPv6 addresses
>>> need to be changed, and that includes ip6tables, in this case these
>>> rules now need to refer to 2001:6b2f:1705:0000::/52,
>>> 2001:62bf:1705:1000::/52 and so on.
>>>
>> Won't this break existing tcp connections if all of a sudden you get a
>> new address?
>
>Yes.  Welcome to the brave new world of IPv6.  One of many reasons why IPv6 IMO
>is seriously misdesigned, but it's what we have and we no longer have the time
>to do anything else.

Well we know academia is evil as they never talk to us on linux-netdev
when designing protocols behind closed doors.

One could also argue that IPv6 just does what it does, and that any
extra feature is layered... what you want sounds like Shim6.
