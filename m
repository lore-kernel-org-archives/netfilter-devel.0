From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 29/38] netfilter: nf_tables: make valid_genid callback mandatory
Date: Fri, 20 Jul 2018 15:08:57 +0200
Message-ID: <20180720130906.27687-30-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

always call this function, followup patch can use this to
aquire a per-netns transaction log to guard the entire batch
instead of using the nfnl susbsys mutex (which is shared among all
namespaces).

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 net/netfilter/nfnetlink.c     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5e95e92e547b..594b395442d6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6591,7 +6591,7 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb)
 
 static bool nf_tables_valid_genid(struct net *net, u32 genid)
 {
-	return net->nft.base_seq == genid;
+	return genid == 0 || net->nft.base_seq == genid;
 }
 
 static const struct nfnetlink_subsystem nf_tables_subsys = {
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index e1b6be29848d..94f9bcaa0799 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -331,13 +331,13 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 		}
 	}
 
-	if (!ss->commit || !ss->abort) {
+	if (!ss->valid_genid || !ss->commit || !ss->abort) {
 		nfnl_unlock(subsys_id);
 		netlink_ack(oskb, nlh, -EOPNOTSUPP, NULL);
 		return kfree_skb(skb);
 	}
 
-	if (genid && ss->valid_genid && !ss->valid_genid(net, genid)) {
+	if (!ss->valid_genid(net, genid)) {
 		nfnl_unlock(subsys_id);
 		netlink_ack(oskb, nlh, -ERESTART, NULL);
 		return kfree_skb(skb);
-- 
2.11.0
