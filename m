From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 2/3] netfilter: nf_tables: extend tracing infrastructure
Date: Thu, 26 Nov 2015 18:59:38 +0100
Message-ID: <1448560779-28989-3-git-send-email-fw@strlen.de>
References: <1448560779-28989-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37512 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752442AbbKZR7t (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 12:59:49 -0500
In-Reply-To: <1448560779-28989-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft monitor mode can then decode and display this trace data.

Parts of LL/Network/Transport headers are provided as separate
attributes.

Otherwise, printing IP address data becomes virtually impossible
for userspace since in the case of the netdev family we really don't
want userspace to have to know all the possible link layer types
and/or sizes just to display/print an ip address.

We also don't want userspace to have to follow ipv6 header chains
to get the s/dport info, the kernel already did this work for us.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Changes since v1:
  - move trace into new file, nf_tables_trace.c (Pablo)
  - add new netlink group for trace messages (Pablo, Patrick)
  - make verdict nested attr (Patrick)
  - add percpu area to store current processed skb id
  (suggested by Patrick)
  - fold arguments to nft_trace_notify into a structure,
  nft_traceinfo.  This would allow easier extension later
  on, e.g. ptr to registers to e.g. log NFT_BREAK/mismatch
  as well.

 include/net/netfilter/nf_tables.h        |  17 +++
 include/uapi/linux/netfilter/nf_tables.h |  46 ++++++
 include/uapi/linux/netfilter/nfnetlink.h |   2 +
 net/netfilter/Makefile                   |   2 +-
 net/netfilter/nf_tables_api.c            |  12 +-
 net/netfilter/nf_tables_core.c           |  35 ++++-
 net/netfilter/nf_tables_trace.c          | 253 +++++++++++++++++++++++++++++++
 net/netfilter/nfnetlink.c                |   1 +
 net/netfilter/nft_meta.c                 |   4 +-
 9 files changed, 356 insertions(+), 16 deletions(-)
 create mode 100644 net/netfilter/nf_tables_trace.c

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 101d7d7..59331ba 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -888,6 +888,23 @@ void nft_unregister_chain_type(const struct nf_chain_type *);
 int nft_register_expr(struct nft_expr_type *);
 void nft_unregister_expr(struct nft_expr_type *);
 
+int nft_verdict_dump(struct sk_buff *skb,
+		     const struct nft_verdict *v, u16 type);
+
+struct nft_traceinfo {
+	const struct nft_chain *chain;
+	const struct nft_rule *rule;
+	const struct nft_verdict *verdict;
+	enum nft_trace_types type;
+
+	bool packet_dumped;
+};
+
+void nft_trace_notify(struct nft_traceinfo *info,
+		      const struct nft_pktinfo *pkt);
+
+void nft_trace_start(struct sk_buff *skb);
+
 #define nft_dereference(p)					\
 	nfnl_dereference(p, NFNL_SUBSYS_NFTABLES)
 
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 5f3ecec..d6abe1c 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -83,6 +83,7 @@ enum nft_verdicts {
  * @NFT_MSG_DELSETELEM: delete a set element (enum nft_set_elem_attributes)
  * @NFT_MSG_NEWGEN: announce a new generation, only for events (enum nft_gen_attributes)
  * @NFT_MSG_GETGEN: get the rule-set generation (enum nft_gen_attributes)
+ * @NFT_MSG_TRACE: trace event (enum nft_trace_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -102,6 +103,7 @@ enum nf_tables_msg_types {
 	NFT_MSG_DELSETELEM,
 	NFT_MSG_NEWGEN,
 	NFT_MSG_GETGEN,
+	NFT_MSG_TRACE,
 	NFT_MSG_MAX,
 };
 
@@ -987,4 +989,48 @@ enum nft_gen_attributes {
 };
 #define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
 
+/**
+ * enum nft_trace_attributes - nf_tables trace netlink attributes
+ *
+ * @NFTA_TRACE_TABLE: name of the table (NLA_STRING)
+ * @NFTA_TRACE_CHAIN: name of the chain (NLA_STRING)
+ * @NFTA_TRACE_RULE_HANDLE: numeric handle of the rule (NLA_U64)
+ * @NFTA_TRACE_TYPE: type of the event (NLA_U32: nft_trace_types)
+ * @NFTA_TRACE_VERDICT: verdict returned by hook (NLA_NESTED: nft_verdicts)
+ * @NFTA_TRACE_ID: pseudo-id, same for each skb traced (NLA_U32)
+ * @NFTA_TRACE_LL_HEADER: linklayer header (NLA_BINARY)
+ * @NFTA_TRACE_NETWORK_HEADER: network header (NLA_BINARY)
+ * @NFTA_TRACE_TRANSPORT_HEADER: transport header (NLA_BINARY)
+ * @NFTA_TRACE_IIFTYPE: netdev->type of indev (NLA_U16)
+ * @NFTA_TRACE_IIF: indev ifindex (NLA_U32)
+ * @NFTA_TRACE_OIF: outdev ifindex (NLA_U32)
+ * @NFTA_TRACE_MARK: nfmark (NLA_U32)
+ */
+enum nft_trace_attibutes {
+	NFTA_TRACE_UNSPEC,
+	NFTA_TRACE_TABLE,
+	NFTA_TRACE_CHAIN,
+	NFTA_TRACE_RULE_HANDLE,
+	NFTA_TRACE_TYPE,
+	NFTA_TRACE_VERDICT,
+	NFTA_TRACE_ID,
+	NFTA_TRACE_LL_HEADER,
+	NFTA_TRACE_NETWORK_HEADER,
+	NFTA_TRACE_TRANSPORT_HEADER,
+	NFTA_TRACE_IIFTYPE,
+	NFTA_TRACE_IIF,
+	NFTA_TRACE_OIF,
+	NFTA_TRACE_MARK,
+	__NFTA_TRACE_MAX
+};
+#define NFTA_TRACE_MAX (__NFTA_TRACE_MAX - 1)
+
+enum nft_trace_types {
+	NFT_TRACETYPE_UNSPEC,
+	NFT_TRACETYPE_POLICY,
+	NFT_TRACETYPE_RETURN,
+	NFT_TRACETYPE_RULE,
+	__NFT_TRACETYPE_MAX
+};
+#define NFT_TRACETYPE_MAX (__NFT_TRACETYPE_MAX - 1)
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/include/uapi/linux/netfilter/nfnetlink.h b/include/uapi/linux/netfilter/nfnetlink.h
index 354a7e5..4bb8cb7 100644
--- a/include/uapi/linux/netfilter/nfnetlink.h
+++ b/include/uapi/linux/netfilter/nfnetlink.h
@@ -22,6 +22,8 @@ enum nfnetlink_groups {
 #define NFNLGRP_NFTABLES                NFNLGRP_NFTABLES
 	NFNLGRP_ACCT_QUOTA,
 #define NFNLGRP_ACCT_QUOTA		NFNLGRP_ACCT_QUOTA
+	NFNLGRP_NFTRACE,
+#define NFNLGRP_NFTRACE			NFNLGRP_NFTRACE
 	__NFNLGRP_MAX,
 };
 #define NFNLGRP_MAX	(__NFNLGRP_MAX - 1)
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 7638c36..2293484 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -67,7 +67,7 @@ obj-$(CONFIG_NF_NAT_TFTP) += nf_nat_tftp.o
 obj-$(CONFIG_NETFILTER_SYNPROXY) += nf_synproxy_core.o
 
 # nf_tables
-nf_tables-objs += nf_tables_core.o nf_tables_api.o
+nf_tables-objs += nf_tables_core.o nf_tables_api.o nf_tables_trace.o
 nf_tables-objs += nft_immediate.o nft_cmp.o nft_lookup.o nft_dynset.o
 nf_tables-objs += nft_bitwise.o nft_byteorder.o nft_payload.o
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 93cc473..717373a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4446,22 +4446,22 @@ static void nft_verdict_uninit(const struct nft_data *data)
 	}
 }
 
-static int nft_verdict_dump(struct sk_buff *skb, const struct nft_data *data)
+int nft_verdict_dump(struct sk_buff *skb, const struct nft_verdict *v, u16 type)
 {
 	struct nlattr *nest;
 
-	nest = nla_nest_start(skb, NFTA_DATA_VERDICT);
+	nest = nla_nest_start(skb, type);
 	if (!nest)
 		goto nla_put_failure;
 
-	if (nla_put_be32(skb, NFTA_VERDICT_CODE, htonl(data->verdict.code)))
+	if (nla_put_be32(skb, NFTA_VERDICT_CODE, htonl(v->code)))
 		goto nla_put_failure;
 
-	switch (data->verdict.code) {
+	switch (v->code) {
 	case NFT_JUMP:
 	case NFT_GOTO:
 		if (nla_put_string(skb, NFTA_VERDICT_CHAIN,
-				   data->verdict.chain->name))
+				   v->chain->name))
 			goto nla_put_failure;
 	}
 	nla_nest_end(skb, nest);
@@ -4572,7 +4572,7 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
 		err = nft_value_dump(skb, data, len);
 		break;
 	case NFT_DATA_VERDICT:
-		err = nft_verdict_dump(skb, data);
+		err = nft_verdict_dump(skb, &data->verdict, NFTA_DATA_VERDICT);
 		break;
 	default:
 		err = -EINVAL;
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index f3695a4..e8ba9da 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -54,12 +54,23 @@ static void __nft_trace_packet(const struct nft_pktinfo *pkt,
 		     rulenum);
 }
 
-static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
+static inline void nft_trace_packet(struct nft_traceinfo *info,
+				    const struct nft_pktinfo *pkt,
 				    const struct nft_chain *chain,
-				    int rulenum, enum nft_trace type)
+				    const struct nft_rule *rule,
+				    const struct nft_verdict *verdict,
+				    int rulenum,
+				    enum nft_trace_types type)
 {
-	if (unlikely(pkt->skb->nf_trace))
+	if (unlikely(pkt->skb->nf_trace)) {
+		info->chain = chain;
+		info->rule = rule;
+		info->verdict = verdict;
+		info->type = type;
+		nft_trace_notify(info, pkt);
+
 		__nft_trace_packet(pkt, chain, rulenum, type);
+	}
 }
 
 static void nft_cmp_fast_eval(const struct nft_expr *expr,
@@ -121,7 +132,9 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	struct nft_stats *stats;
 	int rulenum;
 	unsigned int gencursor = nft_genmask_cur(net);
+	struct nft_traceinfo info;
 
+	info.packet_dumped = false;
 do_chain:
 	rulenum = 0;
 	rule = list_entry(&chain->rules, struct nft_rule, list);
@@ -151,7 +164,8 @@ next_rule:
 			regs.verdict.code = NFT_CONTINUE;
 			continue;
 		case NFT_CONTINUE:
-			nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
+			nft_trace_packet(&info, pkt, chain, rule, &regs.verdict,
+					 rulenum, NFT_TRACETYPE_RULE);
 			continue;
 		}
 		break;
@@ -161,7 +175,8 @@ next_rule:
 	case NF_ACCEPT:
 	case NF_DROP:
 	case NF_QUEUE:
-		nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
+		nft_trace_packet(&info, pkt, chain, rule, &regs.verdict,
+				 rulenum, NFT_TRACETYPE_RULE);
 		return regs.verdict.code;
 	}
 
@@ -174,7 +189,8 @@ next_rule:
 		stackptr++;
 		/* fall through */
 	case NFT_GOTO:
-		nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
+		nft_trace_packet(&info, pkt, chain, rule, &regs.verdict,
+				 rulenum, NFT_TRACETYPE_RULE);
 
 		chain = regs.verdict.chain;
 		goto do_chain;
@@ -182,7 +198,9 @@ next_rule:
 		rulenum++;
 		/* fall through */
 	case NFT_RETURN:
-		nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RETURN);
+		if (stackptr)
+			nft_trace_packet(&info, pkt, chain, rule, &regs.verdict,
+					 rulenum, NFT_TRACETYPE_RETURN);
 		break;
 	default:
 		WARN_ON(1);
@@ -196,7 +214,8 @@ next_rule:
 		goto next_rule;
 	}
 
-	nft_trace_packet(pkt, basechain, -1, NFT_TRACE_POLICY);
+	nft_trace_packet(&info, pkt, basechain, NULL, NULL, -1,
+			 NFT_TRACETYPE_POLICY);
 
 	rcu_read_lock_bh();
 	stats = this_cpu_ptr(rcu_dereference(nft_base_chain(basechain)->stats));
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
new file mode 100644
index 0000000..2f557b7
--- /dev/null
+++ b/net/netfilter/nf_tables_trace.c
@@ -0,0 +1,253 @@
+/*
+ * (C) 2015 Red Hat GmbH
+ * Author: Florian Westphal <fw@strlen.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/hash.h>
+#include <linux/if_vlan.h>
+#include <linux/init.h>
+#include <linux/skbuff.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
+#include <net/netfilter/nf_tables.h>
+
+#define NFT_TRACETYPE_LL_HSIZE		20
+#define NFT_TRACETYPE_NETWORK_HSIZE	40
+#define NFT_TRACETYPE_TRANSPORT_HSIZE	20
+
+#define NFT_ID_SKB_HASHBITS	12
+
+/* only used if tracing is on */
+static DEFINE_PER_CPU_READ_MOSTLY(u32, trace_seq);
+static atomic_t trace_cnt;
+
+static int trace_fill_id(struct sk_buff *nlskb, unsigned long skb_addr)
+{
+	u32 seq, id;
+
+	/* using hash_ptr(skb) causes immediate re-use of old ID when
+	 * skb moves to another cpu, this can happen e.g. with nfqueue.
+	 *
+	 * using skb address as ID results in a limited number of
+	 * values (and quick reuse).
+	 *
+	 * In order to also get a 'new' id in that case we use both.
+	 */
+	seq = __this_cpu_read(trace_seq);
+	id = seq + hash_long(skb_addr >> L1_CACHE_SHIFT, NFT_ID_SKB_HASHBITS);
+
+	return nla_put_be32(nlskb, NFTA_TRACE_ID, htonl(id));
+}
+
+static int trace_fill_header(struct sk_buff *nlskb, u16 type,
+			     const struct sk_buff *skb,
+			     int off, unsigned int len)
+{
+	struct nlattr *nla;
+
+	if (len == 0)
+		return 0;
+
+	if (skb_tailroom(nlskb) < nla_total_size(len))
+		return -1;
+
+	nla = (struct nlattr *)skb_put(nlskb, nla_total_size(len));
+	nla->nla_type = type;
+	nla->nla_len = nla_attr_size(len);
+
+	if (skb_copy_bits(skb, off, nla_data(nla), len))
+		return -1;
+
+	return 0;
+}
+
+static int nf_trace_fill_meta_info(struct sk_buff *nlskb,
+				   const struct nft_pktinfo *pkt)
+{
+	if (pkt->in) {
+		if (nla_put_be32(nlskb, NFTA_TRACE_IIF,
+				 htonl(pkt->in->ifindex)))
+			return -1;
+
+		/* needed for LL_HEADER decode */
+		if (nla_put_be16(nlskb, NFTA_TRACE_IIFTYPE,
+				 htons(pkt->in->type)))
+			return -1;
+	}
+
+	if (pkt->out &&
+	    nla_put_be32(nlskb, NFTA_TRACE_OIF, htonl(pkt->out->ifindex)))
+		return -1;
+
+	return 0;
+}
+
+static int nf_trace_fill_ll_header(struct sk_buff *nlskb,
+				   const struct sk_buff *skb)
+{
+	struct vlan_ethhdr veth;
+	unsigned int len, off;
+
+	off = skb_mac_header(skb) - skb->data;
+
+	if (skb_copy_bits(skb, off, &veth, ETH_HLEN))
+		return -1;
+
+	veth.h_vlan_proto = skb->vlan_proto;
+	veth.h_vlan_TCI = htons(skb_vlan_tag_get(skb));
+	veth.h_vlan_encapsulated_proto = skb->protocol;
+
+	len = min_t(unsigned int,
+		    skb->data - skb_mac_header(skb), NFT_TRACETYPE_LL_HSIZE);
+
+	if (WARN_ON_ONCE(len != ETH_HLEN))
+		return -1;
+
+	len = sizeof(veth);
+	if (skb_tailroom(nlskb) < nla_total_size(len))
+		return -1;
+
+	return nla_put(nlskb, NFTA_TRACE_LL_HEADER, len, &veth);
+}
+
+static int nf_trace_fill_pkt_info(struct sk_buff *nlskb,
+				  const struct nft_pktinfo *pkt)
+{
+	const struct sk_buff *skb = pkt->skb;
+	unsigned int len = min_t(unsigned int,
+				 pkt->xt.thoff - skb_network_offset(skb),
+				 NFT_TRACETYPE_NETWORK_HSIZE);
+	int off = skb_network_offset(skb);
+
+	if (trace_fill_header(nlskb, NFTA_TRACE_NETWORK_HEADER, skb, off, len))
+		return -1;
+
+	len = min_t(unsigned int, skb->len - pkt->xt.thoff,
+		    NFT_TRACETYPE_TRANSPORT_HSIZE);
+
+	if (trace_fill_header(nlskb, NFTA_TRACE_TRANSPORT_HEADER, skb,
+			      pkt->xt.thoff, len))
+		return -1;
+
+	if (!skb_mac_header_was_set(skb))
+		return 0;
+
+	if (skb_vlan_tag_get(skb))
+		return nf_trace_fill_ll_header(nlskb, skb);
+
+	len = min_t(unsigned int,
+		    skb->data - skb_mac_header(skb), NFT_TRACETYPE_LL_HSIZE);
+	off = skb_mac_header(skb) - skb->data;
+	return trace_fill_header(nlskb, NFTA_TRACE_LL_HEADER,
+				 skb, off, len);
+}
+
+static int nf_trace_fill_chain_info(struct sk_buff *nlskb,
+				    const struct nft_chain *chain)
+{
+	if (nla_put_string(nlskb, NFTA_TRACE_TABLE, chain->table->name))
+		return -1;
+
+	return nla_put_string(nlskb, NFTA_TRACE_CHAIN, chain->name);
+}
+
+void nft_trace_notify(struct nft_traceinfo *info,
+		      const struct nft_pktinfo *pkt)
+{
+	struct nfgenmsg *nfmsg;
+	struct nlmsghdr *nlh;
+	struct sk_buff *skb;
+	unsigned int size;
+	int event = (NFNL_SUBSYS_NFTABLES << 8) | NFT_MSG_TRACE;
+
+	if (!nfnetlink_has_listeners(pkt->net, NFNLGRP_NFTRACE))
+		return;
+
+	size = nlmsg_total_size(sizeof(struct nfgenmsg)) +
+		nla_total_size(NFT_TABLE_MAXNAMELEN) +
+		nla_total_size(NFT_CHAIN_MAXNAMELEN) +
+		nla_total_size(sizeof(__be64)) +	/* rule handle */
+		nla_total_size(sizeof(__be32)) +	/* trace type */
+		nla_total_size(0) +			/* VERDICT, nested */
+			nla_total_size(sizeof(u32)) +	/* verdict code */
+			nla_total_size(NFT_CHAIN_MAXNAMELEN) + /* jump target */
+		nla_total_size(sizeof(u32)) +		/* id */
+		nla_total_size(NFT_TRACETYPE_LL_HSIZE) +
+		nla_total_size(NFT_TRACETYPE_NETWORK_HSIZE) +
+		nla_total_size(NFT_TRACETYPE_TRANSPORT_HSIZE) +
+		nla_total_size(sizeof(u32)) +		/* mark */
+		nla_total_size(sizeof(u32)) +		/* iif */
+		nla_total_size(sizeof(u32)) +		/* oif */
+		nla_total_size(sizeof(__be16));		/* device type */
+
+	skb = nlmsg_new(size, GFP_ATOMIC);
+	if (!skb)
+		return;
+
+	nlh = nlmsg_put(skb, 0, 0, event, sizeof(struct nfgenmsg), 0);
+	if (!nlh)
+		goto nla_put_failure;
+
+	nfmsg = nlmsg_data(nlh);
+	nfmsg->nfgen_family	= pkt->pf;
+	nfmsg->version		= NFNETLINK_V0;
+	nfmsg->res_id		= 0;
+
+	if (nla_put_be32(skb, NFTA_TRACE_TYPE, htonl(info->type)))
+		goto nla_put_failure;
+
+	if (trace_fill_id(skb, (unsigned long)pkt->skb))
+		goto nla_put_failure;
+
+	if (info->chain &&
+	    nf_trace_fill_chain_info(skb, info->chain))
+		goto nla_put_failure;
+
+	if (info->rule &&
+	    nla_put_be64(skb, NFTA_TRACE_RULE_HANDLE,
+			 cpu_to_be64(info->rule->handle)))
+		goto nla_put_failure;
+
+	if ((info->type == NFT_TRACETYPE_RETURN ||
+	     info->type == NFT_TRACETYPE_RULE) &&
+	    nft_verdict_dump(skb, info->verdict, NFTA_TRACE_VERDICT))
+		goto nla_put_failure;
+
+	if (pkt->skb->mark &&
+	    nla_put_be32(skb, NFTA_TRACE_MARK, htonl(pkt->skb->mark)))
+		goto nla_put_failure;
+
+	if (!info->packet_dumped) {
+		if (nf_trace_fill_meta_info(skb, pkt))
+			goto nla_put_failure;
+
+		if (nf_trace_fill_pkt_info(skb, pkt))
+			goto nla_put_failure;
+		info->packet_dumped = true;
+	}
+
+	nlmsg_end(skb, nlh);
+	nfnetlink_send(skb, pkt->net, 0, NFNLGRP_NFTRACE, 0, GFP_ATOMIC);
+	return;
+
+ nla_put_failure:
+	WARN_ON_ONCE(1);
+	kfree_skb(skb);
+}
+
+void nft_trace_start(struct sk_buff *skb)
+{
+	u32 seq = atomic_inc_return(&trace_cnt) << NFT_ID_SKB_HASHBITS;
+
+	__this_cpu_write(trace_seq, seq);
+	skb->nf_trace = 1;
+}
+EXPORT_SYMBOL(nft_trace_start);
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 46453ab..28591fa 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -49,6 +49,7 @@ static const int nfnl_group2type[NFNLGRP_MAX+1] = {
 	[NFNLGRP_CONNTRACK_EXP_DESTROY] = NFNL_SUBSYS_CTNETLINK_EXP,
 	[NFNLGRP_NFTABLES]		= NFNL_SUBSYS_NFTABLES,
 	[NFNLGRP_ACCT_QUOTA]		= NFNL_SUBSYS_ACCT,
+	[NFNLGRP_NFTRACE]		= NFNL_SUBSYS_NFTABLES,
 };
 
 void nfnl_lock(__u8 subsys_id)
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 9dfaf4d..eaf41e4 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -204,7 +204,9 @@ void nft_meta_set_eval(const struct nft_expr *expr,
 		skb->priority = value;
 		break;
 	case NFT_META_NFTRACE:
-		skb->nf_trace = 1;
+		if (skb->nf_trace)
+			break;
+		nft_trace_start(pkt->skb);
 		break;
 	default:
 		WARN_ON(1);
-- 
2.4.10

