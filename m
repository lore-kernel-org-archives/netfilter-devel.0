From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 5/8] Netfilter:  Use ct_extend for helper pointer
Date: Thu, 13 Jan 2005 07:59:00 +1100
Message-ID: <1105563544.12794.12.camel@localhost.localdomain>
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

Name: Use ct_extend for helper pointer
Status: Tested lightly under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Most connections don't have a connection tracking helper.  So that
pointer is a good candidate to put in ct_extend.

Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/ip_nat_core.c	2005-01-12 23:29:00.605426112 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_nat_core.c	2005-01-12 23:43:00.822693672 +1100
@@ -283,7 +283,8 @@
 
 		/* Alter conntrack table so will recognize replies. */
 		invert_tuplepr(&reply, &new_tuple);
-		ip_conntrack_alter_reply(conntrack, &reply);
+		if (ip_conntrack_alter_reply(conntrack, &reply) != 0)
+			return NF_DROP;
 
 		/* Non-atomic: we own this at the moment. */
 		if (maniptype == IP_NAT_MANIP_SRC)
Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-12 23:41:09.571606408 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-12 23:42:01.974639936 +1100
@@ -385,11 +385,17 @@
 
 	/* This is where we call the helper: as the packet goes out. */
 	ct = ip_conntrack_get(*pskb, &ctinfo);
-	if (ct && ct->helper) {
-		unsigned int ret;
-		ret = ct->helper->help(pskb, ct, ctinfo);
-		if (ret != NF_ACCEPT)
-			return ret;
+	if (ct) {
+		struct ip_conntrack_helper **helpp;
+
+		/* Don't need lock: ct not in hash yet. */
+		helpp = ct_extend_find(ct->ext, CTE_CT_HELPER);
+		if (helpp) {
+			unsigned int ret;
+			ret = (*helpp)->help(pskb, ct, ctinfo);
+			if (ret != NF_ACCEPT)
+				return ret;
+		}
 	}
 
 	/* We've seen it coming out the other side: confirm it */
Index: linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ip_nat.h
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/include/linux/netfilter_ipv4/ip_nat.h	2005-01-12 23:29:00.641420640 +1100
+++ linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ip_nat.h	2005-01-12 23:43:00.823693520 +1100
@@ -57,9 +57,6 @@
 {
 	struct list_head bysource;
 
-	/* Helper (NULL if none). */
-	struct ip_nat_helper *helper;
-
 	struct ip_nat_seq seq[IP_CT_DIR_MAX];
 };
 
Index: linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-12 23:41:09.573606104 +1100
+++ linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-12 23:42:02.014633856 +1100
@@ -172,9 +172,6 @@
 	/* Current number of expected connections */
 	unsigned int expecting;
 
-	/* Helper, if any. */
-	struct ip_conntrack_helper *helper;
-
 	/* Storage reserved for other modules: */
 	union ip_conntrack_proto proto;
 
@@ -202,8 +199,8 @@
 /* get master conntrack via master expectation */
 #define master_ct(conntr) (conntr->master)
 
-/* Alter reply tuple (maybe alter helper). */
-extern void
+/* Alter reply tuple (maybe alter helper).  Returns 0 or -errno. */
+extern int
 ip_conntrack_alter_reply(struct ip_conntrack *conntrack,
 			 const struct ip_conntrack_tuple *newreply);
 
Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ipt_helper.c
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/ipt_helper.c	2005-01-12 23:29:00.605426112 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ipt_helper.c	2005-01-12 23:42:02.015633704 +1100
@@ -18,6 +18,7 @@
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_helper.h>
+#include <linux/netfilter_ipv4/ct_extend.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Martin Josefsson <gandalf@netfilter.org>");
@@ -40,6 +41,7 @@
 	const struct ipt_helper_info *info = matchinfo;
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
+	struct ip_conntrack_helper **helpp;
 	int ret = info->invert;
 	
 	ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
@@ -54,20 +56,21 @@
 	}
 
 	READ_LOCK(&ip_conntrack_lock);
-	if (!ct->master->helper) {
+	helpp = ct_extend_find(ct->master->ext, CTE_CT_HELPER);
+	if (!helpp) {
 		DEBUGP("ipt_helper: master ct %p has no helper\n", 
 			exp->expectant);
 		goto out_unlock;
 	}
 
 	DEBUGP("master's name = %s , info->name = %s\n", 
-		ct->master->helper->name, info->name);
+		(*helpp)->name, info->name);
 
 	if (info->name[0] == '\0')
 		ret ^= 1;
 	else
-		ret ^= !strncmp(ct->master->helper->name, info->name, 
-		                strlen(ct->master->helper->name));
+		ret ^= !strncmp((*helpp)->name, info->name, 
+		                strlen((*helpp)->name));
 out_unlock:
 	READ_UNLOCK(&ip_conntrack_lock);
 	return ret;
Index: linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ct_extend.h
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/include/linux/netfilter_ipv4/ct_extend.h	2005-01-12 23:41:58.520165096 +1100
+++ linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ct_extend.h	2005-01-12 23:43:16.845257872 +1100
@@ -7,12 +7,14 @@
 	CTE_MASQ,
 	CTE_FTP_CONN,
 	CTE_MARK,
+	CTE_CT_HELPER,
 	CTE_MAX,
 } __attribute__((packed));
 
 #define CTE_MASQ_TYPE char 	/* Actually char[IFNAMSIZ] */
 #define CTE_FTP_CONN_TYPE struct ip_ct_ftp_master
 #define CTE_MARK_TYPE unsigned long
+#define CTE_CT_HELPER_TYPE struct ip_conntrack_helper *
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct ct_extend {
Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-12 23:41:09.578605344 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-12 23:42:02.018633248 +1100
@@ -574,8 +574,19 @@
 		nf_conntrack_get(&conntrack->master->ct_general);
 		CONNTRACK_STAT_INC(expect_new);
 	} else {
-		conntrack->helper = ip_ct_find_helper(&repl_tuple);
+		struct ip_conntrack_helper *helper, **helpp;
 
+		helper = ip_ct_find_helper(&repl_tuple);
+		if (helper) {
+			helpp = ct_extend_add(&conntrack->ext, CTE_CT_HELPER,
+					      GFP_ATOMIC);
+			if (!helpp) {
+				kmem_cache_free(ip_conntrack_cachep,conntrack);
+				WRITE_UNLOCK(&ip_conntrack_lock);
+				return NULL;
+			}
+			*helpp = helper;
+		}
 		CONNTRACK_STAT_INC(new);
 	}
 
@@ -805,18 +816,19 @@
 	kmem_cache_free(ip_conntrack_expect_cachep, expect);
 }
 
-static void ip_conntrack_expect_insert(struct ip_conntrack_expect *exp)
+static void ip_conntrack_expect_insert(struct ip_conntrack_expect *exp,
+				       struct ip_conntrack_helper *helper)
 {
 	atomic_inc(&exp->master->ct_general.use);
 	exp->master->expecting++;
 	list_add(&exp->list, &ip_conntrack_expect_list);
 
-	if (exp->master->helper->timeout) {
+	if (helper->timeout) {
 		init_timer(&exp->timeout);
 		exp->timeout.data = (unsigned long)exp;
 		exp->timeout.function = expectation_timed_out;
 		exp->timeout.expires
-			= jiffies + exp->master->helper->timeout * HZ;
+			= jiffies + helper->timeout * HZ;
 		add_timer(&exp->timeout);
 	} else
 		exp->timeout.function = NULL;
@@ -840,12 +852,13 @@
 	}
 }
 
-static inline int refresh_timer(struct ip_conntrack_expect *i)
+static inline int refresh_timer(struct ip_conntrack_expect *i,
+				struct ip_conntrack_helper *helper)
 {
 	if (!del_timer(&i->timeout))
 		return 0;
 
-	i->timeout.expires = jiffies + i->master->helper->timeout*HZ;
+	i->timeout.expires = jiffies + helper->timeout*HZ;
 	add_timer(&i->timeout);
 	return 1;
 }
@@ -854,16 +867,20 @@
 {
 	struct ip_conntrack_expect *i;
 	int ret;
+	struct ip_conntrack_helper **helpp;
 
 	DEBUGP("ip_conntrack_expect_related %p\n", related_to);
 	DEBUGP("tuple: "); DUMP_TUPLE(&expect->tuple);
 	DEBUGP("mask:  "); DUMP_TUPLE(&expect->mask);
 
 	WRITE_LOCK(&ip_conntrack_lock);
+	helpp = ct_extend_find(expect->master->ext, CTE_CT_HELPER);
+	BUG_ON(!helpp || !*helpp);
+
 	list_for_each_entry(i, &ip_conntrack_expect_list, list) {
 		if (expect_matches(i, expect)) {
 			/* Refresh timer: if it's dying, ignore.. */
-			if (refresh_timer(i)) {
+			if (refresh_timer(i, *helpp)) {
 				ret = 0;
 				/* We don't need the one they've given us. */
 				ip_conntrack_expect_free(expect);
@@ -876,11 +893,11 @@
 	}
 
 	/* Will be over limit? */
-	if (expect->master->helper->max_expected && 
-	    expect->master->expecting >= expect->master->helper->max_expected)
+	if ((*helpp)->max_expected && 
+	    expect->master->expecting >= (*helpp)->max_expected)
 		evict_oldest_expect(expect->master);
 
-	ip_conntrack_expect_insert(expect);
+	ip_conntrack_expect_insert(expect, *helpp);
 	ret = 0;
 out:
 	WRITE_UNLOCK(&ip_conntrack_lock);
@@ -889,10 +906,11 @@
 
 /* Alter reply tuple (maybe alter helper).  This is for NAT, and is
    implicitly racy: see __ip_conntrack_confirm */
-void ip_conntrack_alter_reply(struct ip_conntrack *conntrack,
-			      const struct ip_conntrack_tuple *newreply)
+int ip_conntrack_alter_reply(struct ip_conntrack *conntrack,
+			     const struct ip_conntrack_tuple *newreply)
 {
-	WRITE_LOCK(&ip_conntrack_lock);
+	struct ip_conntrack_helper *helper, **helpp;
+
 	/* Should be unconfirmed, so not in hash table yet */
 	IP_NF_ASSERT(!is_confirmed(conntrack));
 
@@ -900,9 +918,25 @@
 	DUMP_TUPLE(newreply);
 
 	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
-	if (!conntrack->master && conntrack->expecting == 0)
-		conntrack->helper = ip_ct_find_helper(newreply);
+	if (conntrack->master || conntrack->expecting)
+		return 0;
+
+	WRITE_LOCK(&ip_conntrack_lock);
+	helper = ip_ct_find_helper(newreply);
+	if (helper) {
+		helpp = ct_extend_find(conntrack->ext, CTE_CT_HELPER);
+		if (!helpp) {
+			helpp = ct_extend_add(&conntrack->ext, CTE_CT_HELPER,
+					      GFP_ATOMIC);
+			if (!helpp) {
+				READ_UNLOCK(&ip_conntrack_lock);
+				return -ENOMEM;
+			}
+		}
+		*helpp = helper;
+	}
 	WRITE_UNLOCK(&ip_conntrack_lock);
+	return 0;
 }
 
 int ip_conntrack_helper_register(struct ip_conntrack_helper *me)
@@ -918,8 +952,13 @@
 static inline int unhelp(struct ip_conntrack_tuple_hash *i,
 			 const struct ip_conntrack_helper *me)
 {
-	if (tuplehash_to_ctrack(i)->helper == me)
-		tuplehash_to_ctrack(i)->helper = NULL;
+	struct ip_conntrack_helper **helpp;
+	helpp = ct_extend_find(tuplehash_to_ctrack(i)->ext, CTE_CT_HELPER);
+
+	if (helpp && *helpp == me)
+		tuplehash_to_ctrack(i)->ext
+			= ct_extend_del(tuplehash_to_ctrack(i)->ext,
+					CTE_CT_HELPER);
 	return 0;
 }
 
@@ -934,7 +973,10 @@
 
 	/* Get rid of expectations */
 	list_for_each_entry_safe(exp, tmp, &ip_conntrack_expect_list, list) {
-		if (exp->master->helper == me && del_timer(&exp->timeout)) {
+		struct ip_conntrack_helper **helpp;
+		helpp = ct_extend_find(exp->master->ext, CTE_CT_HELPER);
+
+		if (*helpp == me && del_timer(&exp->timeout)) {
 			unlink_expect(exp);
 			destroy_expect(exp);
 		}
@@ -1178,6 +1220,13 @@
 				     * ip_conntrack_htable_size));
 }
 
+static struct ct_extend_type helper_extend =
+{
+	.len = sizeof(struct ip_conntrack_helper *),
+	.align = __alignof__(struct ip_conntrack_helper *),
+	.type = CTE_CT_HELPER,
+};
+
 /* Mishearing the voices in his head, our hero wonders how he's
    supposed to kill the mall. */
 void ip_conntrack_cleanup(void)
@@ -1196,6 +1245,7 @@
 	}
 
 	unregister_cte_mark();
+	unregister_ct_extend_type(&helper_extend);
 	kmem_cache_destroy(ip_conntrack_cachep);
 	kmem_cache_destroy(ip_conntrack_expect_cachep);
 	free_conntrack_hash();
@@ -1293,6 +1343,7 @@
 	/*  - and look it like as a confirmed connection */
 	set_bit(IPS_CONFIRMED_BIT, &ip_conntrack_untracked.status);
 
+	register_ct_extend_type(&helper_extend);
 	register_cte_mark();
 
 	return ret;
