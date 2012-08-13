From: Denis Efremov <yefremov.denis@gmail.com>
Subject: [PATCH] bridge: rcu_deref outside read-lock section
Date: Tue, 14 Aug 2012 02:47:42 +0400
Message-ID: <1344898062-23633-1-git-send-email-yefremov.denis@gmail.com>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org,
	ldv-project@ispras.ru
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

As it noted in the comment before the br_handle_frame_finish
function, this function should be called under rcu_read_lock.

The problem callgraph:
br_dev_xmit -> br_nf_pre_routing_finish_bridge_slow ->
-> br_handle_frame_finish -> br_port_get_rcu -> rcu_dereference

And in this case there is no read-lock section.
I have put lock/unlock in br_nf_pre_routing_finish_bridge_slow,
as the only function that calls it(for now) - is br_dev_xmit.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 include/linux/netfilter_bridge.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index 31d2844..ceb048e 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -79,6 +79,7 @@ extern int br_handle_frame_finish(struct sk_buff *skb);
 /* Only used in br_device.c */
 static inline int br_nf_pre_routing_finish_bridge_slow(struct sk_buff *skb)
 {
+	int res;
 	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
 
 	skb_pull(skb, ETH_HLEN);
@@ -86,7 +87,10 @@ static inline int br_nf_pre_routing_finish_bridge_slow(struct sk_buff *skb)
 	skb_copy_to_linear_data_offset(skb, -(ETH_HLEN-ETH_ALEN),
 				       skb->nf_bridge->data, ETH_HLEN-ETH_ALEN);
 	skb->dev = nf_bridge->physindev;
-	return br_handle_frame_finish(skb);
+	rcu_read_lock();
+	res = br_handle_frame_finish(skb);
+	rcu_read_unlock();
+	return res;
 }
 
 /* This is called by the IP fragmenting code and it ensures there is
-- 
1.7.7

