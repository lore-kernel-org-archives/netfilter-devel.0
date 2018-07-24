From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/9] netfilter: nf_tables: use dev->name directly
Date: Tue, 24 Jul 2018 18:31:28 +0200
Message-ID: <20180724163133.14586-5-pablo@netfilter.org>
References: <20180724163133.14586-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180724163133.14586-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

no need to store the name in separate area.

Furthermore, it uses kmalloc but not kfree and most accesses seem to treat
it as char[IFNAMSIZ] not char *.

Remove this and use dev->name instead.

In case event zeroed dev, just omit the name in the dump.

Fixes: d92191aa84e5f1 ("netfilter: nf_tables: cache device name in flowtable object")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  1 -
 net/netfilter/nf_tables_api.c     | 14 +++++---------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4e82a4c49912..dc417ef0a0c5 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1124,7 +1124,6 @@ struct nft_flowtable {
 	u32				genmask:2,
 					use:30;
 	u64				handle;
-	char				*dev_name[NFT_FLOWTABLE_DEVICE_MAX];
 	/* runtime data below here */
 	struct nf_hook_ops		*ops ____cacheline_aligned;
 	struct nf_flowtable		data;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d41fa2c82f14..54a4f75ff9da 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5324,8 +5324,6 @@ static int nf_tables_flowtable_parse_hook(const struct nft_ctx *ctx,
 		flowtable->ops[i].priv		= &flowtable->data;
 		flowtable->ops[i].hook		= flowtable->data.type->hook;
 		flowtable->ops[i].dev		= dev_array[i];
-		flowtable->dev_name[i]		= kstrdup(dev_array[i]->name,
-							  GFP_KERNEL);
 	}
 
 	return err;
@@ -5483,10 +5481,8 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 err6:
 	i = flowtable->ops_len;
 err5:
-	for (k = i - 1; k >= 0; k--) {
-		kfree(flowtable->dev_name[k]);
+	for (k = i - 1; k >= 0; k--)
 		nf_unregister_net_hook(net, &flowtable->ops[k]);
-	}
 
 	kfree(flowtable->ops);
 err4:
@@ -5585,9 +5581,10 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 		goto nla_put_failure;
 
 	for (i = 0; i < flowtable->ops_len; i++) {
-		if (flowtable->dev_name[i][0] &&
-		    nla_put_string(skb, NFTA_DEVICE_NAME,
-				   flowtable->dev_name[i]))
+		const struct net_device *dev = READ_ONCE(flowtable->ops[i].dev);
+
+		if (dev &&
+		    nla_put_string(skb, NFTA_DEVICE_NAME, dev->name))
 			goto nla_put_failure;
 	}
 	nla_nest_end(skb, nest_devs);
@@ -5829,7 +5826,6 @@ static void nft_flowtable_event(unsigned long event, struct net_device *dev,
 			continue;
 
 		nf_unregister_net_hook(dev_net(dev), &flowtable->ops[i]);
-		flowtable->dev_name[i][0] = '\0';
 		flowtable->ops[i].dev = NULL;
 		break;
 	}
-- 
2.11.0
