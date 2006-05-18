From: James Morris <jmorris@namei.org>
Subject: [PATCH 05/05] secmark: Add libip6t_CONNSECMARK
Date: Thu, 18 May 2006 11:42:35 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0605181141500.3010@d.namei>
References: <Pine.LNX.4.64.0605181130560.3010@d.namei>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Stephen Smalley <sds@tycho.nsa.gov>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <Pine.LNX.4.64.0605181130560.3010@d.namei>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This patch adds the shared library module for the CONNSECMARK target 
(IPv6).

Signed-off-by: James Morris <jmorris@namei.org>

---

 extensions/Makefile                |    2 
 extensions/libip6t_CONNSECMARK.c   |  124 +++++++++++++++++++++++++++++++++++++
 extensions/libip6t_CONNSECMARK.man |   15 ++++
 3 files changed, 140 insertions(+), 1 deletion(-)

diff -purN -X dontdiff iptables.p/extensions/libip6t_CONNSECMARK.c iptables.w/extensions/libip6t_CONNSECMARK.c
--- iptables.p/extensions/libip6t_CONNSECMARK.c	1969-12-31 19:00:00.000000000 -0500
+++ iptables.w/extensions/libip6t_CONNSECMARK.c	2006-05-17 23:27:41.000000000 -0400
@@ -0,0 +1,124 @@
+/*
+ * Shared library add-on to ip6tables to add CONNSECMARK target support.
+ *
+ * Based on the MARK and CONNMARK targets.
+ *
+ * Copyright (C) 2006 Red Hat, Inc., James Morris <jmorris@redhat.com>
+ */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <ip6tables.h>
+#include <linux/netfilter/xt_CONNSECMARK.h>
+
+#define PFX "CONNSECMARK target: "
+
+static void help(void)
+{
+	printf(
+"CONNSECMARK target v%s options:\n"
+"  --save                   Copy security mark from packet to conntrack\n"
+"  --restore                Copy security mark from connection to packet\n"
+"\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "save", 0, 0, '1' },
+	{ "restore", 0, 0, '2' },
+	{ 0 }
+};
+
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+                 const struct ip6t_entry *entry, struct ip6t_entry_target **target)
+{
+	struct xt_connsecmark_target_info *info =
+		(struct xt_connsecmark_target_info*)(*target)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags & CONNSECMARK_SAVE)
+			exit_error(PARAMETER_PROBLEM, PFX
+				   "Can't specify --save twice");
+		info->mode = CONNSECMARK_SAVE;
+		*flags |= CONNSECMARK_SAVE;
+		break;
+
+	case '2':
+		if (*flags & CONNSECMARK_RESTORE)
+			exit_error(PARAMETER_PROBLEM, PFX
+				   "Can't specify --restore twice");
+		info->mode = CONNSECMARK_RESTORE;
+		*flags |= CONNSECMARK_RESTORE;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM, PFX "parameter required");
+
+	if (flags == (CONNSECMARK_SAVE|CONNSECMARK_RESTORE))
+		exit_error(PARAMETER_PROBLEM, PFX "only one flag of --save "
+		           "or --restore is allowed");
+}
+
+static void print_connsecmark(struct xt_connsecmark_target_info *info)
+{
+	switch (info->mode) {
+	case CONNSECMARK_SAVE:
+		printf("save ");
+		break;
+		
+	case CONNSECMARK_RESTORE:
+		printf("restore ");
+		break;
+		
+	default:
+		exit_error(OTHER_PROBLEM, PFX "invalid mode %hhu\n", info->mode);
+	}
+}
+
+static void print(const struct ip6t_ip6 *ip,
+		  const struct ip6t_entry_target *target, int numeric)
+{
+	struct xt_connsecmark_target_info *info =
+		(struct xt_connsecmark_target_info*)(target)->data;
+
+	printf("CONNSECMARK ");
+	print_connsecmark(info);
+}
+
+static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_target *target)
+{
+	struct xt_connsecmark_target_info *info =
+		(struct xt_connsecmark_target_info*)target->data;
+
+	printf("--");
+	print_connsecmark(info);
+}
+
+static struct ip6tables_target connsecmark = {
+	.name		= "CONNSECMARK",
+	.version	= IPTABLES_VERSION,
+	.size		= IP6T_ALIGN(sizeof(struct xt_connsecmark_target_info)),
+	.userspacesize	= IP6T_ALIGN(sizeof(struct xt_connsecmark_target_info)),
+	.parse		= &parse,
+	.help		= &help,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	register_target6(&connsecmark);
+}
diff -purN -X dontdiff iptables.p/extensions/libip6t_CONNSECMARK.man iptables.w/extensions/libip6t_CONNSECMARK.man
--- iptables.p/extensions/libip6t_CONNSECMARK.man	1969-12-31 19:00:00.000000000 -0500
+++ iptables.w/extensions/libip6t_CONNSECMARK.man	2006-05-17 23:23:25.000000000 -0400
@@ -0,0 +1,15 @@
+This module copies security markings from packets to connections
+(if unlabeled), and from connections back to packets (also only
+if unlabeled).  Typically used in conjunction with SECMARK, it is
+only valid in the
+.B mangle
+table.
+.TP
+.B --save
+If the packet has a security marking, copy it to the connection
+if the connection is not marked.
+.TP
+.B --restore
+If the packet does not have a security marking, and the connection
+does, copy the security marking from the connection to the packet.
+
diff -purN -X dontdiff iptables.p/extensions/Makefile iptables.w/extensions/Makefile
--- iptables.p/extensions/Makefile	2006-05-17 23:26:30.000000000 -0400
+++ iptables.w/extensions/Makefile	2006-05-17 23:25:37.000000000 -0400
@@ -10,7 +10,7 @@ PF6_EXT_SLIB:=connmark eui64 hl icmp6 le
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=SECMARK CONNSECMARK
-PF6_EXT_SE_SLIB:=SECMARK
+PF6_EXT_SE_SLIB:=SECMARK CONNSECMARK
 endif
 
 # Optionals
