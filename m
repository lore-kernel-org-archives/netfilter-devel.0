From: Stephane Bryant <stephane.ml.bryant@gmail.com>
Subject: [PATCH nf-next v3 3/3] netfilter: bridge: nf queue verdict to use NFQA_VLAN and NFQA_L2HDR
Date: Sat, 20 Feb 2016 10:07:10 +0100
Message-ID: <1455959230-3680-3-git-send-email-stephane.ml.bryant@gmail.com>
References: <1455959230-3680-1-git-send-email-stephane.ml.bryant@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	Stephane Bryant <stephane.ml.bryant@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:34271 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1427301AbcBTJHg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Feb 2016 04:07:36 -0500
Received: by mail-wm0-f46.google.com with SMTP id b205so96409371wmb.1
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Feb 2016 01:07:35 -0800 (PST)
In-Reply-To: <1455959230-3680-1-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This makes nf queues use NFQA_VLAN and NFQA_L2HDR in verdict to modify the
original skb

Signed-off-by: Stephane Bryant <stephane.ml.bryant@gmail.com>
---
 net/netfilter/nfnetlink_queue.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index b40cdb4..c6c365a 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1121,6 +1121,25 @@ static int nfqnl_recv_verdict(struct net *net, struct sock *ctnl,
 			ct = nfqnl_ct_parse(nfnl_ct, nlh, nfqa, entry, &ctinfo);
 	}
 
+	if (nfqa[NFQA_VLAN]) {
+		struct nfqnl_msg_vlan *pvlan = nla_data(nfqa[NFQA_VLAN]);
+
+		entry->skb->vlan_tci = pvlan->tci;
+		entry->skb->vlan_proto = pvlan->proto;
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

