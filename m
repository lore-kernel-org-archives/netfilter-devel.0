From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: [PATCH 1/11] Line-based makefile
Date: Mon, 24 Dec 2007 15:29:14 +0100
Message-ID: <476FC23A.7020902@balabit.hu>
References: <Pine.LNX.4.64.0712220342260.8607@fbirervta.pbzchgretzou.qr>
Reply-To: panther@balabit.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:43262 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbXLXObf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:31:35 -0500
In-Reply-To: <Pine.LNX.4.64.0712220342260.8607@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Jan Engelhardt =EDrta:
> Transform the extensions' Makefile into a linear form to reduce
> conflicts for patch stacks (very helpful during development).
> Ideally, I'd just push in the automake patch, though,
> which uses wildcards ;-)
>=20
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>=20
> ---
>  extensions/Makefile |   92 +++++++++++++++++++++++++++++++++++++++++=
++++++++---
>  1 file changed, 88 insertions(+), 4 deletions(-)
>=20
> Index: iptables-modules/extensions/Makefile
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- iptables-modules.orig/extensions/Makefile
> +++ iptables-modules/extensions/Makefile
> @@ -5,13 +5,97 @@
>  # header files are present in the include/linux directory of this ip=
tables
>  # package (HW)
>  #
> -PF_EXT_SLIB:=3Dah addrtype conntrack ecn icmp iprange owner policy r=
ealm recent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NE=
TMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG
> -PF6_EXT_SLIB:=3Dah dst eui64 frag hbh hl icmp6 ipv6header mh owner p=
olicy rt HL LOG REJECT
> -PFX_EXT_SLIB:=3Dconnbytes connmark connlimit comment dccp dscp esp h=
ashlimit helper length limit mac mark multiport physdev pkttype quota s=
ctp state statistic standard string tcp tcpmss time u32 udp CLASSIFY CO=
NNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
> +a :=3D
=2E.
> +a +=3D rt
> +PF6_EXT_SLIB :=3D ${a}
> +a :=3D
=2E..
> +a +=3D udp
> +PFX_EXT_SLIB :=3D ${a}
> =20
>  PF_EXT_SELINUX_SLIB:=3D
>  PF6_EXT_SELINUX_SLIB:=3D
> -PFX_EXT_SELINUX_SLIB:=3DCONNSECMARK SECMARK
> +a :=3D
> +a +=3D CONNSECMARK
> +a +=3D SECMARK
> +PFX_EXT_SELINUX_SLIB :=3D ${a}
>=20

That would be better as
PF_EXT_SLIB :=3D
PF_EXT_SLIB +=3D ah
and so on.

The other one uses the same variable for every PF_*SLIB also patch
command  may fail.

--
Attila


>=20
> -
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
