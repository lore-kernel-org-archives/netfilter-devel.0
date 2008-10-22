From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables-1.4.2: libxt_TOS.c compilation ending with error - IPPROTO_SCTP
 redefined
Date: Wed, 22 Oct 2008 08:59:06 +0200
Message-ID: <48FECF3A.6040509@trash.net>
References: <48FE5130.1040609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?B?SmnFmcOtIE1vcmF2ZWM=?= <jim.lkml@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41716 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbYJVG7J (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Oct 2008 02:59:09 -0400
In-Reply-To: <48FE5130.1040609@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ji=C5=99=C3=AD Moravec wrote:
> When I compiled iptables-1.4.2 I get an error:
>=20
> In file included from /usr/include/netinet/ip.h:25,
>                  from /usr/include/linux/ip.h:19,
>                  from tos_values.c:4,
>                  from libxt_TOS.c:15:
> /usr/include/netinet/in.h:84: error: expected identifier before numer=
ic constant
> make[2]: *** [libxt_TOS.oo] Error 1
>=20
>=20
>=20
> libxt_TOS.c:12
> #include <xtables.h>
> #include <linux/netfilter/xt_DSCP.h>
> #include <linux/netfilter_ipv4/ipt_TOS.h>
> #include "tos_values.c"
>=20
> /usr/include/xtables.h:10
> #ifndef IPPROTO_SCTP
> #define IPPROTO_SCTP 132
> #endif
>=20
> /usr/include/netinet/in.h:84 (through tos_values.c -> linux/ip.h -> n=
etinet/ip.h)
>     IPPROTO_SCTP =3D 132,	   /* Stream Control Transmission Protocol.=
  */
> #define IPPROTO_SCTP		IPPROTO_SCTP
>=20
>=20
> On my gentoo box IPPROTO_SCTP is defined in /usr/include/netinet/in.h=
 (from sys-libs/glibc-2.7 package)
> and in /usr/include/xtables.h (net-firewall/iptables-1.4.1.1 package)=
 too (conditionally).
>=20
> However, in libxt_TOS.c <xtables.h> preceded <netinet/in.h> and SCTP =
is already defined by <xtables.h>.
> So, definition in <netinet/in.h> ending with error, because line "IPP=
ROTO_SCTP =3D 132",=20
> is probably interpreted as "132 =3D 132"
>=20
>=20
> As a temporary workaround, I included <netinet/in.h> before <xtables.=
h>:

I don't have a better solution, so I've applied your patch. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
