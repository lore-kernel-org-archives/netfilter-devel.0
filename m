From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 36/38]: nf_conntrack: clean up a few header files
Date: Tue, 15 Jan 2008 07:20:00 +0100 (MET)
Message-ID: <20080115061955.3184.31690.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62272 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbYAOGUC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:20:02 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: clean up a few header files

- Remove declarations of non-existing variables and functions
- Move helper init/cleanup function declarations to nf_conntrack_helper.h
- Remove unneeded __nf_conntrack_attach declaration and make it static

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit acb619184a16c40b0f24fa7a66464a7494421b1f
tree 5f4365cd37acae2d1ebc55f3a79bf6368612a827
parent b243ece57ad7c480af162ff7cc857b8aa2b0c409
author Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:30 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:30 +0100

 include/net/netfilter/nf_conntrack.h        |    7 -------
 include/net/netfilter/nf_conntrack_core.h   |   12 ------------
 include/net/netfilter/nf_conntrack_helper.h |    4 ++++
 net/netfilter/nf_conntrack_core.c           |    5 ++---
 4 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 4ac5ab1..857d899 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -223,8 +223,6 @@ extern void nf_conntrack_tcp_update(struct sk_buff *skb,
 /* Fake conntrack entry for untracked connections */
 extern struct nf_conn nf_conntrack_untracked;
 
-extern int nf_ct_no_defrag;
-
 /* Iterate over all conntracks: if iter returns true, it's deleted. */
 extern void
 nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data), void *data);
@@ -264,10 +262,5 @@ do {							\
 	local_bh_enable();				\
 } while (0)
 
-extern int
-nf_conntrack_register_cache(u_int32_t features, const char *name, size_t size);
-extern void
-nf_conntrack_unregister_cache(u_int32_t features);
-
 #endif /* __KERNEL__ */
 #endif /* _NF_CONNTRACK_H */
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index a532e7b..7ad0828 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -30,16 +30,6 @@ extern void nf_conntrack_cleanup(void);
 extern int nf_conntrack_proto_init(void);
 extern void nf_conntrack_proto_fini(void);
 
-extern int nf_conntrack_helper_init(void);
-extern void nf_conntrack_helper_fini(void);
-
-struct nf_conntrack_l3proto;
-extern struct nf_conntrack_l3proto *nf_ct_find_l3proto(u_int16_t pf);
-/* Like above, but you already have conntrack read lock. */
-extern struct nf_conntrack_l3proto *__nf_ct_find_l3proto(u_int16_t l3proto);
-
-struct nf_conntrack_l4proto;
-
 extern int
 nf_ct_get_tuple(const struct sk_buff *skb,
 		unsigned int nhoff,
@@ -76,8 +66,6 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 	return ret;
 }
 
-extern void __nf_conntrack_attach(struct sk_buff *nskb, struct sk_buff *skb);
-
 int
 print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
 	    struct nf_conntrack_l3proto *l3proto,
diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index d7b2d54..2f3af00 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -58,4 +58,8 @@ static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
 {
 	return nf_ct_ext_find(ct, NF_CT_EXT_HELPER);
 }
+
+extern int nf_conntrack_helper_init(void);
+extern void nf_conntrack_helper_fini(void);
+
 #endif /*_NF_CONNTRACK_HELPER_H*/
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2556407..078fff0 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -861,7 +861,7 @@ EXPORT_SYMBOL_GPL(nf_ct_port_nlattr_to_tuple);
 #endif
 
 /* Used by ipt_REJECT and ip6t_REJECT. */
-void __nf_conntrack_attach(struct sk_buff *nskb, struct sk_buff *skb)
+static void nf_conntrack_attach(struct sk_buff *nskb, struct sk_buff *skb)
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
@@ -878,7 +878,6 @@ void __nf_conntrack_attach(struct sk_buff *nskb, struct sk_buff *skb)
 	nskb->nfctinfo = ctinfo;
 	nf_conntrack_get(nskb->nfct);
 }
-EXPORT_SYMBOL_GPL(__nf_conntrack_attach);
 
 static inline int
 do_iter(const struct nf_conntrack_tuple_hash *i,
@@ -1122,7 +1121,7 @@ int __init nf_conntrack_init(void)
 		goto out_fini_expect;
 
 	/* For use by REJECT target */
-	rcu_assign_pointer(ip_ct_attach, __nf_conntrack_attach);
+	rcu_assign_pointer(ip_ct_attach, nf_conntrack_attach);
 	rcu_assign_pointer(nf_ct_destroy, destroy_conntrack);
 
 	/* Set up fake conntrack:
