From: Stephane Bryant <stephane.ml.bryant@gmail.com>
Subject: [PATCH nf-next v5 3/3] netfilter: bridge: nf queue verdict to use NFQA_VLAN and NFQA_L2HDR
Date: Sun, 20 Mar 2016 09:06:46 +0100
Message-ID: <1458461206-4338-3-git-send-email-stephane.ml.bryant@gmail.com>
References: <1458461206-4338-1-git-send-email-stephane.ml.bryant@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	Stephane Bryant <stephane.ml.bryant@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33535 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbcCTIHL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Mar 2016 04:07:11 -0400
Received: by mail-wm0-f65.google.com with SMTP id x188so14927541wmg.0
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Mar 2016 01:07:10 -0700 (PDT)
In-Reply-To: <1458461206-4338-1-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This makes nf queues use NFQA_VLAN and NFQA_L2HDR in verdict to modify the
original skb

Signed-off-by: Stephane Bryant <stephane.ml.bryant@gmail.com>
---
 net/netfilter/nfnetlink_queue.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 0da0276..aa526f0 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1126,6 +1126,31 @@ static int nfqnl_recv_verdict(struct net *net, struct sock *ctnl,
 			ct = nfqnl_ct_parse(nfnl_ct, nlh, nfqa, entry, &ctinfo);
 	}
 
+	if (nfqa[NFQA_VLAN]) {
+		struct nlattr *vlan_tci =
+			nla_find_nested(nfqa[NFQA_VLAN], NFQA_VLAN_TCI);
+		struct nlattr *vlan_proto =
+			nla_find_nested(nfqa[NFQA_VLAN], NFQA_VLAN_PROTO);
+
+		if (vlan_tci)
+			entry->skb->vlan_tci = ntohs(nla_get_be16(vlan_tci));
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

