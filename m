From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/47] netfilter: nfnetlink_acct: remove useless parameter
Date: Fri, 30 Mar 2018 13:36:44 +0200
Message-ID: <20180330113729.18335-3-pablo@netfilter.org>
References: <20180330113729.18335-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330113729.18335-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

parameter skb in nfnl_acct_overquota is not used anywhere.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink_acct.h | 3 +--
 net/netfilter/nfnetlink_acct.c           | 3 +--
 net/netfilter/xt_nfacct.c                | 2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index b4d741195c28..beee8bffe49e 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -16,6 +16,5 @@ struct nf_acct;
 struct nf_acct *nfnl_acct_find_get(struct net *net, const char *filter_name);
 void nfnl_acct_put(struct nf_acct *acct);
 void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct);
-int nfnl_acct_overquota(struct net *net, const struct sk_buff *skb,
-			struct nf_acct *nfacct);
+int nfnl_acct_overquota(struct net *net, struct nf_acct *nfacct);
 #endif /* _NFNL_ACCT_H */
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 88d427f9f9e6..b9505bcd3827 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -467,8 +467,7 @@ static void nfnl_overquota_report(struct net *net, struct nf_acct *nfacct)
 			  GFP_ATOMIC);
 }
 
-int nfnl_acct_overquota(struct net *net, const struct sk_buff *skb,
-			struct nf_acct *nfacct)
+int nfnl_acct_overquota(struct net *net, struct nf_acct *nfacct)
 {
 	u64 now;
 	u64 *quota;
diff --git a/net/netfilter/xt_nfacct.c b/net/netfilter/xt_nfacct.c
index c8674deed4eb..6b56f4170860 100644
--- a/net/netfilter/xt_nfacct.c
+++ b/net/netfilter/xt_nfacct.c
@@ -28,7 +28,7 @@ static bool nfacct_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 	nfnl_acct_update(skb, info->nfacct);
 
-	overquota = nfnl_acct_overquota(xt_net(par), skb, info->nfacct);
+	overquota = nfnl_acct_overquota(xt_net(par), info->nfacct);
 
 	return overquota == NFACCT_UNDERQUOTA ? false : true;
 }
-- 
2.11.0
