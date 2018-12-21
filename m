From: Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH] netfilter: fix a missing check of nla put failure
Date: Fri, 21 Dec 2018 00:46:23 -0600
Message-ID: <20181221064623.59988-1-kjlu@umn.edu>
Cc: pakki001@umn.edu, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: kjlu@umn.edu
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

If nla_nest_start() may fail. The fix checks its return value and goes
to nla_put_failure if it fails.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2e61aab6ed73..bc1b9814f2ee 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5689,6 +5689,8 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 		goto nla_put_failure;
 
 	nest = nla_nest_start(skb, NFTA_FLOWTABLE_HOOK);
+	if (!nest)
+		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_FLOWTABLE_HOOK_NUM, htonl(flowtable->hooknum)) ||
 	    nla_put_be32(skb, NFTA_FLOWTABLE_HOOK_PRIORITY, htonl(flowtable->priority)))
 		goto nla_put_failure;
-- 
2.17.2 (Apple Git-113)
