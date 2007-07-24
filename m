From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 02/13] Unifies libip[6]t_CONNSECMARK into libxt_CONNSECMARK
Date: Tue, 24 Jul 2007 15:58:01 +0900 (JST)
Message-ID: <200707240658.l6O6w1hB010140@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: kaber@trash.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


 extensions/Makefile                                |    6 +-
 extensions/libip6t_CONNSECMARK.c                   |  124 --------------------
 .../{libipt_CONNSECMARK.c => libxt_CONNSECMARK.c}  |   30 ++++-
 include/linux/netfilter/xt_CONNSECMARK.h           |   13 ++
 4 files changed, 40 insertions(+), 133 deletions(-)
 delete mode 100644 extensions/libip6t_CONNSECMARK.c
 rename extensions/{libipt_CONNSECMARK.c => libxt_CONNSECMARK.c} (78%)
 create mode 100644 include/linux/netfilter/xt_CONNSECMARK.h

diff --git a/extensions/Makefile b/extensions/Makefile
index 7956dbd..d495725 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -10,9 +10,9 @@ PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 owner policy state HL LOG MARK T
 PFX_EXT_SLIB:=comment dscp esp length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp CONNMARK NFQUEUE NOTRACK TCPMSS
 
 ifeq ($(DO_SELINUX), 1)
-PF_EXT_SE_SLIB:=CONNSECMARK
-PF6_EXT_SE_SLIB:=CONNSECMARK
-PFX_EXT_SE_SLIB:=SECMARK 
+PF_EXT_SE_SLIB:=
+PF6_EXT_SE_SLIB:=
+PFX_EXT_SE_SLIB:=CONNSECMARK SECMARK
 endif
 
 # Optionals
diff --git a/extensions/libip6t_CONNSECMARK.c b/extensions/libip6t_CONNSECMARK.c
deleted file mode 100644
index 805492c..0000000
--- a/extensions/libip6t_CONNSECMARK.c
+++ /dev/null
@@ -1,124 +0,0 @@
-/*
- * Shared library add-on to ip6tables to add CONNSECMARK target support.
- *
- * Based on the MARK and CONNMARK targets.
- *
- * Copyright (C) 2006 Red Hat, Inc., James Morris <jmorris@redhat.com>
- */
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <ip6tables.h>
-#include <linux/netfilter/xt_CONNSECMARK.h>
-
-#define PFX "CONNSECMARK target: "
-
-static void help(void)
-{
-	printf(
-"CONNSECMARK target v%s options:\n"
-"  --save                   Copy security mark from packet to conntrack\n"
-"  --restore                Copy security mark from connection to packet\n"
-"\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "save", 0, 0, '1' },
-	{ "restore", 0, 0, '2' },
-	{ 0 }
-};
-
-static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const void *entry, struct xt_entry_target **target)
-{
-	struct xt_connsecmark_target_info *info =
-		(struct xt_connsecmark_target_info*)(*target)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & CONNSECMARK_SAVE)
-			exit_error(PARAMETER_PROBLEM, PFX
-				   "Can't specify --save twice");
-		info->mode = CONNSECMARK_SAVE;
-		*flags |= CONNSECMARK_SAVE;
-		break;
-
-	case '2':
-		if (*flags & CONNSECMARK_RESTORE)
-			exit_error(PARAMETER_PROBLEM, PFX
-				   "Can't specify --restore twice");
-		info->mode = CONNSECMARK_RESTORE;
-		*flags |= CONNSECMARK_RESTORE;
-		break;
-
-	default:
-		return 0;
-	}
-
-	return 1;
-}
-
-static void final_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM, PFX "parameter required");
-
-	if (flags == (CONNSECMARK_SAVE|CONNSECMARK_RESTORE))
-		exit_error(PARAMETER_PROBLEM, PFX "only one flag of --save "
-		           "or --restore is allowed");
-}
-
-static void print_connsecmark(struct xt_connsecmark_target_info *info)
-{
-	switch (info->mode) {
-	case CONNSECMARK_SAVE:
-		printf("save ");
-		break;
-		
-	case CONNSECMARK_RESTORE:
-		printf("restore ");
-		break;
-		
-	default:
-		exit_error(OTHER_PROBLEM, PFX "invalid mode %hhu\n", info->mode);
-	}
-}
-
-static void print(const void *ip,
-		  const struct xt_entry_target *target, int numeric)
-{
-	struct xt_connsecmark_target_info *info =
-		(struct xt_connsecmark_target_info*)(target)->data;
-
-	printf("CONNSECMARK ");
-	print_connsecmark(info);
-}
-
-static void save(const void *ip, const struct xt_entry_target *target)
-{
-	struct xt_connsecmark_target_info *info =
-		(struct xt_connsecmark_target_info*)target->data;
-
-	printf("--");
-	print_connsecmark(info);
-}
-
-static struct ip6tables_target connsecmark = {
-	.name		= "CONNSECMARK",
-	.version	= IPTABLES_VERSION,
-	.size		= IP6T_ALIGN(sizeof(struct xt_connsecmark_target_info)),
-	.userspacesize	= IP6T_ALIGN(sizeof(struct xt_connsecmark_target_info)),
-	.parse		= &parse,
-	.help		= &help,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
-};
-
-void _init(void)
-{
-	register_target6(&connsecmark);
-}
diff --git a/extensions/libipt_CONNSECMARK.c b/extensions/libxt_CONNSECMARK.c
similarity index 78%
rename from extensions/libipt_CONNSECMARK.c
rename to extensions/libxt_CONNSECMARK.c
index bb6fb28..4527503 100644
--- a/extensions/libipt_CONNSECMARK.c
+++ b/extensions/libxt_CONNSECMARK.c
@@ -9,7 +9,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter/xt_CONNSECMARK.h>
 
 #define PFX "CONNSECMARK target: "
@@ -105,22 +105,40 @@ static void save(const void *ip, const struct xt_entry_target *target)
 	print_connsecmark(info);
 }
 
-static struct iptables_target connsecmark = {
+static struct xtables_target connsecmark = {
 	.next		= NULL,
+	.family		= AF_INET,
 	.name		= "CONNSECMARK",
 	.version	= IPTABLES_VERSION,
 	.revision	= 0,
-	.size		= IPT_ALIGN(sizeof(struct xt_connsecmark_target_info)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct xt_connsecmark_target_info)),
+	.size		= XT_ALIGN(sizeof(struct xt_connsecmark_target_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_connsecmark_target_info)),
 	.parse		= &parse,
 	.help		= &help,
 	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
-	.extra_opts	= opts
+	.extra_opts	= opts,
+};
+
+static struct xtables_target connsecmark6 = {
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "CONNSECMARK",
+	.version	= IPTABLES_VERSION,
+	.revision	= 0,
+	.size		= XT_ALIGN(sizeof(struct xt_connsecmark_target_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_connsecmark_target_info)),
+	.parse		= &parse,
+	.help		= &help,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts,
 };
 
 void _init(void)
 {
-	register_target(&connsecmark);
+	xtables_register_target(&connsecmark);
+	xtables_register_target(&connsecmark6);
 }
diff --git a/include/linux/netfilter/xt_CONNSECMARK.h b/include/linux/netfilter/xt_CONNSECMARK.h
new file mode 100644
index 0000000..c6bd754
--- /dev/null
+++ b/include/linux/netfilter/xt_CONNSECMARK.h
@@ -0,0 +1,13 @@
+#ifndef _XT_CONNSECMARK_H_target
+#define _XT_CONNSECMARK_H_target
+
+enum {
+	CONNSECMARK_SAVE = 1,
+	CONNSECMARK_RESTORE,
+};
+
+struct xt_connsecmark_target_info {
+	u_int8_t mode;
+};
+
+#endif /*_XT_CONNSECMARK_H_target */
-- 
1.5.2.2
