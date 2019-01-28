From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/33] netfilter: conntrack: gre: convert rwlock to rcu
Date: Tue, 29 Jan 2019 00:57:26 +0100
Message-ID: <20190128235750.18412-10-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

We can use gre.  Lock is only needed when a new expectation is added.

In case a single spinlock proves to be problematic we can either add one
per netns or use an array of locks combined with net_hash_mix() or similar
to pick the 'correct' one.

But given this is only needed for an expectation rather than per packet
a single one should be ok.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_proto_gre.h |  1 +
 net/netfilter/nf_conntrack_proto_gre.c           | 37 ++++++++++--------------
 2 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_proto_gre.h b/include/linux/netfilter/nf_conntrack_proto_gre.h
index 6989e2e4eabf..222c9d3d453f 100644
--- a/include/linux/netfilter/nf_conntrack_proto_gre.h
+++ b/include/linux/netfilter/nf_conntrack_proto_gre.h
@@ -19,6 +19,7 @@ struct nf_conn;
 struct nf_ct_gre_keymap {
 	struct list_head list;
 	struct nf_conntrack_tuple tuple;
+	struct rcu_head rcu;
 };
 
 enum grep_conntrack {
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 8899b51aad44..34dd89485be2 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -49,6 +49,8 @@ static const unsigned int gre_timeouts[GRE_CT_MAX] = {
 };
 
 static unsigned int proto_gre_net_id __read_mostly;
+/* used when expectation is added */
+static DEFINE_SPINLOCK(keymap_lock);
 
 static inline struct netns_proto_gre *gre_pernet(struct net *net)
 {
@@ -60,12 +62,12 @@ static void nf_ct_gre_keymap_flush(struct net *net)
 	struct netns_proto_gre *net_gre = gre_pernet(net);
 	struct nf_ct_gre_keymap *km, *tmp;
 
-	write_lock_bh(&net_gre->keymap_lock);
+	spin_lock_bh(&keymap_lock);
 	list_for_each_entry_safe(km, tmp, &net_gre->keymap_list, list) {
-		list_del(&km->list);
-		kfree(km);
+		list_del_rcu(&km->list);
+		kfree_rcu(km, rcu);
 	}
-	write_unlock_bh(&net_gre->keymap_lock);
+	spin_unlock_bh(&keymap_lock);
 }
 
 static inline int gre_key_cmpfn(const struct nf_ct_gre_keymap *km,
@@ -85,14 +87,12 @@ static __be16 gre_keymap_lookup(struct net *net, struct nf_conntrack_tuple *t)
 	struct nf_ct_gre_keymap *km;
 	__be16 key = 0;
 
-	read_lock_bh(&net_gre->keymap_lock);
-	list_for_each_entry(km, &net_gre->keymap_list, list) {
+	list_for_each_entry_rcu(km, &net_gre->keymap_list, list) {
 		if (gre_key_cmpfn(km, t)) {
 			key = km->tuple.src.u.gre.key;
 			break;
 		}
 	}
-	read_unlock_bh(&net_gre->keymap_lock);
 
 	pr_debug("lookup src key 0x%x for ", key);
 	nf_ct_dump_tuple(t);
@@ -112,14 +112,10 @@ int nf_ct_gre_keymap_add(struct nf_conn *ct, enum ip_conntrack_dir dir,
 	kmp = &ct_pptp_info->keymap[dir];
 	if (*kmp) {
 		/* check whether it's a retransmission */
-		read_lock_bh(&net_gre->keymap_lock);
-		list_for_each_entry(km, &net_gre->keymap_list, list) {
-			if (gre_key_cmpfn(km, t) && km == *kmp) {
-				read_unlock_bh(&net_gre->keymap_lock);
+		list_for_each_entry_rcu(km, &net_gre->keymap_list, list) {
+			if (gre_key_cmpfn(km, t) && km == *kmp)
 				return 0;
-			}
 		}
-		read_unlock_bh(&net_gre->keymap_lock);
 		pr_debug("trying to override keymap_%s for ct %p\n",
 			 dir == IP_CT_DIR_REPLY ? "reply" : "orig", ct);
 		return -EEXIST;
@@ -134,9 +130,9 @@ int nf_ct_gre_keymap_add(struct nf_conn *ct, enum ip_conntrack_dir dir,
 	pr_debug("adding new entry %p: ", km);
 	nf_ct_dump_tuple(&km->tuple);
 
-	write_lock_bh(&net_gre->keymap_lock);
+	spin_lock_bh(&keymap_lock);
 	list_add_tail(&km->list, &net_gre->keymap_list);
-	write_unlock_bh(&net_gre->keymap_lock);
+	spin_unlock_bh(&keymap_lock);
 
 	return 0;
 }
@@ -145,24 +141,22 @@ EXPORT_SYMBOL_GPL(nf_ct_gre_keymap_add);
 /* destroy the keymap entries associated with specified master ct */
 void nf_ct_gre_keymap_destroy(struct nf_conn *ct)
 {
-	struct net *net = nf_ct_net(ct);
-	struct netns_proto_gre *net_gre = gre_pernet(net);
 	struct nf_ct_pptp_master *ct_pptp_info = nfct_help_data(ct);
 	enum ip_conntrack_dir dir;
 
 	pr_debug("entering for ct %p\n", ct);
 
-	write_lock_bh(&net_gre->keymap_lock);
+	spin_lock_bh(&keymap_lock);
 	for (dir = IP_CT_DIR_ORIGINAL; dir < IP_CT_DIR_MAX; dir++) {
 		if (ct_pptp_info->keymap[dir]) {
 			pr_debug("removing %p from list\n",
 				 ct_pptp_info->keymap[dir]);
-			list_del(&ct_pptp_info->keymap[dir]->list);
-			kfree(ct_pptp_info->keymap[dir]);
+			list_del_rcu(&ct_pptp_info->keymap[dir]->list);
+			kfree_rcu(ct_pptp_info->keymap[dir], rcu);
 			ct_pptp_info->keymap[dir] = NULL;
 		}
 	}
-	write_unlock_bh(&net_gre->keymap_lock);
+	spin_unlock_bh(&keymap_lock);
 }
 EXPORT_SYMBOL_GPL(nf_ct_gre_keymap_destroy);
 
@@ -365,7 +359,6 @@ static int gre_init_net(struct net *net)
 	struct nf_proto_net *nf = &net_gre->nf;
 	int i;
 
-	rwlock_init(&net_gre->keymap_lock);
 	INIT_LIST_HEAD(&net_gre->keymap_list);
 	for (i = 0; i < GRE_CT_MAX; i++)
 		net_gre->gre_timeouts[i] = gre_timeouts[i];
-- 
2.11.0
