From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] kill __ip_ct_expect_unlink_destroy
Date: Thu, 25 Aug 2005 22:46:03 +0200
Message-ID: <430E2E0B.1010109@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000005070003010507050509"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------000005070003010507050509
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The following patch kills __ip_ct_expect_unlink_destroy and export 
unlink_expect as ip_ct_unlink_expect. As it was discussed [1], the 
function __ip_ct_expect_unlink_destroy is a bit confusing so better do 
the following sequence: ip_ct_destroy_expect and ip_conntrack_expect_put.

[1]https://lists.netfilter.org/pipermail/netfilter-devel/2005-August/020794.html

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

--------------000005070003010507050509
Content-Type: text/x-patch;
 name="07kill.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="07kill.patch"

Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_standalone.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-08-20 18:48:51.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-08-20 18:48:55.000000000 +0200
@@ -998,7 +998,7 @@
 EXPORT_SYMBOL(ip_conntrack_unexpect_related);
 EXPORT_SYMBOL_GPL(ip_conntrack_expect_list);
 EXPORT_SYMBOL_GPL(__ip_conntrack_expect_find);
-EXPORT_SYMBOL_GPL(__ip_ct_expect_unlink_destroy);
+EXPORT_SYMBOL_GPL(ip_ct_unlink_expect);
 
 EXPORT_SYMBOL(ip_conntrack_tuple_taken);
 EXPORT_SYMBOL(ip_ct_gather_frags);
Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-08-20 18:48:51.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-08-20 18:48:56.000000000 +0200
@@ -1391,8 +1391,10 @@
 		list_for_each_entry_safe(exp, tmp, &ip_conntrack_expect_list,
 					 list) {
 			if (exp->master->helper == h 
-			    && del_timer(&exp->timeout))
-				__ip_ct_expect_unlink_destroy(exp);
+			    && del_timer(&exp->timeout)) {
+				ip_ct_unlink_expect(exp);
+				ip_conntrack_expect_put(exp);
+			}
 		}
 		write_unlock(&ip_conntrack_lock);
 	} else {
@@ -1400,8 +1402,10 @@
 		write_lock_bh(&ip_conntrack_lock);
 		list_for_each_entry_safe(exp, tmp, &ip_conntrack_expect_list,
 					 list) {
-			if (del_timer(&exp->timeout))
-				__ip_ct_expect_unlink_destroy(exp);
+			if (del_timer(&exp->timeout)) {
+				ip_ct_unlink_expect(exp);
+				ip_conntrack_expect_put(exp);
+			}
 		}
 		write_unlock_bh(&ip_conntrack_lock);
 	}
Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-08-20 18:48:51.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_core.c	2005-08-20 18:53:03.000000000 +0200
@@ -197,7 +197,7 @@
 
 
 /* ip_conntrack_expect helper functions */
-static void unlink_expect(struct ip_conntrack_expect *exp)
+void ip_ct_unlink_expect(struct ip_conntrack_expect *exp)
 {
 	ASSERT_WRITE_LOCK(&ip_conntrack_lock);
 	IP_NF_ASSERT(!timer_pending(&exp->timeout));
@@ -207,18 +207,12 @@
 	ip_conntrack_expect_put(exp);
 }
 
-void __ip_ct_expect_unlink_destroy(struct ip_conntrack_expect *exp)
-{
-	unlink_expect(exp);
-	ip_conntrack_expect_put(exp);
-}
-
 static void expectation_timed_out(unsigned long ul_expect)
 {
 	struct ip_conntrack_expect *exp = (void *)ul_expect;
 
 	write_lock_bh(&ip_conntrack_lock);
-	unlink_expect(exp);
+	ip_ct_unlink_expect(exp);
 	write_unlock_bh(&ip_conntrack_lock);
 	ip_conntrack_expect_put(exp);
 }
@@ -266,7 +260,7 @@
 		if (ip_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)
 		    && is_confirmed(i->master)
 		    && del_timer(&i->timeout)) {
-			unlink_expect(i);
+			ip_ct_unlink_expect(i);
 			return i;
 		}
 	}
@@ -284,7 +278,7 @@
 
 	list_for_each_entry_safe(i, tmp, &ip_conntrack_expect_list, list) {
 		if (i->master == ct && del_timer(&i->timeout)) {
-			unlink_expect(i);
+			ip_ct_unlink_expect(i);
 			ip_conntrack_expect_put(i);
 		}
 	}
@@ -925,7 +919,7 @@
 	/* choose the the oldest expectation to evict */
 	list_for_each_entry_reverse(i, &ip_conntrack_expect_list, list) {
 		if (expect_matches(i, exp) && del_timer(&i->timeout)) {
-			unlink_expect(i);
+			ip_ct_unlink_expect(i);
 			write_unlock_bh(&ip_conntrack_lock);
 			ip_conntrack_expect_put(i);
 			return;
@@ -982,7 +976,7 @@
 	list_for_each_entry_reverse(i, &ip_conntrack_expect_list, list) {
 		if (i->master == master) {
 			if (del_timer(&i->timeout)) {
-				unlink_expect(i);
+				ip_ct_unlink_expect(i);
 				ip_conntrack_expect_put(i);
 			}
 			break;
@@ -1099,7 +1093,7 @@
 	/* Get rid of expectations */
 	list_for_each_entry_safe(exp, tmp, &ip_conntrack_expect_list, list) {
 		if (exp->master->helper == me && del_timer(&exp->timeout)) {
-			unlink_expect(exp);
+			ip_ct_unlink_expect(exp);
 			ip_conntrack_expect_put(exp);
 		}
 	}
Index: netfilter-2.6.14/include/linux/netfilter_ipv4/ip_conntrack_core.h
===================================================================
--- netfilter-2.6.14.orig/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-08-20 18:48:51.000000000 +0200
+++ netfilter-2.6.14/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-08-20 18:48:56.000000000 +0200
@@ -52,7 +52,7 @@
 	return ret;
 }
 
-extern void __ip_ct_expect_unlink_destroy(struct ip_conntrack_expect *exp);
+extern void ip_ct_unlink_expect(struct ip_conntrack_expect *exp);
 
 extern struct list_head *ip_conntrack_hash;
 extern struct list_head ip_conntrack_expect_list;

--------------000005070003010507050509--
