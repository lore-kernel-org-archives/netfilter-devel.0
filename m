Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC94C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jun 2022 14:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358511AbiFVOoP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jun 2022 10:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359007AbiFVOoJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jun 2022 10:44:09 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E2512ACB
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2022 07:44:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1o41aM-0004fY-F7; Wed, 22 Jun 2022 16:44:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nf_tables: avoid skb access on nf_stolen
Date:   Wed, 22 Jun 2022 16:43:57 +0200
Message-Id: <20220622144357.20162-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When verdict is NF_STOLEN, the skb might have been freed.

When tracing is enabled, this can result in a use-after-free:
1. access to skb->nf_trace
2. access to skb->mark
3. computation of trace id
4. dump of packet payload

To avoid 1, keep a cached copy of skb->nf_trace in the
trace state struct.
Refresh this copy whenever verdict is != STOLEN.

Avoid 2 by skipping skb->mark access if verdict is STOLEN.

3 is avoided by precomputing the trace id.

Only dump the packet when verdict is not "STOLEN".

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h | 16 ++++++-----
 net/netfilter/nf_tables_core.c    | 24 ++++++++++++++---
 net/netfilter/nf_tables_trace.c   | 44 +++++++++++++++++--------------
 3 files changed, 55 insertions(+), 29 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 279ae0fff7ad..5c4e5a96a984 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1338,24 +1338,28 @@ void nft_unregister_flowtable_type(struct nf_flowtable_type *type);
 /**
  *	struct nft_traceinfo - nft tracing information and state
  *
+ *	@trace: other struct members are initialised
+ *	@nf_trace: copy of skb->nf_trace before rule evaluation
+ *	@type: event type (enum nft_trace_types)
+ *	@skbid: hash of skb to be used as trace id
+ *	@packet_dumped: packet headers sent in a previous traceinfo message
  *	@pkt: pktinfo currently processed
  *	@basechain: base chain currently processed
  *	@chain: chain currently processed
  *	@rule:  rule that was evaluated
  *	@verdict: verdict given by rule
- *	@type: event type (enum nft_trace_types)
- *	@packet_dumped: packet headers sent in a previous traceinfo message
- *	@trace: other struct members are initialised
  */
 struct nft_traceinfo {
+	bool				trace;
+	bool				nf_trace;
+	bool				packet_dumped;
+	enum nft_trace_types		type:8;
+	u32				skbid;
 	const struct nft_pktinfo	*pkt;
 	const struct nft_base_chain	*basechain;
 	const struct nft_chain		*chain;
 	const struct nft_rule_dp	*rule;
 	const struct nft_verdict	*verdict;
-	enum nft_trace_types		type;
-	bool				packet_dumped;
-	bool				trace;
 };
 
 void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 53f40e473855..3ddce24ac76d 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -25,9 +25,7 @@ static noinline void __nft_trace_packet(struct nft_traceinfo *info,
 					const struct nft_chain *chain,
 					enum nft_trace_types type)
 {
-	const struct nft_pktinfo *pkt = info->pkt;
-
-	if (!info->trace || !pkt->skb->nf_trace)
+	if (!info->trace || !info->nf_trace)
 		return;
 
 	info->chain = chain;
@@ -42,11 +40,24 @@ static inline void nft_trace_packet(struct nft_traceinfo *info,
 				    enum nft_trace_types type)
 {
 	if (static_branch_unlikely(&nft_trace_enabled)) {
+		const struct nft_pktinfo *pkt = info->pkt;
+
+		info->nf_trace = pkt->skb->nf_trace;
 		info->rule = rule;
 		__nft_trace_packet(info, chain, type);
 	}
 }
 
+static inline void nft_trace_copy_nftrace(struct nft_traceinfo *info)
+{
+	if (static_branch_unlikely(&nft_trace_enabled)) {
+		const struct nft_pktinfo *pkt = info->pkt;
+
+		if (info->trace)
+			info->nf_trace = pkt->skb->nf_trace;
+	}
+}
+
 static void nft_bitwise_fast_eval(const struct nft_expr *expr,
 				  struct nft_regs *regs)
 {
@@ -85,6 +96,7 @@ static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
 					 const struct nft_chain *chain,
 					 const struct nft_regs *regs)
 {
+	const struct nft_pktinfo *pkt = info->pkt;
 	enum nft_trace_types type;
 
 	switch (regs->verdict.code) {
@@ -92,8 +104,13 @@ static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
 	case NFT_RETURN:
 		type = NFT_TRACETYPE_RETURN;
 		break;
+	case NF_STOLEN:
+		type = NFT_TRACETYPE_RULE;
+		/* can't access skb->nf_trace; use copy */
+		break;
 	default:
 		type = NFT_TRACETYPE_RULE;
+		info->nf_trace = pkt->skb->nf_trace;
 		break;
 	}
 
@@ -254,6 +271,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		switch (regs.verdict.code) {
 		case NFT_BREAK:
 			regs.verdict.code = NFT_CONTINUE;
+			nft_trace_copy_nftrace(&info);
 			continue;
 		case NFT_CONTINUE:
 			nft_trace_packet(&info, chain, rule,
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index 5041725423c2..1163ba9c1401 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -7,7 +7,7 @@
 #include <linux/module.h>
 #include <linux/static_key.h>
 #include <linux/hash.h>
-#include <linux/jhash.h>
+#include <linux/siphash.h>
 #include <linux/if_vlan.h>
 #include <linux/init.h>
 #include <linux/skbuff.h>
@@ -25,22 +25,6 @@
 DEFINE_STATIC_KEY_FALSE(nft_trace_enabled);
 EXPORT_SYMBOL_GPL(nft_trace_enabled);
 
-static int trace_fill_id(struct sk_buff *nlskb, struct sk_buff *skb)
-{
-	__be32 id;
-
-	/* using skb address as ID results in a limited number of
-	 * values (and quick reuse).
-	 *
-	 * So we attempt to use as many skb members that will not
-	 * change while skb is with netfilter.
-	 */
-	id = (__be32)jhash_2words(hash32_ptr(skb), skb_get_hash(skb),
-				  skb->skb_iif);
-
-	return nla_put_be32(nlskb, NFTA_TRACE_ID, id);
-}
-
 static int trace_fill_header(struct sk_buff *nlskb, u16 type,
 			     const struct sk_buff *skb,
 			     int off, unsigned int len)
@@ -186,6 +170,7 @@ void nft_trace_notify(struct nft_traceinfo *info)
 	struct nlmsghdr *nlh;
 	struct sk_buff *skb;
 	unsigned int size;
+	u32 mark = 0;
 	u16 event;
 
 	if (!nfnetlink_has_listeners(nft_net(pkt), NFNLGRP_NFTRACE))
@@ -229,7 +214,7 @@ void nft_trace_notify(struct nft_traceinfo *info)
 	if (nla_put_be32(skb, NFTA_TRACE_TYPE, htonl(info->type)))
 		goto nla_put_failure;
 
-	if (trace_fill_id(skb, pkt->skb))
+	if (nla_put_u32(skb, NFTA_TRACE_ID, info->skbid))
 		goto nla_put_failure;
 
 	if (nla_put_string(skb, NFTA_TRACE_CHAIN, info->chain->name))
@@ -249,16 +234,24 @@ void nft_trace_notify(struct nft_traceinfo *info)
 	case NFT_TRACETYPE_RULE:
 		if (nft_verdict_dump(skb, NFTA_TRACE_VERDICT, info->verdict))
 			goto nla_put_failure;
+
+		/* pkt->skb undefined iff NF_STOLEN, disable dump */
+		if (info->verdict->code == NF_STOLEN)
+			info->packet_dumped = true;
+		else
+			mark = pkt->skb->mark;
+
 		break;
 	case NFT_TRACETYPE_POLICY:
+		mark = pkt->skb->mark;
+
 		if (nla_put_be32(skb, NFTA_TRACE_POLICY,
 				 htonl(info->basechain->policy)))
 			goto nla_put_failure;
 		break;
 	}
 
-	if (pkt->skb->mark &&
-	    nla_put_be32(skb, NFTA_TRACE_MARK, htonl(pkt->skb->mark)))
+	if (mark && nla_put_be32(skb, NFTA_TRACE_MARK, htonl(mark)))
 		goto nla_put_failure;
 
 	if (!info->packet_dumped) {
@@ -283,9 +276,20 @@ void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
 		    const struct nft_verdict *verdict,
 		    const struct nft_chain *chain)
 {
+	static siphash_key_t trace_key __read_mostly;
+	struct sk_buff *skb = pkt->skb;
+
 	info->basechain = nft_base_chain(chain);
 	info->trace = true;
+	info->nf_trace = pkt->skb->nf_trace;
 	info->packet_dumped = false;
 	info->pkt = pkt;
 	info->verdict = verdict;
+
+	net_get_random_once(&trace_key, sizeof(trace_key));
+
+	info->skbid = (u32)siphash_3u32(hash32_ptr(skb),
+					skb_get_hash(skb),
+					skb->skb_iif,
+					&trace_key);
 }
-- 
2.35.1

