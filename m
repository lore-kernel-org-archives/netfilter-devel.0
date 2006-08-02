From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] update quota match for xtables + fix -D bug
Date: Tue, 1 Aug 2006 19:43:22 -0700
Message-ID: <20060802024322.GA15127@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The iptables quota match has not been updated to reflect the new xtables
location/structures in 2.6.18-rc.  In addition, it has a bug which makes
it impossible to delete a rule once added.  E.g.:

# iptables -A foo -m quota --quota 1111 -j RETURN
# iptables -D foo -m quota --quota 1111 -j RETURN
iptables: Bad rule (does a matching rule exist in that chain?)

Below patch fixes both issues and resolve bugzilla #496.

Phil



--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-quota

diff -ru ipt-orig/extensions/libipt_quota.c ipt-new/extensions/libipt_quota.c
--- ipt-orig/extensions/libipt_quota.c	2005-02-14 05:13:04.000000000 -0800
+++ ipt-new/extensions/libipt_quota.c	2006-08-01 19:05:28.000000000 -0700
@@ -3,12 +3,13 @@
  *
  * Sam Johnston <samj@samj.net>
  */
+#include <stddef.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <getopt.h>
 #include <iptables.h>
 
-#include <linux/netfilter_ipv4/ipt_quota.h>
+#include <linux/netfilter/xt_quota.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 
 static struct option opts[] = {
@@ -28,7 +29,7 @@
 static void
 print(const struct ipt_ip *ip, const struct ipt_entry_match *match, int numeric)
 {
-        struct ipt_quota_info *q = (struct ipt_quota_info *) match->data;
+        struct xt_quota_info *q = (struct xt_quota_info *) match->data;
         printf("quota: %llu bytes", (unsigned long long) q->quota);
 }
 
@@ -36,7 +37,7 @@
 static void
 save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
 {
-        struct ipt_quota_info *q = (struct ipt_quota_info *) match->data;
+        struct xt_quota_info *q = (struct xt_quota_info *) match->data;
         printf("--quota %llu ", (unsigned long long) q->quota);
 }
 
@@ -62,7 +63,7 @@
       const struct ipt_entry *entry,
       unsigned int *nfcache, struct ipt_entry_match **match)
 {
-        struct ipt_quota_info *info = (struct ipt_quota_info *) (*match)->data;
+        struct xt_quota_info *info = (struct xt_quota_info *) (*match)->data;
 
         switch (c) {
         case '1':
@@ -89,8 +90,8 @@
 	.next		= NULL,
 	.name		= "quota",
 	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof (struct ipt_quota_info)),
-	.userspacesize	= IPT_ALIGN(sizeof (struct ipt_quota_info)),
+	.size		= IPT_ALIGN(sizeof (struct xt_quota_info)),
+	.userspacesize	= offsetof(struct xt_quota_info, quota),
 	.help		= &help,
 	.parse		= &parse,
 	.final_check	= &final_check,
diff -ru ipt-orig/extensions/.quota-test ipt-new/extensions/.quota-test
--- ipt-orig/extensions/.quota-test	2001-12-03 14:22:55.000000000 -0800
+++ ipt-new/extensions/.quota-test	2006-08-01 17:48:12.000000000 -0700
@@ -1,3 +1,3 @@
 #!/bin/sh
-[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_quota.h ] && echo quota
+[ -f $KERNEL_DIR/include/linux/netfilter/xt_quota.h ] && echo quota
 

--sdtB3X0nJg68CQEu--
