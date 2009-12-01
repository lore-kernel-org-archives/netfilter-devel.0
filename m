From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: Add seperated timeout for the connections that only receive
	packets in one direction
Date: Tue, 1 Dec 2009 17:29:46 +0800
Message-ID: <412e6f7f0912010129l10386c75y5109578caf83147c@mail.gmail.com>
References: <4B0FA3AA.4070702@trash.net> <4B0FBC5F.8030108@trash.net>
	 <412e6f7f0911292039v74b89b4cieca5e2a043bad43d@mail.gmail.com>
	 <alpine.DEB.2.00.0912010940390.575@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:50787 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbZLAJ3j convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Dec 2009 04:29:39 -0500
Received: by pwi3 with SMTP id 3so2437846pwi.21
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Dec 2009 01:29:46 -0800 (PST)
In-Reply-To: <alpine.DEB.2.00.0912010940390.575@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 1, 2009 at 5:14 PM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> On Mon, 30 Nov 2009, Changli Gao wrote:
>
>> Think about this topologic:
>>
>> Attacker -> router1 -> router2 -> ... -> Linux Router -> Apache.
>>
>> the packets in the other direction won't be sent to the Linux Router=
,
>> as the other routers will routed them to the other place.
>
> Sorry, I don't get it.

There is a assumption: the final receiver doesn't reply any packet for
this packet in the invalid state.

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
