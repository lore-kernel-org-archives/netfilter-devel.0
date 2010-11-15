From: Frederic Leroy <fredo@starox.org>
Subject: [PATCH] netfilter: xtables: add arp support, allow CLASSIFY target
 on any table
Date: Mon, 15 Nov 2010 13:28:36 +0100
Message-ID: <20101115132836.505b4b58@caresse>
References: <20101107152636.56f62235@caresse>
	<alpine.LNX.2.01.1011071616150.21289@obet.zrqbmnf.qr>
	<4CD959D6.1090705@trash.net>
	<20101109161047.GB25549@sd-11162.dedibox.fr>
	<4CD98746.4050100@pandora.be>
	<20101109211834.4da8e412@caresse>
	<alpine.LNX.2.01.1011092121210.10710@obet.zrqbmnf.qr>
	<20101109215126.502a155e@caresse>
	<4CDBC7B1.2020101@trash.net>
	<20101111124505.345643a3@caresse>
	<4CDCF1A7.2050402@trash.net>
	<20101113162934.768e4a3c@caresse>
	<4CE10F29.4010103@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Bart De Schuymer <bdschuym@pandora.be>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-11162.dedibox.fr ([88.191.70.230]:37699 "EHLO
	sd-11162.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088Ab0KOM2u convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 07:28:50 -0500
In-Reply-To: <4CE10F29.4010103@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Fr=C3=A9d=C3=A9ric Leroy <fredo@starox.org>
---
 net/netfilter/xt_CLASSIFY.c |   36 ++++++++++++++++++++++++-----------=
-
 1 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index c2c0e4a..af9c4da 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -19,12 +19,14 @@
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_CLASSIFY.h>
+#include <linux/netfilter_arp.h>
=20
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Xtables: Qdisc classification");
 MODULE_ALIAS("ipt_CLASSIFY");
 MODULE_ALIAS("ip6t_CLASSIFY");
+MODULE_ALIAS("arpt_CLASSIFY");
=20
 static unsigned int
 classify_tg(struct sk_buff *skb, const struct xt_action_param *par)
@@ -35,26 +37,36 @@ classify_tg(struct sk_buff *skb, const struct xt_ac=
tion_param *par)
 	return XT_CONTINUE;
 }
=20
-static struct xt_target classify_tg_reg __read_mostly =3D {
-	.name       =3D "CLASSIFY",
-	.revision   =3D 0,
-	.family     =3D NFPROTO_UNSPEC,
-	.table      =3D "mangle",
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
+	return xt_register_targets(classify_tg_reg, ARRAY_SIZE(classify_tg_re=
g));
 }
=20
 static void __exit classify_tg_exit(void)
 {
-	xt_unregister_target(&classify_tg_reg);
+	xt_unregister_targets(classify_tg_reg, ARRAY_SIZE(classify_tg_reg));
 }
=20
 module_init(classify_tg_init);
--=20
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
