From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sun, 19 Dec 2010 01:28:16 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012190122320.13461@obet.zrqbmnf.qr>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <1292657351.2371.73.camel@kushiel.sterenborg.info> <alpine.DEB.2.00.1012181149560.11002@blackhole.kfki.hu> <alpine.LNX.2.01.1012181635530.13544@obet.zrqbmnf.qr>
 <alpine.DEB.2.00.1012182024240.11577@blackhole.kfki.hu> <alpine.LNX.2.01.1012182136190.19284@obet.zrqbmnf.qr> <alpine.DEB.2.00.1012190100180.11753@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Rob Sterenborg (lists)" <lists@sterenborg.info>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54446 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab0LSA2R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 19:28:17 -0500
In-Reply-To: <alpine.DEB.2.00.1012190100180.11753@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2010-12-19 01:05, Jozsef Kadlecsik wrote:
>>   CC     parse.lo
>> cc1: warnings being treated as errors
>> parse.c: In function ?get_addrinfo?:
>> parse.c:637:11: error: cast increases required alignment of target t=
ype
>> parse.c:640:11: error: cast increases required alignment of target t=
ype
>
>Oh well, the good old Sparc issue. I put back the workaround and pushe=
d.

Yeah. It seems struct sockaddr only has an alignment of 2=C2=A0=E2=80=94
even on x86_64.

Given struct sockaddr is usually just a base of another sockaddr_XXX
object and is thus always has the same alignment of the latter,
we could avoid the memcpy:

const struct sockaddr_in *x =3D (void *)i->ai_addr;
err =3D ipset_session_data_set(session, opt, &x->sin_addr);


>> 22:43 ares:../ipset/kernel > make
>
>Nobody is supposed to run `make' in the kernel/ subdir. You should hav=
e=20
>typed one level above:

Hah. So, what's the point of the Makefile? kbuild will find
Kbuild, so it uses just that.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
