From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/6] netfilter: nf_tables: extend tracing infrastructure
Date: Tue, 24 Nov 2015 11:02:06 +0100
Message-ID: <1448359331-12692-2-git-send-email-fw@strlen.de>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58367 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752867AbbKXKCZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:02:25 -0500
In-Reply-To: <1448359331-12692-1-git-send-email-fw@strlen.de>
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
to get the s/dport info, the kernel already did this work so just
follow suit.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h        |   6 +
 include/uapi/linux/netfilter/nf_tables.h |  32 ++++++
 net/netfilter/nf_tables_api.c            | 190 +++++++++++++++++++++++++++++++
 net/netfilter/nf_tables_core.c           |  28 +++--
 net/netfilter/nft_meta.c                 |   3 +
 5 files changed, 252 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4bd7508..5131ad4 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -890,6 +890,12 @@ void nft_unregister_chain_type(const struct nf_chain_type *);
 int nft_register_expr(struct nft_expr_type *);
 void nft_unregister_expr(struct nft_expr_type *);
 
+void nf_tables_trace_notify(const struct nft_pktinfo *pkt,
+			    const struct nft_chain *chain,
+			    const struct nft_rule *rule,
+			    u32 verdict,
+			    enum nft_trace_types type);
+
 #define nft_dereference(p)					\
 	nfnl_dereference(p, NFNL_SUBSYS_NFTABLES)
 
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index d8c8a7c..88bcd00 100644
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
 
@@ -970,4 +972,34 @@ enum nft_gen_attributes {
 };
 #define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
 
+enum nft_trace_attibutes {
+	NFTA_TRACE_UNSPEC,
+	NFTA_TRACE_CHAIN,
+	NFTA_TRACE_DEV_TYPE,
+	NFTA_TRACE_ID,
+	NFTA_TRACE_IIF,
+	NFTA_TRACE_OIF,
+	NFTA_TRACE_LL_HEADER,
+	NFTA_TRACE_MARK,
+	NFTA_TRACE_NETWORK_HEADER,
+	NFTA_TRACE_TABLE,
+	NFTA_TRACE_TRANSPORT_HEADER,
+	NFTA_TRACE_TRANSPORT_PROTO,
+	NFTA_TRACE_TYPE,
+	NFTA_TRACE_RULE_HANDLE,
+	NFTA_TRACE_VERDICT,
+	NFTA_TRACE_VLAN_TAG,
+	__NFTA_TRACE_MAX
+};
+#define NFTA_TRACE_MAX (__NFTA_TRACE_MAX - 1)
+
+enum nft_trace_types {
+	NFT_TRACETYPE_UNSPEC,
+	NFT_TRACETYPE_PACKET,
+	NFT_TRACETYPE_POLICY,
+	NFT_TRACETYPE_RETURN,
+	NFT_TRACETYPE_RULE,
+	__NFT_TRACETYPE_MAX
+};
+#define NFT_TRACETYPE_MAX (__NFT_TRACETYPE_MAX - 1)
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 93cc473..25d8168 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9,6 +9,8 @@
  */
 
 #include <linux/module.h>
+#include <linux/hash.h>
+#include <linux/if_vlan.h>
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/skbuff.h>
@@ -21,6 +23,10 @@
 #include <net/net_namespace.h>
 #include <net/sock.h>
 
+#define NFT_TRACETYPE_LL_HSIZE		20
+#define NFT_TRACETYPE_NETWORK_HSIZE	32
+#define NFT_TRACETYPE_TRANSPORT_HSIZE	 4
+
 static LIST_HEAD(nf_tables_expressions);
 
 /**
@@ -468,6 +474,84 @@ nla_put_failure:
 	return -1;
 }
 
+static bool trace_notify_put_data(struct sk_buff *nlskb, u16 type,
+				  const struct sk_buff *skb,
+				  int off, unsigned int plen)
+{
+	struct nlattr *nla;
+
+	if (skb_tailroom(nlskb) < nla_total_size(plen))
+		return false;
+
+	nla = (struct nlattr *)skb_put(nlskb, nla_total_size(plen));
+	nla->nla_type = type;
+	nla->nla_len = nla_attr_size(plen);
+
+	if (skb_copy_bits(skb, off, nla_data(nla), plen))
+		return false;
+
+	return true;
+}
+
+static bool
+trace_notify_put_packet(struct sk_buff *nlskb, const struct nft_pktinfo *pkt)
+{
+	const struct sk_buff *skb = pkt->skb;
+	unsigned int plen = min_t(unsigned int,
+				  pkt->xt.thoff - skb_network_offset(skb),
+				  NFT_TRACETYPE_NETWORK_HSIZE);
+	int mac_off;
+
+	if (plen >= 20u && /* minimum iphdr size */
+	    !trace_notify_put_data(nlskb, NFTA_TRACE_NETWORK_HEADER,
+				   skb, skb_network_offset(skb), plen))
+		return false;
+
+	if (nla_put_u8(nlskb, NFTA_TRACE_TRANSPORT_PROTO, pkt->tprot))
+		return false;
+
+	plen = min_t(unsigned int, skb->len - pkt->xt.thoff,
+		     NFT_TRACETYPE_TRANSPORT_HSIZE);
+
+	if (plen >= sizeof(u32) &&
+	    !trace_notify_put_data(nlskb, NFTA_TRACE_TRANSPORT_HEADER,
+				   skb, pkt->xt.thoff, plen))
+		return false;
+
+	switch (pkt->pf) {
+	case NFPROTO_ARP: /* fallthrough */
+	case NFPROTO_BRIDGE:
+		break;
+	case NFPROTO_NETDEV:
+		if (WARN_ON_ONCE(!skb->dev))
+			break;
+		if (nla_put_be16(nlskb, NFTA_TRACE_DEV_TYPE,
+				 htons(skb->dev->type)))
+			return false;
+		break;
+	default:
+		return true;
+	}
+
+	if (skb_vlan_tag_get(skb) &&
+	    !nla_put_be16(nlskb, NFTA_TRACE_VLAN_TAG,
+			  htons(skb_vlan_tag_get(skb))))
+		return false;
+
+	if (!skb_mac_header_was_set(skb))
+		return true;
+
+	plen = min_t(unsigned int,
+		     skb->data - skb_mac_header(skb), NFT_TRACETYPE_LL_HSIZE);
+	mac_off = skb_mac_header(skb) - skb->data;
+
+	if (plen && !trace_notify_put_data(nlskb, NFTA_TRACE_LL_HEADER,
+					   skb, mac_off, plen))
+		return false;
+
+	return true;
+}
+
 static int nf_tables_table_notify(const struct nft_ctx *ctx, int event)
 {
 	struct sk_buff *skb;
@@ -499,6 +583,112 @@ err:
 	return err;
 }
 
+void nf_tables_trace_notify(const struct nft_pktinfo *pkt,
+			    const struct nft_chain *chain,
+			    const struct nft_rule *rule,
+			    u32 verdict,
+			    enum nft_trace_types type)
+{
+	struct nfgenmsg *nfmsg;
+	struct nlmsghdr *nlh;
+	struct sk_buff *skb;
+	unsigned int size;
+	int event = (NFNL_SUBSYS_NFTABLES << 8) | NFT_MSG_TRACE;
+
+	if (!nfnetlink_has_listeners(pkt->net, NFNLGRP_NFTABLES))
+		return;
+
+	/* Unlike other notifiers we need GFP_ATOMIC so use actual size
+	 * needed instead of NLMSG_GOODSIZE.
+	 */
+	size = nlmsg_total_size(sizeof(struct nfgenmsg))
+		+ nla_total_size(sizeof(__be32))	/* trace type */
+		+ nla_total_size(NFT_TABLE_MAXNAMELEN)
+		+ nla_total_size(NFT_CHAIN_MAXNAMELEN)
+		+ nla_total_size(sizeof(u32))	/* iif */
+		+ nla_total_size(sizeof(u32))	/* oif */
+		+ nla_total_size(sizeof(u32))	/* id */
+		+ nla_total_size(sizeof(u32))	/* mark */
+		+ nla_total_size(sizeof(u32))	/* verdict */
+		+ nla_total_size(sizeof(__be64)); /* rule handle */
+
+	switch (type) {
+	case NFT_TRACETYPE_PACKET:
+		size += nla_total_size(NFT_TRACETYPE_NETWORK_HSIZE)
+			+ nla_total_size(NFT_TRACETYPE_TRANSPORT_HSIZE)
+			+ nla_total_size(NFT_TRACETYPE_LL_HSIZE)
+			+ nla_total_size(sizeof(__be16)) /* vlan tag */
+			+ nla_total_size(sizeof(__be16)) /* device type */
+			+ nla_total_size(sizeof(__u8));  /* transport prot */
+		break;
+	default:
+		break;
+	}
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
+	nfmsg->res_id		= htons(pkt->net->nft.base_seq & 0xffff);
+
+	if (nla_put_be32(skb, NFTA_TRACE_TYPE, htonl(type)))
+		goto nla_put_failure;
+
+	if (nla_put_be32(skb, NFTA_TRACE_ID, htonl(hash32_ptr(pkt->skb))))
+		goto nla_put_failure;
+
+	if (chain) {
+		if (nla_put_string(skb, NFTA_TRACE_TABLE, chain->table->name))
+			goto nla_put_failure;
+		if (nla_put_string(skb, NFTA_TRACE_CHAIN, chain->name))
+			goto nla_put_failure;
+	}
+
+	if (rule && nla_put_be64(skb, NFTA_TRACE_RULE_HANDLE,
+				 cpu_to_be64(rule->handle)))
+		goto nla_put_failure;
+
+	if (pkt->in &&
+	    nla_put_be32(skb, NFTA_TRACE_IIF, htonl(pkt->in->ifindex)))
+		goto nla_put_failure;
+	if (pkt->out &&
+	    nla_put_be32(skb, NFTA_TRACE_OIF, htonl(pkt->out->ifindex)))
+		goto nla_put_failure;
+	if (pkt->skb->mark &&
+	    nla_put_be32(skb, NFTA_TRACE_MARK, htonl(pkt->skb->mark)))
+		goto nla_put_failure;
+
+	switch (type) {
+	case NFT_TRACETYPE_POLICY:
+	case NFT_TRACETYPE_RETURN:
+	case NFT_TRACETYPE_RULE:
+		if (nla_put_be32(skb, NFTA_TRACE_VERDICT, htonl(verdict)))
+			goto nla_put_failure;
+		break;
+	case NFT_TRACETYPE_PACKET:
+		if (!trace_notify_put_packet(skb, pkt))
+			goto nla_put_failure;
+		break;
+	default:
+		break;
+	}
+
+	nlmsg_end(skb, nlh);
+	nfnetlink_send(skb, pkt->net, 0, NFNLGRP_NFTABLES, 0, GFP_ATOMIC);
+	return;
+
+ nla_put_failure:
+	WARN_ON_ONCE(1);
+	kfree_skb(skb);
+}
+
 static int nf_tables_dump_tables(struct sk_buff *skb,
 				 struct netlink_callback *cb)
 {
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index f3695a4..29a6ca9 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -56,10 +56,15 @@ static void __nft_trace_packet(const struct nft_pktinfo *pkt,
 
 static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
 				    const struct nft_chain *chain,
-				    int rulenum, enum nft_trace type)
+				    const struct nft_rule *rule,
+				    int rulenum,
+				    u32 verdict,
+				    enum nft_trace_types type)
 {
-	if (unlikely(pkt->skb->nf_trace))
+	if (unlikely(pkt->skb->nf_trace)) {
+		nf_tables_trace_notify(pkt, chain, rule, verdict, type);
 		__nft_trace_packet(pkt, chain, rulenum, type);
+	}
 }
 
 static void nft_cmp_fast_eval(const struct nft_expr *expr,
@@ -151,7 +156,8 @@ next_rule:
 			regs.verdict.code = NFT_CONTINUE;
 			continue;
 		case NFT_CONTINUE:
-			nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
+			nft_trace_packet(pkt, chain, rule, rulenum,
+					 regs.verdict.code, NFT_TRACETYPE_RULE);
 			continue;
 		}
 		break;
@@ -161,7 +167,9 @@ next_rule:
 	case NF_ACCEPT:
 	case NF_DROP:
 	case NF_QUEUE:
-		nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
+		nft_trace_packet(pkt, chain, rule, rulenum,
+				 regs.verdict.code & NF_VERDICT_MASK,
+				 NFT_TRACETYPE_RULE);
 		return regs.verdict.code;
 	}
 
@@ -174,7 +182,8 @@ next_rule:
 		stackptr++;
 		/* fall through */
 	case NFT_GOTO:
-		nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
+		nft_trace_packet(pkt, chain, rule, rulenum,
+				 regs.verdict.code, NFT_TRACETYPE_RULE);
 
 		chain = regs.verdict.chain;
 		goto do_chain;
@@ -182,7 +191,10 @@ next_rule:
 		rulenum++;
 		/* fall through */
 	case NFT_RETURN:
-		nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RETURN);
+		if (stackptr)
+			nft_trace_packet(pkt, chain, rule, rulenum,
+					 regs.verdict.code,
+					 NFT_TRACETYPE_RETURN);
 		break;
 	default:
 		WARN_ON(1);
@@ -196,7 +208,9 @@ next_rule:
 		goto next_rule;
 	}
 
-	nft_trace_packet(pkt, basechain, -1, NFT_TRACE_POLICY);
+	nft_trace_packet(pkt, basechain, NULL, -1,
+			 nft_base_chain(basechain)->policy,
+			 NFT_TRACETYPE_POLICY);
 
 	rcu_read_lock_bh();
 	stats = this_cpu_ptr(rcu_dereference(nft_base_chain(basechain)->stats));
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 9dfaf4d..e94526a 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -204,6 +204,9 @@ void nft_meta_set_eval(const struct nft_expr *expr,
 		skb->priority = value;
 		break;
 	case NFT_META_NFTRACE:
+		if (skb->nf_trace == 0)
+			nf_tables_trace_notify(pkt, NULL, NULL, 0,
+					       NFT_TRACETYPE_PACKET);
 		skb->nf_trace = 1;
 		break;
 	default:
-- 
2.4.10

