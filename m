Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72CE8C77B72
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Apr 2023 13:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjDNNCC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Apr 2023 09:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjDNNB6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Apr 2023 09:01:58 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30A54ED5
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2023 06:01:56 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pnJ3r-0001rM-9A; Fri, 14 Apr 2023 15:01:55 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 4/4] netfilter: nf_tables: do not store rule in traceinfo structure
Date:   Fri, 14 Apr 2023 15:01:34 +0200
Message-Id: <20230414130134.29040-5-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414130134.29040-1-fw@strlen.de>
References: <20230414130134.29040-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

pass it as argument instead.  This reduces size of traceinfo to
16 bytes.  Total stack usage:

 nf_tables_core.c:252 nft_do_chain    304     static

While its possible to also pass basechain as argument, doing so
increases nft_do_chaininfo function size.

Unlike pktinfo/verdict/rule the basechain info isn't used in
the expression evaluation path. gcc places it on the stack, which
results in extra push/pop when it gets passed to the trace helpers
as argument rather than as part of the traceinfo structure.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h |  3 +--
 net/netfilter/nf_tables_core.c    | 15 +++++++--------
 net/netfilter/nf_tables_trace.c   | 14 ++++++++------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index a11fde72c87e..36df00f854e0 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1403,7 +1403,6 @@ void nft_unregister_flowtable_type(struct nf_flowtable_type *type);
  *	@skbid: hash of skb to be used as trace id
  *	@packet_dumped: packet headers sent in a previous traceinfo message
  *	@basechain: base chain currently processed
- *	@rule:  rule that was evaluated
  */
 struct nft_traceinfo {
 	bool				trace;
@@ -1412,7 +1411,6 @@ struct nft_traceinfo {
 	enum nft_trace_types		type:8;
 	u32				skbid;
 	const struct nft_base_chain	*basechain;
-	const struct nft_rule_dp	*rule;
 };
 
 void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
@@ -1420,6 +1418,7 @@ void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
 
 void nft_trace_notify(const struct nft_pktinfo *pkt,
 		      const struct nft_verdict *verdict,
+		      const struct nft_rule_dp *rule,
 		      struct nft_traceinfo *info);
 
 #define MODULE_ALIAS_NFT_CHAIN(family, name) \
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 6debe8b2623f..4d0ce12221f6 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -43,6 +43,7 @@ static inline void nf_skip_indirect_calls_enable(void) { }
 
 static noinline void __nft_trace_packet(const struct nft_pktinfo *pkt,
 					const struct nft_verdict *verdict,
+					const struct nft_rule_dp *rule,
 					struct nft_traceinfo *info,
 					enum nft_trace_types type)
 {
@@ -51,7 +52,7 @@ static noinline void __nft_trace_packet(const struct nft_pktinfo *pkt,
 
 	info->type = type;
 
-	nft_trace_notify(pkt, verdict, info);
+	nft_trace_notify(pkt, verdict, rule, info);
 }
 
 static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
@@ -62,8 +63,7 @@ static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
 {
 	if (static_branch_unlikely(&nft_trace_enabled)) {
 		info->nf_trace = pkt->skb->nf_trace;
-		info->rule = rule;
-		__nft_trace_packet(pkt, verdict, info, type);
+		__nft_trace_packet(pkt, verdict, rule, info, type);
 	}
 }
 
@@ -110,6 +110,7 @@ static void nft_cmp16_fast_eval(const struct nft_expr *expr,
 
 static noinline void __nft_trace_verdict(const struct nft_pktinfo *pkt,
 					 struct nft_traceinfo *info,
+					 const struct nft_rule_dp *rule,
 					 const struct nft_regs *regs)
 {
 	enum nft_trace_types type;
@@ -131,7 +132,7 @@ static noinline void __nft_trace_verdict(const struct nft_pktinfo *pkt,
 		break;
 	}
 
-	__nft_trace_packet(pkt, &regs->verdict, info, type);
+	__nft_trace_packet(pkt, &regs->verdict, rule, info, type);
 }
 
 static inline void nft_trace_verdict(const struct nft_pktinfo *pkt,
@@ -139,10 +140,8 @@ static inline void nft_trace_verdict(const struct nft_pktinfo *pkt,
 				     const struct nft_rule_dp *rule,
 				     const struct nft_regs *regs)
 {
-	if (static_branch_unlikely(&nft_trace_enabled)) {
-		info->rule = rule;
-		__nft_trace_verdict(pkt, info, regs);
-	}
+	if (static_branch_unlikely(&nft_trace_enabled))
+		__nft_trace_verdict(pkt, info, rule, regs);
 }
 
 static bool nft_payload_fast_eval(const struct nft_expr *expr,
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index e635104a42be..6d41c0bd3d78 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -125,9 +125,10 @@ static int nf_trace_fill_pkt_info(struct sk_buff *nlskb,
 
 static int nf_trace_fill_rule_info(struct sk_buff *nlskb,
 				   const struct nft_verdict *verdict,
+				   const struct nft_rule_dp *rule,
 				   const struct nft_traceinfo *info)
 {
-	if (!info->rule || info->rule->is_last)
+	if (!rule || rule->is_last)
 		return 0;
 
 	/* a continue verdict with ->type == RETURN means that this is
@@ -140,7 +141,7 @@ static int nf_trace_fill_rule_info(struct sk_buff *nlskb,
 		return 0;
 
 	return nla_put_be64(nlskb, NFTA_TRACE_RULE_HANDLE,
-			    cpu_to_be64(info->rule->handle),
+			    cpu_to_be64(rule->handle),
 			    NFTA_TRACE_PAD);
 }
 
@@ -166,9 +167,9 @@ static bool nft_trace_have_verdict_chain(const struct nft_verdict *verdict,
 	return true;
 }
 
-static const struct nft_chain *nft_trace_get_chain(const struct nft_traceinfo *info)
+static const struct nft_chain *nft_trace_get_chain(const struct nft_rule_dp *rule,
+						   const struct nft_traceinfo *info)
 {
-	const struct nft_rule_dp *rule = info->rule;
 	const struct nft_rule_dp_last *last;
 
 	if (!rule)
@@ -187,6 +188,7 @@ static const struct nft_chain *nft_trace_get_chain(const struct nft_traceinfo *i
 
 void nft_trace_notify(const struct nft_pktinfo *pkt,
 		      const struct nft_verdict *verdict,
+		      const struct nft_rule_dp *rule,
 		      struct nft_traceinfo *info)
 {
 	const struct nft_chain *chain;
@@ -199,7 +201,7 @@ void nft_trace_notify(const struct nft_pktinfo *pkt,
 	if (!nfnetlink_has_listeners(nft_net(pkt), NFNLGRP_NFTRACE))
 		return;
 
-	chain = nft_trace_get_chain(info);
+	chain = nft_trace_get_chain(rule, info);
 
 	size = nlmsg_total_size(sizeof(struct nfgenmsg)) +
 		nla_total_size(strlen(chain->table->name)) +
@@ -248,7 +250,7 @@ void nft_trace_notify(const struct nft_pktinfo *pkt,
 	if (nla_put_string(skb, NFTA_TRACE_TABLE, chain->table->name))
 		goto nla_put_failure;
 
-	if (nf_trace_fill_rule_info(skb, verdict, info))
+	if (nf_trace_fill_rule_info(skb, verdict, rule, info))
 		goto nla_put_failure;
 
 	switch (info->type) {
-- 
2.39.2

