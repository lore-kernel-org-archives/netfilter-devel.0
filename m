From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 8/8] Netfilter:  Use ct_extend for number of expectations
Date: Thu, 13 Jan 2005 07:59:41 +1100
Message-ID: <1105563581.12794.15.camel@localhost.localdomain>
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

Name: Use ct_extend for number of expectations
Status: Tested lightly under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Only connections with helpers can have expectations, so the
"expectations" field is usually unused.  Put it in CTE_CT_HELPER with
the helper pointer.

Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-12 23:42:01.974639936 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-12 23:45:27.310424152 +1100
@@ -386,13 +386,13 @@
 	/* This is where we call the helper: as the packet goes out. */
 	ct = ip_conntrack_get(*pskb, &ctinfo);
 	if (ct) {
-		struct ip_conntrack_helper **helpp;
+		struct ip_ct_helper_extend *helpext;
 
 		/* Don't need lock: ct not in hash yet. */
-		helpp = ct_extend_find(ct->ext, CTE_CT_HELPER);
-		if (helpp) {
+		helpext = ct_extend_find(ct->ext, CTE_CT_HELPER);
+		if (helpext) {
 			unsigned int ret;
-			ret = (*helpp)->help(pskb, ct, ctinfo);
+			ret = helpext->helper->help(pskb, ct, ctinfo);
 			if (ret != NF_ACCEPT)
 				return ret;
 		}
Index: linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-12 23:44:23.300155192 +1100
+++ linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-12 23:45:27.312423848 +1100
@@ -166,8 +166,6 @@
 	/* Accounting Information (same cache line as other written members) */
 	struct ip_conntrack_counter counters[IP_CT_DIR_MAX];
 #endif
-	/* Current number of expected connections */
-	unsigned int expecting;
 
 	/* Storage reserved for other modules: */
 	union ip_conntrack_proto proto;
Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ipt_helper.c
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/ipt_helper.c	2005-01-12 23:44:23.301155040 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ipt_helper.c	2005-01-12 23:45:27.312423848 +1100
@@ -41,7 +41,7 @@
 	const struct ipt_helper_info *info = matchinfo;
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
-	struct ip_conntrack_helper **helpp;
+	struct ip_ct_helper_extend *helpext;
 	struct ip_conntrack **master;
 	int ret = info->invert;
 	
@@ -58,21 +58,21 @@
 	}
 
 	READ_LOCK(&ip_conntrack_lock);
-	helpp = ct_extend_find((*master)->ext, CTE_CT_HELPER);
-	if (!helpp) {
+	helpext = ct_extend_find((*master)->ext, CTE_CT_HELPER);
+	if (!helpext) {
 		DEBUGP("ipt_helper: master ct %p has no helper\n", 
 			exp->expectant);
 		goto out_unlock;
 	}
 
 	DEBUGP("master's name = %s , info->name = %s\n", 
-		(*helpp)->name, info->name);
+		helpext->helper->name, info->name);
 
 	if (info->name[0] == '\0')
 		ret ^= 1;
 	else
-		ret ^= !strncmp((*helpp)->name, info->name, 
-		                strlen((*helpp)->name));
+		ret ^= !strncmp(helpext->helper->name, info->name, 
+		                strlen(helpext->helper->name));
 out_unlock:
 	READ_UNLOCK(&ip_conntrack_lock);
 	return ret;
Index: linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ct_extend.h
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/include/linux/netfilter_ipv4/ct_extend.h	2005-01-12 23:45:24.353873616 +1100
+++ linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ct_extend.h	2005-01-12 23:46:34.107269488 +1100
@@ -16,7 +16,7 @@
 #define CTE_MASQ_TYPE char 	/* Actually char[IFNAMSIZ] */
 #define CTE_FTP_CONN_TYPE struct ip_ct_ftp_master
 #define CTE_MARK_TYPE unsigned long
-#define CTE_CT_HELPER_TYPE struct ip_conntrack_helper *
+#define CTE_CT_HELPER_TYPE struct ip_ct_helper_extend
 #define CTE_NAT_SEQ_TYPE struct ip_nat_seq
 #define CTE_MASTER_TYPE struct ip_conntrack *
 
Index: linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_helper.h
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2005-01-12 23:28:49.949046128 +1100
+++ linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2005-01-12 23:45:27.313423696 +1100
@@ -26,6 +26,15 @@
 		    enum ip_conntrack_info conntrackinfo);
 };
 
+/* The structure for CTE_CT_HELPER */
+struct ip_ct_helper_extend
+{
+	struct ip_conntrack_helper *helper;
+
+	/* Current number of expected connections */
+	unsigned int expecting;
+};
+
 extern int ip_conntrack_helper_register(struct ip_conntrack_helper *);
 extern void ip_conntrack_helper_unregister(struct ip_conntrack_helper *);
 
Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-12 23:44:23.304154584 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-12 23:45:27.316423240 +1100
@@ -148,10 +148,12 @@
 
 static void unlink_expect(struct ip_conntrack_expect *exp)
 {
+	struct ip_ct_helper_extend *helpext;
 	MUST_BE_WRITE_LOCKED(&ip_conntrack_lock);
 	list_del(&exp->list);
+	helpext = ct_extend_find(exp->master->ext, CTE_CT_HELPER);
 	/* Logically in destroy_expect, but we hold the lock here. */
-	exp->master->expecting--;
+	helpext->expecting--;
 }
 
 static void expectation_timed_out(unsigned long ul_expect)
@@ -193,7 +195,7 @@
 	struct ip_conntrack_expect *i, *tmp;
 
 	/* Optimization: most connection never expect any others. */
-	if (ct->expecting == 0)
+	if (!ct_extend_find(ct->ext, CTE_CT_HELPER))
 		return;
 
 	list_for_each_entry_safe(i, tmp, &ip_conntrack_expect_list, list) {
@@ -585,18 +587,20 @@
 		nf_conntrack_get(&exp->master->ct_general);
 		CONNTRACK_STAT_INC(expect_new);
 	} else {
-		struct ip_conntrack_helper *helper, **helpp;
+		struct ip_conntrack_helper *helper;
+		struct ip_ct_helper_extend *helpext;
 
 		helper = ip_ct_find_helper(&repl_tuple);
 		if (helper) {
-			helpp = ct_extend_add(&conntrack->ext, CTE_CT_HELPER,
-					      GFP_ATOMIC);
-			if (!helpp) {
+			helpext = ct_extend_add(&conntrack->ext, CTE_CT_HELPER,
+						GFP_ATOMIC);
+			if (!helpext) {
 				kmem_cache_free(ip_conntrack_cachep,conntrack);
 				WRITE_UNLOCK(&ip_conntrack_lock);
 				return NULL;
 			}
-			*helpp = helper;
+			helpext->helper = helper;
+			helpext->expecting = 0;
 		}
 		CONNTRACK_STAT_INC(new);
 	}
@@ -828,18 +832,18 @@
 }
 
 static void ip_conntrack_expect_insert(struct ip_conntrack_expect *exp,
-				       struct ip_conntrack_helper *helper)
+				       struct ip_ct_helper_extend *helpext)
 {
 	atomic_inc(&exp->master->ct_general.use);
-	exp->master->expecting++;
+	helpext->expecting++;
 	list_add(&exp->list, &ip_conntrack_expect_list);
 
-	if (helper->timeout) {
+	if (helpext->helper->timeout) {
 		init_timer(&exp->timeout);
 		exp->timeout.data = (unsigned long)exp;
 		exp->timeout.function = expectation_timed_out;
 		exp->timeout.expires
-			= jiffies + helper->timeout * HZ;
+			= jiffies + helpext->helper->timeout * HZ;
 		add_timer(&exp->timeout);
 	} else
 		exp->timeout.function = NULL;
@@ -878,20 +882,20 @@
 {
 	struct ip_conntrack_expect *i;
 	int ret;
-	struct ip_conntrack_helper **helpp;
+	struct ip_ct_helper_extend *helpext;
 
 	DEBUGP("ip_conntrack_expect_related %p\n", related_to);
 	DEBUGP("tuple: "); DUMP_TUPLE(&expect->tuple);
 	DEBUGP("mask:  "); DUMP_TUPLE(&expect->mask);
 
 	WRITE_LOCK(&ip_conntrack_lock);
-	helpp = ct_extend_find(expect->master->ext, CTE_CT_HELPER);
-	BUG_ON(!helpp || !*helpp);
+	helpext = ct_extend_find(expect->master->ext, CTE_CT_HELPER);
+	BUG_ON(!helpext || !helpext->helper);
 
 	list_for_each_entry(i, &ip_conntrack_expect_list, list) {
 		if (expect_matches(i, expect)) {
 			/* Refresh timer: if it's dying, ignore.. */
-			if (refresh_timer(i, *helpp)) {
+			if (refresh_timer(i, helpext->helper)) {
 				ret = 0;
 				/* We don't need the one they've given us. */
 				ip_conntrack_expect_free(expect);
@@ -904,11 +908,11 @@
 	}
 
 	/* Will be over limit? */
-	if ((*helpp)->max_expected && 
-	    expect->master->expecting >= (*helpp)->max_expected)
+	if (helpext->helper->max_expected && 
+	    helpext->expecting >= helpext->helper->max_expected)
 		evict_oldest_expect(expect->master);
 
-	ip_conntrack_expect_insert(expect, *helpp);
+	ip_conntrack_expect_insert(expect, helpext);
 	ret = 0;
 out:
 	WRITE_UNLOCK(&ip_conntrack_lock);
@@ -920,7 +924,7 @@
 int ip_conntrack_alter_reply(struct ip_conntrack *conntrack,
 			     const struct ip_conntrack_tuple *newreply)
 {
-	struct ip_conntrack_helper *helper, **helpp;
+	struct ip_conntrack_helper *helper;
 
 	/* Should be unconfirmed, so not in hash table yet */
 	IP_NF_ASSERT(!is_confirmed(conntrack));
@@ -929,22 +933,28 @@
 	DUMP_TUPLE(newreply);
 
 	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
-	if (conntrack->expecting || ct_extend_find(conntrack->ext, CTE_MASTER))
+	if (ct_extend_find(conntrack->ext, CTE_MASTER))
 		return 0;
 
 	WRITE_LOCK(&ip_conntrack_lock);
 	helper = ip_ct_find_helper(newreply);
 	if (helper) {
-		helpp = ct_extend_find(conntrack->ext, CTE_CT_HELPER);
-		if (!helpp) {
-			helpp = ct_extend_add(&conntrack->ext, CTE_CT_HELPER,
-					      GFP_ATOMIC);
-			if (!helpp) {
-				READ_UNLOCK(&ip_conntrack_lock);
+		struct ip_ct_helper_extend *helpext;
+
+		helpext = ct_extend_find(conntrack->ext, CTE_CT_HELPER);
+		if (helpext->expecting) {
+			WRITE_UNLOCK(&ip_conntrack_lock);
+			return 0;
+		}
+		if (!helpext) {
+			helpext = ct_extend_add(&conntrack->ext, CTE_CT_HELPER,
+						GFP_ATOMIC);
+			if (!helpext) {
+				WRITE_UNLOCK(&ip_conntrack_lock);
 				return -ENOMEM;
 			}
 		}
-		*helpp = helper;
+		helpext->helper = helper;
 	}
 	WRITE_UNLOCK(&ip_conntrack_lock);
 	return 0;
@@ -963,10 +973,10 @@
 static inline int unhelp(struct ip_conntrack_tuple_hash *i,
 			 const struct ip_conntrack_helper *me)
 {
-	struct ip_conntrack_helper **helpp;
-	helpp = ct_extend_find(tuplehash_to_ctrack(i)->ext, CTE_CT_HELPER);
+	struct ip_ct_helper_extend *helpext;
+	helpext = ct_extend_find(tuplehash_to_ctrack(i)->ext, CTE_CT_HELPER);
 
-	if (helpp && *helpp == me)
+	if (helpext && helpext->helper == me)
 		tuplehash_to_ctrack(i)->ext
 			= ct_extend_del(tuplehash_to_ctrack(i)->ext,
 					CTE_CT_HELPER);
@@ -984,10 +994,10 @@
 
 	/* Get rid of expectations */
 	list_for_each_entry_safe(exp, tmp, &ip_conntrack_expect_list, list) {
-		struct ip_conntrack_helper **helpp;
-		helpp = ct_extend_find(exp->master->ext, CTE_CT_HELPER);
+		struct ip_ct_helper_extend *helpext;
+		helpext = ct_extend_find(exp->master->ext, CTE_CT_HELPER);
 
-		if (*helpp == me && del_timer(&exp->timeout)) {
+		if (helpext->helper == me && del_timer(&exp->timeout)) {
 			unlink_expect(exp);
 			destroy_expect(exp);
 		}
@@ -1233,8 +1243,8 @@
 
 static struct ct_extend_type helper_extend =
 {
-	.len = sizeof(struct ip_conntrack_helper *),
-	.align = __alignof__(struct ip_conntrack_helper *),
+	.len = sizeof(struct ip_ct_helper_extend),
+	.align = __alignof__(struct ip_ct_helper_extend),
 	.type = CTE_CT_HELPER,
 };
 
