From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] arptables: mcmangle target support
Date: Wed, 28 Jan 2009 16:07:15 +0100
Message-ID: <498074A3.2050406@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040302010500050402070703"
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58994 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751120AbZA1PHY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Jan 2009 10:07:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040302010500050402070703
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------040302010500050402070703
Content-Type: text/x-diff;
 name="arptables-ext.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="arptables-ext.patch"

Index: arptables-v0.0.3-3/extensions/Makefile
===================================================================
--- arptables-v0.0.3-3.orig/extensions/Makefile	2008-12-28 17:47:57.000000000 +0100
+++ arptables-v0.0.3-3/extensions/Makefile	2008-12-28 17:48:01.000000000 +0100
@@ -1,6 +1,6 @@
 #! /usr/bin/make
 
-EXT_FUNC+=standard mangle
+EXT_FUNC+=standard mangle mcmangle
 EXT_OBJS+=$(foreach T,$(EXT_FUNC), extensions/arpt_$(T).o)
 
 extensions/ebt_%.o: extensions/arpt_%.c include/arptables.h include/arptables_common.h
Index: arptables-v0.0.3-3/extensions/arpt_mcmangle.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ arptables-v0.0.3-3/extensions/arpt_mcmangle.c	2008-12-30 13:42:18.000000000 +0100
@@ -0,0 +1,122 @@
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <limits.h>
+#include <getopt.h>
+#include <arptables.h>
+#include <linux/netfilter_arp/arpt_mcmangle.h>
+
+static void help(void)
+{
+	printf(
+"mcmangle target v%s options:\n"
+"--mc-mangle-mac MAC address\n"
+"--mc-mangle-dev interface name\n",
+	ARPTABLES_VERSION);
+}
+
+enum arpt_mcmangle_options {
+	MC_MANGLE_MAC,
+	MC_MANGLE_DEV,
+};
+
+static struct option opts[] = {
+	{ "mc-mangle-mac", required_argument, 0, MC_MANGLE_MAC },
+	{ "mc-mangle-dev", required_argument, 0, MC_MANGLE_DEV },
+	{ NULL }
+};
+
+static void init(struct arpt_entry_target *t) {}
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct arpt_entry *e,
+      struct arpt_entry_target **t)
+{
+	struct arpt_mcmangle *mangle = (struct arpt_mcmangle *)(*t)->data;
+	struct ether_addr *macaddr;
+	int ret = 1;
+
+	switch (c) {
+	case MC_MANGLE_MAC:
+		if (e->arp.arhln_mask == 0)
+			exit_error(PARAMETER_PROBLEM, "no --h-length defined");
+		if (e->arp.invflags & ARPT_INV_ARPHLN)
+			exit_error(PARAMETER_PROBLEM,
+				   "! --h-length not allowed for "
+				   "--mc-mangle-mac");
+		if (e->arp.arhln != 6)
+			exit_error(PARAMETER_PROBLEM, "only --h-length 6 "
+						      "supported");
+		macaddr = ether_aton(argv[optind-1]);
+		if (macaddr == NULL)
+			exit_error(PARAMETER_PROBLEM, "invalid MAC address");
+		if (!(macaddr->ether_addr_octet[0] & 0x01))
+			exit_error(PARAMETER_PROBLEM, "invalid multicast MAC");
+		memcpy(mangle->mc_devaddr, macaddr, e->arp.arhln);
+		*flags |= (1 << MC_MANGLE_MAC);
+		break;
+	case MC_MANGLE_DEV:
+		strncpy(mangle->ifname, optarg, IFNAMSIZ);
+		*flags |= (1 << MC_MANGLE_DEV);
+		break;
+	default:
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static void final_check(unsigned int flags)
+{
+	if (!(flags & (1 << MC_MANGLE_MAC))) {
+		exit_error(PARAMETER_PROBLEM, "missing --mc-mangle-mac");
+	}
+	if (!(flags & (1 << MC_MANGLE_DEV))) {
+		exit_error(PARAMETER_PROBLEM, "missing --mc-mangle-dev");
+	}
+}
+
+static void
+print(const struct arpt_arp *ip,
+      const struct arpt_entry_target *target, int numeric)
+{
+	struct arpt_mcmangle *m = (struct arpt_mcmangle *)(target->data);
+
+	printf("--mc-mangle-mac ");
+	print_mac((unsigned char *)m->mc_devaddr, 6);
+	printf(" --mc-mangle-dev ");
+	printf("%s", m->ifname);
+}
+
+static void
+save(const struct arpt_arp *ip, const struct arpt_entry_target *target)
+{
+	struct arpt_mcmangle *m = (struct arpt_mcmangle *)(target->data);
+
+	printf("--mc-mangle-mac ");
+	print_mac((unsigned char *)m->mc_devaddr, 6);
+	printf(" --mc-mangle-dev ");
+	printf("%s", m->ifname);
+}
+
+static struct arptables_target arpt_mcmangle = {
+	.name		= "mcmangle",
+	.version	= ARPTABLES_VERSION,
+	.size		= ARPT_ALIGN(sizeof(struct arpt_mcmangle)),
+	.userspacesize	= ARPT_ALIGN(offsetof(struct arpt_mcmangle, dev)),
+	.help		= help,
+	.init		= init,
+	.parse		= parse,
+	.final_check	= final_check,
+	.print		= print,
+	.save		= save,
+	.extra_opts	= opts,
+};
+
+static void _init(void) __attribute__ ((constructor));
+static void _init(void)
+{
+	register_target(&arpt_mcmangle);
+}
Index: arptables-v0.0.3-3/include/linux/netfilter_arp/arpt_mcmangle.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ arptables-v0.0.3-3/include/linux/netfilter_arp/arpt_mcmangle.h	2008-12-30 14:01:02.000000000 +0100
@@ -0,0 +1,14 @@
+#ifndef _ARPT_MCMANGLE_H
+#define _ARPT_MCMANGLE_H
+#include <linux/netfilter_arp/arp_tables.h>
+
+struct net_device;
+
+struct arpt_mcmangle
+{
+	char ifname[IFNAMSIZ];
+	char mc_devaddr[ETH_ALEN];
+	struct net_device __attribute__((aligned(8))) *dev;
+};
+
+#endif /* _ARPT_MANGLE_H */
Index: arptables-v0.0.3-3/include/arptables_common.h
===================================================================
--- arptables-v0.0.3-3.orig/include/arptables_common.h	2008-12-28 18:21:10.000000000 +0100
+++ arptables-v0.0.3-3/include/arptables_common.h	2008-12-28 18:21:19.000000000 +0100
@@ -1,6 +1,9 @@
 #ifndef _ARPTABLES_COMMON_H
 #define _ARPTABLES_COMMON_H
 
+#undef offsetof
+#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+
 enum exittype {
 	OTHER_PROBLEM = 1,
 	PARAMETER_PROBLEM,

--------------040302010500050402070703--
