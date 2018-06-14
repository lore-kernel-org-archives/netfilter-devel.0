From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next,RFC 04/13] net: Use one bit of NAPI_GRO_CB for the netfilter fastpath.
Date: Thu, 14 Jun 2018 16:19:38 +0200
Message-ID: <20180614141947.3580-5-pablo@netfilter.org>
References: <20180614141947.3580-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org, steffen.klassert@secunet.com
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180614141947.3580-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

This patch adds a is_ffwd bit to the NAPI_GRO_CB to indicate
fastpath packtes in the GRO layer. It also implements the
logic we need for this in the generic codepath. The rest
of the needed logic is implemented within netfilter and
introduced with a followup patch.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice.h |  2 +-
 net/core/dev.c            | 36 +++++++++++++++++++++++++++---------
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d8cadfa3769b..62734cf0c43a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2238,7 +2238,7 @@ struct napi_gro_cb {
 	/* Number of gro_receive callbacks this packet already went through */
 	u8 recursion_counter:4;
 
-	/* 1 bit hole */
+	u8	is_ffwd:1;
 
 	/* used to support CHECKSUM_COMPLETE for tunneling protocols */
 	__wsum	csum;
diff --git a/net/core/dev.c b/net/core/dev.c
index 115de8bfcb54..75f530886874 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4864,7 +4864,8 @@ static int napi_gro_complete(struct sk_buff *skb)
 
 	BUILD_BUG_ON(sizeof(struct napi_gro_cb) > sizeof(skb->cb));
 
-	if (NAPI_GRO_CB(skb)->count == 1) {
+	if (NAPI_GRO_CB(skb)->count == 1 &&
+	    !(NAPI_GRO_CB(skb)->is_ffwd)) {
 		skb_shinfo(skb)->gso_size = 0;
 		goto out;
 	}
@@ -4880,8 +4881,10 @@ static int napi_gro_complete(struct sk_buff *skb)
 	rcu_read_unlock();
 
 	if (err) {
-		WARN_ON(&ptype->list == head);
-		kfree_skb(skb);
+		if (err != -EINPROGRESS) {
+			WARN_ON(&ptype->list == head);
+			kfree_skb(skb);
+		}
 		return NET_RX_SUCCESS;
 	}
 
@@ -4936,8 +4939,10 @@ static void gro_list_prepare(struct napi_struct *napi, struct sk_buff *skb)
 
 		diffs = (unsigned long)p->dev ^ (unsigned long)skb->dev;
 		diffs |= p->vlan_tci ^ skb->vlan_tci;
-		diffs |= skb_metadata_dst_cmp(p, skb);
-		diffs |= skb_metadata_differs(p, skb);
+		if (!NAPI_GRO_CB(p)->is_ffwd) {
+			diffs |= skb_metadata_dst_cmp(p, skb);
+			diffs |= skb_metadata_differs(p, skb);
+		}
 		if (maclen == ETH_HLEN)
 			diffs |= compare_ether_header(skb_mac_header(p),
 						      skb_mac_header(skb));
@@ -5019,6 +5024,7 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 		NAPI_GRO_CB(skb)->is_fou = 0;
 		NAPI_GRO_CB(skb)->is_atomic = 1;
 		NAPI_GRO_CB(skb)->gro_remcsum_start = 0;
+		NAPI_GRO_CB(skb)->is_ffwd = 0;
 
 		/* Setup for GRO checksum validation */
 		switch (skb->ip_summed) {
@@ -5044,9 +5050,14 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 	if (&ptype->list == head)
 		goto normal;
 
-	if (IS_ERR(pp) && PTR_ERR(pp) == -EINPROGRESS) {
-		ret = GRO_CONSUMED;
-		goto ok;
+	if (IS_ERR(pp)) {
+		int err;
+
+		err = PTR_ERR(pp);
+		if (err == -EINPROGRESS || err == -EPERM) {
+			ret = GRO_CONSUMED;
+			goto ok;
+		}
 	}
 
 	same_flow = NAPI_GRO_CB(skb)->same_flow;
@@ -5064,8 +5075,15 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 	if (same_flow)
 		goto ok;
 
-	if (NAPI_GRO_CB(skb)->flush)
+	if (NAPI_GRO_CB(skb)->flush) {
+		if (NAPI_GRO_CB(skb)->is_ffwd) {
+			napi_gro_complete(skb);
+			ret = GRO_CONSUMED;
+			goto ok;
+		}
+
 		goto normal;
+	}
 
 	if (unlikely(napi->gro_count >= MAX_GRO_SKBS)) {
 		struct sk_buff *nskb = napi->gro_list;
-- 
2.11.0
