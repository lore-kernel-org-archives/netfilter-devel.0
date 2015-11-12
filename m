From: Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC] netfilter: nf_tables: extend tracing infrastructure
Date: Thu, 12 Nov 2015 16:46:49 +0100
Message-ID: <1447343209-28029-1-git-send-email-fw@strlen.de>
References: <20151109133608.GD8098@macbook.localdomain>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33725 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932070AbbKLPrE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Nov 2015 10:47:04 -0500
In-Reply-To: <20151109133608.GD8098@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

RFC for the kernel-side of the tracing changes.

Caveats+Questions are:
 - should kernel dump entire rule instead of just the handle?
 PRO of dumping entire rule matched:
  * Userspace doesn't need to dump rules first to display
  the rule that matched
  * nft trace doesn't need to also monitor ruleset for changes
  * would make it possible to use a new nfnetlink group as Pablo
  suggested

 CON:
  * needs more memory in kernel space (can't use NLMSG_GOODSIZE -
    allocation uses GFP_ATOMIC)

 This patch only dumps the rule handle.

 As you can see, I reimplemented parts of nfqueue/nfnetlink_log attributes.
 Problem is that I don't want to add dependencies on nfetlink_log for this,
 but things like iif and oif are rather imporant, esp. when debugging
 packets being forwarded.

 The first 128 bytes of the packet data is also dumped to userspace, currently
 limited to when we do the initial 'skb->nf_trace=1' assignment in nft_meta.c

 Patrick, I saw your idea wrt. dumping register contents instead, but it
 seems both complex and 'backwards' to me -- isn't the 'meta set nftrace'
 rule already a selector, i.e. user would say something like

 'tcp port 22 limit rate 1/second meta nftrace set 1'

 So I'm not sure its right to extend nftrace with additional selectors (its
 also possible that I failed to understand what you were suggesting 8-} )

The userspace side currently lives in libnftnl, with new api functions:

struct nftnl_trace *nftnl_trace_alloc(void);
void nftnl_trace_free(struct nftnl_trace *trace);
bool nftnl_trace_is_set(const struct nftnl_trace *trace, uint16_t type);

const void *nftnl_trace_get_data(const struct nftnl_trace *trace, uint16_t type, uint32_t *data_len);
uint32_t nftnl_trace_get_u32(const struct nftnl_trace *trace, uint16_t type);
uint64_t nftnl_trace_get_u64(const struct nftnl_trace *trace, uint16_t type);
const char *nftnl_trace_get_str(const struct nftnl_trace *trace, uint16_t type);

int nftnl_trace_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_trace *t);
int nftnl_trace_snprintf(char *buf, size_t size, const struct nftnl_trace *t, uint32_t type);
int nftnl_trace_fprintf(FILE *fh, const struct nftnl_trace *t, uint32_t type);


The nftnl_trace struct is readonly (thus no setters).
I'd then extend nft to use those helpers.

Cheers,
Florian
--
 include/net/netfilter/nf_tables.h        |   6 ++
 include/uapi/linux/netfilter/nf_tables.h |  27 ++++++++
 net/netfilter/nf_tables_api.c            | 114 +++++++++++++++++++++++++++++++
 net/netfilter/nf_tables_core.c           |  63 +++++------------
 net/netfilter/nft_meta.c                 |   3 +
 5 files changed, 166 insertions(+), 47 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index c9149cc..a92be10 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -878,6 +878,12 @@ void nft_unregister_chain_type(const struct nf_chain_type *);
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
index d8c8a7c..c7584dc 100644
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
 
@@ -970,4 +972,29 @@ enum nft_gen_attributes {
 };
 #define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
 
+enum nft_trace_attibutes {
+	NFTA_TRACE_UNSPEC,
+	NFTA_TRACE_CHAIN,
+	NFTA_TRACE_ID,
+	NFTA_TRACE_IIF,
+	NFTA_TRACE_OIF,
+	NFTA_TRACE_MARK,
+	NFTA_TRACE_PAYLOAD,
+	NFTA_TRACE_TABLE,
+	NFTA_TRACE_TYPE,
+	NFTA_TRACE_RULE_HANDLE,
+	NFTA_TRACE_VERDICT,
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
index 93cc473..65a6635 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/hash.h>
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/skbuff.h>
@@ -499,6 +500,119 @@ err:
 	return err;
 }
 
+void nf_tables_trace_notify(const struct nft_pktinfo *pkt,
+			    const struct nft_chain *chain,
+			    const struct nft_rule *rule,
+			    u32 verdict,
+			    enum nft_trace_types type)
+{
+	static const unsigned int hdrlen = 128;
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
+		size += nla_total_size(hdrlen);
+		break;
+	default:
+		break;
+	}
+
+	skb = nlmsg_new(size, GFP_ATOMIC);
+	if (skb == NULL)
+		return;
+
+	nlh = nlmsg_put(skb, 0, 0, event, sizeof(struct nfgenmsg), 0);
+	if (nlh == NULL)
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
+	if (nla_put_be32(skb, NFTA_TRACE_ID, htonl(hash_ptr(skb, 32))))
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
+	case NFT_TRACETYPE_PACKET: {
+		unsigned int plen = min(hdrlen, pkt->skb->len);
+		struct nlattr *nla;
+
+		if (skb_tailroom(skb) < nla_total_size(plen))
+			goto nla_put_failure;
+
+		nla = (struct nlattr *)skb_put(skb, nla_total_size(plen));
+		nla->nla_type = NFTA_TRACE_PAYLOAD;
+		nla->nla_len = nla_attr_size(plen);
+
+		if (skb_copy_bits(pkt->skb, 0, nla_data(nla), plen))
+			goto nla_put_failure;
+		}
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
index f3695a4..731909d 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -22,44 +22,14 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_log.h>
 
-enum nft_trace {
-	NFT_TRACE_RULE,
-	NFT_TRACE_RETURN,
-	NFT_TRACE_POLICY,
-};
-
-static const char *const comments[] = {
-	[NFT_TRACE_RULE]	= "rule",
-	[NFT_TRACE_RETURN]	= "return",
-	[NFT_TRACE_POLICY]	= "policy",
-};
-
-static struct nf_loginfo trace_loginfo = {
-	.type = NF_LOG_TYPE_LOG,
-	.u = {
-		.log = {
-			.level = LOGLEVEL_WARNING,
-			.logflags = NF_LOG_MASK,
-	        },
-	},
-};
-
-static void __nft_trace_packet(const struct nft_pktinfo *pkt,
-			       const struct nft_chain *chain,
-			       int rulenum, enum nft_trace type)
-{
-	nf_log_trace(pkt->net, pkt->pf, pkt->hook, pkt->skb, pkt->in,
-		     pkt->out, &trace_loginfo, "TRACE: %s:%s:%s:%u ",
-		     chain->table->name, chain->name, comments[type],
-		     rulenum);
-}
-
 static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
 				    const struct nft_chain *chain,
-				    int rulenum, enum nft_trace type)
+				    const struct nft_rule *rule,
+				    u32 verdict,
+				    enum nft_trace_types type)
 {
 	if (unlikely(pkt->skb->nf_trace))
-		__nft_trace_packet(pkt, chain, rulenum, type);
+		nf_tables_trace_notify(pkt, chain, rule, verdict, type);
 }
 
 static void nft_cmp_fast_eval(const struct nft_expr *expr,
@@ -105,7 +75,6 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 struct nft_jumpstack {
 	const struct nft_chain	*chain;
 	const struct nft_rule	*rule;
-	int			rulenum;
 };
 
 unsigned int
@@ -119,11 +88,9 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	unsigned int stackptr = 0;
 	struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
 	struct nft_stats *stats;
-	int rulenum;
 	unsigned int gencursor = nft_genmask_cur(net);
 
 do_chain:
-	rulenum = 0;
 	rule = list_entry(&chain->rules, struct nft_rule, list);
 next_rule:
 	regs.verdict.code = NFT_CONTINUE;
@@ -133,8 +100,6 @@ next_rule:
 		if (unlikely(rule->genmask & (1 << gencursor)))
 			continue;
 
-		rulenum++;
-
 		nft_rule_for_each_expr(expr, last, rule) {
 			if (expr->ops == &nft_cmp_fast_ops)
 				nft_cmp_fast_eval(expr, &regs);
@@ -151,7 +116,8 @@ next_rule:
 			regs.verdict.code = NFT_CONTINUE;
 			continue;
 		case NFT_CONTINUE:
-			nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
+			nft_trace_packet(pkt, chain, rule,
+					 regs.verdict.code, NFT_TRACETYPE_RULE);
 			continue;
 		}
 		break;
@@ -161,7 +127,9 @@ next_rule:
 	case NF_ACCEPT:
 	case NF_DROP:
 	case NF_QUEUE:
-		nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
+		nft_trace_packet(pkt, chain, rule,
+				 regs.verdict.code & NF_VERDICT_MASK,
+				 NFT_TRACETYPE_RULE);
 		return regs.verdict.code;
 	}
 
@@ -170,19 +138,20 @@ next_rule:
 		BUG_ON(stackptr >= NFT_JUMP_STACK_SIZE);
 		jumpstack[stackptr].chain = chain;
 		jumpstack[stackptr].rule  = rule;
-		jumpstack[stackptr].rulenum = rulenum;
 		stackptr++;
 		/* fall through */
 	case NFT_GOTO:
-		nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
+		nft_trace_packet(pkt, chain, rule,
+				 regs.verdict.code, NFT_TRACETYPE_RULE);
 
 		chain = regs.verdict.chain;
 		goto do_chain;
 	case NFT_CONTINUE:
-		rulenum++;
 		/* fall through */
 	case NFT_RETURN:
-		nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RETURN);
+		if (stackptr)
+			nft_trace_packet(pkt, chain, rule,
+					 regs.verdict.code, NFT_TRACETYPE_RETURN);
 		break;
 	default:
 		WARN_ON(1);
@@ -192,11 +161,11 @@ next_rule:
 		stackptr--;
 		chain = jumpstack[stackptr].chain;
 		rule  = jumpstack[stackptr].rule;
-		rulenum = jumpstack[stackptr].rulenum;
 		goto next_rule;
 	}
 
-	nft_trace_packet(pkt, basechain, -1, NFT_TRACE_POLICY);
+	nft_trace_packet(pkt, basechain, NULL,
+			 nft_base_chain(basechain)->policy, NFT_TRACETYPE_POLICY);
 
 	rcu_read_lock_bh();
 	stats = this_cpu_ptr(rcu_dereference(nft_base_chain(basechain)->stats));
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index e4ad2c2..857a652 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -200,6 +200,9 @@ void nft_meta_set_eval(const struct nft_expr *expr,
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

