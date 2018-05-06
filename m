From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 17/51] netfilter: nf_flow_table: fix priv pointer for netdev hook
Date: Mon,  7 May 2018 00:46:35 +0200
Message-ID: <20180506224709.29100-18-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

The offload ip hook expects a pointer to the flowtable, not to the
rhashtable. Since the rhashtable is the first member, this is safe for
the moment, but breaks as soon as the structure layout changes

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6cd9955916e5..517bb93c00fb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5019,7 +5019,7 @@ static int nf_tables_flowtable_parse_hook(const struct nft_ctx *ctx,
 		flowtable->ops[i].pf		= NFPROTO_NETDEV;
 		flowtable->ops[i].hooknum	= hooknum;
 		flowtable->ops[i].priority	= priority;
-		flowtable->ops[i].priv		= &flowtable->data.rhashtable;
+		flowtable->ops[i].priv		= &flowtable->data;
 		flowtable->ops[i].hook		= flowtable->data.type->hook;
 		flowtable->ops[i].dev		= dev_array[i];
 		flowtable->dev_name[i]		= kstrdup(dev_array[i]->name,
-- 
2.11.0
