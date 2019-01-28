From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/33] netfilter: conntrack: remove net_id
Date: Tue, 29 Jan 2019 00:57:28 +0100
Message-ID: <20190128235750.18412-12-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

No users anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h | 2 +-
 net/netfilter/nf_conntrack_proto.c           | 8 ++------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index fded3f164dcc..3585f8666fc0 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -79,7 +79,7 @@ struct nf_conntrack_l4proto {
 	/* Print out the private part of the conntrack. */
 	void (*print_conntrack)(struct seq_file *s, struct nf_conn *);
 #endif
-	unsigned int	*net_id;
+
 	/* Init l4proto pernet data */
 	int (*init_net)(struct net *net);
 
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index e113bb2dc88d..47b9294a86f7 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -163,13 +163,9 @@ static int kill_l4proto(struct nf_conn *i, void *data)
 static struct nf_proto_net *nf_ct_l4proto_net(struct net *net,
 				const struct nf_conntrack_l4proto *l4proto)
 {
-	if (l4proto->get_net_proto) {
-		/* statically built-in protocols use static per-net */
+	if (l4proto->get_net_proto)
 		return l4proto->get_net_proto(net);
-	} else if (l4proto->net_id) {
-		/* ... and loadable protocols use dynamic per-net */
-		return net_generic(net, *l4proto->net_id);
-	}
+
 	return NULL;
 }
 
-- 
2.11.0
