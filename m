From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: bridge: restore vlan tag when refragmenting
Date: Fri,  5 Jun 2015 13:27:13 +0200
Message-ID: <1433503633-16312-1-git-send-email-fw@strlen.de>
Cc: eric.dumazet@gmail.com, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38176 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008AbbFEL1R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 07:27:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If bridge netfilter is used with both
bridge-nf-call-iptables and bridge-nf-filter-vlan-tagged enabled
then ip fragments in VLAN frames are sent without the vlan header.

This has never worked reliably.  Turns out this relied on pre-3.5
behaviour where skb frag_list was used to store ip fragments;
ip_fragment() then re-used these skbs.

But since commit 3cc4949269e01f39443d0fcfffb5bc6b47878d45
("ipv4: use skb coalescing in defragmentation") this is no longer
the case.  ip_do_fragment now needs to allocate new skbs, but these
don't contain the vlan tag information anymore.

Fix it by storing vlan information of the ressembled skb in the
br netfilter percpu frag area, and restore them for each of the
fragments.

Fixes: 3cc4949269e01f3 ("ipv4: use skb coalescing in defragmentation")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/br_netfilter.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 46660a2..0d9ad4a 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -115,6 +115,8 @@ struct brnf_frag_data {
 	char mac[NF_BRIDGE_MAX_MAC_HEADER_LENGTH];
 	u8 encap_size;
 	u8 size;
+	u16 vlan_tci;
+	__be16 vlan_proto;
 };
 
 static DEFINE_PER_CPU(struct brnf_frag_data, brnf_frag_data_storage);
@@ -837,6 +839,11 @@ static int br_nf_push_frag_xmit(struct sock *sk, struct sk_buff *skb)
 		return 0;
 	}
 
+	if (data->vlan_tci) {
+		skb->vlan_tci = data->vlan_tci;
+		skb->vlan_proto = data->vlan_proto;
+	}
+
 	skb_copy_to_linear_data_offset(skb, -data->size, data->mac, data->size);
 	__skb_push(skb, data->encap_size);
 
@@ -890,6 +897,9 @@ static int br_nf_dev_queue_xmit(struct sock *sk, struct sk_buff *skb)
 		nf_bridge_update_protocol(skb);
 
 		data = this_cpu_ptr(&brnf_frag_data_storage);
+
+		data->vlan_tci = skb->vlan_tci;
+		data->vlan_proto = skb->vlan_proto;
 		data->encap_size = nf_bridge_encap_header_len(skb);
 		data->size = ETH_HLEN + data->encap_size;
 
-- 
2.0.5

