From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 31/43] Use unified API in quota match and add support for
 IPv6 to it
Date: Sun, 15 Jul 2007 03:11:52 +0900 (JST)
Message-ID: <200707141811.l6EIBr8b002966@toshiba.co.jp>
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
 extensions/.quota-test    |    3 -
 extensions/.quota-testx   |    3 +
 extensions/libipt_quota.c |  107 ---------------------------------------
 extensions/libxt_quota.c  |  123 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 126 insertions(+), 110 deletions(-)
 delete mode 100755 extensions/.quota-test
 create mode 100755 extensions/.quota-testx
 delete mode 100644 extensions/libipt_quota.c
 create mode 100644 extensions/libxt_quota.c

diff --git a/extensions/.quota-test b/extensions/.quota-test
deleted file mode 100755
index b21058c..0000000
--- a/extensions/.quota-test
+++ /dev/null
@@ -1,3 +0,0 @@
-#!/bin/sh
-[ -f $KERNEL_DIR/include/linux/netfilter/xt_quota.h ] && echo quota
-
diff --git a/extensions/.quota-testx b/extensions/.quota-testx
new file mode 100755
index 0000000..b21058c
--- /dev/null
+++ b/extensions/.quota-testx
@@ -0,0 +1,3 @@
+#!/bin/sh
+[ -f $KERNEL_DIR/include/linux/netfilter/xt_quota.h ] && echo quota
+
diff --git a/extensions/libipt_quota.c b/extensions/libipt_quota.c
deleted file mode 100644
index 89e5168..0000000
--- a/extensions/libipt_quota.c
+++ /dev/null
@@ -1,107 +0,0 @@
-/*
- * Shared library add-on to iptables to add quota support
- *
- * Sam Johnston <samj@samj.net>
- */
-#include <stddef.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <iptables.h>
-
-#include <linux/netfilter/xt_quota.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-
-static struct option opts[] = {
-        {"quota", 1, 0, '1'},
-        {0}
-};
-
-/* print usage */
-static void
-help(void)
-{
-        printf("quota options:\n"
-               " --quota quota			quota (bytes)\n" "\n");
-}
-
-/* print matchinfo */
-static void
-print(const void *ip, const struct xt_entry_match *match, int numeric)
-{
-        struct xt_quota_info *q = (struct xt_quota_info *) match->data;
-        printf("quota: %llu bytes", (unsigned long long) q->quota);
-}
-
-/* save matchinfo */
-static void
-save(const void *ip, const struct xt_entry_match *match)
-{
-        struct xt_quota_info *q = (struct xt_quota_info *) match->data;
-        printf("--quota %llu ", (unsigned long long) q->quota);
-}
-
-/* parse quota option */
-static int
-parse_quota(const char *s, u_int64_t * quota)
-{
-        *quota = strtoull(s, (char **) NULL, 10);
-
-#ifdef DEBUG_IPT_QUOTA
-        printf("Quota: %llu\n", *quota);
-#endif
-
-        if (*quota == -1)
-                exit_error(PARAMETER_PROBLEM, "quota invalid: '%s'\n", s);
-        else
-                return 1;
-}
-
-/* parse all options, returning true if we found any for us */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache, struct xt_entry_match **match)
-{
-        struct xt_quota_info *info = (struct xt_quota_info *) (*match)->data;
-
-        switch (c) {
-        case '1':
-                if (check_inverse(optarg, &invert, NULL, 0))
-                        exit_error(PARAMETER_PROBLEM, "quota: unexpected '!'");
-                if (!parse_quota(optarg, &info->quota))
-                        exit_error(PARAMETER_PROBLEM,
-                                   "bad quota: '%s'", optarg);
-                break;
-
-        default:
-                return 0;
-        }
-        return 1;
-}
-
-/* no final check */
-static void
-final_check(unsigned int flags)
-{
-}
-
-struct iptables_match quota = { 
-	.next		= NULL,
-	.name		= "quota",
-	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof (struct xt_quota_info)),
-	.userspacesize	= offsetof(struct xt_quota_info, quota),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
-};
-
-void
-_init(void)
-{
-        register_match(&quota);
-}
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
new file mode 100644
index 0000000..a273b29
--- /dev/null
+++ b/extensions/libxt_quota.c
@@ -0,0 +1,123 @@
+/*
+ * Shared library add-on to iptables to add quota support
+ *
+ * Sam Johnston <samj@samj.net>
+ */
+#include <stddef.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <xtables.h>
+
+#include <linux/netfilter/xt_quota.h>
+
+static struct option opts[] = {
+        {"quota", 1, 0, '1'},
+        {0}
+};
+
+/* print usage */
+static void
+help(void)
+{
+        printf("quota options:\n"
+               " --quota quota			quota (bytes)\n" "\n");
+}
+
+/* print matchinfo */
+static void
+print(const void *ip, const struct xt_entry_match *match, int numeric)
+{
+        struct xt_quota_info *q = (struct xt_quota_info *) match->data;
+        printf("quota: %llu bytes", (unsigned long long) q->quota);
+}
+
+/* save matchinfo */
+static void
+save(const void *ip, const struct xt_entry_match *match)
+{
+        struct xt_quota_info *q = (struct xt_quota_info *) match->data;
+        printf("--quota %llu ", (unsigned long long) q->quota);
+}
+
+/* parse quota option */
+static int
+parse_quota(const char *s, u_int64_t * quota)
+{
+        *quota = strtoull(s, (char **) NULL, 10);
+
+#ifdef DEBUG_XT_QUOTA
+        printf("Quota: %llu\n", *quota);
+#endif
+
+        if (*quota == -1)
+                exit_error(PARAMETER_PROBLEM, "quota invalid: '%s'\n", s);
+        else
+                return 1;
+}
+
+/* parse all options, returning true if we found any for us */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const void *entry,
+      unsigned int *nfcache, struct xt_entry_match **match)
+{
+        struct xt_quota_info *info = (struct xt_quota_info *) (*match)->data;
+
+        switch (c) {
+        case '1':
+                if (check_inverse(optarg, &invert, NULL, 0))
+                        exit_error(PARAMETER_PROBLEM, "quota: unexpected '!'");
+                if (!parse_quota(optarg, &info->quota))
+                        exit_error(PARAMETER_PROBLEM,
+                                   "bad quota: '%s'", optarg);
+                break;
+
+        default:
+                return 0;
+        }
+        return 1;
+}
+
+/* no final check */
+static void
+final_check(unsigned int flags)
+{
+}
+
+struct xtables_match quota = { 
+	.next		= NULL,
+	.family		= AF_INET,
+	.name		= "quota",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof (struct xt_quota_info)),
+	.userspacesize	= offsetof(struct xt_quota_info, quota),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+struct xtables_match quota6 = { 
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "quota",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof (struct xt_quota_info)),
+	.userspacesize	= offsetof(struct xt_quota_info, quota),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void
+_init(void)
+{
+	xtables_register_match(&quota);
+	xtables_register_match(&quota6);
+}
-- 
1.5.2.2
