From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 4/8] Netfilter:  Use ct_extend for conntrack mark value
Date: Thu, 13 Jan 2005 07:58:44 +1100
Message-ID: <1105563524.12794.11.camel@localhost.localdomain>
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

Name: Use ct_extend for conntrack mark value
Status: Tested lightly under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Move the connection tracking mark value to ct_extend.  While used
frequently, ct_extend_find() is a few cycles and only a single
cacheline access.  Certainly cheap if most connections don't have
anything in ct->ext.

Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ipt_CONNMARK.c
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/ipt_CONNMARK.c	2005-01-12 23:29:02.873081376 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ipt_CONNMARK.c	2005-01-12 23:41:09.570606560 +1100
@@ -30,6 +30,23 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_CONNMARK.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ct_extend.h>
+
+static unsigned int set_mark(struct ip_conntrack *ct,
+			     unsigned long *markp,
+			     unsigned long mark)
+{
+	if (!markp) {
+		/* Nonexistent means 0 anyway. */
+		if (mark == 0)
+			return IPT_CONTINUE;
+		markp = ct_extend_add(&ct->ext, CTE_MARK, GFP_ATOMIC);
+		if (!markp)
+			return NF_DROP;
+	}
+	*markp = mark;
+	return IPT_CONTINUE;
+}
 
 static unsigned int
 target(struct sk_buff **pskb,
@@ -40,36 +57,51 @@
        void *userinfo)
 {
 	const struct ipt_connmark_target_info *markinfo = targinfo;
+	unsigned int ret = IPT_CONTINUE;
 	unsigned long diff;
 	unsigned long nfmark;
 	unsigned long newmark;
-
+	unsigned long mark, *markp;
 	enum ip_conntrack_info ctinfo;
 	struct ip_conntrack *ct = ip_conntrack_get((*pskb), &ctinfo);
-	if (ct) {
-	    switch(markinfo->mode) {
-	    case IPT_CONNMARK_SET:
-		newmark = (ct->mark & ~markinfo->mask) | markinfo->mark;
-		if (newmark != ct->mark)
-		    ct->mark = newmark;
-		break;
-	    case IPT_CONNMARK_SAVE:
-		newmark = (ct->mark & ~markinfo->mask) | ((*pskb)->nfmark & markinfo->mask);
-		if (ct->mark != newmark)
-		    ct->mark = newmark;
-		break;
-	    case IPT_CONNMARK_RESTORE:
+
+	if (!ct)
+		return IPT_CONTINUE;
+
+	switch(markinfo->mode) {
+	case IPT_CONNMARK_SET:
+		WRITE_LOCK(&ip_conntrack_lock);
+		markp = ct_extend_find(ct->ext, CTE_MARK);
+		mark = markp ? *markp : 0;
+
+		newmark = (mark & ~markinfo->mask) | markinfo->mark;
+		ret = set_mark(ct, markp, newmark);
+		WRITE_UNLOCK(&ip_conntrack_lock);
+	case IPT_CONNMARK_SAVE:
+		WRITE_LOCK(&ip_conntrack_lock);
+		markp = ct_extend_find(ct->ext, CTE_MARK);
+		mark = markp ? *markp : 0;
+
+		newmark = ((mark & ~markinfo->mask)
+			   | ((*pskb)->nfmark & markinfo->mask));
+		ret = set_mark(ct, markp, newmark);
+		WRITE_UNLOCK(&ip_conntrack_lock);
+	case IPT_CONNMARK_RESTORE:
+		READ_LOCK(&ip_conntrack_lock);
+		markp = ct_extend_find(ct->ext, CTE_MARK);
+		mark = markp ? *markp : 0;
+
 		nfmark = (*pskb)->nfmark;
-		diff = (ct->mark ^ nfmark) & markinfo->mask;
+		diff = (mark ^ nfmark) & markinfo->mask;
 		if (diff != 0) {
-		    (*pskb)->nfmark = nfmark ^ diff;
-		    (*pskb)->nfcache |= NFC_ALTERED;
+			(*pskb)->nfmark = nfmark ^ diff;
+			(*pskb)->nfcache |= NFC_ALTERED;
 		}
+		READ_UNLOCK(&ip_conntrack_lock);
 		break;
-	    }
 	}
 
-	return IPT_CONTINUE;
+	return ret;
 }
 
 static int
Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-12 23:29:02.874081224 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-12 23:41:09.571606408 +1100
@@ -36,6 +36,7 @@
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/listhelp.h>
+#include <linux/netfilter_ipv4/ct_extend.h>
 
 #if 0
 #define DEBUGP printk
@@ -96,6 +97,25 @@
 	return &ip_conntrack_hash[*pos];
 }
   
+#ifdef CONFIG_IP_NF_CONNTRACK_MARK
+static int print_mark(struct seq_file *s, const struct ip_conntrack *conntrack)
+{
+	unsigned long *markp, mark;
+
+	READ_LOCK(&ip_conntrack_lock);
+	markp = ct_extend_find(conntrack->ext, CTE_MARK);
+	mark = markp ? *markp: 0;
+	READ_UNLOCK(&ip_conntrack_lock);
+
+	return seq_printf(s, "mark=%ld ", mark);
+}
+#else
+static int print_mark(struct seq_file *s, const struct ip_conntrack *conntrack)
+{
+	return 0;
+}
+#endif
+
 /* return 0 on success, 1 in case of error */
 static int ct_seq_real_show(const struct ip_conntrack_tuple_hash *hash,
 			    struct seq_file *s)
@@ -147,10 +167,8 @@
 		if (seq_printf(s, "[ASSURED] "))
 			return 1;
 
-#if defined(CONFIG_IP_NF_CONNTRACK_MARK)
-	if (seq_printf(s, "mark=%ld ", conntrack->mark))
+	if (print_mark(s, conntrack) != 0)
 		return 1;
-#endif
 
 	if (seq_printf(s, "use=%u\n", atomic_read(&conntrack->ct_general.use)))
 		return 1;
Index: linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-12 23:40:34.631918048 +1100
+++ linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-12 23:41:09.573606104 +1100
@@ -187,10 +187,6 @@
 	} nat;
 #endif /* CONFIG_IP_NF_NAT_NEEDED */
 
-#if defined(CONFIG_IP_NF_CONNTRACK_MARK)
-	unsigned long mark;
-#endif
-
 	/* Traversed often, so hopefully in different cacheline to top */
 	/* These are my tuples; original and reply */
 	struct ip_conntrack_tuple_hash tuplehash[IP_CT_DIR_MAX];
Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ipt_connmark.c
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/ipt_connmark.c	2005-01-12 23:29:02.874081224 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ipt_connmark.c	2005-01-12 23:41:09.573606104 +1100
@@ -29,6 +29,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_connmark.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ct_extend.h>
 
 static int
 match(const struct sk_buff *skb,
@@ -40,11 +41,19 @@
 {
 	const struct ipt_connmark_info *info = matchinfo;
 	enum ip_conntrack_info ctinfo;
-	struct ip_conntrack *ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
+	struct ip_conntrack *ct;
+	unsigned long *markp, mark;
+
+	ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
 	if (!ct)
 		return 0;
 
-	return ((ct->mark & info->mask) == info->mark) ^ info->invert;
+	READ_LOCK(&ip_conntrack_lock);
+	markp = ct_extend_find(ct->ext, CTE_MARK);
+	mark = markp ? *markp : 0;
+	READ_UNLOCK(&ip_conntrack_lock);
+
+	return ((mark & info->mask) == info->mark) ^ info->invert;
 }
 
 static int
Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ipt_CLUSTERIP.c
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/ipt_CLUSTERIP.c	2005-01-12 23:29:02.874081224 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ipt_CLUSTERIP.c	2005-01-12 23:41:09.575605800 +1100
@@ -29,6 +29,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_CLUSTERIP.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ct_extend.h>
 
 #define CLUSTERIP_VERSION "0.6"
 
@@ -319,6 +320,7 @@
 	const struct ipt_clusterip_tgt_info *cipinfo = targinfo;
 	enum ip_conntrack_info ctinfo;
 	struct ip_conntrack *ct = ip_conntrack_get((*pskb), &ctinfo);
+	unsigned long *mark;
 	u_int32_t hash;
 
 	/* don't need to clusterip_config_get() here, since refcount
@@ -347,8 +349,16 @@
 	hash = clusterip_hashfn(*pskb, cipinfo->config);
 
 	switch (ctinfo) {
-		case IP_CT_NEW:
-			ct->mark = hash;
+		case IP_CT_NEW: {
+			WRITE_LOCK(&ip_conntrack_lock);
+			mark = ct_extend_find(ct->ext, CTE_MARK);
+			if (!mark && !(mark = ct_extend_add(&ct->ext, CTE_MARK,
+							    GFP_ATOMIC))) {
+				WRITE_UNLOCK(&ip_conntrack_lock);
+				return NF_DROP;
+			}
+			*mark = hash;
+			WRITE_UNLOCK(&ip_conntrack_lock);
 			break;
 		case IP_CT_RELATED:
 		case IP_CT_RELATED+IP_CT_IS_REPLY:
@@ -365,7 +375,6 @@
 #ifdef DEBUG_CLUSTERP
 	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 #endif
-	DEBUGP("hash=%u ct_hash=%lu ", hash, ct->mark);
 	if (!clusterip_responsible(cipinfo->config, hash)) {
 		DEBUGP("not responsible\n");
 		return NF_DROP;
Index: linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ct_extend.h
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/include/linux/netfilter_ipv4/ct_extend.h	2005-01-12 23:41:03.500529352 +1100
+++ linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ct_extend.h	2005-01-12 23:41:58.520165096 +1100
@@ -6,11 +6,13 @@
 {
 	CTE_MASQ,
 	CTE_FTP_CONN,
+	CTE_MARK,
 	CTE_MAX,
 } __attribute__((packed));
 
 #define CTE_MASQ_TYPE char 	/* Actually char[IFNAMSIZ] */
 #define CTE_FTP_CONN_TYPE struct ip_ct_ftp_master
+#define CTE_MARK_TYPE unsigned long
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct ct_extend {
Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-12 23:39:20.531183072 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-12 23:41:09.578605344 +1100
@@ -456,6 +456,51 @@
 			 tuple);
 }
 
+#if CONFIG_IP_NF_CONNTRACK_MARK
+static struct ct_extend_type mark_extend =
+{
+	.len = sizeof(unsigned long),
+	.align = __alignof__(unsigned long),
+	.type = CTE_MARK,
+};
+
+static int copy_mark(struct ip_conntrack *new, struct ip_conntrack *old)
+{
+	unsigned long *mark, *newmark;
+
+	mark = ct_extend_find(old, CTE_MARK);
+	if (!mark)
+		return 0;
+
+	newmark = ct_extend_add(&new->ext, CTE_MARK, GFP_ATOMIC);
+	if (!newmark)
+		return -ENOMEM;
+	*newmark = *mark;
+	return 0;
+}
+
+static void register_cte_mark(void)
+{
+	register_ct_extend_type(&mark_extend);
+}
+
+static void unregister_cte_mark(void)
+{
+	unregister_ct_extend_type(&mark_extend);
+}
+#else
+static inline int copy_mark(struct ip_conntrack *new, struct ip_conntrack *old)
+{
+	return 0;
+}
+static void register_cte_mark(void)
+{
+}
+static void unregister_cte_mark(void)
+{
+}
+#endif
+
 /* Allocate a new conntrack: we return -ENOMEM if classification
    failed due to stress.  Otherwise it really is unclassifiable. */
 static struct ip_conntrack_tuple_hash *
@@ -520,10 +565,12 @@
 			conntrack, exp);
 		/* Welcome, Mr. Bond.  We've been expecting you... */
 		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
+		if (copy_mark(conntrack, exp->master) < 0) {
+			WRITE_UNLOCK(&ip_conntrack_lock);
+			kmem_cache_free(ip_conntrack_cachep, conntrack);
+			return NULL;
+		}
 		conntrack->master = exp->master;
-#if CONFIG_IP_NF_CONNTRACK_MARK
-		conntrack->mark = exp->master->mark;
-#endif
 		nf_conntrack_get(&conntrack->master->ct_general);
 		CONNTRACK_STAT_INC(expect_new);
 	} else {
@@ -1148,6 +1195,7 @@
 		goto i_see_dead_people;
 	}
 
+	unregister_cte_mark();
 	kmem_cache_destroy(ip_conntrack_cachep);
 	kmem_cache_destroy(ip_conntrack_expect_cachep);
 	free_conntrack_hash();
@@ -1245,6 +1293,8 @@
 	/*  - and look it like as a confirmed connection */
 	set_bit(IPS_CONFIRMED_BIT, &ip_conntrack_untracked.status);
 
+	register_cte_mark();
+
 	return ret;
 
 err_free_conntrack_slab:
