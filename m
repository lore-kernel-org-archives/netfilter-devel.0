From: Stephane Bryant <stephane.ml.bryant@gmail.com>
Subject: [PATCH nf-next v4 3/3] netfilter: bridge: nf queue verdict to use NFQA_VLAN and NFQA_L2HDR
Date: Fri, 18 Mar 2016 18:33:36 +0100
Message-ID: <1458322416-4137-3-git-send-email-stephane.ml.bryant@gmail.com>
References: <1458322416-4137-1-git-send-email-stephane.ml.bryant@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	Stephane Bryant <stephane.ml.bryant@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35973 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602AbcCRReF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Mar 2016 13:34:05 -0400
Received: by mail-wm0-f65.google.com with SMTP id l68so7681414wml.3
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Mar 2016 10:34:04 -0700 (PDT)
In-Reply-To: <1458322416-4137-1-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This makes nf queues use NFQA_VLAN and NFQA_L2HDR in verdict to modify the
original skb

Signed-off-by: Stephane Bryant <stephane.ml.bryant@gmail.com>
---
 net/netfilter/nfnetlink_queue.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index acfc15c..ece25c5 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1127,6 +1127,31 @@ static int nfqnl_recv_verdict(struct net *net, struct sock *ctnl,
 			ct = nfqnl_ct_parse(nfnl_ct, nlh, nfqa, entry, &ctinfo);
 	}
 
+	if (nfqa[NFQA_VLAN]) {
+		struct nlattr *vlan_tci =
+			nla_find_nested(nfqa[NFQA_VLAN], NFQA_VLAN_TCI);
+		struct nlattr *vlan_proto =
+			nla_find_nested(nfqa[NFQA_VLAN], NFQA_VLAN_PROTO);
+
+		if (vlan_tci)
+			entry->skb->vlan_tci = nla_get_u16(vlan_tci);
+
+		if (vlan_proto)
+			entry->skb->vlan_proto = nla_get_be16(vlan_proto);
+	}
+
+	if (nfqa[NFQA_L2HDR]) {
+		int mac_header_len = entry->skb->network_header -
+			entry->skb->mac_header;
+
+		if (mac_header_len != nla_len(nfqa[NFQA_L2HDR]))
+			verdict = NF_DROP;
+		else if (mac_header_len > 0)
+			memcpy(skb_mac_header(entry->skb),
+			       nla_data(nfqa[NFQA_L2HDR]),
+			       mac_header_len);
+	}
+
 	if (nfqa[NFQA_PAYLOAD]) {
 		u16 payload_len = nla_len(nfqa[NFQA_PAYLOAD]);
 		int diff = payload_len - entry->skb->len;
-- 
2.1.4

