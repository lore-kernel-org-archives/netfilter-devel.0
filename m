From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 05/10] nf_nat: Use extension infrastructure
Date: Mon, 25 Jun 2007 12:15:04 +0900 (JST)
Message-ID: <200706250315.l5P3F5vI009154@toshiba.co.jp>
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
 include/net/netfilter/nf_conntrack.h           |   17 -------
 include/net/netfilter/nf_conntrack_extend.h    |    2 +
 include/net/netfilter/nf_nat.h                 |    6 ++
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    3 -
 net/ipv4/netfilter/nf_nat_core.c               |   61 ++++++++++++++++++++++--
 net/ipv4/netfilter/nf_nat_standalone.c         |   21 ++++-----
 6 files changed, 74 insertions(+), 36 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index f1e0fee..b2083d3 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -278,22 +278,5 @@ nf_conntrack_register_cache(u_int32_t features, const char *name, size_t size);
 extern void
 nf_conntrack_unregister_cache(u_int32_t features);
 
-/* valid combinations:
- * basic: nf_conn, nf_conn .. nf_conn_help
- * nat: nf_conn .. nf_conn_nat, nf_conn .. nf_conn_nat .. nf_conn help
- */
-#ifdef CONFIG_NF_NAT_NEEDED
-#include <net/netfilter/nf_nat.h>
-static inline struct nf_conn_nat *nfct_nat(const struct nf_conn *ct)
-{
-	unsigned int offset = sizeof(struct nf_conn);
-
-	if (!(ct->features & NF_CT_F_NAT))
-		return NULL;
-
-	offset = ALIGN(offset, __alignof__(struct nf_conn_nat));
-	return (struct nf_conn_nat *) ((void *)ct + offset);
-}
-#endif /* CONFIG_NF_NAT_NEEDED */
 #endif /* __KERNEL__ */
 #endif /* _NF_CONNTRACK_H */
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 5caf13e..b8457d8 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -6,10 +6,12 @@
 enum nf_ct_ext_id
 {
 	NF_CT_EXT_HELPER,
+	NF_CT_EXT_NAT,
 	NF_CT_EXT_MAX,
 } __attribute__((packed));
 
 #define NF_CT_EXT_HELPER_TYPE struct nf_conn_help
+#define NF_CT_EXT_NAT_TYPE struct nf_conn_nat
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 3cf0c6a..712edec 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -52,6 +52,7 @@ struct nf_nat_multi_range_compat
 #ifdef __KERNEL__
 #include <linux/list.h>
 #include <linux/netfilter/nf_conntrack_pptp.h>
+#include <net/netfilter/nf_conntrack_extend.h>
 
 struct nf_conn;
 
@@ -87,6 +88,11 @@ extern unsigned int nf_nat_setup_info(struct nf_conn *ct,
 extern int nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
 			     const struct nf_conn *ignored_conntrack);
 
+static inline struct nf_conn_nat *nfct_nat(const struct nf_conn *ct)
+{
+	return nf_ct_ext_find(ct, NF_CT_EXT_NAT);
+}
+
 extern int nf_nat_module_is_loaded;
 
 #else  /* !__KERNEL__: iptables wants this to compile. */
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 6dc72a8..96f641d 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -108,9 +108,6 @@ EXPORT_SYMBOL_GPL(nf_nat_module_is_loaded);
 
 static u_int32_t ipv4_get_features(const struct nf_conntrack_tuple *tuple)
 {
-	if (nf_nat_module_is_loaded)
-		return NF_CT_F_NAT;
-
 	return NF_CT_F_BASIC;
 }
 
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index ac7e8ab..1ce4969 100644
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
+		nat = nf_ct_ext_add(ct, NF_CT_EXT_NAT, GFP_ATOMIC);
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
@@ -592,17 +603,53 @@ nf_nat_port_nfattr_to_range(struct nfattr *tb[], struct nf_nat_range *range)
 EXPORT_SYMBOL_GPL(nf_nat_port_range_to_nfattr);
 #endif
 
+static void nf_nat_move_storage(struct nf_conn *conntrack, void *old)
+{
+	struct nf_conn_nat *new_nat = nf_ct_ext_find(conntrack, NF_CT_EXT_NAT);
+	struct nf_conn_nat *old_nat = (struct nf_conn_nat *)old;
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
+struct nf_ct_ext_type nat_extend = {
+	.len	= sizeof(struct nf_conn_nat),
+	.align	= __alignof__(struct nf_conn_nat),
+	.move	= nf_nat_move_storage,
+	.id	= NF_CT_EXT_NAT,
+	.flags	= NF_CT_EXT_F_PREALLOC,
+};
+
 static int __init nf_nat_init(void)
 {
 	size_t i;
+	int ret;
+
+	ret = nf_ct_extend_register(&nat_extend);
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
@@ -625,7 +672,12 @@ static int __init nf_nat_init(void)
 	nf_conntrack_untracked.status |= IPS_NAT_DONE_MASK;
 
 	l3proto = nf_ct_l3proto_find_get((u_int16_t)AF_INET);
+
 	return 0;
+
+ cleanup_extend:
+	nf_ct_extend_unregister(&nat_extend);
+	return ret;
 }
 
 /* Clear NAT section of all conntracks, in case we're loaded again. */
@@ -647,6 +699,7 @@ static void __exit nf_nat_cleanup(void)
 	synchronize_rcu();
 	vfree(bysource);
 	nf_ct_l3proto_put(l3proto);
+	nf_ct_extend_unregister(&nat_extend);
 }
 
 MODULE_LICENSE("GPL");
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 0b2f0c3..2dfa931 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -19,6 +19,7 @@
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_rule.h>
 #include <net/netfilter/nf_nat_protocol.h>
@@ -113,8 +114,13 @@ nf_nat_fn(unsigned int hooknum,
 		return NF_ACCEPT;
 
 	nat = nfct_nat(ct);
-	if (!nat)
-		return NF_ACCEPT;
+	if (!nat) {
+		nat = nf_ct_ext_add(ct, NF_CT_EXT_NAT, GFP_ATOMIC);
+		if (unlikely(nat == NULL)) {
+			DEBUGP("failed to add NAT extension\n");
+			return NF_ACCEPT;
+		}
+	}
 
 	switch (ctinfo) {
 	case IP_CT_RELATED:
@@ -326,18 +332,10 @@ static struct nf_hook_ops nf_nat_ops[] = {
 
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
@@ -362,7 +360,6 @@ static int __init nf_nat_standalone_init(void)
 	ip_nat_decode_session = NULL;
 	synchronize_net();
 #endif
-	nf_conntrack_unregister_cache(NF_CT_F_NAT);
 	return ret;
 }
 
-- 
1.5.2.2
