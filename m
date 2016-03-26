From: Stephane Bryant <stephane.ml.bryant@gmail.com>
Subject: [PATCH nf-next v6 3/3] netfilter: bridge: nf queue verdict to use NFQA_VLAN and NFQA_L2HDR
Date: Sat, 26 Mar 2016 08:42:12 +0100
Message-ID: <1458978132-8006-3-git-send-email-stephane.ml.bryant@gmail.com>
References: <1458978132-8006-1-git-send-email-stephane.ml.bryant@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	Stephane Bryant <stephane.ml.bryant@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36677 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbcCZHmY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Mar 2016 03:42:24 -0400
Received: by mail-wm0-f65.google.com with SMTP id l68so8339332wml.3
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Mar 2016 00:42:24 -0700 (PDT)
In-Reply-To: <1458978132-8006-1-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This makes nf queues use NFQA_VLAN and NFQA_L2HDR in verdict to modify the
original skb

Signed-off-by: Stephane Bryant <stephane.ml.bryant@gmail.com>
---
 net/netfilter/nfnetlink_queue.c | 45 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 6451f5d..a7ad25a 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -967,12 +967,18 @@ static struct notifier_block nfqnl_rtnl_notifier = {
 	.notifier_call	= nfqnl_rcv_nl_event,
 };
 
+static const struct nla_policy nfqa_vlan_policy[NFQA_VLAN_MAX + 1] = {
+	[NFQA_VLAN_TCI]		= { .type = NLA_U16},
+	[NFQA_VLAN_PROTO]	= { .type = NLA_U16},
+};
+
 static const struct nla_policy nfqa_verdict_policy[NFQA_MAX+1] = {
 	[NFQA_VERDICT_HDR]	= { .len = sizeof(struct nfqnl_msg_verdict_hdr) },
 	[NFQA_MARK]		= { .type = NLA_U32 },
 	[NFQA_PAYLOAD]		= { .type = NLA_UNSPEC },
 	[NFQA_CT]		= { .type = NLA_UNSPEC },
 	[NFQA_EXP]		= { .type = NLA_UNSPEC },
+	[NFQA_VLAN]		= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy nfqa_verdict_batch_policy[NFQA_MAX+1] = {
@@ -1086,6 +1092,40 @@ static struct nf_conn *nfqnl_ct_parse(struct nfnl_ct_hook *nfnl_ct,
 	return ct;
 }
 
+static int nfqa_parse_bridge(struct nf_queue_entry *entry,
+			     const struct nlattr * const nfqa[])
+{
+	if (nfqa[NFQA_VLAN]) {
+		int err;
+		struct nlattr *tb[NFQA_VLAN_MAX + 1];
+
+		err = nla_parse_nested(tb, NFQA_VLAN_MAX, nfqa[NFQA_VLAN],
+				       nfqa_vlan_policy);
+		if (err < 0)
+			return err;
+
+		if (!tb[NFQA_VLAN_TCI] || !tb[NFQA_VLAN_PROTO])
+			return -EINVAL;
+
+		entry->skb->vlan_tci = ntohs(nla_get_be16(tb[NFQA_VLAN_TCI]));
+		entry->skb->vlan_proto = nla_get_be16(tb[NFQA_VLAN_PROTO]);
+	}
+
+	if (nfqa[NFQA_L2HDR]) {
+		int mac_header_len = entry->skb->network_header -
+			entry->skb->mac_header;
+
+		if (mac_header_len != nla_len(nfqa[NFQA_L2HDR]))
+			return -EINVAL;
+		else if (mac_header_len > 0)
+			memcpy(skb_mac_header(entry->skb),
+			       nla_data(nfqa[NFQA_L2HDR]),
+			       mac_header_len);
+	}
+
+	return 0;
+}
+
 static int nfqnl_recv_verdict(struct net *net, struct sock *ctnl,
 			      struct sk_buff *skb,
 			      const struct nlmsghdr *nlh,
@@ -1127,6 +1167,11 @@ static int nfqnl_recv_verdict(struct net *net, struct sock *ctnl,
 			ct = nfqnl_ct_parse(nfnl_ct, nlh, nfqa, entry, &ctinfo);
 	}
 
+	if (entry->state.pf == PF_BRIDGE) {
+		if (nfqa_parse_bridge(entry, nfqa) < 0)
+			verdict = NF_DROP;
+	}
+
 	if (nfqa[NFQA_PAYLOAD]) {
 		u16 payload_len = nla_len(nfqa[NFQA_PAYLOAD]);
 		int diff = payload_len - entry->skb->len;
-- 
2.1.4

