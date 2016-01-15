From: Stephane Bryant <stephane.ml.bryant@gmail.com>
Subject: [PATCH nf-next 3/3] netfilter: bridge: copy back VLAN header for bridge packet queued to userspace
Date: Fri, 15 Jan 2016 09:48:54 +0100
Message-ID: <1452847734-3766-4-git-send-email-stephane.ml.bryant@gmail.com>
References: <1452847734-3766-1-git-send-email-stephane.ml.bryant@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	stephane <stephane.ml.bryant@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36367 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbcAOItK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jan 2016 03:49:10 -0500
Received: by mail-wm0-f66.google.com with SMTP id l65so1699298wmf.3
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Jan 2016 00:49:09 -0800 (PST)
In-Reply-To: <1452847734-3766-1-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: stephane <stephane.ml.bryant@gmail.com>

For bridge packets queued to userspace, this uses the skb tci info
to reinstate the VLAN header, and conversely parses and removes it
to fill the tci info on the way back.

Signed-off-by: Stephane Bryant <stephane.ml.bryant@gmail.com>
---
 net/netfilter/nfnetlink_queue.c | 72 ++++++++++++++++++++++++++++++-----------
 1 file changed, 54 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index b299236..07723f9 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -317,7 +317,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	bool csum_verify;
 	char *secdata = NULL;
 	u32 seclen = 0;
-	int mac_header_len = 0;
+	size_t mac_header_len = 0;
+	size_t vlan_len = 0;
 
 	size =    nlmsg_total_size(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
@@ -357,12 +358,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 		if ((entry->state.pf == PF_BRIDGE) &&
 		    (entskb->dev && (entskb->data > skb_mac_header(entskb)))) {
-			/* push back the mac header into the data so that
-			 * it gets copied in
-			 */
 			mac_header_len =
 				(int)(entskb->data - skb_mac_header(entskb));
-			skb_push(entskb, mac_header_len);
+			if (skb_vlan_tag_present(entskb))
+				vlan_len = VLAN_HLEN;
 		}
 #endif
 
@@ -372,7 +371,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 
 		hlen = skb_zerocopy_headlen(entskb);
 		hlen = min_t(unsigned int, hlen, data_len);
-		size += sizeof(struct nlattr) + hlen;
+		size += sizeof(struct nlattr) + hlen + mac_header_len +
+			vlan_len;
 		cap_len = entskb->len;
 		rem_len = data_len - hlen;
 		break;
@@ -548,7 +548,26 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 
 		nla = (struct nlattr *)skb_put(skb, sizeof(*nla));
 		nla->nla_type = NFQA_PAYLOAD;
-		nla->nla_len = nla_attr_size(data_len);
+		nla->nla_len =
+			nla_attr_size(data_len + mac_header_len + vlan_len);
+		if (mac_header_len > 0) {
+			unsigned char *mac_header;
+
+			mac_header = skb_put(skb, mac_header_len + vlan_len);
+			memcpy(mac_header, skb_mac_header(entskb),
+			       mac_header_len);
+			if (vlan_len > 0) {
+				struct vlan_ethhdr *veth =
+					(struct vlan_ethhdr *)mac_header;
+
+				u16 proto = veth->h_vlan_proto;
+
+				veth->h_vlan_proto = entskb->vlan_proto;
+				veth->h_vlan_TCI =
+					htons(skb_vlan_tag_get(entskb));
+				veth->h_vlan_encapsulated_proto = proto;
+			}
+		}
 
 		if (skb_zerocopy(skb, entskb, data_len, hlen))
 			goto nla_put_failure;
@@ -556,9 +575,6 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 
 	nlh->nlmsg_len = skb->len;
 
-	if (mac_header_len > 0)
-		skb_pull(entskb, mac_header_len);
-
 	return skb;
 
 nla_put_failure:
@@ -1087,24 +1103,44 @@ static int nfqnl_recv_verdict(struct net *net, struct sock *ctnl,
 
 	if (nfqa[NFQA_PAYLOAD]) {
 		u16 payload_len = nla_len(nfqa[NFQA_PAYLOAD]);
+		unsigned char *payload = nla_data(nfqa[NFQA_PAYLOAD]);
 		int diff = 0;
 		int mac_header_len = 0;
+
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 		if ((entry->state.pf == PF_BRIDGE) &&
 		    (entry->skb->dev &&
 		     (entry->skb->data > skb_mac_header(entry->skb)))) {
-			/* push back the mac header into the data so that
-			 * it gets copied in before mangling
-			 */
-			mac_header_len = (int)(entry->skb->data -
-					       skb_mac_header(entry->skb));
+			struct vlan_ethhdr *veth =
+				(struct vlan_ethhdr *)payload;
+
+			mac_header_len = (int)
+				(entry->skb->data - skb_mac_header(entry->skb));
+			/* push back mac header before mangling */
 			skb_push(entry->skb, mac_header_len);
-	}
+			/* check for VLAN in NFQA_PAYLOAD */
+			if ((payload_len >= VLAN_ETH_HLEN) &&
+			    ((veth->h_vlan_proto == htons(ETH_P_8021Q)) ||
+			     (veth->h_vlan_proto == htons(ETH_P_8021AD)))) {
+				entry->skb->vlan_proto = veth->h_vlan_proto;
+				entry->skb->vlan_tci =
+					ntohs(veth->h_vlan_TCI) |
+					VLAN_TAG_PRESENT;
+				memmove(payload + VLAN_HLEN, payload,
+					2 * ETH_ALEN);
+				entry->skb->protocol =
+					veth->h_vlan_encapsulated_proto;
+				payload += VLAN_HLEN;
+				payload_len -= VLAN_HLEN;
+			} else {
+				entry->skb->vlan_tci &= ~VLAN_TAG_PRESENT;
+				entry->skb->protocol = veth->h_vlan_proto;
+			}
+		}
 #endif
 		diff = payload_len - entry->skb->len;
 
-		if (nfqnl_mangle(nla_data(nfqa[NFQA_PAYLOAD]),
-				 payload_len, entry, diff) < 0)
+		if (nfqnl_mangle(payload, payload_len, entry, diff) < 0)
 			verdict = NF_DROP;
 
 		if (mac_header_len > 0) /* pull mac header again */
-- 
2.1.4

