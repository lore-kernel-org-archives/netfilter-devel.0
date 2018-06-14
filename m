From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next,RFC 01/13] net: Add a helper to get the packet offload callbacks by priority.
Date: Thu, 14 Jun 2018 16:19:35 +0200
Message-ID: <20180614141947.3580-2-pablo@netfilter.org>
References: <20180614141947.3580-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org, steffen.klassert@secunet.com
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180614141947.3580-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

With this helper it is possible to request callbacks with
a certain priority. This will be used in the upcoming forward
fastpath to pass packets to the standard GRO path.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice.h |  1 +
 net/core/dev.c            | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3ec9850c7936..13a56f9b2a32 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2523,6 +2523,7 @@ void dev_remove_pack(struct packet_type *pt);
 void __dev_remove_pack(struct packet_type *pt);
 void dev_add_offload(struct packet_offload *po);
 void dev_remove_offload(struct packet_offload *po);
+struct packet_offload *dev_get_packet_offload(__be16 type, int priority);
 
 int dev_get_iflink(const struct net_device *dev);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
diff --git a/net/core/dev.c b/net/core/dev.c
index 6e18242a1cae..115de8bfcb54 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -468,7 +468,21 @@ void dev_remove_pack(struct packet_type *pt)
 }
 EXPORT_SYMBOL(dev_remove_pack);
 
+struct packet_offload *dev_get_packet_offload(__be16 type, int priority)
+{
+	struct list_head *offload_head = &offload_base;
+	struct packet_offload *ptype;
+
+	list_for_each_entry_rcu(ptype, offload_head, list) {
+		if (ptype->type != type || !ptype->callbacks.gro_receive || !ptype->callbacks.gro_complete || ptype->priority < priority)
+			continue;
 
+		return ptype;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(dev_get_packet_offload);
 /**
  *	dev_add_offload - register offload handlers
  *	@po: protocol offload declaration
-- 
2.11.0
