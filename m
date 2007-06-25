From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 03/10] nf_conntrack: Use extension infrastructure for helper
Date: Mon, 25 Jun 2007 12:14:48 +0900 (JST)
Message-ID: <200706250314.l5P3EmZD019561@toshiba.co.jp>
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
 include/net/netfilter/nf_conntrack.h        |   26 ---------
 include/net/netfilter/nf_conntrack_core.h   |    3 +
 include/net/netfilter/nf_conntrack_extend.h |    3 +
 include/net/netfilter/nf_conntrack_helper.h |    5 ++
 net/ipv4/netfilter/nf_nat_standalone.c      |   10 ---
 net/netfilter/nf_conntrack_core.c           |   80 +++++++++++++++++----------
 net/netfilter/nf_conntrack_helper.c         |   27 ++++++---
 net/netfilter/nf_conntrack_netlink.c        |   37 +++++++-----
 8 files changed, 99 insertions(+), 92 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index c31382d..f1e0fee 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -294,32 +294,6 @@ static inline struct nf_conn_nat *nfct_nat(const struct nf_conn *ct)
 	offset = ALIGN(offset, __alignof__(struct nf_conn_nat));
 	return (struct nf_conn_nat *) ((void *)ct + offset);
 }
-
-static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
-{
-	unsigned int offset = sizeof(struct nf_conn);
-
-	if (!(ct->features & NF_CT_F_HELP))
-		return NULL;
-	if (ct->features & NF_CT_F_NAT) {
-		offset = ALIGN(offset, __alignof__(struct nf_conn_nat));
-		offset += sizeof(struct nf_conn_nat);
-	}
-
-	offset = ALIGN(offset, __alignof__(struct nf_conn_help));
-	return (struct nf_conn_help *) ((void *)ct + offset);
-}
-#else /* No NAT */
-static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
-{
-	unsigned int offset = sizeof(struct nf_conn);
-
-	if (!(ct->features & NF_CT_F_HELP))
-		return NULL;
-
-	offset = ALIGN(offset, __alignof__(struct nf_conn_help));
-	return (struct nf_conn_help *) ((void *)ct + offset);
-}
 #endif /* CONFIG_NF_NAT_NEEDED */
 #endif /* __KERNEL__ */
 #endif /* _NF_CONNTRACK_H */
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 9fb9066..3bf7d05 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -30,6 +30,9 @@ extern void nf_conntrack_cleanup(void);
 extern int nf_conntrack_proto_init(void);
 extern void nf_conntrack_proto_fini(void);
 
+extern int nf_conntrack_helper_init(void);
+extern void nf_conntrack_helper_fini(void);
+
 struct nf_conntrack_l3proto;
 extern struct nf_conntrack_l3proto *nf_ct_find_l3proto(u_int16_t pf);
 /* Like above, but you already have conntrack read lock. */
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 6fff268..5caf13e 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -5,9 +5,12 @@
 
 enum nf_ct_ext_id
 {
+	NF_CT_EXT_HELPER,
 	NF_CT_EXT_MAX,
 } __attribute__((packed));
 
+#define NF_CT_EXT_HELPER_TYPE struct nf_conn_help
+
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
 	u8 offset[NF_CT_EXT_MAX];
diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 8c72ac9..b43a75b 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -10,6 +10,7 @@
 #ifndef _NF_CONNTRACK_HELPER_H
 #define _NF_CONNTRACK_HELPER_H
 #include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_extend.h>
 
 struct module;
 
@@ -52,4 +53,8 @@ extern void nf_ct_helper_put(struct nf_conntrack_helper *helper);
 extern int nf_conntrack_helper_register(struct nf_conntrack_helper *);
 extern void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
 
+static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
+{
+	return nf_ct_ext_find(ct, NF_CT_EXT_HELPER);
+}
 #endif /*_NF_CONNTRACK_HELPER_H*/
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 55dac36..0b2f0c3 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -338,14 +338,6 @@ static int __init nf_nat_standalone_init(void)
 		return ret;
 	}
 
-	size = ALIGN(size, __alignof__(struct nf_conn_help)) +
-	       sizeof(struct nf_conn_help);
-	ret = nf_conntrack_register_cache(NF_CT_F_NAT|NF_CT_F_HELP,
-					  "nf_nat:help", size);
-	if (ret < 0) {
-		printk(KERN_ERR "nf_nat_init: Unable to create slab cache\n");
-		goto cleanup_register_cache;
-	}
 #ifdef CONFIG_XFRM
 	BUG_ON(ip_nat_decode_session != NULL);
 	ip_nat_decode_session = nat_decode_session;
@@ -370,8 +362,6 @@ static int __init nf_nat_standalone_init(void)
 	ip_nat_decode_session = NULL;
 	synchronize_net();
 #endif
-	nf_conntrack_unregister_cache(NF_CT_F_NAT|NF_CT_F_HELP);
- cleanup_register_cache:
 	nf_conntrack_unregister_cache(NF_CT_F_NAT);
 	return ret;
 }
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b56f954..d8b3b0c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -566,7 +566,6 @@ __nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 		     u_int32_t features)
 {
 	struct nf_conn *conntrack = NULL;
-	struct nf_conntrack_helper *helper;
 
 	if (unlikely(!nf_conntrack_hash_rnd_initted)) {
 		get_random_bytes(&nf_conntrack_hash_rnd, 4);
@@ -593,14 +592,6 @@ __nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 	/*  find features needed by this conntrack. */
 	features |= l3proto->get_features(orig);
 
-	/* FIXME: protect helper list per RCU */
-	read_lock_bh(&nf_conntrack_lock);
-	helper = __nf_ct_helper_find(repl);
-	/* NAT might want to assign a helper later */
-	if (helper || features & NF_CT_F_NAT)
-		features |= NF_CT_F_HELP;
-	read_unlock_bh(&nf_conntrack_lock);
-
 	DEBUGP("nf_conntrack_alloc: features=0x%x\n", features);
 
 	read_lock_bh(&nf_ct_cache_lock);
@@ -681,12 +672,6 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 		return NULL;
 	}
 
-	read_lock_bh(&nf_conntrack_lock);
-	exp = __nf_conntrack_expect_find(tuple);
-	if (exp && exp->helper)
-		features = NF_CT_F_HELP;
-	read_unlock_bh(&nf_conntrack_lock);
-
 	conntrack = __nf_conntrack_alloc(tuple, &repl_tuple, l3proto, features);
 	if (conntrack == NULL || IS_ERR(conntrack)) {
 		DEBUGP("Can't allocate conntrack.\n");
@@ -701,16 +686,21 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 
 	write_lock_bh(&nf_conntrack_lock);
 	exp = find_expectation(tuple);
-
-	help = nfct_help(conntrack);
 	if (exp) {
 		DEBUGP("conntrack: expectation arrives ct=%p exp=%p\n",
 			conntrack, exp);
 		/* Welcome, Mr. Bond.  We've been expecting you... */
 		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
 		conntrack->master = exp->master;
-		if (exp->helper)
-			rcu_assign_pointer(help->helper, exp->helper);
+		if (exp->helper) {
+			help = nf_ct_ext_add(conntrack, NF_CT_EXT_HELPER,
+					     GFP_ATOMIC);
+			if (likely(help))
+				rcu_assign_pointer(help->helper, exp->helper);
+			else
+				DEBUGP("failed to add helper extension area");
+		}
+
 #ifdef CONFIG_NF_CONNTRACK_MARK
 		conntrack->mark = exp->master->mark;
 #endif
@@ -720,10 +710,18 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 		nf_conntrack_get(&conntrack->master->ct_general);
 		NF_CT_STAT_INC(expect_new);
 	} else {
-		if (help) {
-			/* not in hash table yet, so not strictly necessary */
-			rcu_assign_pointer(help->helper,
-					   __nf_ct_helper_find(&repl_tuple));
+		struct nf_conntrack_helper *helper;
+
+		helper = __nf_ct_helper_find(&repl_tuple);
+		if (helper) {
+			help = nf_ct_ext_add(conntrack, NF_CT_EXT_HELPER,
+					     GFP_ATOMIC);
+			if (likely(help))
+				/* not in hash table yet, so not strictly
+				   necessary */
+				rcu_assign_pointer(help->helper, helper);
+			else
+				DEBUGP("failed to add helper extension area");
 		}
 		NF_CT_STAT_INC(new);
 	}
@@ -892,6 +890,7 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 			      const struct nf_conntrack_tuple *newreply)
 {
 	struct nf_conn_help *help = nfct_help(ct);
+	struct nf_conntrack_helper *helper;
 
 	write_lock_bh(&nf_conntrack_lock);
 	/* Should be unconfirmed, so not in hash table yet */
@@ -901,14 +900,28 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 	NF_CT_DUMP_TUPLE(newreply);
 
 	ct->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
-	if (!ct->master && help && help->expecting == 0) {
-		struct nf_conntrack_helper *helper;
-		helper = __nf_ct_helper_find(newreply);
-		if (helper)
-			memset(&help->help, 0, sizeof(help->help));
-		/* not in hash table yet, so not strictly necessary */
-		rcu_assign_pointer(help->helper, helper);
+	if (ct->master || (help && help->expecting != 0))
+		goto out;
+
+	helper = __nf_ct_helper_find(newreply);
+	if (helper == NULL) {
+		if (help)
+			rcu_assign_pointer(help->helper, NULL);
+		goto out;
 	}
+
+	if (help == NULL) {
+		help = nf_ct_ext_add(ct, NF_CT_EXT_HELPER, GFP_ATOMIC);
+		if (unlikely(help == NULL)) {
+			DEBUGP("failed to add helper extension area");
+			goto out;
+		}
+	} else {
+		memset(&help->help, 0, sizeof(help->help));
+	}
+
+	rcu_assign_pointer(help->helper, helper);
+out:
 	write_unlock_bh(&nf_conntrack_lock);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_alter_reply);
@@ -1150,6 +1163,7 @@ void nf_conntrack_cleanup(void)
 			    nf_conntrack_htable_size);
 
 	nf_conntrack_proto_fini();
+	nf_conntrack_helper_fini();
 }
 
 static struct list_head *alloc_hashtable(int size, int *vmalloced)
@@ -1272,6 +1286,10 @@ int __init nf_conntrack_init(void)
 	if (ret < 0)
 		goto out_free_expect_slab;
 
+	ret = nf_conntrack_helper_init();
+	if (ret < 0)
+		goto out_fini_proto;
+
 	/* For use by REJECT target */
 	rcu_assign_pointer(ip_ct_attach, __nf_conntrack_attach);
 	rcu_assign_pointer(nf_ct_destroy, destroy_conntrack);
@@ -1284,6 +1302,8 @@ int __init nf_conntrack_init(void)
 
 	return ret;
 
+out_fini_proto:
+	nf_conntrack_proto_fini();
 out_free_expect_slab:
 	kmem_cache_destroy(nf_conntrack_expect_cachep);
 err_free_conntrack_slab:
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index f868b7f..6d32399 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -26,6 +26,7 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_extend.h>
 
 static __read_mostly LIST_HEAD(helpers);
 
@@ -100,18 +101,8 @@ static inline int unhelp(struct nf_conntrack_tuple_hash *i,
 
 int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 {
-	int size, ret;
-
 	BUG_ON(me->timeout == 0);
 
-	size = ALIGN(sizeof(struct nf_conn), __alignof__(struct nf_conn_help)) +
-	       sizeof(struct nf_conn_help);
-	ret = nf_conntrack_register_cache(NF_CT_F_HELP, "nf_conntrack:help",
-					  size);
-	if (ret < 0) {
-		printk(KERN_ERR "nf_conntrack_helper_register: Unable to create slab cache for conntracks\n");
-		return ret;
-	}
 	write_lock_bh(&nf_conntrack_lock);
 	list_add(&me->list, &helpers);
 	write_unlock_bh(&nf_conntrack_lock);
@@ -153,3 +144,19 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	synchronize_net();
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
+
+struct nf_ct_ext_type helper_extend = {
+	.len	= sizeof(struct nf_conn_help),
+	.align	= __alignof__(struct nf_conn_help),
+	.id	= NF_CT_EXT_HELPER,
+};
+
+int nf_conntrack_helper_init()
+{
+	return nf_ct_extend_register(&helper_extend);
+}
+
+void nf_conntrack_helper_fini()
+{
+	nf_ct_extend_unregister(&helper_extend);
+}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d0fe3d7..3d56f36 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -856,23 +856,23 @@ ctnetlink_change_helper(struct nf_conn *ct, struct nfattr *cda[])
 		return 0;
 	}
 
-	if (!help) {
-		/* FIXME: we need to reallocate and rehash */
-		return -EBUSY;
-	}
-
 	helper = __nf_conntrack_helper_find_byname(helpname);
 	if (helper == NULL)
 		return -EINVAL;
 
-	if (help->helper == helper)
-		return 0;
-
-	if (help->helper)
-		return -EBUSY;
+	if (help) {
+		if (help->helper == helper)
+			return 0;
+		if (help->helper)
+			return -EBUSY;
+		/* need to zero data of old helper */
+		memset(&help->help, 0, sizeof(help->help));
+	} else {
+		help = nf_ct_ext_add(ct, NF_CT_EXT_HELPER, GFP_KERNEL);
+		if (help == NULL)
+			return -ENOMEM;
+	}
 
-	/* need to zero data of old helper */
-	memset(&help->help, 0, sizeof(help->help));
 	rcu_assign_pointer(help->helper, helper);
 
 	return 0;
@@ -957,7 +957,7 @@ ctnetlink_create_conntrack(struct nfattr *cda[],
 	struct nf_conn *ct;
 	int err = -EINVAL;
 	struct nf_conn_help *help;
-	struct nf_conntrack_helper *helper = NULL;
+	struct nf_conntrack_helper *helper;
 
 	ct = nf_conntrack_alloc(otuple, rtuple);
 	if (ct == NULL || IS_ERR(ct))
@@ -987,9 +987,14 @@ ctnetlink_create_conntrack(struct nfattr *cda[],
 		ct->mark = ntohl(*(__be32 *)NFA_DATA(cda[CTA_MARK-1]));
 #endif
 
-	help = nfct_help(ct);
-	if (help) {
-		helper = nf_ct_helper_find_get(rtuple);
+	helper = nf_ct_helper_find_get(rtuple);
+	if (helper) {
+		help = nf_ct_ext_add(ct, NF_CT_EXT_HELPER, GFP_KERNEL);
+		if (help == NULL) {
+			nf_ct_helper_put(helper);
+			err = -ENOMEM;
+			goto err;
+		}
 		/* not in hash table yet so not strictly necessary */
 		rcu_assign_pointer(help->helper, helper);
 	}
-- 
1.5.2.2
