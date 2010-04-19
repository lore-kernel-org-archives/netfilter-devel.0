From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] extensions: add support for xt_TEE
Date: Mon, 19 Apr 2010 14:48:41 +0200
Message-ID: <1271681322-29994-2-git-send-email-jengelh@medozas.de>
References: <1271681322-29994-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40405 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712Ab0DSMsp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Apr 2010 08:48:45 -0400
In-Reply-To: <1271681322-29994-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xt_TEE is firstly included in Linux 2.6.35.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_TEE.c           |  202 ++++++++++++++++++++++++++++++=
++++++++
 extensions/libxt_TEE.man         |   12 +++
 include/linux/netfilter/xt_TEE.h |    9 ++
 3 files changed, 223 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libxt_TEE.c
 create mode 100644 extensions/libxt_TEE.man
 create mode 100644 include/linux/netfilter/xt_TEE.h

diff --git a/extensions/libxt_TEE.c b/extensions/libxt_TEE.c
new file mode 100644
index 0000000..f8e7fd1
--- /dev/null
+++ b/extensions/libxt_TEE.c
@@ -0,0 +1,202 @@
+/*
+ *	"TEE" target extension for iptables
+ *	Copyright =C2=A9 Sebastian Cla=C3=9Fen <sebastian.classen [at] free=
net.ag>, 2007
+ *	Jan Engelhardt <jengelh [at] medozas de>, 2007 - 2010
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License; either
+ *	version 2 of the License, or any later version, as published by the
+ *	Free Software Foundation.
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
+#include <linux/netfilter.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_TEE.h>
+
+enum {
+	FLAG_GATEWAY =3D 1 << 0,
+	FLAG_OIF     =3D 1 << 1,
+};
+
+static const struct option tee_tg_opts[] =3D {
+	{.name =3D "gateway", .has_arg =3D true, .val =3D 'g'},
+	{.name =3D "oif",     .has_arg =3D true, .val =3D 'o'},
+	{NULL},
+};
+
+static void tee_tg_help(void)
+{
+	printf(
+"TEE target options:\n"
+"  --gateway IPADDR    Route packet via the gateway given by address\n=
"
+"  --oif NAME          Include oif in route calculation\n"
+"\n");
+}
+
+static int tee_tg_parse(int c, char **argv, int invert, unsigned int *=
flags,
+                        const void *entry, struct xt_entry_target **ta=
rget)
+{
+	struct xt_tee_tginfo *info =3D (void *)(*target)->data;
+	const struct in_addr *ia;
+
+	switch (c) {
+	case 'g':
+		if (*flags & FLAG_GATEWAY)
+			xtables_error(PARAMETER_PROBLEM,
+			           "Cannot specify --gateway more than once");
+
+		ia =3D xtables_numeric_to_ipaddr(optarg);
+		if (ia =3D=3D NULL)
+			xtables_error(PARAMETER_PROBLEM,
+			           "Invalid IP address %s", optarg);
+
+		memcpy(&info->gw, ia, sizeof(*ia));
+		*flags |=3D FLAG_GATEWAY;
+		return true;
+	case 'o':
+		if (*flags & FLAG_OIF)
+			xtables_error(PARAMETER_PROBLEM,
+				"Cannot specify --oif more than once");
+		if (strlen(optarg) >=3D sizeof(info->oif))
+			xtables_error(PARAMETER_PROBLEM,
+				"oif name too long");
+		strcpy(info->oif, optarg);
+		*flags |=3D FLAG_OIF;
+		return true;
+	}
+
+	return false;
+}
+
+static int tee_tg6_parse(int c, char **argv, int invert, unsigned int =
*flags,
+                         const void *entry, struct xt_entry_target **t=
arget)
+{
+	struct xt_tee_tginfo *info =3D (void *)(*target)->data;
+	const struct in6_addr *ia;
+
+	switch (c) {
+	case 'g':
+		if (*flags & FLAG_GATEWAY)
+			xtables_error(PARAMETER_PROBLEM,
+			           "Cannot specify --gateway more than once");
+
+		ia =3D xtables_numeric_to_ip6addr(optarg);
+		if (ia =3D=3D NULL)
+			xtables_error(PARAMETER_PROBLEM,
+			           "Invalid IP address %s", optarg);
+
+		memcpy(&info->gw, ia, sizeof(*ia));
+		*flags |=3D FLAG_GATEWAY;
+		return true;
+	case 'o':
+		if (*flags & FLAG_OIF)
+			xtables_error(PARAMETER_PROBLEM,
+				"Cannot specify --oif more than once");
+		if (strlen(optarg) >=3D sizeof(info->oif))
+			xtables_error(PARAMETER_PROBLEM,
+				"oif name too long");
+		strcpy(info->oif, optarg);
+		*flags |=3D FLAG_OIF;
+		return true;
+	}
+
+	return false;
+}
+
+static void tee_tg_check(unsigned int flags)
+{
+	if (flags =3D=3D 0)
+		xtables_error(PARAMETER_PROBLEM, "TEE target: "
+		           "--gateway parameter required");
+}
+
+static void tee_tg_print(const void *ip, const struct xt_entry_target =
*target,
+                         int numeric)
+{
+	const struct xt_tee_tginfo *info =3D (const void *)target->data;
+
+	if (numeric)
+		printf("TEE gw:%s ", xtables_ipaddr_to_numeric(&info->gw.in));
+	else
+		printf("TEE gw:%s ", xtables_ipaddr_to_anyname(&info->gw.in));
+	if (*info->oif !=3D '\0')
+		printf("oif=3D%s ", info->oif);
+}
+
+static void tee_tg6_print(const void *ip, const struct xt_entry_target=
 *target,
+                          int numeric)
+{
+	const struct xt_tee_tginfo *info =3D (const void *)target->data;
+
+	if (numeric)
+		printf("TEE gw:%s ", xtables_ip6addr_to_numeric(&info->gw.in6));
+	else
+		printf("TEE gw:%s ", xtables_ip6addr_to_anyname(&info->gw.in6));
+	if (*info->oif !=3D '\0')
+		printf("oif=3D%s ", info->oif);
+}
+
+static void tee_tg_save(const void *ip, const struct xt_entry_target *=
target)
+{
+	const struct xt_tee_tginfo *info =3D (const void *)target->data;
+
+	printf("--gateway %s ", xtables_ipaddr_to_numeric(&info->gw.in));
+	if (*info->oif !=3D '\0')
+		printf("--oif %s ", info->oif);
+}
+
+static void tee_tg6_save(const void *ip, const struct xt_entry_target =
*target)
+{
+	const struct xt_tee_tginfo *info =3D (const void *)target->data;
+
+	printf("--gateway %s ", xtables_ip6addr_to_numeric(&info->gw.in6));
+	if (*info->oif !=3D '\0')
+		printf("--oif %s ", info->oif);
+}
+
+static struct xtables_target tee_tg_reg =3D {
+	.name          =3D "TEE",
+	.version       =3D XTABLES_VERSION,
+	.revision      =3D 1,
+	.family        =3D NFPROTO_IPV4,
+	.size          =3D XT_ALIGN(sizeof(struct xt_tee_tginfo)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_tee_tginfo)),
+	.help          =3D tee_tg_help,
+	.parse         =3D tee_tg_parse,
+	.final_check   =3D tee_tg_check,
+	.print         =3D tee_tg_print,
+	.save          =3D tee_tg_save,
+	.extra_opts    =3D tee_tg_opts,
+};
+
+static struct xtables_target tee_tg6_reg =3D {
+	.name          =3D "TEE",
+	.version       =3D XTABLES_VERSION,
+	.revision      =3D 1,
+	.family        =3D NFPROTO_IPV6,
+	.size          =3D XT_ALIGN(sizeof(struct xt_tee_tginfo)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_tee_tginfo)),
+	.help          =3D tee_tg_help,
+	.parse         =3D tee_tg6_parse,
+	.final_check   =3D tee_tg_check,
+	.print         =3D tee_tg6_print,
+	.save          =3D tee_tg6_save,
+	.extra_opts    =3D tee_tg_opts,
+};
+
+static __attribute__((constructor)) void tee_tg_ldr(void)
+{
+	xtables_register_target(&tee_tg_reg);
+	xtables_register_target(&tee_tg6_reg);
+}
diff --git a/extensions/libxt_TEE.man b/extensions/libxt_TEE.man
new file mode 100644
index 0000000..456d150
--- /dev/null
+++ b/extensions/libxt_TEE.man
@@ -0,0 +1,12 @@
+The \fBTEE\fP target will clone a packet and redirect this clone to an=
other
+machine on the \fBlocal\fP network segment. In other words, the nextho=
p
+must be the target, or you will have to configure the nexthop to forwa=
rd it
+further if so desired.
+.TP
+\fB\-\-gateway\fP \fIipaddr\fP
+Send the cloned packet to the host reachable at the given IP address.
+Use of 0.0.0.0 (for IPv4 packets) or :: (IPv6) is invalid.
+.PP
+To forward all incoming traffic on eth0 to an Network Layer logging bo=
x:
+.PP
+\-t mangle \-A PREROUTING \-i eth0 \-j TEE \-\-gateway 2001:db8::1
diff --git a/include/linux/netfilter/xt_TEE.h b/include/linux/netfilter=
/xt_TEE.h
new file mode 100644
index 0000000..55d4a50
--- /dev/null
+++ b/include/linux/netfilter/xt_TEE.h
@@ -0,0 +1,9 @@
+#ifndef _XT_TEE_TARGET_H
+#define _XT_TEE_TARGET_H
+
+struct xt_tee_tginfo {
+	union nf_inet_addr gw;
+	char oif[16];
+};
+
+#endif /* _XT_TEE_TARGET_H */
--=20
1.7.0.5

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
