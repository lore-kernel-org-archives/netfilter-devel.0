From: Frederic Leroy <fredo@starox.org>
Subject: Re: [arptables] rfc: add classify target
Date: Tue, 9 Nov 2010 21:51:26 +0100
Message-ID: <20101109215126.502a155e@caresse>
References: <20101107152636.56f62235@caresse>
	<alpine.LNX.2.01.1011071616150.21289@obet.zrqbmnf.qr>
	<4CD959D6.1090705@trash.net>
	<20101109161047.GB25549@sd-11162.dedibox.fr>
	<4CD98746.4050100@pandora.be>
	<20101109211834.4da8e412@caresse>
	<alpine.LNX.2.01.1011092121210.10710@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/qDc.q3IUuaAxUy7Pb7oxje9"
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-11162.dedibox.fr ([88.191.70.230]:41587 "EHLO
	sd-11162.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab0KIUud (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:50:33 -0500
In-Reply-To: <alpine.LNX.2.01.1011092121210.10710@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--MP_/qDc.q3IUuaAxUy7Pb7oxje9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le Tue, 9 Nov 2010 21:28:09 +0100 (CET),
Jan Engelhardt <jengelh@medozas.de> a =C3=A9crit :

> Alas, when I originally coded NFPROTO_UNSPEC wildcard support,
> I allowed for same-rev overloading, as in:
>=20
> static struct xt_target classify_tg_reg[] __read_mostly =3D {
> 	{
> [...]
> };
>=20

Here is a patch against my previous patch with your insights.
I had time to test it.=20

--=20
Fr=C3=A9d=C3=A9ric Leroy

--MP_/qDc.q3IUuaAxUy7Pb7oxje9
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=xt_CLASSIFY.arp_table.patch

commit fdf76e03e17b7d4cd5a160ee3a5b005859eff2fd
Author: Fr=C3=A9d=C3=A9ric Leroy <fredo@starox.org>
Date:   Tue Nov 9 21:46:29 2010 +0100

    netfilter: xtables: allow xt_CLASSIFY for arp tables

diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index eb7057a..add7435 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -19,6 +19,7 @@
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_CLASSIFY.h>
+#include <linux/netfilter_arp.h>
=20
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_LICENSE("GPL");
@@ -35,25 +36,37 @@ classify_tg(struct sk_buff *skb, const struct xt_action=
_param *par)
 	return XT_CONTINUE;
 }
=20
-static struct xt_target classify_tg_reg __read_mostly =3D {
-	.name       =3D "CLASSIFY",
-	.revision   =3D 0,
-	.family     =3D NFPROTO_UNSPEC,
-	.hooks      =3D (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_FORWARD) |
-		      (1 << NF_INET_POST_ROUTING),
-	.target     =3D classify_tg,
-	.targetsize =3D sizeof(struct xt_classify_target_info),
-	.me         =3D THIS_MODULE,
+static struct xt_target classify_tg_reg[] __read_mostly =3D {
+	{
+		.name       =3D "CLASSIFY",
+		.revision   =3D 0,
+		.family     =3D NFPROTO_UNSPEC,
+		.table      =3D "mangle",
+		.hooks      =3D (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_FORWARD) |
+		              (1 << NF_INET_POST_ROUTING),
+		.target     =3D classify_tg,
+		.targetsize =3D sizeof(struct xt_classify_target_info),
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "CLASSIFY",
+		.revision   =3D 0,
+		.family     =3D NFPROTO_ARP,
+		.hooks      =3D (1 << NF_ARP_OUT) | (1 << NF_ARP_FORWARD),
+		.target     =3D classify_tg,
+		.targetsize =3D sizeof(struct xt_classify_target_info),
+		.me         =3D THIS_MODULE,
+	},
 };
=20
 static int __init classify_tg_init(void)
 {
-	return xt_register_target(&classify_tg_reg);
+	return xt_register_targets(classify_tg_reg, ARRAY_SIZE(classify_tg_reg));
 }
=20
 static void __exit classify_tg_exit(void)
 {
-	xt_unregister_target(&classify_tg_reg);
+	xt_unregister_targets(classify_tg_reg, ARRAY_SIZE(classify_tg_reg));
 }
=20
 module_init(classify_tg_init);

--MP_/qDc.q3IUuaAxUy7Pb7oxje9--
