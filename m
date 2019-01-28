From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 19/33] netfilter: conntrack: remove sysctl registration helpers
Date: Tue, 29 Jan 2019 00:57:36 +0100
Message-ID: <20190128235750.18412-20-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

After previous patch these are not used anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netns/conntrack.h      |  4 --
 net/netfilter/nf_conntrack_proto.c | 77 +-------------------------------------
 2 files changed, 1 insertion(+), 80 deletions(-)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index c72f413a2d4d..b8faa72e0f5b 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -19,10 +19,6 @@ struct ctl_table_header;
 struct nf_conntrack_ecache;
 
 struct nf_proto_net {
-#ifdef CONFIG_SYSCTL
-	struct ctl_table_header *ctl_table_header;
-	struct ctl_table        *ctl_table;
-#endif
 	unsigned int		users;
 };
 
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 13b782cc6a7a..c8f024d731c8 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -48,35 +48,6 @@ static struct nf_conntrack_l4proto __rcu *nf_ct_protos[MAX_NF_CT_PROTO + 1] __re
 static DEFINE_MUTEX(nf_ct_proto_mutex);
 
 #ifdef CONFIG_SYSCTL
-static int
-nf_ct_register_sysctl(struct net *net,
-		      struct ctl_table_header **header,
-		      const char *path,
-		      struct ctl_table *table)
-{
-	if (*header == NULL) {
-		*header = register_net_sysctl(net, path, table);
-		if (*header == NULL)
-			return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static void
-nf_ct_unregister_sysctl(struct ctl_table_header **header,
-			struct ctl_table **table,
-			unsigned int users)
-{
-	if (users > 0)
-		return;
-
-	unregister_net_sysctl_table(*header);
-	kfree(*table);
-	*header = NULL;
-	*table = NULL;
-}
-
 __printf(5, 6)
 void nf_l4proto_log_invalid(const struct sk_buff *skb,
 			    struct net *net,
@@ -161,40 +132,6 @@ static struct nf_proto_net *nf_ct_l4proto_net(struct net *net,
 	return NULL;
 }
 
-static
-int nf_ct_l4proto_register_sysctl(struct net *net,
-				  struct nf_proto_net *pn)
-{
-	int err = 0;
-
-#ifdef CONFIG_SYSCTL
-	if (pn->ctl_table != NULL) {
-		err = nf_ct_register_sysctl(net,
-					    &pn->ctl_table_header,
-					    "net/netfilter",
-					    pn->ctl_table);
-		if (err < 0) {
-			if (!pn->users) {
-				kfree(pn->ctl_table);
-				pn->ctl_table = NULL;
-			}
-		}
-	}
-#endif /* CONFIG_SYSCTL */
-	return err;
-}
-
-static
-void nf_ct_l4proto_unregister_sysctl(struct nf_proto_net *pn)
-{
-#ifdef CONFIG_SYSCTL
-	if (pn->ctl_table_header != NULL)
-		nf_ct_unregister_sysctl(&pn->ctl_table_header,
-					&pn->ctl_table,
-					pn->users);
-#endif /* CONFIG_SYSCTL */
-}
-
 /* FIXME: Allow NULL functions and sub in pointers to generic for
    them. --RR */
 int nf_ct_l4proto_register_one(const struct nf_conntrack_l4proto *l4proto)
@@ -237,10 +174,6 @@ static int nf_ct_l4proto_pernet_register_one(struct net *net,
 	if (pn == NULL)
 		goto out;
 
-	ret = nf_ct_l4proto_register_sysctl(net, pn);
-	if (ret < 0)
-		goto out;
-
 	pn->users++;
 out:
 	return ret;
@@ -280,7 +213,6 @@ static void nf_ct_l4proto_pernet_unregister_one(struct net *net,
 		return;
 
 	pn->users--;
-	nf_ct_l4proto_unregister_sysctl(pn);
 }
 
 static void
@@ -859,17 +791,11 @@ int nf_conntrack_proto_pernet_init(struct net *net)
 	err = nf_conntrack_l4proto_generic.init_net(net);
 	if (err < 0)
 		return err;
-	err = nf_ct_l4proto_register_sysctl(net,
-					    pn);
-	if (err < 0)
-		return err;
 
 	err = nf_ct_l4proto_pernet_register(net, builtin_l4proto,
 					    ARRAY_SIZE(builtin_l4proto));
-	if (err < 0) {
-		nf_ct_l4proto_unregister_sysctl(pn);
+	if (err < 0)
 		return err;
-	}
 
 	pn->users++;
 	return 0;
@@ -883,7 +809,6 @@ void nf_conntrack_proto_pernet_fini(struct net *net)
 	nf_ct_l4proto_pernet_unregister(net, builtin_l4proto,
 					ARRAY_SIZE(builtin_l4proto));
 	pn->users--;
-	nf_ct_l4proto_unregister_sysctl(pn);
 #ifdef CONFIG_NF_CT_PROTO_GRE
 	nf_ct_gre_keymap_flush(net);
 #endif
-- 
2.11.0
