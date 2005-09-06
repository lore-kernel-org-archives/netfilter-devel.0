From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 7/8]: kill __ip_ct_expect_unlink_destroy
Date: Tue, 06 Sep 2005 19:55:50 +0200
Message-ID: <431DD826.10600@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="07.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="07.diff"
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

[NETFILTER]: kill __ip_ct_expect_unlink_destroy

The following patch kills __ip_ct_expect_unlink_destroy and export
unlink_expect as ip_ct_unlink_expect. As it was discussed [1], the function
__ip_ct_expect_unlink_destroy is a bit confusing so better do the following
sequence: ip_ct_destroy_expect and ip_conntrack_expect_put.

[1] https://lists.netfilter.org/pipermail/netfilter-devel/2005-August/020794.html

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d6a220e261a31f34b644112192cc2d86278ee326
tree 8c81b54f47e24e22b487ef22f926f5016957f970
parent 0cec535bc739cac6e928db1c5e178b6a3f72f241
author Pablo Neira Ayuso <pablo@netfilter.org> Sun, 04 Sep 2005 19:51:01 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 04 Sep 2005 19:51:01 +0200

 include/linux/netfilter_ipv4/ip_conntrack_core.h |    2 +-
 net/ipv4/netfilter/ip_conntrack_core.c           |   20 +++++++-------------
 net/ipv4/netfilter/ip_conntrack_netlink.c        |   12 ++++++++----
 net/ipv4/netfilter/ip_conntrack_standalone.c     |    2 +-
 4 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_conntrack_core.h b/include/linux/netfilter_ipv4/ip_conntrack_core.h
--- a/include/linux/netfilter_ipv4/ip_conntrack_core.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack_core.h
@@ -52,7 +52,7 @@ static inline int ip_conntrack_confirm(s
 	return ret;
 }
 
-extern void __ip_ct_expect_unlink_destroy(struct ip_conntrack_expect *exp);
+extern void ip_ct_unlink_expect(struct ip_conntrack_expect *exp);
 
 extern struct list_head *ip_conntrack_hash;
 extern struct list_head ip_conntrack_expect_list;
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -197,7 +197,7 @@ ip_ct_invert_tuple(struct ip_conntrack_t
 
 
 /* ip_conntrack_expect helper functions */
-static void unlink_expect(struct ip_conntrack_expect *exp)
+void ip_ct_unlink_expect(struct ip_conntrack_expect *exp)
 {
 	ASSERT_WRITE_LOCK(&ip_conntrack_lock);
 	IP_NF_ASSERT(!timer_pending(&exp->timeout));
@@ -207,18 +207,12 @@ static void unlink_expect(struct ip_conn
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
@@ -269,7 +263,7 @@ find_expectation(const struct ip_conntra
 				atomic_inc(&i->use);
 				return i;
 			} else if (del_timer(&i->timeout)) {
-				unlink_expect(i);
+				ip_ct_unlink_expect(i);
 				return i;
 			}
 		}
@@ -288,7 +282,7 @@ void ip_ct_remove_expectations(struct ip
 
 	list_for_each_entry_safe(i, tmp, &ip_conntrack_expect_list, list) {
 		if (i->master == ct && del_timer(&i->timeout)) {
-			unlink_expect(i);
+			ip_ct_unlink_expect(i);
 			ip_conntrack_expect_put(i);
 		}
 	}
@@ -929,7 +923,7 @@ void ip_conntrack_unexpect_related(struc
 	/* choose the the oldest expectation to evict */
 	list_for_each_entry_reverse(i, &ip_conntrack_expect_list, list) {
 		if (expect_matches(i, exp) && del_timer(&i->timeout)) {
-			unlink_expect(i);
+			ip_ct_unlink_expect(i);
 			write_unlock_bh(&ip_conntrack_lock);
 			ip_conntrack_expect_put(i);
 			return;
@@ -986,7 +980,7 @@ static void evict_oldest_expect(struct i
 	list_for_each_entry_reverse(i, &ip_conntrack_expect_list, list) {
 		if (i->master == master) {
 			if (del_timer(&i->timeout)) {
-				unlink_expect(i);
+				ip_ct_unlink_expect(i);
 				ip_conntrack_expect_put(i);
 			}
 			break;
@@ -1103,7 +1097,7 @@ void ip_conntrack_helper_unregister(stru
 	/* Get rid of expectations */
 	list_for_each_entry_safe(exp, tmp, &ip_conntrack_expect_list, list) {
 		if (exp->master->helper == me && del_timer(&exp->timeout)) {
-			unlink_expect(exp);
+			ip_ct_unlink_expect(exp);
 			ip_conntrack_expect_put(exp);
 		}
 	}
diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -1349,8 +1349,10 @@ ctnetlink_del_expect(struct sock *ctnl, 
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
@@ -1358,8 +1360,10 @@ ctnetlink_del_expect(struct sock *ctnl, 
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
diff --git a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c
@@ -998,7 +998,7 @@ EXPORT_SYMBOL(ip_conntrack_expect_relate
 EXPORT_SYMBOL(ip_conntrack_unexpect_related);
 EXPORT_SYMBOL_GPL(ip_conntrack_expect_list);
 EXPORT_SYMBOL_GPL(__ip_conntrack_expect_find);
-EXPORT_SYMBOL_GPL(__ip_ct_expect_unlink_destroy);
+EXPORT_SYMBOL_GPL(ip_ct_unlink_expect);
 
 EXPORT_SYMBOL(ip_conntrack_tuple_taken);
 EXPORT_SYMBOL(ip_ct_gather_frags);
