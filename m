From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/8] netfilter: xt_TEE: add missing code to get interface index in checkentry.
Date: Mon, 22 Oct 2018 22:07:20 +0200
Message-ID: <20181022200724.25806-5-pablo@netfilter.org>
References: <20181022200724.25806-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181022200724.25806-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

checkentry(tee_tg_check) should initialize priv->oif from dev if possible.
But only netdevice notifier handler can set that.
Hence priv->oif is always -1 until notifier handler is called.

Fixes: 9e2f6c5d78db ("netfilter: Rework xt_TEE netdevice notifier")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_TEE.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index 673ad2099f97..1dae02a97ee3 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -104,6 +104,8 @@ static int tee_tg_check(const struct xt_tgchk_param *par)
 		return -EINVAL;
 
 	if (info->oif[0]) {
+		struct net_device *dev;
+
 		if (info->oif[sizeof(info->oif)-1] != '\0')
 			return -EINVAL;
 
@@ -115,6 +117,11 @@ static int tee_tg_check(const struct xt_tgchk_param *par)
 		priv->oif     = -1;
 		info->priv    = priv;
 
+		dev = dev_get_by_name(par->net, info->oif);
+		if (dev) {
+			priv->oif = dev->ifindex;
+			dev_put(dev);
+		}
 		mutex_lock(&tn->lock);
 		list_add(&priv->list, &tn->priv_list);
 		mutex_unlock(&tn->lock);
-- 
2.11.0
