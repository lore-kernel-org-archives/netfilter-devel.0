From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 42/43] Unifies libip[6]t_SECMARK.c into libxt_SECMARK.c
Date: Sun, 15 Jul 2007 03:57:18 +0900 (JST)
Message-ID: <200707141857.l6EIvJuX005662@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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


---
 extensions/Makefile          |   11 +++-
 extensions/libip6t_SECMARK.c |  125 ------------------------------------
 extensions/libipt_SECMARK.c  |  125 ------------------------------------
 extensions/libxt_SECMARK.c   |  144 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 153 insertions(+), 252 deletions(-)
 delete mode 100644 extensions/libip6t_SECMARK.c
 delete mode 100644 extensions/libipt_SECMARK.c
 create mode 100644 extensions/libxt_SECMARK.c

diff --git a/extensions/Makefile b/extensions/Makefile
index 5690da3..3159b3d 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -10,8 +10,9 @@ PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 owner policy state CONNMARK HL L
 PFX_EXT_SLIB:=comment dscp esp length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp NOTRACK TCPMSS
 
 ifeq ($(DO_SELINUX), 1)
-PF_EXT_SE_SLIB:=SECMARK CONNSECMARK
-PF6_EXT_SE_SLIB:=SECMARK CONNSECMARK
+PF_EXT_SE_SLIB:=CONNSECMARK
+PF6_EXT_SE_SLIB:=CONNSECMARK
+PFX_EXT_SE_SLIB:=SECMARK 
 endif
 
 # Optionals
@@ -66,15 +67,19 @@ EXTRA_INSTALLS+=$(foreach T, $(PFX_EXT_SLIB), $(DEST_IPT_LIBDIR)/libip6t_$(T).so
 endif
 
 SHARED_LIBS+=$(foreach T,$(PFX_EXT_SLIB),extensions/libxt_$(T).so)
+SHARED_SE_LIBS+=$(foreach T,$(PFX_EXT_SE_SLIB),extensions/libxt_$(T).so)
 EXTRA_INSTALLS+=$(foreach T, $(PFX_EXT_SLIB), $(DEST_IPT_LIBDIR)/libxt_$(T).so)
+EXTRA_INSTALLS+=$(foreach T, $(PFX_EXT_SE_SLIB), $(DEST_IPT_LIBDIR)/libxt_$(T).so)
 
 else 	# NO_SHARED_LIBS
 EXT_OBJS+=$(foreach T,$(PF_EXT_SLIB),extensions/libipt_$(T).o)
 EXT_OBJS+=$(foreach T,$(PF_EXT_SE_SLIB),extensions/libipt_$(T).o)
 EXT_OBJS+=$(foreach T,$(PFX_EXT_SLIB),extensions/libxt_$(T).o)
+EXT_OBJS+=$(foreach T,$(PFX_EXT_SE_SLIB),extensions/libxt_$(T).o)
 EXT_FUNC+=$(foreach T,$(PF_EXT_SLIB),ipt_$(T))
 EXT_FUNC+=$(foreach T,$(PF_EXT_SE_SLIB),ipt_$(T))
 EXT_FUNC+=$(foreach T,$(PFX_EXT_SLIB),xt_$(T))
+EXT_FUNC+=$(foreach T,$(PFX_EXT_SE_SLIB),xt_$(T))
 EXT_OBJS+= extensions/initext.o
 ifeq ($(DO_IPV6), 1)
 EXT6_OBJS+=$(foreach T,$(PF6_EXT_SLIB),extensions/libip6t_$(T).o)
@@ -83,6 +88,8 @@ EXT6_OBJS+=$(foreach T,$(PFX_EXT_SLIB),extensions/libxt_$(T).o)
 EXT6_FUNC+=$(foreach T,$(PF6_EXT_SLIB),ip6t_$(T))
 EXT6_FUNC+=$(foreach T,$(PF6_EXT_SE_SLIB),ip6t_$(T))
 EXT6_FUNC+=$(foreach T,$(PFX_EXT_SLIB),xt_$(T))
+EXT6_OBJS+=$(foreach T,$(PFX_EXT_SE_SLIB),extensions/libxt_$(T).o)
+EXT6_FUNC+=$(foreach T,$(PFX_EXT_SE_SLIB),xt_$(T))
 EXT6_OBJS+= extensions/initext6.o
 endif	# DO_IPV6
 endif	# NO_SHARED_LIBS
diff --git a/extensions/libip6t_SECMARK.c b/extensions/libip6t_SECMARK.c
deleted file mode 100644
index 16961a3..0000000
--- a/extensions/libip6t_SECMARK.c
+++ /dev/null
@@ -1,125 +0,0 @@
-/*
- * Shared library add-on to iptables to add SECMARK target support.
- *
- * Based on the MARK target.
- *
- * IPv6 version.
- *
- * Copyright (C) 2006 Red Hat, Inc., James Morris <jmorris@redhat.com>
- */
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <ip6tables.h>
-#include <linux/netfilter/xt_SECMARK.h>
-
-#define PFX "SECMARK target: "
-
-static void help(void)
-{
-	printf(
-"SECMARK target v%s options:\n"
-"  --selctx value                     Set the SELinux security context\n"
-"\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "selctx", 1, 0, '1' },
-	{ 0 }
-};
-
-/* Initialize the target. */
-static void init(struct xt_entry_target *t, unsigned int *nfcache)
-{ }
-
-/*
- * Function which parses command options; returns true if it
- * ate an option.
- */
-static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const void *entry, struct xt_entry_target **target)
-{
-	struct xt_secmark_target_info *info =
-		(struct xt_secmark_target_info*)(*target)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & SECMARK_MODE_SEL)
-			exit_error(PARAMETER_PROBLEM, PFX
-				   "Can't specify --selctx twice");
-		info->mode = SECMARK_MODE_SEL;
-
-		if (strlen(optarg) > SECMARK_SELCTX_MAX-1)
-			exit_error(PARAMETER_PROBLEM, PFX
-				   "Maximum length %u exceeded by --selctx"
-				   " parameter (%zu)",
-				   SECMARK_SELCTX_MAX-1, strlen(optarg));
-
-		strcpy(info->u.sel.selctx, optarg);
-		*flags |= SECMARK_MODE_SEL;
-		break;
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
-}
-
-static void print_secmark(struct xt_secmark_target_info *info)
-{
-	switch (info->mode) {
-	case SECMARK_MODE_SEL:
-		printf("selctx %s ", info->u.sel.selctx);\
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
-	struct xt_secmark_target_info *info =
-		(struct xt_secmark_target_info*)(target)->data;
-
-	printf("SECMARK ");
-	print_secmark(info);
-}
-
-/* Saves the target info in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_target *target)
-{
-	struct xt_secmark_target_info *info =
-		(struct xt_secmark_target_info*)target->data;
-
-	printf("--");
-	print_secmark(info);
-}
-
-static struct ip6tables_target secmark = {
-	.name		= "SECMARK",
-	.version	= IPTABLES_VERSION,
-	.size		= IP6T_ALIGN(sizeof(struct xt_secmark_target_info)),
-	.userspacesize	= IP6T_ALIGN(sizeof(struct xt_secmark_target_info)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
-};
-
-void _init(void)
-{
-	register_target6(&secmark);
-}
diff --git a/extensions/libipt_SECMARK.c b/extensions/libipt_SECMARK.c
deleted file mode 100644
index d8b0aa3..0000000
--- a/extensions/libipt_SECMARK.c
+++ /dev/null
@@ -1,125 +0,0 @@
-/*
- * Shared library add-on to iptables to add SECMARK target support.
- *
- * Based on the MARK target.
- *
- * Copyright (C) 2006 Red Hat, Inc., James Morris <jmorris@redhat.com>
- */
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <iptables.h>
-#include <linux/netfilter/xt_SECMARK.h>
-
-#define PFX "SECMARK target: "
-
-static void help(void)
-{
-	printf(
-"SECMARK target v%s options:\n"
-"  --selctx value                     Set the SELinux security context\n"
-"\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "selctx", 1, 0, '1' },
-	{ 0 }
-};
-
-/* Initialize the target. */
-static void init(struct xt_entry_target *t, unsigned int *nfcache)
-{ }
-
-/*
- * Function which parses command options; returns true if it
- * ate an option.
- */
-static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const void *entry, struct xt_entry_target **target)
-{
-	struct xt_secmark_target_info *info =
-		(struct xt_secmark_target_info*)(*target)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & SECMARK_MODE_SEL)
-			exit_error(PARAMETER_PROBLEM, PFX
-				   "Can't specify --selctx twice");
-		info->mode = SECMARK_MODE_SEL;
-
-		if (strlen(optarg) > SECMARK_SELCTX_MAX-1)
-			exit_error(PARAMETER_PROBLEM, PFX
-				   "Maximum length %u exceeded by --selctx"
-				   " parameter (%zu)",
-				   SECMARK_SELCTX_MAX-1, strlen(optarg));
-
-		strcpy(info->u.sel.selctx, optarg);
-		*flags |= SECMARK_MODE_SEL;
-		break;
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
-}
-
-static void print_secmark(struct xt_secmark_target_info *info)
-{
-	switch (info->mode) {
-	case SECMARK_MODE_SEL:
-		printf("selctx %s ", info->u.sel.selctx);\
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
-	struct xt_secmark_target_info *info =
-		(struct xt_secmark_target_info*)(target)->data;
-
-	printf("SECMARK ");
-	print_secmark(info);
-}
-
-/* Saves the target info in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_target *target)
-{
-	struct xt_secmark_target_info *info =
-		(struct xt_secmark_target_info*)target->data;
-
-	printf("--");
-	print_secmark(info);
-}
-
-static struct iptables_target secmark = {
-	.next		= NULL,
-	.name		= "SECMARK",
-	.version	= IPTABLES_VERSION,
-	.revision	= 0,
-	.size		= IPT_ALIGN(sizeof(struct xt_secmark_target_info)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct xt_secmark_target_info)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
-};
-
-void _init(void)
-{
-	register_target(&secmark);
-}
diff --git a/extensions/libxt_SECMARK.c b/extensions/libxt_SECMARK.c
new file mode 100644
index 0000000..38aaca9
--- /dev/null
+++ b/extensions/libxt_SECMARK.c
@@ -0,0 +1,144 @@
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
+#include <xtables.h>
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
+static void init(struct xt_entry_target *t, unsigned int *nfcache)
+{ }
+
+/*
+ * Function which parses command options; returns true if it
+ * ate an option.
+ */
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+                 const void *entry, struct xt_entry_target **target)
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
+static void print(const void *ip,
+		  const struct xt_entry_target *target, int numeric)
+{
+	struct xt_secmark_target_info *info =
+		(struct xt_secmark_target_info*)(target)->data;
+
+	printf("SECMARK ");
+	print_secmark(info);
+}
+
+/* Saves the target info in parsable form to stdout. */
+static void save(const void *ip, const struct xt_entry_target *target)
+{
+	struct xt_secmark_target_info *info =
+		(struct xt_secmark_target_info*)target->data;
+
+	printf("--");
+	print_secmark(info);
+}
+
+static struct xtables_target secmark = {
+	.next		= NULL,
+	.family		= AF_INET,
+	.name		= "SECMARK",
+	.version	= IPTABLES_VERSION,
+	.revision	= 0,
+	.size		= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+static struct xtables_target secmark6 = {
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "SECMARK",
+	.version	= IPTABLES_VERSION,
+	.revision	= 0,
+	.size		= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
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
+	xtables_register_target(&secmark);
+	xtables_register_target(&secmark6);
+}
-- 
1.5.2.2
