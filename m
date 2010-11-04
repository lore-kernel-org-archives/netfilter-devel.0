From: "Jeff Haran" <jharan@bytemobile.com>
Subject: RE: rules matching ipv6 prefix addrs
Date: Thu, 4 Nov 2010 10:35:59 -0700
Message-ID: <6F5DE7538AFCDA45A114F5E7510424A70225758A@hq-exchange01.bytemobile.com>
References: <4CD12B8B.9090506@plouf.fr.eu.org> <20101103.051925.193703726.davem@davemloft.net> <alpine.LNX.2.01.1011031331170.19124@obet.zrqbmnf.qr> <20101103.145503.104044664.davem@davemloft.net> <5ca75042-e809-4439-856a-e3da43cb6c23@email.android.com> <alpine.LNX.2.01.1011032339220.29167@obet.zrqbmnf.qr> <4CD21679.2070508@zytor.com> <4CD29423.6050009@earthlink.net> <4CD2C633.3070602@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Jan Engelhardt" <jengelh@medozas.de>,
	"David Miller" <davem@davemloft.net>,
	<pascal.mail@plouf.fr.eu.org>, <netfilter-devel@vger.kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ironport.bytemobile.com ([12.153.136.13]:2640 "EHLO
	ironport.bytemobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0KDRiB convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Nov 2010 13:38:01 -0400
Content-class: urn:content-classes:message
In-Reply-To: <4CD2C633.3070602@zytor.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> From: netfilter-devel-owner@vger.kernel.org
[mailto:netfilter-devel-owner@vger.kernel.org] On Behalf Of H. Peter
Anvin
>
> On 11/04/2010 07:08 AM, Stephen Clark wrote:
>>>
>>> Now, the upstream (ISP-assigned) prefix changes to 
>>> 2001:6b2f:1705::/48. RA will handle reassigning addresses to actual 
>>> downstream hosts, but things that explicitly encode IPv6 addresses 
>>> need to be changed, and that includes ip6tables, in this case these 
>>> rules now need to refer to 2001:6b2f:1705:0000::/52,
>>> 2001:62bf:1705:1000::/52 and so on.
>>>
>> Won't this break existing tcp connections if all of a sudden you get
a 
>> new address?
>>
>
>Yes.  Welcome to the brave new world of IPv6.  One of many reasons why
>IPv6 IMO is seriously misdesigned, but it's what we have and we no
longer have the time to do anything else.
>
>	-hpa

Ideally, your ISP wouldn't do this to you. Ideally, they would advertise
the new prefix as preferred and deprecate the old one. So connections
using the old prefix would continue to work while new connections should
start using the new prefix. By the time the old prefix is invalid there
should be no TCP connections using it since most TCP connections don't
last as long as the valid lifetime. But since TCP doesn't define a
maximum connection duration, it's still a possibility that long lived
connections could be dropped, no matter how hard the ISP tries to
prevent it. But it does mean that any reasonable IPv6 firewall setup
should deal with multiple prefixes. And it also means that if you have
an application that won't well tolerate dropped connections, you should
probably code it to do a clean close and restart whenever the address at
your end of the socket transitions from preferred to deprecated state.

Jeff Haran
Bytemobile

