From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/15] netfilter: nf_tables: don't prevent event handler from device cleanup on netns exit
Date: Fri, 17 Aug 2018 21:38:43 +0200
Message-ID: <20180817193850.2796-9-pablo@netfilter.org>
References: <20180817193850.2796-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180817193850.2796-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

When a netnsamespace exits, the nf_tables pernet_ops will remove all rules.
However, there is one caveat:

Base chains that register ingress hooks will cause use-after-free:
device is already gone at that point.

The device event handlers prevent this from happening:
netns exit synthesizes unregister events for all devices.

However, an improper fix for a race condition made the notifiers a no-op
in case they get called from netns exit path, so revert that part.

This is safe now as the previous patch fixed nf_tables pernet ops
and device notifier initialisation ordering.

Fixes: 0a2cf5ee432c2 ("netfilter: nf_tables: close race between netns exit and rmmod")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c    |  7 ++-----
 net/netfilter/nft_chain_filter.c | 12 +++++++-----
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 80636cc59686..1dca5683f59f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5925,10 +5925,7 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 	if (event != NETDEV_UNREGISTER)
 		return 0;
 
-	net = maybe_get_net(dev_net(dev));
-	if (!net)
-		return 0;
-
+	net = dev_net(dev);
 	mutex_lock(&net->nft.commit_mutex);
 	list_for_each_entry(table, &net->nft.tables, list) {
 		list_for_each_entry(flowtable, &table->flowtables, list) {
@@ -5936,7 +5933,7 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 		}
 	}
 	mutex_unlock(&net->nft.commit_mutex);
-	put_net(net);
+
 	return NOTIFY_DONE;
 }
 
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 9d07b277b9ee..3fd540b2c6ba 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -293,6 +293,13 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 		if (strcmp(basechain->dev_name, dev->name) != 0)
 			return;
 
+		/* UNREGISTER events are also happpening on netns exit.
+		 *
+		 * Altough nf_tables core releases all tables/chains, only
+		 * this event handler provides guarantee that
+		 * basechain.ops->dev is still accessible, so we cannot
+		 * skip exiting net namespaces.
+		 */
 		__nft_release_basechain(ctx);
 		break;
 	case NETDEV_CHANGENAME:
@@ -318,10 +325,6 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	    event != NETDEV_CHANGENAME)
 		return NOTIFY_DONE;
 
-	ctx.net = maybe_get_net(ctx.net);
-	if (!ctx.net)
-		return NOTIFY_DONE;
-
 	mutex_lock(&ctx.net->nft.commit_mutex);
 	list_for_each_entry(table, &ctx.net->nft.tables, list) {
 		if (table->family != NFPROTO_NETDEV)
@@ -338,7 +341,6 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 		}
 	}
 	mutex_unlock(&ctx.net->nft.commit_mutex);
-	put_net(ctx.net);
 
 	return NOTIFY_DONE;
 }
-- 
2.11.0
