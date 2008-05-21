From: Patrick McHardy <kaber@trash.net>
Subject: Re: include/linux/netfilter.h after make headers_install is incomplete
Date: Wed, 21 May 2008 12:31:45 +0200
Message-ID: <4833FA11.4080507@trash.net>
References: <a27c0c970805161521k332fba8cg808d52396b5cdce5@mail.gmail.com> <a27c0c970805201139i38e12d15ue807fc0239b1c10e@mail.gmail.com> <a27c0c970805201144j12189201g9567460d4d3d8361@mail.gmail.com> <20080520.142121.15017166.davem@davemloft.net> <4833F1E7.5050700@trash.net> <20080521100443.GA7976@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, greg@nest.cx,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36160 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045AbYEUKbr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 06:31:47 -0400
In-Reply-To: <20080521100443.GA7976@uranus.ravnborg.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sam Ravnborg wrote:
> On Wed, May 21, 2008 at 11:56:55AM +0200, Patrick McHardy wrote:
>> David Miller wrote:
>>> From: "Greg Steuck" <greg@nest.cx>
>>> Date: Tue, 20 May 2008 11:44:56 -0700
>>>
>>>> I ran make headers_install in 2.6.25 tree and the installed netfilter.h is
>>>> not complete. Namely, it declares
>>>> union nf_inet_addr {
>>>>      __u32           all[4];
>>>>      __be32          ip;
>>>>      __be32          ip6[4];
>>>> ...
>>>> }
>>>>
>>>> The __u32, __be32 types are declared in <linux/types.h> and the #include
>>>> directive is removed by the installation process. This in turn makes some
>>>> applications unbuildable against such an exported tree, e.g.
>>>>
>>>> busybox-1.10.1/networking/tcpudp.c:#include <linux/netfilter_ipv4.h>
>>>>
>>>> If I correctly understand the purpose of make headers_install, it is
>>>> supposed to generate an API for applications. I could certainly
>>>> make tcpudp.c include linux/types.h, but given that the application
>>>> does not even use nf_inet_addr, this would be the wrong place for
>>>> the fix.
>> These types are used by countless header files. I don't know
>> why types.h is stripped, I guess this question can be best
>> answered by whoever maintains the header-install stuff (Sam?
>> I don't know).
> 
> Everything inside
> #ifdef __KERNEL__
> ...
> #endif
> 
> are stripped.


I didn't notice the ifdef around the include statement, this makes
sense of course.

I'll fix it up, thanks Sam.
