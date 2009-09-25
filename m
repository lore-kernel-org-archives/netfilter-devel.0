From: =?UTF-8?B?VmxhZG8gRHLFvsOtaw==?= <vlado@ttx.sk>
Subject: Re: xtables-addons ACCOUNT - userspace
Date: Fri, 25 Sep 2009 19:20:34 +0200
Message-ID: <4ABCFBE2.8080702@ttx.sk>
References: <4ABA69F3.9010907@ttx.sk> <alpine.LNX.2.00.0909232154500.25578@cedric.unob.cz> <alpine.LSU.2.00.0909240150350.30035@obet.zrqbmnf.qr> <4ABBDD8E.1030703@ttx.sk> <alpine.LSU.2.00.0909250950130.10538@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Rafaj <jr+netfilter-devel@cedric.unob.cz>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ttx02.ttx-net.sk ([193.110.187.3]:51965 "EHLO ttx02.ttx-net.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbZIYRUn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Sep 2009 13:20:43 -0400
In-Reply-To: <alpine.LSU.2.00.0909250950130.10538@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for pointer,
it works for me now on 2.6.31 and iptables 1.4.4

Regards,
Vlado
Jan Engelhardt  wrote / nap=C3=ADsal(a):
> On Thursday 2009-09-24 22:58, Vlado Dr=C5=BE=C3=ADk wrote:
>=20
>> Thanks for that!,
>> I was able to get also the userspace part working with snapshot from
>> ACCOUNT branch but I'm not able to compile whole xtables-addons from
>> this branch.
>>
>> Compile was running on CentOS 5 (x86 and x86_64)
>>
>> I've recieved following when trying compile:
>>  CC     libxt_RAWDNAT.oo
>> In file included from libxt_RAWDNAT.c:17:
>> xt_RAWNAT.h:5: error: field =E2=80=98addr=E2=80=99 has incomplete ty=
pe
>>
>> Do you have any clue what can be possibly wrong?
>=20
> I could imagine that, on systems with a /usr/include/linux older than=
=20
> 2.6.25, you need to point it to the iptables source tree, which has a=
=20
> timely copy of linux/netfilter.h shipping said type; in other words,=20
> please try:
>=20
> 	./configure --with-xtables=3D/path/to/iptables.src
>=20

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
