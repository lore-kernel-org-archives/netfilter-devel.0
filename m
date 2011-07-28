From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons: TEE extension fails to build
Date: Thu, 28 Jul 2011 13:51:11 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1107281336540.15776@frira.zrqbmnf.qr>
References: <1311849998.19605.2.camel@tablet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Peter Volkov <pva@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:34735 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab1G1LvM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jul 2011 07:51:12 -0400
In-Reply-To: <1311849998.19605.2.camel@tablet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2011-07-28 12:46, Peter Volkov wrote:

>Hi. TEE extension fails to build in xtables-addons. It fails with the =
following error:
>
>  CC [M]  /vt/portage/tmp/portage/net-firewall/xtables-addons-1.37/wor=
k/xtables-addons-1.37/extensions/xt_TEE.o
>/vt/portage/tmp/portage/net-firewall/xtables-addons-1.37/work/xtables-=
addons-1.37/extensions/xt_TEE.c: In function =E2=80=98tee_tg_route4=E2=80=
=99:
>/vt/portage/tmp/portage/net-firewall/xtables-addons-1.37/work/xtables-=
addons-1.37/extensions/xt_TEE.c:46:4: error: =E2=80=98struct flowi=E2=80=
=99 has no member named =E2=80=98nl_u=E2=80=99
>/vt/portage/tmp/portage/net-firewall/xtables-addons-1.37/work/xtables-=
addons-1.37/extensions/xt_TEE.c:47:4: error: =E2=80=98struct flowi=E2=80=
=99 has no member named =E2=80=98nl_u=E2=80=99
>/vt/portage/tmp/portage/net-firewall/xtables-addons-1.37/work/xtables-=
addons-1.37/extensions/xt_TEE.c:48:4: error: =E2=80=98struct flowi=E2=80=
=99 has no member named =E2=80=98nl_u=E2=80=99
>/vt/portage/tmp/portage/net-firewall/xtables-addons-1.37/work/xtables-=
addons-1.37/extensions/xt_TEE.c:50:2: warning: passing argument 2 of =E2=
=80=98ip_route_output_key=E2=80=99 from incompatible pointer type
>include/net/route.h:131:61: note: expected =E2=80=98struct flowi4 *=E2=
=80=99 but argument is of type =E2=80=98struct rtable **=E2=80=99

Because the mainline kernel already has xt_TEE (revision 1+) since vers=
ion
2.6.35, the xt_TEE (revision 0) copy in Xt-a is build-disabled by defau=
lt.
And now I added a big fat #error to emphase on that. :)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
