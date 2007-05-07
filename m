From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 4/7]: nf_nat: Use extension infrastructure
Date: Mon, 07 May 2007 21:01:36 +0900 (JST)
Message-ID: <200705071201.l47C1bUI016561@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, kaber@trash.net, pablo@netfilter.org,
	kadlec@blackhole.kfki.hu
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


Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 include/net/netfilter/nf_conntrack.h           |    8 +---
 include/net/netfilter/nf_conntrack_extend.h    |    2 +
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    3 -
 net/ipv4/netfilter/nf_nat_core.c               |   60 ++++++++++++++++++++++--
 net/ipv4/netfilter/nf_nat_standalone.c         |   20 +++-----
 5 files changed, 67 insertions(+), 26 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 5c43caf..bd1af5c 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -286,13 +286,7 @@ nf_conntrack_unregister_cache(u_int32_t
 #ifdef CONFIG_NF_NAT_NEEDED
 static inline struct nf_conn_nat *nfct_nat(const struct nf_conn *ct)
 {
-	unsigned int offset = sizeof(struct nf_conn);
-
-	if (!(ct->features & NF_CT_F_NAT))
-		return NULL;
-
-	offset = ALIGN(offset, __alignof__(struct nf_conn_nat));
-	return (struct nf_conn_nat *) ((void *)ct + offset);
+	return ct_extend_find(ct->ext, CTE_NAT);
 }
 #endif /* CONFIG_NF_NAT_NEEDED */
 
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 1bfc87c..a66bb7b 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -4,10 +4,12 @@
 enum ct_ext_type
 {
 	CTE_HELPER,
+	CTE_NAT,
 	CTE_MAX,
 } __attribute__((packed));
 
 #define CTE_HELPER_TYPE struct nf_conn_help
+#define CTE_NAT_TYPE struct nf_conn_nat
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct ct_extend {
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 0654eaa..b5eb948 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -108,9 +108,6 @@ EXPORT_SYMBOL_GPL(nf_nat_module_is_loade
 
 static u_int32_t ipv4_get_features(const struct nf_conntrack_tuple *tuple)
 {
-	if (nf_nat_module_is_loaded)
-		return NF_CT_F_NAT;
-
 	return NF_CT_F_BASIC;
 }
 
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index ac7e8ab..278c6d3 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -297,11 +297,22 @@ nf_nat_setup_info(struct nf_conn *ct,
 		  unsigned int hooknum)
 {
 	struct nf_conntrack_tuple curr_tuple, new_tuple;
-	struct nf_conn_nat *nat = nfct_nat(ct);
-	struct nf_nat_info *info = &nat->info;
+	struct nf_conn_nat *nat;
+	struct nf_nat_info *info;
 	int have_to_hash = !(ct->status & IPS_NAT_DONE_MASK);
 	enum nf_nat_manip_type maniptype = HOOK2MANIP(hooknum);
 
+	/* nat helper or nfctnetlink also setup binding */
+	nat = nfct_nat(ct);
+	if (!nat) {
+		nat = ct_extend_add(&ct->ext, CTE_NAT, GFP_ATOMIC);
+		if (unlikely(nat == NULL)) {
+			DEBUGP("failed to add NAT extension\n");
+			return NF_ACCEPT;
+		}
+	}
+	info = &nat->info;
+
 	NF_CT_ASSERT(hooknum == NF_IP_PRE_ROUTING ||
 		     hooknum == NF_IP_POST_ROUTING ||
 		     hooknum == NF_IP_LOCAL_IN ||
@@ -592,17 +603,52 @@ nf_nat_port_nfattr_to_range(struct nfatt
 EXPORT_SYMBOL_GPL(nf_nat_port_range_to_nfattr);
 #endif
 
+static void nf_nat_move_storage(struct ct_extend *new, struct ct_extend *old)
+{
+	struct nf_conn_nat *new_nat = ct_extend_find(new, CTE_NAT);
+	struct nf_conn_nat *old_nat = ct_extend_find(old, CTE_NAT);
+	struct nf_conn *ct = old_nat->info.ct;
+	unsigned int srchash;
+
+	if (!ct || !(ct->status & IPS_NAT_DONE_MASK))
+		return;
+
+	srchash = hash_by_src(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+
+	write_lock_bh(&nf_nat_lock);
+	list_del(&old_nat->info.bysource);
+	new_nat->info.ct = ct;
+	list_add(&new_nat->info.bysource, &bysource[srchash]);
+	write_unlock_bh(&nf_nat_lock);
+}
+
+struct ct_extend_type nat_extend = {
+	.len	= sizeof(struct nf_conn_nat),
+	.align	= __alignof__(struct nf_conn_nat),
+	.move	= nf_nat_move_storage,
+	.type	= CTE_NAT,
+};
+
 static int __init nf_nat_init(void)
 {
 	size_t i;
+	int ret;
+
+	ret = ct_extend_type_register(&nat_extend);
+	if (ret < 0) {
+		printk(KERN_ERR "nf_nat_core: Unable to register extension\n");
+		return ret;
+	}
 
 	/* Leave them the same for the moment. */
 	nf_nat_htable_size = nf_conntrack_htable_size;
 
 	/* One vmalloc for both hash tables */
 	bysource = vmalloc(sizeof(struct list_head) * nf_nat_htable_size);
-	if (!bysource)
-		return -ENOMEM;
+	if (!bysource) {
+		ret = -ENOMEM;
+		goto cleanup_extend;
+	}
 
 	/* Sew in builtin protocols. */
 	write_lock_bh(&nf_nat_lock);
@@ -625,7 +671,12 @@ static int __init nf_nat_init(void)
 	nf_conntrack_untracked.status |= IPS_NAT_DONE_MASK;
 
 	l3proto = nf_ct_l3proto_find_get((u_int16_t)AF_INET);
+
 	return 0;
+
+ cleanup_extend:
+	ct_extend_type_unregister(&nat_extend);
+	return ret;
 }
 
 /* Clear NAT section of all conntracks, in case we're loaded again. */
@@ -647,6 +698,7 @@ static void __exit nf_nat_cleanup(void)
 	synchronize_rcu();
 	vfree(bysource);
 	nf_ct_l3proto_put(l3proto);
+	ct_extend_type_unregister(&nat_extend);
 }
 
 MODULE_LICENSE("GPL");
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 0b2f0c3..88af64e 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -113,8 +113,13 @@ nf_nat_fn(unsigned int hooknum,
 		return NF_ACCEPT;
 
 	nat = nfct_nat(ct);
-	if (!nat)
-		return NF_ACCEPT;
+	if (!nat) {
+		nat = ct_extend_add(&ct->ext, CTE_NAT, GFP_ATOMIC);
+		if (unlikely(nat == NULL)) {
+			DEBUGP("failed to add NAT extension\n");
+			return NF_ACCEPT;
+		}
+	}
 
 	switch (ctinfo) {
 	case IP_CT_RELATED:
@@ -326,18 +331,10 @@ static struct nf_hook_ops nf_nat_ops[] =
 
 static int __init nf_nat_standalone_init(void)
 {
-	int size, ret = 0;
+	int ret = 0;
 
 	need_conntrack();
 
-	size = ALIGN(sizeof(struct nf_conn), __alignof__(struct nf_conn_nat)) +
-	       sizeof(struct nf_conn_nat);
-	ret = nf_conntrack_register_cache(NF_CT_F_NAT, "nf_nat:base", size);
-	if (ret < 0) {
-		printk(KERN_ERR "nf_nat_init: Unable to create slab cache\n");
-		return ret;
-	}
-
 #ifdef CONFIG_XFRM
 	BUG_ON(ip_nat_decode_session != NULL);
 	ip_nat_decode_session = nat_decode_session;
@@ -362,7 +359,6 @@ static int __init nf_nat_standalone_init
 	ip_nat_decode_session = NULL;
 	synchronize_net();
 #endif
-	nf_conntrack_unregister_cache(NF_CT_F_NAT);
 	return ret;
 }
 
-- 
1.4.4
