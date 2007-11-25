From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: IPT [PATCH 4/4] libxt_gateway
Date: Sun, 25 Nov 2007 20:08:58 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711252008410.9477@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711252007320.9477@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, azez@ufomechanic.net
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38207 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbXKYTJA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 14:09:00 -0500
In-Reply-To: <Pine.LNX.4.64.0711252007320.9477@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Import libxt_gateway into iptables

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Cc: <azez@ufomechanic.net>

---
 extensions/Makefile                  |    2=20
 extensions/libxt_gateway.c           |  161 ++++++++++++++++++++++++++=
+++++++++
 extensions/libxt_gateway.man         |    9 +
 include/linux/netfilter/xt_gateway.h |   19 ++++
 4 files changed, 190 insertions(+), 1 deletion(-)

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
Y CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TEE TCPOPTSTRIP TRACE
+PFX_EXT_SLIB:=3Dconnbytes connmark connlimit comment dccp dscp esp gat=
eway hashlimit helper length limit mac mark multiport owner physdev pkt=
type quota sctp state statistic standard string tcp tcpmss time u32 udp=
 CLASSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TEE TCPOPTSTR=
IP TRACE
=20
 PF_EXT_SELINUX_SLIB:=3D
 PF6_EXT_SELINUX_SLIB:=3D
Index: iptables-modules/extensions/libxt_gateway.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables-modules/extensions/libxt_gateway.c
@@ -0,0 +1,161 @@
+/*
+ * Shared library add-on to iptables to add gateway IP address matchin=
g support.
+ * Based on iprange.
+ * Copyright (C) UFO Mechanic <azez@ufomechanic.net>
+ * Copyright =C2=A9 CC Computer Consultants GmbH, 2007
+ * Contact: Jan Engelhardt <jengelh@computergmbh.de>
+ */
+#include <sys/types.h>
+#include <getopt.h>
+#include <netdb.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <xtables.h>
+#include <iptables.h>
+#include <linux/netfilter/xt_gateway.h>
+
+enum {
+	FLAG_GATEWAY =3D 1 << 0,
+	FLAG_NEXTHOP =3D 1 << 1,
+};
+
+static const struct option gateway_mt_opts[] =3D {
+	{.name =3D "gateway", .has_arg =3D true, .val =3D 'g'},
+	{.name =3D "nexthop", .has_arg =3D true, .val =3D 'n'},
+	{},
+};
+
+static void gateway_mt_help(void)
+{
+	printf(
+		"gateway match v%s options:\n"
+		"[!] --gateway ip        Match IP address of routed gateway\n"
+		"[!] --nexthop ip        Match IP address of next hop\n"
+		"\n",
+		IPTABLES_VERSION);
+}
+
+static int gateway_mt_parse(int c, char **argv, int invert,
+                            unsigned int *flags, const void *entry,
+                            struct xt_entry_match **match)
+{
+	struct xt_gateway_match_info *info =3D (void *)(*match)->data;
+	struct in_addr *ip;
+
+	switch (c) {
+	case 'g':
+		if (*flags & FLAG_GATEWAY)
+			exit_error(PARAMETER_PROBLEM, "gateway match: Cannot"
+			           "specify --gateway more than once");
+		if (*flags & FLAG_NEXTHOP)
+			exit_error(PARAMETER_PROBLEM, "gateway match: You "
+			           "cannot specify both --gateway and "
+			           "--nexthop");
+
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			info->flags |=3D XT_GATEWAY_INVERT;
+
+		ip =3D dotted_to_addr(optarg);
+		if (ip =3D=3D NULL)
+			exit_error(PARAMETER_PROBLEM, "gateway match: Bad IP "
+			           "address \"%s\"\n", optarg);
+
+		info->gateway_v4 =3D ip->s_addr;
+		info->flags |=3D XT_GATEWAY_ROUTE;
+		*flags |=3D FLAG_GATEWAY;
+		return true;
+
+	case 'n':
+		if (*flags & FLAG_NEXTHOP)
+			exit_error(PARAMETER_PROBLEM, "gateway match: Cannot"
+			           "specify --nexthop more than once");
+		if (*flags & FLAG_GATEWAY)
+			exit_error(PARAMETER_PROBLEM, "gateway match: You "
+			           "cannot specify both --gateway and "
+			           "--nexthop");
+
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			info->flags |=3D XT_GATEWAY_INVERT;
+
+		ip =3D dotted_to_addr(optarg);
+		if (ip =3D=3D NULL)
+			exit_error(PARAMETER_PROBLEM, "gateway match: Bad IP "
+			           "address \"%s|'\n", optarg);
+
+		info->gateway_v4 =3D ip->s_addr;
+		info->flags &=3D ~XT_GATEWAY_ROUTE;
+		*flags |=3D FLAG_NEXTHOP;
+		return true;
+	}
+
+	return false;
+}
+
+static void gateway_mt_check(unsigned int flags)
+{
+	if (flags =3D=3D 0)
+		exit_error(PARAMETER_PROBLEM, "gateway match: --gateway or "
+		           "--nexthop parameter required");
+}
+
+static void
+gateway_mt_print(const void *ip, const struct xt_entry_match *match,
+                 int numeric)
+{
+	const struct xt_gateway_match_info *info =3D (const void *)match->dat=
a;
+	struct in_addr a;
+
+	a.s_addr =3D info->gateway_v4;
+
+	if (info->flags & XT_GATEWAY_ROUTE)
+		printf("gateway ");
+	else
+		printf("nexthop ");
+
+	if (info->flags & XT_GATEWAY_INVERT)
+		printf("! ");
+
+	printf("%s", addr_to_dotted(&a));
+}
+
+static void gateway_mt_save(const void *ip, const struct xt_entry_matc=
h *match)
+{
+	const struct xt_gateway_match_info *info =3D (const void *)match->dat=
a;
+	struct in_addr a;
+
+	a.s_addr =3D info->gateway_v4;
+
+	if (info->flags & XT_GATEWAY_INVERT)
+		printf("! ");
+
+	if (info->flags & XT_GATEWAY_ROUTE)
+		printf("--gateway ");
+	else
+		printf("--nexthop ");
+
+	printf("%s ", addr_to_dotted(&a));
+}
+
+static struct xtables_match gateway_mt_reg =3D {
+	.name		=3D "gateway",
+	.family         =3D AF_INET,
+	.version	=3D IPTABLES_VERSION,
+	.size		=3D XT_ALIGN(sizeof(struct xt_gateway_match_info)),
+	.userspacesize	=3D XT_ALIGN(sizeof(struct xt_gateway_match_info)),
+	.help		=3D gateway_mt_help,
+	.parse		=3D gateway_mt_parse,
+	.final_check	=3D gateway_mt_check,
+	.print		=3D gateway_mt_print,
+	.save		=3D gateway_mt_save,
+	.extra_opts	=3D gateway_mt_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&gateway_mt_reg);
+}
Index: iptables-modules/extensions/libxt_gateway.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables-modules/extensions/libxt_gateway.man
@@ -0,0 +1,9 @@
+This matches the gateway by IP address on routed packets. It does not =
mach
+packets that are not routed, or which are directly addresses to the ga=
teway.
+.TP
+[\fB!\fR] \fB--gateway\fR \fIaddress\fR
+Matches if the packet is routed to a gateway with the specified IP add=
ress.
+.TP
+[\fB!\fR] \fB--nexthop\fR \fIaddress\fR
+Matches if the packet is being directed to the specified IP address
+either directly or as a route.
Index: iptables-modules/include/linux/netfilter/xt_gateway.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables-modules/include/linux/netfilter/xt_gateway.h
@@ -0,0 +1,19 @@
+#ifndef _XT_GATEWAY_H
+#define _XT_GATEWAY_H
+
+enum {
+	/* Negate the condition */
+	XT_GATEWAY_INVERT =3D 1 << 0,
+	/* and the gateway is not the final hop */
+	XT_GATEWAY_ROUTE  =3D 1 << 1,
+};
+
+struct xt_gateway_match_info {
+	union {
+		__be32 gateway_v4;
+		__be32 gateway_v6[4];
+	};
+	u_int8_t flags;
+};
+
+#endif /* _XT_GATEWAY_H */
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
