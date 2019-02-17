From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/11] netfilter: nf_tables: add NFTA_RULE_POSITION_ID to nla_policy
Date: Mon, 18 Feb 2019 00:23:47 +0100
Message-ID: <20190217232357.29858-2-pablo@netfilter.org>
References: <20190217232357.29858-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190217232357.29858-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Fixes: 75dd48e2e420a ("netfilter: nf_tables: Support RULE_ID reference in new rule")
Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e92bedd09cde..7495f29d24e8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2239,6 +2239,7 @@ static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
 	[NFTA_RULE_USERDATA]	= { .type = NLA_BINARY,
 				    .len = NFT_USERDATA_MAXLEN },
 	[NFTA_RULE_ID]		= { .type = NLA_U32 },
+	[NFTA_RULE_POSITION_ID]	= { .type = NLA_U32 },
 };
 
 static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
-- 
2.11.0
