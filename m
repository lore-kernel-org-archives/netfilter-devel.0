From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: IPT [PATCH 2/4] libxt_TEE
Date: Sun, 25 Nov 2007 20:08:18 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711252007560.9477@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711252007320.9477@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Sebastian Classen <sebastian.classen@freenet.ag>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38199 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbXKYTIT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 14:08:19 -0500
In-Reply-To: <Pine.LNX.4.64.0711252007320.9477@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Import libxt_TEE into iptables

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Sebastian Classen <sebastian.classen@freenet.ag>

---
 extensions/Makefile              |    2=20
 extensions/libxt_TEE.c           |  125 ++++++++++++++++++++++++++++++=
+++++++++
 extensions/libxt_TEE.man         |    6 +
 include/linux/netfilter/xt_TEE.h |   12 +++
 4 files changed, 144 insertions(+), 1 deletion(-)

Index: iptables-modules/extensions/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-modules.orig/extensions/Makefile
+++ iptables-modules/extensions/Makefile
@@ -7,7 +7,7 @@
 #
 PF_EXT_SLIB:=3Dah addrtype conntrack ecn icmp iprange policy realm rec=
ent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETMAP RED=
IRECT REJECT SAME SNAT TOS TTL ULOG
 PF6_EXT_SLIB:=3Dah dst eui64 frag hbh hl icmp6 ipv6header mh policy rt=
 HL LOG REJECT
-PFX_EXT_SLIB:=3Dconnbytes connmark connlimit comment dccp dscp esp has=
hlimit helper length limit mac mark multiport owner physdev pkttype quo=
ta sctp state statistic standard string tcp tcpmss time u32 udp CLASSIF=
Y CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
+PFX_EXT_SLIB:=3Dconnbytes connmark connlimit comment dccp dscp esp has=
hlimit helper length limit mac mark multiport owner physdev pkttype quo=
ta sctp state statistic standard string tcp tcpmss time u32 udp CLASSIF=
Y CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TEE TRACE
=20
 PF_EXT_SELINUX_SLIB:=3D
 PF6_EXT_SELINUX_SLIB:=3D
Index: iptables-modules/extensions/libxt_TEE.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables-modules/extensions/libxt_TEE.c
@@ -0,0 +1,125 @@
+/*
+ * Shared library add-on to iptables to add TEE target support.
+ *
+ * Copyright Sebastian Classen <sebastian.classen@freenet.ag>, 2007
+ *
+ * Copyright =C2=A9 CC Computer Consultants GmbH, 2007
+ * Contact: Jan Engelhardt <jengelh@computergmbh.de>
+ *
+ * Based on ROUTE target with was originaly from:
+ * Cedric de Launois, <delaunois@info.ucl.ac.be>
+ * v 1.0 2007-08-20
+ */
+#include <sys/socket.h>
+#include <getopt.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <arpa/inet.h>
+#include <net/if.h>
+#include <netinet/in.h>
+
+#include <xtables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_TEE.h>
+
+enum {
+	FLAG_GATEWAY =3D 1 << 0,
+};
+
+static const struct option tee_tg_opts[] =3D {
+	{.name =3D "gateway", .has_arg =3D true, .val =3D 'g'},
+	{},
+};
+
+static void tee_tg_help(void)
+{
+	printf(
+"TEE target v%s options:\n"
+"  --gateway IPADDR    Route packet via the gateway given by address\n=
"
+"\n",
+"1.11");
+}
+
+static void tee_tg_init(struct xt_entry_target *target)
+{
+	struct xt_tee_target_info *info =3D (void *)target->data;
+
+	memset(info, 0, sizeof(*info));
+}
+
+static int tee_tg_parse(int c, char **argv, int invert, unsigned int *=
flags,
+                        const void *entry, struct xt_entry_target **ta=
rget)
+{
+	struct xt_tee_target_info *info =3D (void *)(*target)->data;
+
+	switch (c) {
+	case 'g':
+		if (*flags & FLAG_GATEWAY)
+			exit_error(PARAMETER_PROBLEM,
+			           "Cannot specify --gw more than once");
+
+		if (check_inverse(optarg, &invert, NULL, 0))
+			exit_error(PARAMETER_PROBLEM,
+			           "Unexpected \"!\" after --gateway");
+
+		if (!inet_aton(optarg, (void *)&info->gateway_v4))
+			exit_error(PARAMETER_PROBLEM,
+			           "Invalid IP address %s", optarg);
+
+		*flags |=3D FLAG_GATEWAY;
+		return true;
+	}
+
+	return false;
+}
+
+static void tee_tg_check(unsigned int flags)
+{
+	if (flags =3D=3D 0)
+		exit_error(PARAMETER_PROBLEM, "TEE target: "
+		           "--gateway parameter required");
+}
+
+static void tee_tg_print(const void *ip, const struct xt_entry_target =
*target,
+                         int numeric)
+{
+	const struct xt_tee_target_info *info =3D (const void *)target->data;
+
+	printf("TEE ");
+	if (info->gateway_v4 !=3D 0) {
+		struct in_addr ip =3D {info->gateway_v4};
+		printf("gw:%s ", inet_ntoa(ip));
+	}
+}
+
+static void tee_tg_save(const void *ip, const struct xt_entry_target *=
target)
+{
+	const struct xt_tee_target_info *info =3D (const void *)target->data;
+
+	if (info->gateway_v4 !=3D 0) {
+		struct in_addr ip =3D {info->gateway_v4};
+		printf("--gateway %s ", inet_ntoa(ip));
+	}
+}
+
+static struct xtables_target tee_tg_reg =3D {
+	.name          =3D "TEE",
+	.version       =3D IPTABLES_VERSION,
+	.size          =3D XT_ALIGN(sizeof(struct xt_tee_target_info)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_tee_target_info)),
+	.help          =3D tee_tg_help,
+	.init          =3D tee_tg_init,
+	.parse         =3D tee_tg_parse,
+	.final_check   =3D tee_tg_check,
+	.print         =3D tee_tg_print,
+	.save          =3D tee_tg_save,
+	.extra_opts    =3D tee_tg_opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&tee_tg_reg);
+}
Index: iptables-modules/extensions/libxt_TEE.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables-modules/extensions/libxt_TEE.man
@@ -0,0 +1,6 @@
+This is used to explicitly override the core network stack's routing d=
ecision.
+.B mangle
+table.
+.TP
+.BI "--gw " "IP_address"
+Route the packet via this gateway
Index: iptables-modules/include/linux/netfilter/xt_TEE.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables-modules/include/linux/netfilter/xt_TEE.h
@@ -0,0 +1,12 @@
+#ifndef _XT_TEE_TARGET_H
+#define _XT_TEE_TARGET_H
+
+struct xt_tee_target_info {
+	union {
+		/* Address of gateway */
+		u_int32_t gateway_v4;
+		u_int32_t gateway_v6[4];
+	};
+};
+
+#endif /* _XT_TEE_TARGET_H */
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
