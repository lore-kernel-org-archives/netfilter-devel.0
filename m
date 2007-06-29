From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 14/20]: nf_conntrack_expect: maintain per conntrack
	expectation list
Date: Fri, 29 Jun 2007 02:45:16 +0200 (MEST)
Message-ID: <20070629004414.25566.78318.sendpatchset@localhost.localdomain>
References: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_expect: maintain per conntrack expectation list

This patch brings back the per-conntrack expectation list that was
removed around 2.6.10 to avoid walking all expectations on expectation
eviction and conntrack destruction.

As these were the last users of the global expectation list, this patch
also kills that.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 826df5e9b1439f81580998ee5635c6f87e4930bb
tree 50dbce85b0e9f48821e7e0b780379a4f3db3a971
parent f6ae8f4600dff514f6cd766272cd57564fd4a4fe
author Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:15:53 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:15:53 +0200

 include/net/netfilter/nf_conntrack.h        |    2 +
 include/net/netfilter/nf_conntrack_expect.h |    5 +--
 include/net/netfilter/nf_conntrack_helper.h |    2 +
 net/netfilter/nf_conntrack_core.c           |   18 +++---------
 net/netfilter/nf_conntrack_expect.c         |   40 ++++++++++++++-------------
 net/netfilter/nf_conntrack_helper.c         |   13 +++++++++
 net/netfilter/nf_conntrack_netlink.c        |    4 +--
 7 files changed, 45 insertions(+), 39 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 8f2cbb9..d4f02eb 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -82,6 +82,8 @@ struct nf_conn_help {
 
 	union nf_conntrack_help help;
 
+	struct hlist_head expectations;
+
 	/* Current number of expected connections */
 	unsigned int expecting;
 };
diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 424d4bd..9d5af4e 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -6,14 +6,13 @@
 #define _NF_CONNTRACK_EXPECT_H
 #include <net/netfilter/nf_conntrack.h>
 
-extern struct list_head nf_ct_expect_list;
 extern struct hlist_head *nf_ct_expect_hash;
 extern unsigned int nf_ct_expect_hsize;
 
 struct nf_conntrack_expect
 {
-	/* Internal linked list (global expectation list) */
-	struct list_head list;
+	/* Conntrack expectation list member */
+	struct hlist_node lnode;
 
 	/* Hash member */
 	struct hlist_node hnode;
diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index d62e6f0..2c0e2e0 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -52,6 +52,8 @@ extern void nf_ct_helper_put(struct nf_conntrack_helper *helper);
 extern int nf_conntrack_helper_register(struct nf_conntrack_helper *);
 extern void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
 
+extern struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp);
+
 static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
 {
 	return nf_ct_ext_find(ct, NF_CT_EXT_HELPER);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ed44a09..d1fc019 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -502,12 +502,9 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
 		conntrack->master = exp->master;
 		if (exp->helper) {
-			help = nf_ct_ext_add(conntrack, NF_CT_EXT_HELPER,
-					     GFP_ATOMIC);
+			help = nf_ct_helper_ext_add(conntrack, GFP_ATOMIC);
 			if (help)
 				rcu_assign_pointer(help->helper, exp->helper);
-			else
-				DEBUGP("failed to add helper extension area");
 		}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
@@ -523,14 +520,9 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 
 		helper = __nf_ct_helper_find(&repl_tuple);
 		if (helper) {
-			help = nf_ct_ext_add(conntrack, NF_CT_EXT_HELPER,
-					     GFP_ATOMIC);
+			help = nf_ct_helper_ext_add(conntrack, GFP_ATOMIC);
 			if (help)
-				/* not in hash table yet, so not strictly
-				   necessary */
 				rcu_assign_pointer(help->helper, helper);
-			else
-				DEBUGP("failed to add helper extension area");
 		}
 		NF_CT_STAT_INC(new);
 	}
@@ -721,11 +713,9 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 	}
 
 	if (help == NULL) {
-		help = nf_ct_ext_add(ct, NF_CT_EXT_HELPER, GFP_ATOMIC);
-		if (help == NULL) {
-			DEBUGP("failed to add helper extension area");
+		help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
+		if (help == NULL)
 			goto out;
-		}
 	} else {
 		memset(&help->help, 0, sizeof(help->help));
 	}
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 0e61c69..1a9683b 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -27,9 +27,6 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 
-LIST_HEAD(nf_ct_expect_list);
-EXPORT_SYMBOL_GPL(nf_ct_expect_list);
-
 struct hlist_head *nf_ct_expect_hash __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_expect_hash);
 
@@ -52,13 +49,14 @@ void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
 	NF_CT_ASSERT(master_help);
 	NF_CT_ASSERT(!timer_pending(&exp->timeout));
 
-	list_del(&exp->list);
 	hlist_del(&exp->hnode);
 	nf_ct_expect_count--;
 
-	NF_CT_STAT_INC(expect_delete);
+	hlist_del(&exp->lnode);
 	master_help->expecting--;
 	nf_ct_expect_put(exp);
+
+	NF_CT_STAT_INC(expect_delete);
 }
 EXPORT_SYMBOL_GPL(nf_ct_unlink_expect);
 
@@ -153,17 +151,18 @@ nf_ct_find_expectation(const struct nf_conntrack_tuple *tuple)
 /* delete all expectations for this conntrack */
 void nf_ct_remove_expectations(struct nf_conn *ct)
 {
-	struct nf_conntrack_expect *i, *tmp;
 	struct nf_conn_help *help = nfct_help(ct);
+	struct nf_conntrack_expect *exp;
+	struct hlist_node *n, *next;
 
 	/* Optimization: most connection never expect any others. */
 	if (!help || help->expecting == 0)
 		return;
 
-	list_for_each_entry_safe(i, tmp, &nf_ct_expect_list, list) {
-		if (i->master == ct && del_timer(&i->timeout)) {
-			nf_ct_unlink_expect(i);
-			nf_ct_expect_put(i);
+	hlist_for_each_entry_safe(exp, n, next, &help->expectations, lnode) {
+		if (del_timer(&exp->timeout)) {
+			nf_ct_unlink_expect(exp);
+			nf_ct_expect_put(exp);
 		}
 	}
 }
@@ -289,9 +288,10 @@ static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 	unsigned int h = nf_ct_expect_dst_hash(&exp->tuple);
 
 	atomic_inc(&exp->use);
+
+	hlist_add_head(&exp->lnode, &master_help->expectations);
 	master_help->expecting++;
 
-	list_add(&exp->list, &nf_ct_expect_list);
 	hlist_add_head(&exp->hnode, &nf_ct_expect_hash[h]);
 	nf_ct_expect_count++;
 
@@ -308,16 +308,16 @@ static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 /* Race with expectations being used means we could have none to find; OK. */
 static void evict_oldest_expect(struct nf_conn *master)
 {
-	struct nf_conntrack_expect *i;
+	struct nf_conn_help *master_help = nfct_help(master);
+	struct nf_conntrack_expect *exp = NULL;
+	struct hlist_node *n;
 
-	list_for_each_entry_reverse(i, &nf_ct_expect_list, list) {
-		if (i->master == master) {
-			if (del_timer(&i->timeout)) {
-				nf_ct_unlink_expect(i);
-				nf_ct_expect_put(i);
-			}
-			break;
-		}
+	hlist_for_each_entry(exp, n, &master_help->expectations, lnode)
+		; /* nothing */
+
+	if (exp && del_timer(&exp->timeout)) {
+		nf_ct_unlink_expect(exp);
+		nf_ct_expect_put(exp);
 	}
 }
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index cc8ae74..66c209d 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -87,6 +87,19 @@ __nf_conntrack_helper_find_byname(const char *name)
 }
 EXPORT_SYMBOL_GPL(__nf_conntrack_helper_find_byname);
 
+struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp)
+{
+	struct nf_conn_help *help;
+
+	help = nf_ct_ext_add(ct, NF_CT_EXT_HELPER, gfp);
+	if (help)
+		INIT_HLIST_HEAD(&help->expectations);
+	else
+		pr_debug("failed to add helper extension area");
+	return help;
+}
+EXPORT_SYMBOL_GPL(nf_ct_helper_ext_add);
+
 static inline int unhelp(struct nf_conntrack_tuple_hash *i,
 			 const struct nf_conntrack_helper *me)
 {
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 60af9b6..6f89b10 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -868,7 +868,7 @@ ctnetlink_change_helper(struct nf_conn *ct, struct nfattr *cda[])
 		/* need to zero data of old helper */
 		memset(&help->help, 0, sizeof(help->help));
 	} else {
-		help = nf_ct_ext_add(ct, NF_CT_EXT_HELPER, GFP_KERNEL);
+		help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
 		if (help == NULL)
 			return -ENOMEM;
 	}
@@ -989,7 +989,7 @@ ctnetlink_create_conntrack(struct nfattr *cda[],
 
 	helper = nf_ct_helper_find_get(rtuple);
 	if (helper) {
-		help = nf_ct_ext_add(ct, NF_CT_EXT_HELPER, GFP_KERNEL);
+		help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
 		if (help == NULL) {
 			nf_ct_helper_put(helper);
 			err = -ENOMEM;
