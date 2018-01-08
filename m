From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 21/52] netfilter: nf_tables: reject nat hook registration if prio is before conntrack
Date: Mon,  8 Jan 2018 21:19:29 +0100
Message-ID: <20180108202000.12989-22-pablo@netfilter.org>
References: <20180108202000.12989-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180108202000.12989-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

No problem for iptables as priorities are fixed values defined in the
nat modules, but in nftables the priority its coming from userspace.

Reject in case we see that such a hook would not work.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 838eb581b5ab..36d38f8b0284 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1264,7 +1264,7 @@ static void nf_tables_chain_destroy(struct nft_chain *chain)
 
 struct nft_chain_hook {
 	u32				num;
-	u32				priority;
+	s32				priority;
 	const struct nf_chain_type	*type;
 	struct net_device		*dev;
 };
@@ -1303,6 +1303,11 @@ static int nft_chain_parse_hook(struct net *net,
 	}
 	if (!(type->hook_mask & (1 << hook->num)))
 		return -EOPNOTSUPP;
+
+	if (type->type == NFT_CHAIN_T_NAT &&
+	    hook->priority <= NF_IP_PRI_CONNTRACK)
+		return -EOPNOTSUPP;
+
 	if (!try_module_get(type->owner))
 		return -ENOENT;
 
-- 
2.11.0
