From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/8] [NETFILTER]: rename NF_ARP to NFPROTO_ARP and assign
 a non-clashing value
Date: Wed, 09 Apr 2008 15:51:08 +0200
Message-ID: <47FCC9CC.4070307@trash.net>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <2a75525ff0d60f2e71df2c9c3d040d3a76451713.1207668694.git.jengelh@computergmbh.de> <47FCBC24.4020209@trash.net> <alpine.LNX.1.10.0804091508480.4411@fbirervta.pbzchgretzou.qr> <47FCC0D2.7060306@trash.net> <alpine.LNX.1.10.0804091514550.4411@fbirervta.pbzchgretzou.qr> <47FCC2F4.4030901@trash.net> <alpine.LNX.1.10.0804091533010.4411@fbirervta.pbzchgretzou.qr> <47FCC7B0.6080205@trash.net> <alpine.LNX.1.10.0804091545570.4411@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47195 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbYDINvK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:51:10 -0400
In-Reply-To: <alpine.LNX.1.10.0804091545570.4411@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-04-09 15:42, Patrick McHardy wrote:
>>> In this case, I'd just follow AF_ suit.
>>> Especially since NAME_MAX=3D256, PATH_MAX=3D4096 for example,
>> Thats a bad example.
>>
>>> _MAX is more often the total size rather than the last element.
>>> (The more even since loops use for (; x < MAX; )
>>> rather than for (; x<=3D MAX;) as can probably be seen
>>> in a lot of userspace code.)
>> Which is in my opinion a sign of poor coding and leads to
>> off-by-ones. Please don't redefine the meaning of maximum.
>>
> I don't think so. Ask a person on the street:
>=20
> 	What's the maximum number of AFs Linux knows about?
>=20
> S/He would answer 34, counting up in front of you:
>=20
> 	- =E2=80=9Cit knows UNSPEC, IPV4, IPV6, ... and RXRPC, makes for
> 	a total of 34 AFs=E2=80=9D

I'm going to try this. I'll let you know in an hour :)

> So since that just came to my mind, how about using the
> somewhat odd one NFPROTO_TOTAL?

How about just using MAX the way a maximum is defined?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
