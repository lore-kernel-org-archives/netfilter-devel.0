From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: nf_queue: add NFQA_SKB_CSUM_NOTVERIFIED info flag
Date: Sun, 26 May 2013 22:48:09 +0200
Message-ID: <1369601289-12743-1-git-send-email-fw@strlen.de>
References: <20130526204826.GC6578@breakpoint.cc>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36796 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755119Ab3EZUtT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 May 2013 16:49:19 -0400
In-Reply-To: <20130526204826.GC6578@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The common case is that TCP/IP checksums have already been
verified, e.g. by hardware (rx checksum offload), or conntrack.

Userspace can use this flag to determine when the checksum
has not been validated yet.

If the flag is set, this doesn't necessarily mean that the packet has
an invalid checksum, e.g. if NIC doesn't support rx checksum.

Userspace that sucessfully enabled NFQA_CFG_F_GSO queue feature flag can
infer that IP/TCP checksum has already been validated if either the
SKB_INFO attribute is not present or the NFQA_SKB_CSUM_NOTVERIFIED
flag is unset.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nfnetlink_queue.h |  2 ++
 net/netfilter/nfnetlink_queue_core.c           | 16 ++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
index a2308ae..3a9b921 100644
--- a/include/uapi/linux/netfilter/nfnetlink_queue.h
+++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
@@ -105,5 +105,7 @@ enum nfqnl_attr_config {
 #define NFQA_SKB_CSUMNOTREADY (1 << 0)
 /* packet is GSO (i.e., exceeds device mtu) */
 #define NFQA_SKB_GSO (1 << 1)
+/* csum not validated (incoming device doesn't support hw checksum, etc.) */
+#define NFQA_SKB_CSUM_NOTVERIFIED (1 << 2)
 
 #endif /* _NFNETLINK_QUEUE_H */
diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index 2e0e835..d9bddbf 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -272,12 +272,17 @@ nfqnl_zcopy(struct sk_buff *to, const struct sk_buff *from, int len, int hlen)
 	skb_shinfo(to)->nr_frags = j;
 }
 
-static int nfqnl_put_packet_info(struct sk_buff *nlskb, struct sk_buff *packet)
+static int
+nfqnl_put_packet_info(struct sk_buff *nlskb, struct sk_buff *packet,
+		      bool csum_verify)
 {
 	__u32 flags = 0;
 
 	if (packet->ip_summed == CHECKSUM_PARTIAL)
 		flags = NFQA_SKB_CSUMNOTREADY;
+	else if (csum_verify)
+		flags = NFQA_SKB_CSUM_NOTVERIFIED;
+
 	if (skb_is_gso(packet))
 		flags |= NFQA_SKB_GSO;
 
@@ -302,6 +307,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 	struct net_device *outdev;
 	struct nf_conn *ct = NULL;
 	enum ip_conntrack_info uninitialized_var(ctinfo);
+	bool csum_verify;
 
 	size =    nlmsg_total_size(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
@@ -319,6 +325,12 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 	if (entskb->tstamp.tv64)
 		size += nla_total_size(sizeof(struct nfqnl_msg_packet_timestamp));
 
+	if (entry->hook <= NF_INET_FORWARD ||
+	   (entry->hook == NF_INET_POST_ROUTING && entskb->sk == NULL))
+		csum_verify = !skb_csum_unnecessary(entskb);
+	else
+		csum_verify = false;
+
 	outdev = entry->outdev;
 
 	switch ((enum nfqnl_config_mode)ACCESS_ONCE(queue->copy_mode)) {
@@ -468,7 +480,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 	if (cap_len > 0 && nla_put_be32(skb, NFQA_CAP_LEN, htonl(cap_len)))
 		goto nla_put_failure;
 
-	if (nfqnl_put_packet_info(skb, entskb))
+	if (nfqnl_put_packet_info(skb, entskb, csum_verify))
 		goto nla_put_failure;
 
 	if (data_len) {
-- 
1.8.1.5

