From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 7/8] Netfilter:  Use ct_extend for master pointer
Date: Thu, 13 Jan 2005 07:59:28 +1100
Message-ID: <1105563568.12794.14.camel@localhost.localdomain>
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

Name: Use ct_extend for master pointer
Status: Tested lightly under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Most connections were never expected, so their master pointer (which
points to the connection which expected them) is unused.  Good
candidate for ct_extend.

Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_nat_helper.c
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/ip_nat_helper.c	2005-01-12 23:43:21.562540736 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_nat_helper.c	2005-01-12 23:44:23.299155344 +1100
@@ -409,6 +409,7 @@
 			  struct ip_conntrack_expect *exp)
 {
 	struct ip_nat_range range;
+	struct ip_conntrack **master = ct_extend_find(ct->ext, CTE_MASTER);
 
 	/* This must be a fresh one. */
 	BUG_ON(ct->status & IPS_NAT_DONE_MASK);
@@ -416,7 +417,7 @@
 	/* Change src to where master sends to */
 	range.flags = IP_NAT_RANGE_MAP_IPS;
 	range.min_ip = range.max_ip
-		= ct->master->tuplehash[!exp->dir].tuple.dst.ip;
+		= (*master)->tuplehash[!exp->dir].tuple.dst.ip;
 	/* hook doesn't matter, but it has to do source manip */
 	ip_nat_setup_info(ct, &range, NF_IP_POST_ROUTING);
 
@@ -424,7 +425,7 @@
 	range.flags = (IP_NAT_RANGE_MAP_IPS | IP_NAT_RANGE_PROTO_SPECIFIED);
 	range.min = range.max = exp->saved_proto;
 	range.min_ip = range.max_ip
-		= ct->master->tuplehash[!exp->dir].tuple.src.ip;
+		= (*master)->tuplehash[!exp->dir].tuple.src.ip;
 	/* hook doesn't matter, but it has to do destination manip */
 	ip_nat_setup_info(ct, &range, NF_IP_PRE_ROUTING);
 }
Index: linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-12 23:42:02.014633856 +1100
+++ linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-12 23:44:23.300155192 +1100
@@ -166,9 +166,6 @@
 	/* Accounting Information (same cache line as other written members) */
 	struct ip_conntrack_counter counters[IP_CT_DIR_MAX];
 #endif
-	/* If we were expected by an expectation, this will be it */
-	struct ip_conntrack *master;
-
 	/* Current number of expected connections */
 	unsigned int expecting;
 
Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ipt_helper.c
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/ipt_helper.c	2005-01-12 23:42:02.015633704 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ipt_helper.c	2005-01-12 23:44:23.301155040 +1100
@@ -42,6 +42,7 @@
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 	struct ip_conntrack_helper **helpp;
+	struct ip_conntrack **master;
 	int ret = info->invert;
 	
 	ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
@@ -50,13 +51,14 @@
 		return ret;
 	}
 
-	if (!ct->master) {
+	master = ct_extend_find(ct->ext, CTE_MASTER);
+	if (!master) {
 		DEBUGP("ipt_helper: conntrack %p has no master\n", ct);
 		return ret;
 	}
 
 	READ_LOCK(&ip_conntrack_lock);
-	helpp = ct_extend_find(ct->master->ext, CTE_CT_HELPER);
+	helpp = ct_extend_find((*master)->ext, CTE_CT_HELPER);
 	if (!helpp) {
 		DEBUGP("ipt_helper: master ct %p has no helper\n", 
 			exp->expectant);
Index: linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ct_extend.h
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/include/linux/netfilter_ipv4/ct_extend.h	2005-01-12 23:44:19.588719416 +1100
+++ linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ct_extend.h	2005-01-12 23:45:24.353873616 +1100
@@ -9,6 +9,7 @@
 	CTE_MARK,
 	CTE_CT_HELPER,
 	CTE_NAT_SEQ,
+	CTE_MASTER,
 	CTE_MAX,
 } __attribute__((packed));
 
@@ -17,6 +18,7 @@
 #define CTE_MARK_TYPE unsigned long
 #define CTE_CT_HELPER_TYPE struct ip_conntrack_helper *
 #define CTE_NAT_SEQ_TYPE struct ip_nat_seq
+#define CTE_MASTER_TYPE struct ip_conntrack *
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct ct_extend {
Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-12 23:42:02.018633248 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-12 23:44:23.304154584 +1100
@@ -224,7 +224,7 @@
 static void
 destroy_conntrack(struct nf_conntrack *nfct)
 {
-	struct ip_conntrack *ct = (struct ip_conntrack *)nfct;
+	struct ip_conntrack **master, *ct = (struct ip_conntrack *)nfct;
 	struct ip_conntrack_protocol *proto;
 
 	DEBUGP("destroy_conntrack(%p)\n", ct);
@@ -257,8 +257,9 @@
 	CONNTRACK_STAT_INC(delete);
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
-	if (ct->master)
-		ip_conntrack_put(ct->master);
+	master = ct_extend_find(ct->ext, CTE_MASTER);
+	if (master)
+		ip_conntrack_put(*master);
 
 	if (ct->ext)
 		ct_extend_free(ct->ext);
@@ -561,6 +562,8 @@
 	exp = find_expectation(tuple);
 
 	if (exp) {
+		struct ip_conntrack **master;
+
 		DEBUGP("conntrack: expectation arrives ct=%p exp=%p\n",
 			conntrack, exp);
 		/* Welcome, Mr. Bond.  We've been expecting you... */
@@ -570,8 +573,16 @@
 			kmem_cache_free(ip_conntrack_cachep, conntrack);
 			return NULL;
 		}
-		conntrack->master = exp->master;
-		nf_conntrack_get(&conntrack->master->ct_general);
+		master = ct_extend_add(&conntrack->ext, CTE_MASTER,
+				       GFP_ATOMIC);
+		if (!master) {
+			ct_extend_free(conntrack->ext);
+			kmem_cache_free(ip_conntrack_cachep, conntrack);
+			WRITE_UNLOCK(&ip_conntrack_lock);
+			return NULL;
+		}
+		*master = exp->master;
+		nf_conntrack_get(&exp->master->ct_general);
 		CONNTRACK_STAT_INC(expect_new);
 	} else {
 		struct ip_conntrack_helper *helper, **helpp;
@@ -918,7 +929,7 @@
 	DUMP_TUPLE(newreply);
 
 	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
-	if (conntrack->master || conntrack->expecting)
+	if (conntrack->expecting || ct_extend_find(conntrack->ext, CTE_MASTER))
 		return 0;
 
 	WRITE_LOCK(&ip_conntrack_lock);
@@ -1227,6 +1238,13 @@
 	.type = CTE_CT_HELPER,
 };
 
+static struct ct_extend_type master_extend =
+{
+	.len = sizeof(struct ip_conntrack *),
+	.align = __alignof__(struct ip_conntrack *),
+	.type = CTE_MASTER,
+};
+
 /* Mishearing the voices in his head, our hero wonders how he's
    supposed to kill the mall. */
 void ip_conntrack_cleanup(void)
@@ -1246,6 +1264,7 @@
 
 	unregister_cte_mark();
 	unregister_ct_extend_type(&helper_extend);
+	unregister_ct_extend_type(&master_extend);
 	kmem_cache_destroy(ip_conntrack_cachep);
 	kmem_cache_destroy(ip_conntrack_expect_cachep);
 	free_conntrack_hash();
@@ -1344,6 +1363,7 @@
 	set_bit(IPS_CONFIRMED_BIT, &ip_conntrack_untracked.status);
 
 	register_ct_extend_type(&helper_extend);
+	register_ct_extend_type(&master_extend);
 	register_cte_mark();
 
 	return ret;
