From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 16/33] netfilter: conntrack: remove pernet l4 proto register interface
Date: Tue, 29 Jan 2019 00:57:33 +0100
Message-ID: <20190128235750.18412-17-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

No used anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h | 12 ------------
 net/netfilter/nf_conntrack_proto.c           | 28 ++++++++++++----------------
 2 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index dda028996559..87d9c198c05e 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -144,18 +144,6 @@ const struct nf_conntrack_l4proto *__nf_ct_l4proto_find(u8 l4proto);
 
 const struct nf_conntrack_l4proto *nf_ct_l4proto_find_get(u8 l4proto);
 
-/* Protocol pernet registration. */
-int nf_ct_l4proto_pernet_register_one(struct net *net,
-				const struct nf_conntrack_l4proto *proto);
-void nf_ct_l4proto_pernet_unregister_one(struct net *net,
-				const struct nf_conntrack_l4proto *proto);
-int nf_ct_l4proto_pernet_register(struct net *net,
-				  const struct nf_conntrack_l4proto *const proto[],
-				  unsigned int num_proto);
-void nf_ct_l4proto_pernet_unregister(struct net *net,
-				const struct nf_conntrack_l4proto *const proto[],
-				unsigned int num_proto);
-
 /* Protocol global registration. */
 int nf_ct_l4proto_register_one(const struct nf_conntrack_l4proto *proto);
 void nf_ct_l4proto_unregister_one(const struct nf_conntrack_l4proto *proto);
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 3455f993cc68..13b782cc6a7a 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -221,8 +221,8 @@ int nf_ct_l4proto_register_one(const struct nf_conntrack_l4proto *l4proto)
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_register_one);
 
-int nf_ct_l4proto_pernet_register_one(struct net *net,
-				const struct nf_conntrack_l4proto *l4proto)
+static int nf_ct_l4proto_pernet_register_one(struct net *net,
+					     const struct nf_conntrack_l4proto *l4proto)
 {
 	int ret = 0;
 	struct nf_proto_net *pn = NULL;
@@ -245,7 +245,6 @@ int nf_ct_l4proto_pernet_register_one(struct net *net,
 out:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(nf_ct_l4proto_pernet_register_one);
 
 static void __nf_ct_l4proto_unregister_one(const struct nf_conntrack_l4proto *l4proto)
 
@@ -272,7 +271,7 @@ void nf_ct_l4proto_unregister_one(const struct nf_conntrack_l4proto *l4proto)
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_unregister_one);
 
-void nf_ct_l4proto_pernet_unregister_one(struct net *net,
+static void nf_ct_l4proto_pernet_unregister_one(struct net *net,
 				const struct nf_conntrack_l4proto *l4proto)
 {
 	struct nf_proto_net *pn = nf_ct_l4proto_net(net, l4proto);
@@ -283,7 +282,6 @@ void nf_ct_l4proto_pernet_unregister_one(struct net *net,
 	pn->users--;
 	nf_ct_l4proto_unregister_sysctl(pn);
 }
-EXPORT_SYMBOL_GPL(nf_ct_l4proto_pernet_unregister_one);
 
 static void
 nf_ct_l4proto_unregister(const struct nf_conntrack_l4proto * const l4proto[],
@@ -322,7 +320,15 @@ nf_ct_l4proto_register(const struct nf_conntrack_l4proto * const l4proto[],
 	return ret;
 }
 
-int nf_ct_l4proto_pernet_register(struct net *net,
+static void nf_ct_l4proto_pernet_unregister(struct net *net,
+				const struct nf_conntrack_l4proto *const l4proto[],
+				unsigned int num_proto)
+{
+	while (num_proto-- != 0)
+		nf_ct_l4proto_pernet_unregister_one(net, l4proto[num_proto]);
+}
+
+static int nf_ct_l4proto_pernet_register(struct net *net,
 				  const struct nf_conntrack_l4proto *const l4proto[],
 				  unsigned int num_proto)
 {
@@ -341,16 +347,6 @@ int nf_ct_l4proto_pernet_register(struct net *net,
 	}
 	return ret;
 }
-EXPORT_SYMBOL_GPL(nf_ct_l4proto_pernet_register);
-
-void nf_ct_l4proto_pernet_unregister(struct net *net,
-				const struct nf_conntrack_l4proto *const l4proto[],
-				unsigned int num_proto)
-{
-	while (num_proto-- != 0)
-		nf_ct_l4proto_pernet_unregister_one(net, l4proto[num_proto]);
-}
-EXPORT_SYMBOL_GPL(nf_ct_l4proto_pernet_unregister);
 
 static unsigned int nf_confirm(struct sk_buff *skb,
 			       unsigned int protoff,
-- 
2.11.0
