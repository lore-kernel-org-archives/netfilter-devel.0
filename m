From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 21/33] netfilter: conntrack: remove l4proto destroy hook
Date: Tue, 29 Jan 2019 00:57:38 +0100
Message-ID: <20190128235750.18412-22-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Only one user (gre), add a direct call and remove this facility.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h |  3 ---
 net/netfilter/nf_conntrack_core.c            | 15 +++++++++++----
 net/netfilter/nf_conntrack_proto_gre.c       | 14 --------------
 3 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index d5909e51ca92..5d1419ac6a38 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -27,9 +27,6 @@ struct nf_conntrack_l4proto {
 	/* protoinfo nlattr size, closes a hole */
 	u16 nlattr_size;
 
-	/* Called when a conntrack entry is destroyed */
-	void (*destroy)(struct nf_conn *ct);
-
 	/* called by gc worker if table is full */
 	bool (*can_early_drop)(const struct nf_conn *ct);
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 728d2b5bdb1a..52e6c5c6f202 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -524,11 +524,18 @@ void nf_ct_tmpl_free(struct nf_conn *tmpl)
 }
 EXPORT_SYMBOL_GPL(nf_ct_tmpl_free);
 
+static void destroy_gre_conntrack(struct nf_conn *ct)
+{
+	struct nf_conn *master = ct->master;
+
+	if (master)
+		nf_ct_gre_keymap_destroy(master);
+}
+
 static void
 destroy_conntrack(struct nf_conntrack *nfct)
 {
 	struct nf_conn *ct = (struct nf_conn *)nfct;
-	const struct nf_conntrack_l4proto *l4proto;
 
 	pr_debug("destroy_conntrack(%p)\n", ct);
 	WARN_ON(atomic_read(&nfct->use) != 0);
@@ -537,9 +544,9 @@ destroy_conntrack(struct nf_conntrack *nfct)
 		nf_ct_tmpl_free(ct);
 		return;
 	}
-	l4proto = __nf_ct_l4proto_find(nf_ct_protonum(ct));
-	if (l4proto->destroy)
-		l4proto->destroy(ct);
+
+	if (unlikely(nf_ct_protonum(ct) == IPPROTO_GRE))
+		destroy_gre_conntrack(ct);
 
 	local_bh_disable();
 	/* Expectations will have been removed in clean_from_lists,
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index fa765d2fd586..ee9ab10a32e4 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -249,19 +249,6 @@ int nf_conntrack_gre_packet(struct nf_conn *ct,
 	return NF_ACCEPT;
 }
 
-/* Called when a conntrack entry has already been removed from the hashes
- * and is about to be deleted from memory */
-static void gre_destroy(struct nf_conn *ct)
-{
-	struct nf_conn *master = ct->master;
-	pr_debug(" entering\n");
-
-	if (!master)
-		pr_debug("no master !?!\n");
-	else
-		nf_ct_gre_keymap_destroy(master);
-}
-
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 
 #include <linux/netfilter/nfnetlink.h>
@@ -329,7 +316,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre = {
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack = gre_print_conntrack,
 #endif
-	.destroy	 = gre_destroy,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr = nf_ct_port_tuple_to_nlattr,
 	.nlattr_tuple_size = nf_ct_port_nlattr_tuple_size,
-- 
2.11.0
