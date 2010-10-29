From: Patrick McHardy <kaber@trash.net>
Subject: Re: tproxy: added IPv6 support to the socket match
Date: Fri, 29 Oct 2010 16:31:35 +0200
Message-ID: <4CCADAC7.5040309@trash.net>
References: <201010231923.o9NJNK9U013494@hera.kernel.org>	<AANLkTi=KRAcoonwFHKNaptap2LQHDswRCGpect82aHzx@mail.gmail.com> <20101028.130025.102564000.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: geert@linux-m68k.org, bazsi@balabit.hu, hidden@balabit.hu,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40115 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933911Ab0J2Obh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Oct 2010 10:31:37 -0400
In-Reply-To: <20101028.130025.102564000.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 28.10.2010 22:00, schrieb David Miller:
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Date: Thu, 28 Oct 2010 20:51:43 +0200
> 
>>> +       u8 tproto;
>>
>> tproto is unsigned...
>>
>>> +       const struct xt_socket_mtinfo1 *info = (struct xt_socket_mtinfo1 *) par->matchinfo;
>>> +
>>> +       tproto = ipv6_find_hdr(skb, &thoff, -1, NULL);
>>
>> but ipv6_find_hdr() returns int, and negative values for errors...
> 
> Thanks Geert, I'll fix it like so:
> 
> --------------------
> netfilter: xt_socket: Make tproto signed in socket_mt6_v1().
> 
> Otherwise error indications from ipv6_find_hdr() won't be noticed.
> 
> This required making the protocol argument to extract_icmp6_fields()
> signed too.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks for taking care of this Dave.
