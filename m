From: Stephane Bryant <stephane.ml.bryant@gmail.com>
Subject: [PATCH nf-next 2/3] netfilter: bridge: pull back mac header into skb queued to userspace
Date: Fri, 15 Jan 2016 09:48:53 +0100
Message-ID: <1452847734-3766-3-git-send-email-stephane.ml.bryant@gmail.com>
References: <1452847734-3766-1-git-send-email-stephane.ml.bryant@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	stephane <stephane.ml.bryant@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33831 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbcAOItJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jan 2016 03:49:09 -0500
Received: by mail-wm0-f66.google.com with SMTP id b14so1712677wmb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Jan 2016 00:49:08 -0800 (PST)
In-Reply-To: <1452847734-3766-1-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: stephane <stephane.ml.bryant@gmail.com>

This pulls back the mac header into the skb when queuing packets to
userspace in the bridge, and conversely when processing the verdict.

Signed-off-by: Stephane Bryant <stephane.ml.bryant@gmail.com>
---
 net/netfilter/nfnetlink_queue.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 1d39365..b299236 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -317,6 +317,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	bool csum_verify;
 	char *secdata = NULL;
 	u32 seclen = 0;
+	int mac_header_len = 0;
 
 	size =    nlmsg_total_size(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
@@ -353,6 +354,18 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 		    skb_checksum_help(entskb))
 			return NULL;
 
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+		if ((entry->state.pf == PF_BRIDGE) &&
+		    (entskb->dev && (entskb->data > skb_mac_header(entskb)))) {
+			/* push back the mac header into the data so that
+			 * it gets copied in
+			 */
+			mac_header_len =
+				(int)(entskb->data - skb_mac_header(entskb));
+			skb_push(entskb, mac_header_len);
+		}
+#endif
+
 		data_len = ACCESS_ONCE(queue->copy_range);
 		if (data_len > entskb->len)
 			data_len = entskb->len;
@@ -542,6 +555,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	nlh->nlmsg_len = skb->len;
+
+	if (mac_header_len > 0)
+		skb_pull(entskb, mac_header_len);
+
 	return skb;
 
 nla_put_failure:
@@ -1070,12 +1087,29 @@ static int nfqnl_recv_verdict(struct net *net, struct sock *ctnl,
 
 	if (nfqa[NFQA_PAYLOAD]) {
 		u16 payload_len = nla_len(nfqa[NFQA_PAYLOAD]);
-		int diff = payload_len - entry->skb->len;
+		int diff = 0;
+		int mac_header_len = 0;
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+		if ((entry->state.pf == PF_BRIDGE) &&
+		    (entry->skb->dev &&
+		     (entry->skb->data > skb_mac_header(entry->skb)))) {
+			/* push back the mac header into the data so that
+			 * it gets copied in before mangling
+			 */
+			mac_header_len = (int)(entry->skb->data -
+					       skb_mac_header(entry->skb));
+			skb_push(entry->skb, mac_header_len);
+	}
+#endif
+		diff = payload_len - entry->skb->len;
 
 		if (nfqnl_mangle(nla_data(nfqa[NFQA_PAYLOAD]),
 				 payload_len, entry, diff) < 0)
 			verdict = NF_DROP;
 
+		if (mac_header_len > 0) /* pull mac header again */
+			skb_pull(entry->skb, mac_header_len);
+
 		if (ct && diff)
 			nfnl_ct->seq_adjust(entry->skb, ct, ctinfo, diff);
 	}
-- 
2.1.4

