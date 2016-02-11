From: stephane.ml.bryant@gmail.com
Subject: [PATCH nf-next v2 2/2] netfilter: bridge: pass L2 header and VLAN as netlink attributes in queues to userspace
Date: Thu, 11 Feb 2016 15:53:16 +0100
Message-ID: <1455202396-5334-3-git-send-email-stephane.ml.bryant@gmail.com>
References: <1455202396-5334-1-git-send-email-stephane.ml.bryant@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	stephane <stephane.ml.bryant@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36362 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbcBKOx3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2016 09:53:29 -0500
Received: by mail-wm0-f65.google.com with SMTP id 128so11082619wmz.3
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Feb 2016 06:53:28 -0800 (PST)
In-Reply-To: <1455202396-5334-1-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: stephane <stephane.ml.bryant@gmail.com>

-this creates 2 netlink attribute NLQA_VLAN and NLQA_L2HDR
-these are filled up for the PF_BRIDGE family on the way to userspace, and
 used on the way back to modify the original skb accordingly

Signed-off-by: Stephane Bryant <stephane.ml.bryant@gmail.com>
---
 include/uapi/linux/netfilter/nfnetlink_queue.h |   7 ++
 net/netfilter/nfnetlink_queue.c                | 130 ++++++++++++++++++++++++-
 2 files changed, 132 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
index b67a853..211fcdc 100644
--- a/include/uapi/linux/netfilter/nfnetlink_queue.h
+++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
@@ -30,6 +30,11 @@ struct nfqnl_msg_packet_timestamp {
 	__aligned_be64	usec;
 };
 
+struct nfqnl_msg_vlan {
+	__be16                  proto;
+	__u16                   tci;
+} __attribute__ ((packed));
+
 enum nfqnl_attr_type {
 	NFQA_UNSPEC,
 	NFQA_PACKET_HDR,
@@ -50,6 +55,8 @@ enum nfqnl_attr_type {
 	NFQA_UID,			/* __u32 sk uid */
 	NFQA_GID,			/* __u32 sk gid */
 	NFQA_SECCTX,			/* security context string */
+	NFQA_VLAN,                      /* packet vlan info */
+	NFQA_L2HDR,                     /* full L2 header */
 
 	__NFQA_MAX
 };
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 1d39365..cb30b2e 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -295,6 +295,59 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
 	return seclen;
 }
 
+static u32 nfqnl_get_bridge_nla_len(struct nf_queue_entry *entry)
+{
+	u32 nlalen = 0;
+
+	struct sk_buff *entskb = entry->skb;
+
+	if (skb_vlan_tag_present(entskb))
+		nlalen += nla_total_size(sizeof(struct nfqnl_msg_vlan));
+
+	if (entry->state.in && entskb->dev &&
+	    (entskb->network_header > entskb->mac_header)) {
+		nlalen += nla_total_size((entskb->network_header -
+					  entskb->mac_header));
+	}
+
+	return nlalen;
+}
+
+static int nfqnl_put_bridge_nla(struct nf_queue_entry *entry,
+				struct sk_buff *skb)
+{
+	struct sk_buff *entskb = entry->skb;
+
+	if (skb_vlan_tag_present(entskb)) {
+		struct nfqnl_msg_vlan pvlan;
+
+		pvlan.tci = entskb->vlan_tci;
+		pvlan.proto = entskb->vlan_proto;
+		if (nla_put(skb, NFQA_VLAN, sizeof(pvlan), &pvlan))
+			goto nla_put_failure;
+	}
+	if (entry->state.in && entskb->dev &&
+	    (entskb->mac_header < entskb->network_header)) {
+		int len = (int)(entskb->network_header - entskb->mac_header);
+		struct nlattr *nla;
+
+		if (skb_tailroom(skb) <
+		    NLA_ALIGN((sizeof(struct nlattr) + len)))
+			goto nla_put_failure;
+
+		nla = (struct nlattr *)
+			skb_put(skb, NLA_ALIGN(sizeof(struct nlattr) + len));
+		nla->nla_type = NFQA_L2HDR;
+		nla->nla_len = nla_attr_size(len);
+		memcpy(nla_data(nla), skb_mac_header(entskb), len);
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
@@ -334,6 +387,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	if (entskb->tstamp.tv64)
 		size += nla_total_size(sizeof(struct nfqnl_msg_packet_timestamp));
 
+	if (entry->state.pf == PF_BRIDGE)
+		size += nfqnl_get_bridge_nla_len(entry);
+
 	if (entry->state.hook <= NF_INET_FORWARD ||
 	   (entry->state.hook == NF_INET_POST_ROUTING && entskb->sk == NULL))
 		csum_verify = !skb_csum_unnecessary(entskb);
@@ -499,6 +555,11 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 		}
 	}
 
+	if (entry->state.pf == PF_BRIDGE) {
+		if (nfqnl_put_bridge_nla(entry, skb))
+			goto nla_put_failure;
+	}
+
 	if (entskb->tstamp.tv64) {
 		struct nfqnl_msg_packet_timestamp ts;
 		struct timespec64 kts = ktime_to_timespec64(skb->tstamp);
@@ -536,7 +597,6 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 		nla = (struct nlattr *)skb_put(skb, sizeof(*nla));
 		nla->nla_type = NFQA_PAYLOAD;
 		nla->nla_len = nla_attr_size(data_len);
-
 		if (skb_zerocopy(skb, entskb, data_len, hlen))
 			goto nla_put_failure;
 	}
@@ -1027,6 +1087,46 @@ static struct nf_conn *nfqnl_ct_parse(struct nfnl_ct_hook *nfnl_ct,
 	return ct;
 }
 
+static int nfqnl_push_l2hdr(unsigned char **payload, int *payload_len,
+			    struct nf_queue_entry *entry,
+			    const struct nlattr * const nfqa[])
+{
+	int mac_header_len = 0;
+
+	if (entry->skb->dev && nfqa[NFQA_L2HDR]) {
+		mac_header_len = nla_len(nfqa[NFQA_L2HDR]);
+		if (mac_header_len > 0) {
+			unsigned char *full_payload;
+			/* realloc provided payload to have room for the l2
+			 *  header
+			 */
+			full_payload = (char *)
+				kmalloc(((*payload_len) + mac_header_len),
+					GFP_ATOMIC);
+			if (!full_payload)
+				goto err_push;
+
+			memcpy(full_payload, nla_data(nfqa[NFQA_L2HDR]),
+			       mac_header_len);
+			memcpy(full_payload + mac_header_len, *payload,
+			       *payload_len);
+			*payload = full_payload;
+			(*payload_len) += mac_header_len;
+			/* push back mac header */
+			if (entry->skb->network_header > entry->skb->mac_header)
+				skb_push(entry->skb,
+					 (entry->skb->network_header -
+					  entry->skb->mac_header));
+			else
+				mac_header_len = 0;
+		}
+	}
+	return mac_header_len;
+
+err_push:
+	return 0;
+}
+
 static int nfqnl_recv_verdict(struct net *net, struct sock *ctnl,
 			      struct sk_buff *skb,
 			      const struct nlmsghdr *nlh,
@@ -1068,14 +1168,34 @@ static int nfqnl_recv_verdict(struct net *net, struct sock *ctnl,
 			ct = nfqnl_ct_parse(nfnl_ct, nlh, nfqa, entry, &ctinfo);
 	}
 
+	if (nfqa[NFQA_VLAN]) {
+		struct nfqnl_msg_vlan *pvlan = nla_data(nfqa[NFQA_VLAN]);
+
+		entry->skb->vlan_tci = pvlan->tci;
+		entry->skb->vlan_proto = pvlan->proto;
+	}
+
 	if (nfqa[NFQA_PAYLOAD]) {
-		u16 payload_len = nla_len(nfqa[NFQA_PAYLOAD]);
-		int diff = payload_len - entry->skb->len;
+		int payload_len = nla_len(nfqa[NFQA_PAYLOAD]);
+		unsigned char *payload = nla_data(nfqa[NFQA_PAYLOAD]);
+		int mac_header_len = 0;
+		int diff = 0;
+
+		if (entry->state.pf == PF_BRIDGE)
+			mac_header_len = nfqnl_push_l2hdr(&payload,
+							  &payload_len,
+							  entry, nfqa);
 
-		if (nfqnl_mangle(nla_data(nfqa[NFQA_PAYLOAD]),
-				 payload_len, entry, diff) < 0)
+		diff = payload_len - entry->skb->len;
+
+		if (nfqnl_mangle(payload, payload_len, entry, diff) < 0)
 			verdict = NF_DROP;
 
+		if (payload != nla_data(nfqa[NFQA_PAYLOAD]))
+			kfree(payload);
+		if (mac_header_len > 0) /* pull mac header again */
+			skb_pull(entry->skb, mac_header_len);
+
 		if (ct && diff)
 			nfnl_ct->seq_adjust(entry->skb, ct, ctinfo, diff);
 	}
-- 
2.1.4

