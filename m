From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 24/43] Use unified API in libipt_mark.c
Date: Sun, 15 Jul 2007 03:10:38 +0900 (JST)
Message-ID: <200707141810.l6EIAdZ7002445@toshiba.co.jp>
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
 extensions/libipt_mark.c                |   19 ++++++++++---------
 include/linux/netfilter/xt_mark.h       |    9 +++++++++
 include/linux/netfilter_ipv4/ipt_mark.h |    9 ---------
 3 files changed, 19 insertions(+), 18 deletions(-)
 create mode 100644 include/linux/netfilter/xt_mark.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_mark.h

diff --git a/extensions/libipt_mark.c b/extensions/libipt_mark.c
index 089a472..47cc4ea 100644
--- a/extensions/libipt_mark.c
+++ b/extensions/libipt_mark.c
@@ -5,9 +5,9 @@
 #include <stdlib.h>
 #include <getopt.h>
 
-#include <iptables.h>
+#include <xtables.h>
 /* For 64bit kernel / 32bit userspace */
-#include "../include/linux/netfilter_ipv4/ipt_mark.h"
+#include "../include/linux/netfilter/xt_mark.h"
 
 /* Function which prints out usage message. */
 static void
@@ -33,7 +33,7 @@ parse(int c, char **argv, int invert, unsigned int *flags,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
-	struct ipt_mark_info *markinfo = (struct ipt_mark_info *)(*match)->data;
+	struct xt_mark_info *markinfo = (struct xt_mark_info *)(*match)->data;
 
 	switch (c) {
 		char *end;
@@ -81,7 +81,7 @@ print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
-	struct ipt_mark_info *info = (struct ipt_mark_info *)match->data;
+	struct xt_mark_info *info = (struct xt_mark_info *)match->data;
 
 	printf("MARK match ");
 
@@ -95,7 +95,7 @@ print(const void *ip,
 static void
 save(const void *ip, const struct xt_entry_match *match)
 {
-	struct ipt_mark_info *info = (struct ipt_mark_info *)match->data;
+	struct xt_mark_info *info = (struct xt_mark_info *)match->data;
 
 	if (info->invert)
 		printf("! ");
@@ -104,12 +104,13 @@ save(const void *ip, const struct xt_entry_match *match)
 	print_mark(info->mark, info->mask, 0);
 }
 
-static struct iptables_match mark = { 
+static struct xtables_match mark = { 
 	.next		= NULL,
+	.family		= AF_INET,
 	.name		= "mark",
 	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_mark_info)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_mark_info)),
+	.size		= XT_ALIGN(sizeof(struct xt_mark_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_info)),
 	.help		= &help,
 	.parse		= &parse,
 	.final_check	= &final_check,
@@ -120,5 +121,5 @@ static struct iptables_match mark = {
 
 void _init(void)
 {
-	register_match(&mark);
+	xtables_register_match(&mark);
 }
diff --git a/include/linux/netfilter/xt_mark.h b/include/linux/netfilter/xt_mark.h
new file mode 100644
index 0000000..e7023e6
--- /dev/null
+++ b/include/linux/netfilter/xt_mark.h
@@ -0,0 +1,9 @@
+#ifndef _XT_MARK_H
+#define _XT_MARK_H
+
+struct xt_mark_info {
+	unsigned long mark, mask;
+	u_int8_t invert;
+};
+
+#endif /*_XT_MARK_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_mark.h b/include/linux/netfilter_ipv4/ipt_mark.h
deleted file mode 100644
index f3952b5..0000000
--- a/include/linux/netfilter_ipv4/ipt_mark.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef _IPT_MARK_H
-#define _IPT_MARK_H
-
-struct ipt_mark_info {
-    unsigned long mark, mask;
-    u_int8_t invert;
-};
-
-#endif /*_IPT_MARK_H*/
-- 
1.5.2.2
