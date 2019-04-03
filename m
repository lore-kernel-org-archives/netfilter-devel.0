Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99642C4360F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 15:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 596872054F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 15:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfDCPkT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 11:40:19 -0400
Received: from mail.us.es ([193.147.175.20]:56730 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726947AbfDCPkS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 11:40:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 699601878BA
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2019 17:40:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5408ADA717
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2019 17:40:14 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 49BFDDA712; Wed,  3 Apr 2019 17:40:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D076EDA701;
        Wed,  3 Apr 2019 17:40:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Apr 2019 17:40:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8E4444265A31;
        Wed,  3 Apr 2019 17:40:11 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, eric.dumazet@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH net-next,RFC 8/8] netfilter: bridge: add basic conntrack support
Date:   Wed,  3 Apr 2019 17:40:01 +0200
Message-Id: <20190403154001.8177-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190403154001.8177-1-pablo@netfilter.org>
References: <20190403154001.8177-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds native connection tracking support for the bridge.  This
patch register two hooks, one at bridge prerouting to call
nf_conntrack_in() and another at the bridge postrouting hook to confirm
the entry.

The conntrack bridge prerouting hook defragments packets and it passes
them to nf_conntrack_in() to look up for an existing entry, otherwise a
new entry is created in the conntrack table.

The conntrack bridge postrouting hook confirms new entries, ie. this is
the first packet seen of this flow, then - if needed - it refragments
the skbuff into the original fragments, leaving the geometry in
untouched, unless this skbuff has been already linearized - eg. passed
up to nfqueue and conntrack helpers - or skbuff has been cloned either
for the local delivery for tcpdump or in case bridge port flooding is
needed.

The maximum fragment length is stored and it is used refragment the
skbuff. In case the maximum fragment length is larger than the output
port, the packet is silently discarded, ie. no refragmentation occurs.

The packet defragmentation is still done through the ip_defrag() call.
This forces us to save the bridge control buffer, reset the IP
control buffer area and then restore it after call. This function bumps
the IP fragmentation statistics.

The new fraglist iterator and fragment transformer APIs is used to
implement the refragmentation code. The br_ip_fragment() function
drops the packet in case the maximum fragment size seen is larger than
the output port MTU.

Health check validations are only performed in case of defragmentation,
to follow the principle that conntrack should not drop packets, so users
can do it through policy, ie. drop invalid packets.

Like br_netfilter, there is no need to refragment packets that are
passed up for local delivery, ie. prerouting -> input path. There are
calls to nf_reset() already in several spots that were placed there a
bit of time ago already, eg. af_packet, that show that skbuff fraglist
from the netif_rx path is supported already.

This is work-in-progress, missing parts are:

 1. A track extension to allow userspace to pick up selected packets
    for tracking. We cannot inconditionally enable conntrack as in IPv4
    and IPv6, we need an extension to specify what zone this conntrack
    belongs to to support VLAN scenarios.
 2. Complete IPv6 support.
 3. Netnamespace support.

This patch is based on original work from Florian Westphal.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/br_private.h                    |   2 +-
 net/bridge/netfilter/Kconfig               |  14 +
 net/bridge/netfilter/Makefile              |   3 +
 net/bridge/netfilter/nf_conntrack_bridge.c | 411 +++++++++++++++++++++++++++++
 4 files changed, 429 insertions(+), 1 deletion(-)
 create mode 100644 net/bridge/netfilter/nf_conntrack_bridge.c

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 00deef7fc1f3..d8d150677fa1 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -430,7 +430,7 @@ struct br_input_skb_cb {
 	int igmp;
 	int mrouters_only;
 #endif
-
+	u16 nf_frag_max_size;
 	bool proxyarp_replied;
 	bool src_port_isolated;
 
diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 9a0159aebe1a..eb61197d8af8 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -18,6 +18,20 @@ config NF_LOG_BRIDGE
 	tristate "Bridge packet logging"
 	select NF_LOG_COMMON
 
+config NF_CONNTRACK_BRIDGE
+	tristate "IPv4/IPV6 bridge connection tracking support"
+	depends on NF_CONNTRACK
+	default n
+	help
+	  Connection tracking keeps a record of what packets have passed
+	  through your machine, in order to figure out how they are related
+	  into connections. This is used to enhance packet filtering via
+	  stateful policies. Enable this if you want native tracking from
+	  the bridge. This is provides a replacement for the `br_netfilter'
+	  infrastructure.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 endif # NF_TABLES_BRIDGE
 
 menuconfig BRIDGE_NF_EBTABLES
diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index 9b868861f21a..9d7767322a64 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -5,6 +5,9 @@
 
 obj-$(CONFIG_NFT_BRIDGE_REJECT)  += nft_reject_bridge.o
 
+# connection tracking
+obj-$(CONFIG_NF_CONNTRACK_BRIDGE) += nf_conntrack_bridge.o
+
 # packet logging
 obj-$(CONFIG_NF_LOG_BRIDGE) += nf_log_bridge.o
 
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
new file mode 100644
index 000000000000..46fa52778d2c
--- /dev/null
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -0,0 +1,411 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/types.h>
+#include <linux/ip.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv6.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/icmp.h>
+#include <linux/sysctl.h>
+#include <net/route.h>
+#include <net/ip.h>
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/ipv6/nf_defrag_ipv6.h>
+#include <net/netfilter/nf_tables.h>
+
+#include "../br_private.h"
+
+struct nf_ct_bridge_frag_data {
+	char mac[ETH_HLEN];
+	u16 vlan_tci;
+	__be16 vlan_proto;
+};
+
+/* Best effort variant of ip_do_fragment which preserves geometry, unless skbuff
+ * has been linearized or cloned.
+ */
+static int br_ip_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
+			  struct nf_ct_bridge_frag_data *data,
+			  int (*output)(struct net *, struct sock *sk,
+					const struct nf_ct_bridge_frag_data *data,
+					struct sk_buff *))
+{
+	int frag_max_size = BR_INPUT_SKB_CB(skb)->nf_frag_max_size;
+	unsigned int hlen, ll_rs, mtu;
+	struct ip_frag_state state;
+	struct iphdr *iph;
+	int err;
+
+	/* for offloaded checksums cleanup checksum before fragmentation */
+	if (skb->ip_summed == CHECKSUM_PARTIAL &&
+	    (err = skb_checksum_help(skb)))
+		goto blackhole;
+
+	iph = ip_hdr(skb);
+
+	/*
+	 *	Setup starting values
+	 */
+
+	hlen = iph->ihl * 4;
+	frag_max_size -= hlen;
+	ll_rs = LL_RESERVED_SPACE(skb->dev);
+	mtu = skb->dev->mtu;
+
+	if (skb_has_frag_list(skb)) {
+		unsigned int first_len = skb_pagelen(skb);
+		struct ip_fraglist_iter iter;
+		struct sk_buff *frag;
+
+		if (first_len - hlen > mtu ||
+		    skb_headroom(skb) < ll_rs)
+			goto blackhole;
+
+		if (skb_cloned(skb))
+			goto slow_path;
+
+		skb_walk_frags(skb, frag) {
+			if (frag->len > mtu ||
+			    skb_headroom(frag) < hlen + ll_rs)
+				goto blackhole;
+
+			if (skb_shared(frag))
+				goto slow_path;
+		}
+
+		ip_fraglist_init(skb, iph, hlen, &iter);
+
+		for (;;) {
+			if (iter.frag)
+				ip_fraglist_prepare(skb, &iter);
+
+			err = output(net, sk, data, skb);
+			if (err || !iter.frag)
+				break;
+
+			skb = ip_fraglist_next(&iter);
+		}
+		return err;
+	}
+slow_path:
+	/* This is a linearized skbuff, the original geometry is lost for us.
+	 * This may also be a clone skbuff, we could preserve the geometry for
+	 * the copies but probably not worth the effort.
+	 */
+	ip_frag_init(skb, hlen, ll_rs, frag_max_size, &state);
+
+	while (state.left > 0) {
+		struct sk_buff *skb2;
+
+		skb2 = ip_frag_next(skb, &state);
+		if (IS_ERR(skb2)) {
+			err = PTR_ERR(skb2);
+			goto blackhole;
+		}
+
+		err = output(net, sk, data, skb2);
+		if (err)
+			goto blackhole;
+	}
+	consume_skb(skb);
+	return err;
+
+blackhole:
+	kfree_skb(skb);
+	return 0;
+}
+
+/* ip_defrag() expects IPCB() in place. */
+static void br_skb_cb_save(struct sk_buff *skb, struct br_input_skb_cb *cb,
+			   size_t inet_skb_parm_size)
+{
+	memcpy(cb, skb->cb, sizeof(*cb));
+	memset(skb->cb, 0, inet_skb_parm_size);
+}
+
+static void br_skb_cb_restore(struct sk_buff *skb,
+			      const struct br_input_skb_cb *cb,
+			      u16 fragsz)
+{
+	memcpy(skb->cb, cb, sizeof(*cb));
+	BR_INPUT_SKB_CB(skb)->nf_frag_max_size = fragsz;
+}
+
+static int nf_ct_br_defrag4_check(const struct sk_buff *skb)
+{
+	const struct iphdr *iph;
+	int nhoff, len;
+
+	nhoff = skb_network_offset(skb);
+	iph = ip_hdr(skb);
+        if (iph->ihl < 5 ||
+	    iph->version != 4)
+		return -1;
+
+	len = ntohs(iph->tot_len);
+	if (skb->len < nhoff + len ||
+	    len < (iph->ihl * 4))
+		return -1;
+
+	return 0;
+}
+
+static unsigned int nf_ct_br_defrag4(struct sk_buff *skb,
+				     const struct nf_hook_state *state)
+{
+	u16 zone_id = NF_CT_DEFAULT_ZONE_ID;
+	enum ip_conntrack_info ctinfo;
+	struct br_input_skb_cb cb;
+	const struct nf_conn *ct;
+	int err;
+
+	if (!ip_is_fragment(ip_hdr(skb)))
+		return NF_ACCEPT;
+
+	if (nf_ct_br_defrag4_check(skb))
+		return NF_ACCEPT;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct)
+		zone_id = nf_ct_zone_id(nf_ct_zone(ct), CTINFO2DIR(ctinfo));
+
+	br_skb_cb_save(skb, &cb, sizeof(struct inet_skb_parm));
+	local_bh_disable();
+	err = ip_defrag(state->net, skb,
+			IP_DEFRAG_CONNTRACK_BRIDGE_IN + zone_id);
+	local_bh_enable();
+	if (!err) {
+		br_skb_cb_restore(skb, &cb, IPCB(skb)->frag_max_size);
+		skb->ignore_df = 1;
+		return NF_ACCEPT;
+	}
+
+	return NF_STOLEN;
+}
+
+static int nf_ct_br_defrag6_check(const struct sk_buff *skb)
+{
+	const struct ipv6hdr *hdr;
+	int nhoff, len;
+
+	nhoff = skb_network_offset(skb);
+	hdr = ipv6_hdr(skb);
+	if (hdr->version != 6)
+		return -1;
+
+	len = ntohs(hdr->payload_len) + sizeof(struct ipv6hdr) + nhoff;
+	if (skb->len < len)
+		return -1;
+
+	return 0;
+}
+
+static unsigned int nf_ct_br_defrag6(struct sk_buff *skb,
+				     const struct nf_hook_state *state)
+{
+	u16 zone_id = NF_CT_DEFAULT_ZONE_ID;
+	enum ip_conntrack_info ctinfo;
+	struct br_input_skb_cb cb;
+	const struct nf_conn *ct;
+	int err;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct)
+		zone_id = nf_ct_zone_id(nf_ct_zone(ct), CTINFO2DIR(ctinfo));
+
+	if (nf_ct_br_defrag6_check(skb))
+		return NF_ACCEPT;
+
+	br_skb_cb_save(skb, &cb, sizeof(struct inet6_skb_parm));
+
+	err = nf_ct_frag6_gather(state->net, skb,
+				 IP_DEFRAG_CONNTRACK_BRIDGE_IN + zone_id);
+	/* queued */
+	if (err == -EINPROGRESS)
+		return NF_STOLEN;
+
+	br_skb_cb_restore(skb, &cb, IP6CB(skb)->frag_max_size);
+	return err == 0 ? NF_ACCEPT : NF_DROP;
+}
+
+static unsigned int nf_ct_bridge_pre_ipv4(struct sk_buff *skb,
+					  const struct nf_hook_state *state)
+{
+	u32 len;
+
+	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		return NF_ACCEPT;
+
+	len = ntohs(ip_hdr(skb)->tot_len);
+	if (pskb_trim_rcsum(skb, len))
+		return NF_DROP;
+
+	return nf_ct_br_defrag4(skb, state);
+}
+
+static unsigned int nf_ct_bridge_pre_ipv6(struct sk_buff *skb,
+					  const struct nf_hook_state *state)
+{
+	u32 len;
+
+	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+		return NF_ACCEPT;
+
+	len = sizeof(struct ipv6hdr) + ntohs(ipv6_hdr(skb)->payload_len);
+	if (pskb_trim_rcsum(skb, len))
+		return NF_DROP;
+
+	return nf_ct_br_defrag6(skb, state);
+}
+
+static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
+				     const struct nf_hook_state *state)
+{
+	struct nf_hook_state bridge_state = *state;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+	int ret;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct && !nf_ct_is_template(ct))
+		return NF_ACCEPT;
+
+	BR_INPUT_SKB_CB(skb)->nf_frag_max_size = 0;
+
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		bridge_state.pf = NFPROTO_IPV4;
+		ret = nf_ct_bridge_pre_ipv4(skb, &bridge_state);
+		break;
+	case htons(ETH_P_IPV6):
+		bridge_state.pf = NFPROTO_IPV6;
+		ret = nf_ct_bridge_pre_ipv6(skb, &bridge_state);
+	default:
+		return NF_ACCEPT;
+	}
+
+	if (ret != NF_ACCEPT)
+		return ret;
+
+	ret = nf_conntrack_in(skb, &bridge_state);
+
+	return ret;
+}
+
+static void nf_ct_bridge_refrag_prepare(struct sk_buff *skb,
+					struct nf_ct_bridge_frag_data *data)
+{
+	data->vlan_tci = skb->vlan_tci;
+	data->vlan_proto = skb->vlan_proto;
+	skb_copy_from_linear_data_offset(skb, -ETH_HLEN, data->mac, ETH_HLEN);
+}
+
+static unsigned int
+nf_ct_bridge_refrag(struct sk_buff *skb, const struct nf_hook_state *state,
+		    int (*output)(struct net *, struct sock *sk,
+				  const struct nf_ct_bridge_frag_data *data,
+				  struct sk_buff *))
+{
+	struct nf_ct_bridge_frag_data data;
+
+	if (!BR_INPUT_SKB_CB(skb)->nf_frag_max_size)
+		return NF_ACCEPT;
+
+	nf_ct_bridge_refrag_prepare(skb, &data);
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		br_ip_fragment(state->net, state->sk, skb, &data, output);
+		break;
+	case htons(ETH_P_IPV6):
+		return NF_DROP;
+	default:
+		WARN_ON_ONCE(1);
+		return NF_DROP;
+	}
+
+	return NF_STOLEN;
+}
+
+/* Actually only slow path refragmentation needs this. */
+static int nf_ct_bridge_frag_prepare(struct sk_buff *skb,
+				     const struct nf_ct_bridge_frag_data *data)
+{
+	int err;
+
+	err = skb_cow_head(skb, ETH_HLEN);
+	if (err) {
+		kfree_skb(skb);
+		return -ENOMEM;
+	}
+	if (data->vlan_tci) {
+		skb->vlan_tci = skb->vlan_tci;
+		skb->vlan_proto = data->vlan_proto;
+	}
+	skb_copy_to_linear_data_offset(skb, -ETH_HLEN, data->mac, ETH_HLEN);
+	skb_reset_mac_header(skb);
+
+	return 0;
+}
+
+static int nf_ct_bridge_refrag_post(struct net *net, struct sock *sk,
+				    const struct nf_ct_bridge_frag_data *data,
+				    struct sk_buff *skb)
+{
+	int err;
+
+	err = nf_ct_bridge_frag_prepare(skb, data);
+	if (err < 0)
+		return err;
+
+	return br_dev_queue_push_xmit(net, sk, skb);
+}
+
+static unsigned int nf_ct_bridge_post(void *priv, struct sk_buff *skb,
+				      const struct nf_hook_state *state)
+{
+	int ret;
+
+	ret = nf_conntrack_confirm(skb);
+	if (ret != NF_ACCEPT)
+		return ret;
+
+	return nf_ct_bridge_refrag(skb, state, nf_ct_bridge_refrag_post);
+}
+
+static struct nf_hook_ops nf_ct_bridge_hook_ops[] __read_mostly = {
+	{
+		.hook		= nf_ct_bridge_pre,
+		.pf		= NFPROTO_BRIDGE,
+		.hooknum	= NF_INET_PRE_ROUTING,
+		.priority	= NF_IP_PRI_CONNTRACK,
+	},
+	{
+		.hook		= nf_ct_bridge_post,
+		.pf		= NFPROTO_BRIDGE,
+		.hooknum	= NF_INET_POST_ROUTING,
+		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
+	},
+};
+
+static int __init nf_conntrack_l3proto_bridge_init(void)
+{
+	return nf_register_net_hooks(&init_net, nf_ct_bridge_hook_ops,
+				     ARRAY_SIZE(nf_ct_bridge_hook_ops));
+}
+
+static void __exit nf_conntrack_l3proto_bridge_fini(void)
+{
+	nf_unregister_net_hooks(&init_net, nf_ct_bridge_hook_ops,
+				ARRAY_SIZE(nf_ct_bridge_hook_ops));
+}
+
+module_init(nf_conntrack_l3proto_bridge_init);
+module_exit(nf_conntrack_l3proto_bridge_fini);
+
+MODULE_ALIAS("nf_conntrack-" __stringify(AF_BRIDGE));
+MODULE_LICENSE("GPL");
-- 
2.11.0

