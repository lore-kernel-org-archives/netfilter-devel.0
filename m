From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 5/8] Netfilter:  Make Expectations Timeouts Compulsory
Date: Tue, 11 Jan 2005 21:21:39 +1100
Message-ID: <1105438899.19331.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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

Name: Make Expectations Timeouts Compulsory 
Author: Rusty Russell
Status: Tested under nfsim

This patch simplifies the code by always having expectation timeouts.

Index: linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_conntrack_ftp.c
===================================================================
--- linux-2.6.10-bk8-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-01-06 12:03:06.444300896 +1100
+++ linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-01-06 12:03:20.840112400 +1100
@@ -476,7 +476,7 @@
 		ftp[i].mask.src.u.tcp.port = 0xFFFF;
 		ftp[i].mask.dst.protonum = 0xFFFF;
 		ftp[i].max_expected = 1;
-		ftp[i].timeout = 0;
+		ftp[i].timeout = 5 * 60; /* 5 minutes */
 		ftp[i].me = ip_conntrack_ftp;
 		ftp[i].help = help;
 
Index: linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_conntrack_tftp.c
===================================================================
--- linux-2.6.10-bk8-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_tftp.c	2005-01-06 12:03:06.444300896 +1100
+++ linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_conntrack_tftp.c	2005-01-06 12:03:20.839112552 +1100
@@ -131,7 +131,7 @@
 		tftp[i].mask.dst.protonum = 0xFFFF;
 		tftp[i].mask.src.u.udp.port = 0xFFFF;
 		tftp[i].max_expected = 1;
-		tftp[i].timeout = 0;
+		tftp[i].timeout = 5 * 60; /* 5 minutes */
 		tftp[i].me = THIS_MODULE;
 		tftp[i].help = tftp_help;
 
Index: linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_nat_irc.c
===================================================================
--- linux-2.6.10-bk8-Netfilter.orig/net/ipv4/netfilter/ip_nat_irc.c	2005-01-06 12:03:06.445300744 +1100
+++ linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_nat_irc.c	2005-01-06 12:03:20.840112400 +1100
@@ -34,8 +34,6 @@
 MODULE_DESCRIPTION("IRC (DCC) NAT helper");
 MODULE_LICENSE("GPL");
 
-/* FIXME: Time out? --RR */
-
 static unsigned int help(struct sk_buff **pskb,
 			 enum ip_conntrack_info ctinfo,
 			 unsigned int matchoff,
Index: linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.6.10-bk8-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-06 12:03:06.454299376 +1100
+++ linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-06 12:03:20.842112096 +1100
@@ -176,7 +176,7 @@
 		   and weird things would happen to future packets). */
 		if (ip_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)
 		    && is_confirmed(i->master)
-		    && (!i->timeout.function || del_timer(&i->timeout))) {
+		    && del_timer(&i->timeout)) {
 			unlink_expect(i);
 			return i;
 		}
@@ -194,8 +194,7 @@
 		return;
 
 	list_for_each_entry_safe(i, tmp, &ip_conntrack_expect_list, list) {
-		if (i->master == ct
-		    && (!i->timeout.function || del_timer(&i->timeout))) {
+		if (i->master == ct && del_timer(&i->timeout)) {
 			unlink_expect(i);
 			destroy_expect(i);
 		}
@@ -722,8 +721,7 @@
 	WRITE_LOCK(&ip_conntrack_lock);
 	/* choose the the oldest expectation to evict */
 	list_for_each_entry_reverse(i, &ip_conntrack_expect_list, list) {
-		if (expect_matches(i, exp)
-		    && (!i->timeout.function || del_timer(&i->timeout))) {
+		if (expect_matches(i, exp) && del_timer(&i->timeout)) {
 			unlink_expect(i);
 			WRITE_UNLOCK(&ip_conntrack_lock);
 			destroy_expect(i);
@@ -777,7 +775,7 @@
 
 	list_for_each_entry_reverse(i, &ip_conntrack_expect_list, list) {
 		if (i->master == master) {
-			if (!i->timeout.function || del_timer(&i->timeout)) {
+			if (del_timer(&i->timeout)) {
 				unlink_expect(i);
 				destroy_expect(i);
 			}
@@ -788,9 +786,6 @@
 
 static inline int refresh_timer(struct ip_conntrack_expect *i)
 {
-	if (!i->timeout.function)
-		return 1;
-
 	if (!del_timer(&i->timeout))
 		return 0;
 
@@ -856,6 +851,7 @@
 
 int ip_conntrack_helper_register(struct ip_conntrack_helper *me)
 {
+	BUG_ON(me->timeout == 0);
 	WRITE_LOCK(&ip_conntrack_lock);
 	list_prepend(&helpers, me);
 	WRITE_UNLOCK(&ip_conntrack_lock);
@@ -882,12 +878,9 @@
 
 	/* Get rid of expectations */
 	list_for_each_entry_safe(exp, tmp, &ip_conntrack_expect_list, list) {
-		if (exp->master->helper == me) {
-			if (!exp->timeout.function
-			    || del_timer(&exp->timeout)) {
-				unlink_expect(exp);
-				destroy_expect(exp);
-			}
+		if (exp->master->helper == me && del_timer(&exp->timeout)) {
+			unlink_expect(exp);
+			destroy_expect(exp);
 		}
 	}
 	/* Get rid of expecteds, set helpers to NULL. */
