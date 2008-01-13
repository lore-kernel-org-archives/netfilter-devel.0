From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [xt_RAWNAT] iptables libxt_RAWNAT
Date: Sun, 13 Jan 2008 17:22:48 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801131712470.21665@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801131648010.21665@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49395 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbYAMQWu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Jan 2008 11:22:50 -0500
In-Reply-To: <Pine.LNX.4.64.0801131648010.21665@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[IPTABLES]: xt_RAWNAT extensions

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/Makefile                 |    2 
 extensions/libxt_RAWDNAT.c          |  176 ++++++++++++++++++++++++++++++++++++
 extensions/libxt_RAWDNAT.man        |   13 ++
 extensions/libxt_RAWSNAT.c          |  176 ++++++++++++++++++++++++++++++++++++
 extensions/libxt_RAWSNAT.man        |   15 +++
 include/linux/netfilter/xt_RAWNAT.h |    9 +
 6 files changed, 391 insertions(+)

Index: iptables-modules/extensions/Makefile
===================================================================
--- iptables-modules.orig/extensions/Makefile
+++ iptables-modules/extensions/Makefile
@@ -53,6 +53,8 @@ PFX_EXT_SLIB += MARK
 PFX_EXT_SLIB += NFLOG
 PFX_EXT_SLIB += NFQUEUE
 PFX_EXT_SLIB += NOTRACK
+PFX_EXT_SLIB += RAWDNAT
+PFX_EXT_SLIB += RAWSNAT
 PFX_EXT_SLIB += TCPMSS
 PFX_EXT_SLIB += TCPOPTSTRIP
 PFX_EXT_SLIB += TOS
Index: iptables-modules/extensions/libxt_RAWDNAT.c
===================================================================
--- /dev/null
+++ iptables-modules/extensions/libxt_RAWDNAT.c
@@ -0,0 +1,176 @@
+#include <netinet/in.h>
+#include <getopt.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <string.h>
+#include <xtables.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/xt_RAWNAT.h>
+
+enum {
+	FLAGS_TO = 1 << 0,
+};
+
+static const struct option rawdnat_tg_opts[] = {
+	{.name = "to-destination", .has_arg = true, .val = 't'},
+	{},
+};
+
+static void rawdnat_tg_help(void)
+{
+	printf(
+"RAWDNAT target options:\n"
+"    --to-destination addr[/mask]    Address or network to map to\n"
+);
+}
+
+static int
+rawdnat_tg4_parse(int c, char **argv, int invert, unsigned int *flags,
+                  const void *entry, struct xt_entry_target **target)
+{
+	struct xt_rawnat_tginfo *info = (void *)(*target)->data;
+	struct in_addr *a;
+	unsigned int mask;
+	char *end;
+
+	switch (c) {
+	case 't':
+		info->mask = 32;
+		end = strchr(optarg, '/');
+		if (end != NULL) {
+			*end++ = '\0';
+			if (!strtonum(end, NULL, &mask, 0, 32))
+				param_act(P_BAD_VALUE, "RAWDNAT",
+				          "--to-destination", optarg);
+			info->mask = mask;
+		}
+		a = numeric_to_ipaddr(optarg);
+		if (a == NULL)
+			param_act(P_BAD_VALUE, "RAWDNAT", "--to-destination",
+			          optarg);
+		memcpy(&info->addr.in, a, sizeof(*a));
+		*flags |= FLAGS_TO;
+		return true;
+	}
+	return false;
+}
+
+static int
+rawdnat_tg6_parse(int c, char **argv, int invert, unsigned int *flags,
+                  const void *entry, struct xt_entry_target **target)
+{
+	struct xt_rawnat_tginfo *info = (void *)(*target)->data;
+	struct in6_addr *a;
+	unsigned int mask;
+	char *end;
+
+	switch (c) {
+	case 't':
+		info->mask = 128;
+		end = strchr(optarg, '/');
+		if (end != NULL) {
+			*end++ = '\0';
+			if (!strtonum(end, NULL, &mask, 0, 32))
+				param_act(P_BAD_VALUE, "RAWDNAT",
+				          "--to-destination", optarg);
+			info->mask = mask;
+		}
+		a = numeric_to_ip6addr(optarg);
+		if (a == NULL)
+			param_act(P_BAD_VALUE, "RAWDNAT", "--to-destination",
+			          optarg);
+		memcpy(&info->addr.in6, a, sizeof(*a));
+		*flags |= FLAGS_TO;
+		return true;
+	}
+	return false;
+}
+
+static void rawdnat_tg_check(unsigned int flags)
+{
+	if (!(flags & FLAGS_TO))
+		exit_error(PARAMETER_PROBLEM, "RAWDNAT: \"--to-destination\" "
+		           "is required.");
+}
+
+static void
+rawdnat_tg4_print(const void *entry, const struct xt_entry_target *target,
+                  int numeric)
+{
+	const struct xt_rawnat_tginfo *info = (const void *)target->data;
+
+	if (!numeric && info->mask == 32)
+		printf("to-destination %s ",
+		       ipaddr_to_anyname(&info->addr.in));
+	else
+		printf("to-destination %s/%u ",
+		       ipaddr_to_numeric(&info->addr.in), info->mask);
+}
+
+static void
+rawdnat_tg6_print(const void *entry, const struct xt_entry_target *target,
+                  int numeric)
+{
+	const struct xt_rawnat_tginfo *info = (const void *)target->data;
+
+	if (!numeric && info->mask == 128)
+		printf("to-destination %s ",
+		       ip6addr_to_anyname(&info->addr.in6));
+	else
+		printf("to-destination %s/%u ",
+		       ip6addr_to_numeric(&info->addr.in6), info->mask);
+}
+
+static void
+rawdnat_tg4_save(const void *entry, const struct xt_entry_target *target)
+{
+	const struct xt_rawnat_tginfo *info = (const void *)target->data;
+
+	printf("--to-destination %s/%u ", ipaddr_to_numeric(&info->addr.in),
+	       info->mask);
+}
+
+static void
+rawdnat_tg6_save(const void *entry, const struct xt_entry_target *target)
+{
+	const struct xt_rawnat_tginfo *info = (const void *)target->data;
+
+	printf("--to-destination %s/%u ", ip6addr_to_numeric(&info->addr.in6),
+	       info->mask);
+}
+
+static struct xtables_target rawdnat_tg4_reg = {
+	.version       = IPTABLES_VERSION,
+	.name          = "RAWDNAT",
+	.revision      = 0,
+	.family        = AF_INET,
+	.size          = XT_ALIGN(sizeof(struct xt_rawnat_tginfo)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_rawnat_tginfo)),
+	.help          = rawdnat_tg_help,
+	.parse         = rawdnat_tg4_parse,
+	.final_check   = rawdnat_tg_check,
+	.print         = rawdnat_tg4_print,
+	.save          = rawdnat_tg4_save,
+	.extra_opts    = rawdnat_tg_opts,
+};
+
+static struct xtables_target rawdnat_tg6_reg = {
+	.version       = IPTABLES_VERSION,
+	.name          = "RAWDNAT",
+	.revision      = 0,
+	.family        = AF_INET6,
+	.size          = XT_ALIGN(sizeof(struct xt_rawnat_tginfo)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_rawnat_tginfo)),
+	.help          = rawdnat_tg_help,
+	.parse         = rawdnat_tg6_parse,
+	.final_check   = rawdnat_tg_check,
+	.print         = rawdnat_tg6_print,
+	.save          = rawdnat_tg6_save,
+	.extra_opts    = rawdnat_tg_opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&rawdnat_tg4_reg);
+	xtables_register_target(&rawdnat_tg6_reg);
+}
Index: iptables-modules/extensions/libxt_RAWDNAT.man
===================================================================
--- /dev/null
+++ iptables-modules/extensions/libxt_RAWDNAT.man
@@ -0,0 +1,13 @@
+The \fBRAWDNAT\fR target will rewrite the destination address in the IP header,
+much like the \fBNETMAP\fR target. \fBRAWDNAT\fR may only be used in the
+\fBraw\fR table, but can be used in all chains, which makes it possible to
+change the source address either when the packet enters the machine or when it
+leaves it.
+.TP
+\fB--to-destination\fR \fIaddr\fR[\fB/\fR\fImask\fR]
+Network address to map to. The resulting address will be constructed the
+following way: All 'one' bits in the \fImask\fR are filled in from the new
+\fIaddress\fR. All bits that are zero in the mask are filled in from the
+original address.
+.PP
+See the \fBRAWSNAT\fR help entry for examples.
Index: iptables-modules/extensions/libxt_RAWSNAT.c
===================================================================
--- /dev/null
+++ iptables-modules/extensions/libxt_RAWSNAT.c
@@ -0,0 +1,176 @@
+#include <netinet/in.h>
+#include <getopt.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <string.h>
+#include <xtables.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/xt_RAWNAT.h>
+
+enum {
+	FLAGS_TO = 1 << 0,
+};
+
+static const struct option rawsnat_tg_opts[] = {
+	{.name = "to-source", .has_arg = true, .val = 't'},
+	{},
+};
+
+static void rawsnat_tg_help(void)
+{
+	printf(
+"RAWSNAT target options:\n"
+"    --to-source addr[/mask]    Address or network to map to\n"
+);
+}
+
+static int
+rawsnat_tg4_parse(int c, char **argv, int invert, unsigned int *flags,
+                  const void *entry, struct xt_entry_target **target)
+{
+	struct xt_rawnat_tginfo *info = (void *)(*target)->data;
+	struct in_addr *a;
+	unsigned int mask;
+	char *end;
+
+	switch (c) {
+	case 't':
+		info->mask = 32;
+		end = strchr(optarg, '/');
+		if (end != NULL) {
+			*end++ = '\0';
+			if (!strtonum(end, NULL, &mask, 0, 32))
+				param_act(P_BAD_VALUE, "RAWSNAT",
+				          "--to-source", optarg);
+			info->mask = mask;
+		}
+		a = numeric_to_ipaddr(optarg);
+		if (a == NULL)
+			param_act(P_BAD_VALUE, "RAWSNAT", "--to-source",
+			          optarg);
+		memcpy(&info->addr.in, a, sizeof(*a));
+		*flags |= FLAGS_TO;
+		return true;
+	}
+	return false;
+}
+
+static int
+rawsnat_tg6_parse(int c, char **argv, int invert, unsigned int *flags,
+                  const void *entry, struct xt_entry_target **target)
+{
+	struct xt_rawnat_tginfo *info = (void *)(*target)->data;
+	struct in6_addr *a;
+	unsigned int mask;
+	char *end;
+
+	switch (c) {
+	case 't':
+		info->mask = 128;
+		end = strchr(optarg, '/');
+		if (end != NULL) {
+			*end++ = '\0';
+			if (!strtonum(end, NULL, &mask, 0, 32))
+				param_act(P_BAD_VALUE, "RAWSNAT",
+				          "--to-source", optarg);
+			info->mask = mask;
+		}
+		a = numeric_to_ip6addr(optarg);
+		if (a == NULL)
+			param_act(P_BAD_VALUE, "RAWSNAT", "--to-source",
+			          optarg);
+		memcpy(&info->addr.in6, a, sizeof(*a));
+		*flags |= FLAGS_TO;
+		return true;
+	}
+	return false;
+}
+
+static void rawsnat_tg_check(unsigned int flags)
+{
+	if (!(flags & FLAGS_TO))
+		exit_error(PARAMETER_PROBLEM, "RAWSNAT: \"--to-source\" "
+		           "is required.");
+}
+
+static void
+rawsnat_tg4_print(const void *entry, const struct xt_entry_target *target,
+                  int numeric)
+{
+	const struct xt_rawnat_tginfo *info = (const void *)target->data;
+
+	if (!numeric && info->mask == 32)
+		printf("to-source %s ",
+		       ipaddr_to_anyname(&info->addr.in));
+	else
+		printf("to-source %s/%u ",
+		       ipaddr_to_numeric(&info->addr.in), info->mask);
+}
+
+static void
+rawsnat_tg6_print(const void *entry, const struct xt_entry_target *target,
+                  int numeric)
+{
+	const struct xt_rawnat_tginfo *info = (const void *)target->data;
+
+	if (!numeric && info->mask == 128)
+		printf("to-source %s ",
+		       ip6addr_to_anyname(&info->addr.in6));
+	else
+		printf("to-source %s/%u ",
+		       ip6addr_to_numeric(&info->addr.in6), info->mask);
+}
+
+static void
+rawsnat_tg4_save(const void *entry, const struct xt_entry_target *target)
+{
+	const struct xt_rawnat_tginfo *info = (const void *)target->data;
+
+	printf("--to-source %s/%u ", ipaddr_to_numeric(&info->addr.in),
+	       info->mask);
+}
+
+static void
+rawsnat_tg6_save(const void *entry, const struct xt_entry_target *target)
+{
+	const struct xt_rawnat_tginfo *info = (const void *)target->data;
+
+	printf("--to-source %s/%u ", ip6addr_to_numeric(&info->addr.in6),
+	       info->mask);
+}
+
+static struct xtables_target rawsnat_tg4_reg = {
+	.version       = IPTABLES_VERSION,
+	.name          = "RAWSNAT",
+	.revision      = 0,
+	.family        = AF_INET,
+	.size          = XT_ALIGN(sizeof(struct xt_rawnat_tginfo)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_rawnat_tginfo)),
+	.help          = rawsnat_tg_help,
+	.parse         = rawsnat_tg4_parse,
+	.final_check   = rawsnat_tg_check,
+	.print         = rawsnat_tg4_print,
+	.save          = rawsnat_tg4_save,
+	.extra_opts    = rawsnat_tg_opts,
+};
+
+static struct xtables_target rawsnat_tg6_reg = {
+	.version       = IPTABLES_VERSION,
+	.name          = "RAWSNAT",
+	.revision      = 0,
+	.family        = AF_INET6,
+	.size          = XT_ALIGN(sizeof(struct xt_rawnat_tginfo)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_rawnat_tginfo)),
+	.help          = rawsnat_tg_help,
+	.parse         = rawsnat_tg6_parse,
+	.final_check   = rawsnat_tg_check,
+	.print         = rawsnat_tg6_print,
+	.save          = rawsnat_tg6_save,
+	.extra_opts    = rawsnat_tg_opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&rawsnat_tg4_reg);
+	xtables_register_target(&rawsnat_tg6_reg);
+}
Index: iptables-modules/extensions/libxt_RAWSNAT.man
===================================================================
--- /dev/null
+++ iptables-modules/extensions/libxt_RAWSNAT.man
@@ -0,0 +1,15 @@
+The \fBRAWSNAT\fR target will rewrite the source address in the IP header, much
+like the \fBNETMAP\fR target. \fBRAWSNAT\fR may only be used in the \fBraw\fR
+table, but can be used in all chains, which makes it possible to change the
+source address either when the packet enters the machine or when it leaves it.
+.TP
+\fB--to-source\fR \fIaddr\fR[\fB/\fR\fImask\fR]
+Network address to map to. The resulting address will be constructed the
+following way: All 'one' bits in the \fImask\fR are filled in from the new
+\fIaddress\fR. All bits that are zero in the mask are filled in from the
+original address.
+.PP
+As an example, changing the destination for a connection:
+.IP
+-t raw -A POSTROUTING -d 12.34.56.78 -j RAWDNAT --to-destination 66.249.93.104
+-t raw -A PREROUTING -s 66.249.93.104 -j RAWSNAT --to-source 12.34.56.78
Index: iptables-modules/include/linux/netfilter/xt_RAWNAT.h
===================================================================
--- /dev/null
+++ iptables-modules/include/linux/netfilter/xt_RAWNAT.h
@@ -0,0 +1,9 @@
+#ifndef _LINUX_NETFILTER_XT_TARGET_RAWNAT
+#define _LINUX_NETFILTER_XT_TARGET_RAWNAT 1
+
+struct xt_rawnat_tginfo {
+	union nf_inet_addr addr;
+	uint8_t mask;
+};
+
+#endif /* _LINUX_NETFILTER_XT_TARGET_RAWNAT */
