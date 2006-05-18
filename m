From: James Morris <jmorris@namei.org>
Subject: [PATCH 02/05] secmark: Add libipt_SECMARK
Date: Thu, 18 May 2006 11:39:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0605181138490.3010@d.namei>
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

This patch adds the shared library module for the SECMARK target (IPv4).

Signed-off-by: James Morris <jmorris@namei.org>

---

 extensions/Makefile           |    2 
 extensions/libipt_SECMARK.c   |  125 ++++++++++++++++++++++++++++++++++++++++++
 extensions/libipt_SECMARK.man |    7 ++
 3 files changed, 133 insertions(+), 1 deletion(-)

diff -purN -X dontdiff iptables.p/extensions/libipt_SECMARK.c iptables.w/extensions/libipt_SECMARK.c
--- iptables.p/extensions/libipt_SECMARK.c	1969-12-31 19:00:00.000000000 -0500
+++ iptables.w/extensions/libipt_SECMARK.c	2006-05-17 20:06:46.000000000 -0400
@@ -0,0 +1,125 @@
+/*
+ * Shared library add-on to iptables to add SECMARK target support.
+ *
+ * Based on the MARK target.
+ *
+ * Copyright (C) 2006 Red Hat, Inc., James Morris <jmorris@redhat.com>
+ */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <iptables.h>
+#include <linux/netfilter/xt_SECMARK.h>
+
+#define PFX "SECMARK target: "
+
+static void help(void)
+{
+	printf(
+"SECMARK target v%s options:\n"
+"  --selctx value                     Set the SELinux security context\n"
+"\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "selctx", 1, 0, '1' },
+	{ 0 }
+};
+
+/* Initialize the target. */
+static void init(struct ipt_entry_target *t, unsigned int *nfcache)
+{ }
+
+/*
+ * Function which parses command options; returns true if it
+ * ate an option.
+ */
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+                 const struct ipt_entry *entry, struct ipt_entry_target **target)
+{
+	struct xt_secmark_target_info *info =
+		(struct xt_secmark_target_info*)(*target)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags & SECMARK_MODE_SEL)
+			exit_error(PARAMETER_PROBLEM, PFX
+				   "Can't specify --selctx twice");
+		info->mode = SECMARK_MODE_SEL;
+
+		if (strlen(optarg) > SECMARK_SELCTX_MAX-1)
+			exit_error(PARAMETER_PROBLEM, PFX
+				   "Maximum length %u exceeded by --selctx"
+				   " parameter (%zu)",
+				   SECMARK_SELCTX_MAX-1, strlen(optarg));
+
+		strcpy(info->u.sel.selctx, optarg);
+		*flags |= SECMARK_MODE_SEL;
+		break;
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
+}
+
+static void print_secmark(struct xt_secmark_target_info *info)
+{
+	switch (info->mode) {
+	case SECMARK_MODE_SEL:
+		printf("selctx %s ", info->u.sel.selctx);\
+		break;
+	
+	default:
+		exit_error(OTHER_PROBLEM, PFX "invalid mode %hhu\n", info->mode);
+	}
+}
+
+static void print(const struct ipt_ip *ip,
+		  const struct ipt_entry_target *target, int numeric)
+{
+	struct xt_secmark_target_info *info =
+		(struct xt_secmark_target_info*)(target)->data;
+
+	printf("SECMARK ");
+	print_secmark(info);
+}
+
+/* Saves the target info in parsable form to stdout. */
+static void save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+{
+	struct xt_secmark_target_info *info =
+		(struct xt_secmark_target_info*)target->data;
+
+	printf("--");
+	print_secmark(info);
+}
+
+static struct iptables_target secmark = {
+	.next		= NULL,
+	.name		= "SECMARK",
+	.version	= IPTABLES_VERSION,
+	.revision	= 0,
+	.size		= IPT_ALIGN(sizeof(struct xt_secmark_target_info)),
+	.userspacesize	= IPT_ALIGN(sizeof(struct xt_secmark_target_info)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	register_target(&secmark);
+}
diff -purN -X dontdiff iptables.p/extensions/libipt_SECMARK.man iptables.w/extensions/libipt_SECMARK.man
--- iptables.p/extensions/libipt_SECMARK.man	1969-12-31 19:00:00.000000000 -0500
+++ iptables.w/extensions/libipt_SECMARK.man	2006-05-17 17:08:25.000000000 -0400
@@ -0,0 +1,7 @@
+This is used to set the security mark value associated with the
+packet for use by security subsystems such as SELinux.  It is only
+valid in the
+.B mangle
+table.
+.TP
+.BI "--selctx " "security_context"
diff -purN -X dontdiff iptables.p/extensions/Makefile iptables.w/extensions/Makefile
--- iptables.p/extensions/Makefile	2006-05-17 20:08:11.000000000 -0400
+++ iptables.w/extensions/Makefile	2006-05-17 20:05:11.000000000 -0400
@@ -9,7 +9,7 @@ PF_EXT_SLIB:=ah addrtype comment connlim
 PF6_EXT_SLIB:=connmark eui64 hl icmp6 length limit mac mark multiport owner physdev policy standard state tcp udp CONNMARK HL LOG NFQUEUE MARK TRACE
 
 ifeq ($(DO_SELINUX), 1)
-PF_EXT_SE_SLIB:=
+PF_EXT_SE_SLIB:=SECMARK
 PF6_EXT_SE_SLIB:=
 endif
 
