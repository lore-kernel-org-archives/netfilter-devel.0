From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/15] netfilter: conntrack: fix removal of conntrack entries when l4tracker is removed
Date: Fri, 17 Aug 2018 21:38:44 +0200
Message-ID: <20180817193850.2796-10-pablo@netfilter.org>
References: <20180817193850.2796-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180817193850.2796-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

nf_ct_l4proto_unregister_one() leaves conntracks added by
to-be-removed tracker behind, nf_ct_l4proto_unregister has to iterate
for each protocol to be removed.

v2: call nf_ct_iterate_destroy without holding nf_ct_proto_mutex.

Fixes: 2c41f33c1b703 ("netfilter: move table iteration out of netns exit paths")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 30070732ee50..9f14b0df6960 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -312,7 +312,9 @@ void nf_ct_l4proto_unregister_one(const struct nf_conntrack_l4proto *l4proto)
 	__nf_ct_l4proto_unregister_one(l4proto);
 	mutex_unlock(&nf_ct_proto_mutex);
 
-	synchronize_rcu();
+	synchronize_net();
+	/* Remove all contrack entries for this protocol */
+	nf_ct_iterate_destroy(kill_l4proto, (void *)l4proto);
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_unregister_one);
 
@@ -333,14 +335,17 @@ static void
 nf_ct_l4proto_unregister(const struct nf_conntrack_l4proto * const l4proto[],
 			 unsigned int num_proto)
 {
+	int i;
+
 	mutex_lock(&nf_ct_proto_mutex);
-	while (num_proto-- != 0)
-		__nf_ct_l4proto_unregister_one(l4proto[num_proto]);
+	for (i = 0; i < num_proto; i++)
+		__nf_ct_l4proto_unregister_one(l4proto[i]);
 	mutex_unlock(&nf_ct_proto_mutex);
 
 	synchronize_net();
-	/* Remove all contrack entries for this protocol */
-	nf_ct_iterate_destroy(kill_l4proto, (void *)l4proto);
+
+	for (i = 0; i < num_proto; i++)
+		nf_ct_iterate_destroy(kill_l4proto, (void *)l4proto[i]);
 }
 
 static int
-- 
2.11.0
