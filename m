From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 14/37] netfilter: remove unused parameters in nf_ct_l4proto_[un]register_sysctl()
Date: Fri, 21 Dec 2018 01:28:18 +0100
Message-ID: <20181221002841.28587-15-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>

These parameters aren't used now.
So remove them.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 40643af7137e..859f5d07a915 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -175,8 +175,7 @@ static struct nf_proto_net *nf_ct_l4proto_net(struct net *net,
 
 static
 int nf_ct_l4proto_register_sysctl(struct net *net,
-				  struct nf_proto_net *pn,
-				  const struct nf_conntrack_l4proto *l4proto)
+				  struct nf_proto_net *pn)
 {
 	int err = 0;
 
@@ -198,9 +197,7 @@ int nf_ct_l4proto_register_sysctl(struct net *net,
 }
 
 static
-void nf_ct_l4proto_unregister_sysctl(struct net *net,
-				struct nf_proto_net *pn,
-				const struct nf_conntrack_l4proto *l4proto)
+void nf_ct_l4proto_unregister_sysctl(struct nf_proto_net *pn)
 {
 #ifdef CONFIG_SYSCTL
 	if (pn->ctl_table_header != NULL)
@@ -252,7 +249,7 @@ int nf_ct_l4proto_pernet_register_one(struct net *net,
 	if (pn == NULL)
 		goto out;
 
-	ret = nf_ct_l4proto_register_sysctl(net, pn, l4proto);
+	ret = nf_ct_l4proto_register_sysctl(net, pn);
 	if (ret < 0)
 		goto out;
 
@@ -296,7 +293,7 @@ void nf_ct_l4proto_pernet_unregister_one(struct net *net,
 		return;
 
 	pn->users--;
-	nf_ct_l4proto_unregister_sysctl(net, pn, l4proto);
+	nf_ct_l4proto_unregister_sysctl(pn);
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_pernet_unregister_one);
 
@@ -946,16 +943,14 @@ int nf_conntrack_proto_pernet_init(struct net *net)
 	if (err < 0)
 		return err;
 	err = nf_ct_l4proto_register_sysctl(net,
-					    pn,
-					    &nf_conntrack_l4proto_generic);
+					    pn);
 	if (err < 0)
 		return err;
 
 	err = nf_ct_l4proto_pernet_register(net, builtin_l4proto,
 					    ARRAY_SIZE(builtin_l4proto));
 	if (err < 0) {
-		nf_ct_l4proto_unregister_sysctl(net, pn,
-						&nf_conntrack_l4proto_generic);
+		nf_ct_l4proto_unregister_sysctl(pn);
 		return err;
 	}
 
@@ -971,9 +966,7 @@ void nf_conntrack_proto_pernet_fini(struct net *net)
 	nf_ct_l4proto_pernet_unregister(net, builtin_l4proto,
 					ARRAY_SIZE(builtin_l4proto));
 	pn->users--;
-	nf_ct_l4proto_unregister_sysctl(net,
-					pn,
-					&nf_conntrack_l4proto_generic);
+	nf_ct_l4proto_unregister_sysctl(pn);
 }
 
 
-- 
2.11.0
