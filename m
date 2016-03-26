From: Stephane Bryant <stephane.ml.bryant@gmail.com>
Subject: [PATCH nf-next v6 2/3] netfilter: bridge: pass L2 header and VLAN as netlink attributes in queues to userspace
Date: Sat, 26 Mar 2016 08:42:11 +0100
Message-ID: <1458978132-8006-2-git-send-email-stephane.ml.bryant@gmail.com>
References: <1458978132-8006-1-git-send-email-stephane.ml.bryant@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	stephane <stephane.ml.bryant@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36669 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbcCZHmX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Mar 2016 03:42:23 -0400
Received: by mail-wm0-f67.google.com with SMTP id l68so8339280wml.3
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Mar 2016 00:42:23 -0700 (PDT)
In-Reply-To: <1458978132-8006-1-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: stephane <stephane.ml.bryant@gmail.com>

-this creates 2 netlink attribute NLQA_VLAN and NLQA_L2HDR
-these are filled up for the PF_BRIDGE family on the way to userspace
-NFQA_VLAN is a nested attribute, with the NFQA_VLAN_PROTO and the
 NFQA_VLAN_TCI carrying the corresponding vlan_proto and vlan_tci
 fields from the skb using big endian ordering (and using the CFI
 bit as the VLAN_TAG_PRESENT flag in vlan_tci as in the skb)

Signed-off-by: Stephane Bryant <stephane.ml.bryant@gmail.com>
---
 include/uapi/linux/netfilter/nfnetlink_queue.h | 10 +++++
 net/netfilter/nfnetlink_queue.c                | 61 ++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)

diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
index b67a853..d159e71 100644
--- a/include/uapi/linux/netfilter/nfnetlink_queue.h
+++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
@@ -30,6 +30,14 @@ struct nfqnl_msg_packet_timestamp {
 	__aligned_be64	usec;
 };
 
+enum nfqnl_vlan_attr {
+	NFQA_VLAN_UNSPEC,
+	NFQA_VLAN_PROTO,		/* __be16 skb vlan_proto */
+	NFQA_VLAN_TCI,			/* __be16 skb htons(vlan_tci) */
+	_NFQA_VLAN_MAX,
+};
+#define NFQA_VLAN_MAX (_NFQA_VLAN_MAX + 1)
+
 enum nfqnl_attr_type {
 	NFQA_UNSPEC,
 	NFQA_PACKET_HDR,
@@ -50,6 +58,8 @@ enum nfqnl_attr_type {
 	NFQA_UID,			/* __u32 sk uid */
 	NFQA_GID,			/* __u32 sk gid */
 	NFQA_SECCTX,			/* security context string */
+	NFQA_VLAN,			/* nested attribute: packet vlan info */
+	NFQA_L2HDR,			/* full L2 header */
 
 	__NFQA_MAX
 };
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 7542999..6451f5d 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -295,6 +295,62 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
 	return seclen;
 }
 
+static u32 nfqnl_get_bridge_nla_len(struct nf_queue_entry *entry)
+{
+	u32 nlalen = 0;
+	struct sk_buff *entskb = entry->skb;
+
+	if (entry->state.pf != PF_BRIDGE || !skb_mac_header_was_set(entskb))
+		return 0;
+
+	if (skb_vlan_tag_present(entskb))
+		nlalen += nla_total_size(nla_total_size(sizeof(__be16)) +
+					 nla_total_size(sizeof(__be16)));
+
+	if (entskb->network_header > entskb->mac_header)
+		nlalen += nla_total_size((entskb->network_header -
+					  entskb->mac_header));
+
+	return nlalen;
+}
+
+static int nfqnl_put_bridge_nla(struct nf_queue_entry *entry,
+				struct sk_buff *skb)
+{
+	struct sk_buff *entskb = entry->skb;
+
+	if (entry->state.pf != PF_BRIDGE || !skb_mac_header_was_set(entskb))
+		return 0;
+
+	if (skb_vlan_tag_present(entskb)) {
+		struct nlattr *vlan_attr =
+			nla_nest_start(skb, NFQA_VLAN | NLA_F_NESTED);
+
+		if (!vlan_attr)
+			goto nla_put_failure;
+
+		if (nla_put_be16(skb, NFQA_VLAN_TCI, htons(entskb->vlan_tci)))
+			goto nla_put_failure;
+
+		if (nla_put_be16(skb, NFQA_VLAN_PROTO, entskb->vlan_proto))
+			goto nla_put_failure;
+
+		nla_nest_end(skb, vlan_attr);
+	}
+
+	if (entskb->mac_header < entskb->network_header) {
+		int len = (int)(entskb->network_header - entskb->mac_header);
+
+		if (nla_put(skb, NFQA_L2HDR, len, skb_mac_header(entskb)))
+			goto nla_put_failure;
+	}
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
 static struct sk_buff *
 nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 			   struct nf_queue_entry *entry,
@@ -334,6 +390,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	if (entskb->tstamp.tv64)
 		size += nla_total_size(sizeof(struct nfqnl_msg_packet_timestamp));
 
+	size += nfqnl_get_bridge_nla_len(entry);
+
 	if (entry->state.hook <= NF_INET_FORWARD ||
 	   (entry->state.hook == NF_INET_POST_ROUTING && entskb->sk == NULL))
 		csum_verify = !skb_csum_unnecessary(entskb);
@@ -497,6 +555,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 		}
 	}
 
+	if (nfqnl_put_bridge_nla(entry, skb))
+		goto nla_put_failure;
+
 	if (entskb->tstamp.tv64) {
 		struct nfqnl_msg_packet_timestamp ts;
 		struct timespec64 kts = ktime_to_timespec64(skb->tstamp);
-- 
2.1.4

