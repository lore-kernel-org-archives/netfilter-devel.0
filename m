From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: IPT [PATCH] yay, autotools!
Date: Wed, 28 Nov 2007 17:22:35 +0100
Message-ID: <474D95CB.1020004@balabit.hu>
References: <Pine.LNX.4.64.0711280140320.4181@fbirervta.pbzchgretzou.qr> <474D2B75.9070301@trash.net> <Pine.LNX.4.64.0711281149100.16364@fbirervta.pbzchgretzou.qr> <474D5010.10609@trash.net> <Pine.LNX.4.64.0711281246420.16364@fbirervta.pbzchgretzou.qr>
Reply-To: panther@balabit.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:36699 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929AbXK1QUU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Nov 2007 11:20:20 -0500
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id A0A49C15C9
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Nov 2007 17:20:18 +0100 (CET)
In-Reply-To: <Pine.LNX.4.64.0711281246420.16364@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt =EDrta:
> On Nov 28 2007 12:25, Patrick McHardy wrote:
>>>>>  - I think we should move all manuals to libxt_*.man or perhaps
>>>>>  even *.man, would reduce Makefile LOC.
>>>> You mean for the ones where we have an IPv4 and IPv6 version, but
>>>> no xtables extension? I'm not sure they're all similar ...
>>>>
>>> I mean libipt_unclean.man -> libxt_unclean.man. The source file
>>> libipt_unclean.c will persist. As unclean only matches libipt_%
>>> the manpage will only land in iptables.8, not ip6tables.8.
>> Then whats the advantage? Similar to the kernel, I think we should
>> only use xt_ for things that actually support more than one
>> address family.
>=20
> Well, just look at it:
>=20
>         for ext in $(1); do \
>                 f=3D"${srcdir}/libxt_$$ext.man"; \
>                 if [ -f "$$f" ]; then \
>                         echo ".SS $$ext"; \
>                         cat "$$f"; \
>                         continue; \
>                 fi; \
>                 f=3D"${srcdir}/libipt_$$ext.man"; \
>                 if [ -f "$$f" ]; then \
>                         echo ".SS $$ext"; \
>                         cat "$$f"; \
>                         continue; \
>                 fi; \
>                 f=3D"${srcdir}/libip6t_$$ext.man"; \
>                 if [ -f "$$f" ]; then \
>                         echo ".SS $$ext"; \
>                         cat "$$f"; \
>                         continue; \
>                 fi; \
>         done >$@;
>=20
> could be reduced to 1/3 of its size.
>=20

What happens if the difference of the IPv4 and IPv6 version is a single=
=20
option? In this case the man page cannot be the same, but the xt_ prefi=
x=20
is reasonable for the source file and this code fails (using ipt_...man=
=20
instead of ip6t_...man).

Attila
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
