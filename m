From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/9] netfilter: nf_tables: fix a missing check of nla_put_failure
Date: Sat, 29 Dec 2018 13:57:55 +0100
Message-ID: <20181229125803.7415-2-pablo@netfilter.org>
References: <20181229125803.7415-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181229125803.7415-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

If nla_nest_start() may fail. The fix checks its return value and goes
to nla_put_failure if it fails.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fec814dace5a..2b0a93300dd7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5727,6 +5727,8 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 		goto nla_put_failure;
 
 	nest = nla_nest_start(skb, NFTA_FLOWTABLE_HOOK);
+	if (!nest)
+		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_FLOWTABLE_HOOK_NUM, htonl(flowtable->hooknum)) ||
 	    nla_put_be32(skb, NFTA_FLOWTABLE_HOOK_PRIORITY, htonl(flowtable->priority)))
 		goto nla_put_failure;
-- 
2.11.0
