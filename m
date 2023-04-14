Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA2EC77B6E
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Apr 2023 13:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjDNNBu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Apr 2023 09:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjDNNBt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Apr 2023 09:01:49 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C6A1BFD
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2023 06:01:48 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pnJ3j-0001qq-2D; Fri, 14 Apr 2023 15:01:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/4] netfilter: nf_tables: do not store pktinfo in traceinfo structure
Date:   Fri, 14 Apr 2023 15:01:32 +0200
Message-Id: <20230414130134.29040-3-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414130134.29040-1-fw@strlen.de>
References: <20230414130134.29040-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

pass it as argument.  No change in object size.

stack usage decreases by 8 byte:
 nf_tables_core.c:254  nft_do_chain       320     static

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h |  5 ++---
 net/netfilter/nf_tables_core.c    | 21 ++++++++++++---------
 net/netfilter/nf_tables_trace.c   |  5 ++---
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 7b9f141120a1..298e9faa647b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1402,7 +1402,6 @@ void nft_unregister_flowtable_type(struct nf_flowtable_type *type);
  *	@type: event type (enum nft_trace_types)
  *	@skbid: hash of skb to be used as trace id
  *	@packet_dumped: packet headers sent in a previous traceinfo message
- *	@pkt: pktinfo currently processed
  *	@basechain: base chain currently processed
  *	@rule:  rule that was evaluated
  *	@verdict: verdict given by rule
@@ -1413,7 +1412,6 @@ struct nft_traceinfo {
 	bool				packet_dumped;
 	enum nft_trace_types		type:8;
 	u32				skbid;
-	const struct nft_pktinfo	*pkt;
 	const struct nft_base_chain	*basechain;
 	const struct nft_rule_dp	*rule;
 	const struct nft_verdict	*verdict;
@@ -1423,7 +1421,8 @@ void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
 		    const struct nft_verdict *verdict,
 		    const struct nft_chain *basechain);
 
-void nft_trace_notify(struct nft_traceinfo *info);
+void nft_trace_notify(const struct nft_pktinfo *pkt,
+		      struct nft_traceinfo *info);
 
 #define MODULE_ALIAS_NFT_CHAIN(family, name) \
 	MODULE_ALIAS("nft-chain-" __stringify(family) "-" name)
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index bed855638050..776eb2b9f632 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -41,7 +41,8 @@ static inline bool nf_skip_indirect_calls(void) { return false; }
 static inline void nf_skip_indirect_calls_enable(void) { }
 #endif
 
-static noinline void __nft_trace_packet(struct nft_traceinfo *info,
+static noinline void __nft_trace_packet(const struct nft_pktinfo *pkt,
+					struct nft_traceinfo *info,
 					enum nft_trace_types type)
 {
 	if (!info->trace || !info->nf_trace)
@@ -49,7 +50,7 @@ static noinline void __nft_trace_packet(struct nft_traceinfo *info,
 
 	info->type = type;
 
-	nft_trace_notify(info);
+	nft_trace_notify(pkt, info);
 }
 
 static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
@@ -60,7 +61,7 @@ static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
 	if (static_branch_unlikely(&nft_trace_enabled)) {
 		info->nf_trace = pkt->skb->nf_trace;
 		info->rule = rule;
-		__nft_trace_packet(info, type);
+		__nft_trace_packet(pkt, info, type);
 	}
 }
 
@@ -105,7 +106,8 @@ static void nft_cmp16_fast_eval(const struct nft_expr *expr,
 	regs->verdict.code = NFT_BREAK;
 }
 
-static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
+static noinline void __nft_trace_verdict(const struct nft_pktinfo *pkt,
+					 struct nft_traceinfo *info,
 					 const struct nft_regs *regs)
 {
 	enum nft_trace_types type;
@@ -123,20 +125,21 @@ static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
 		type = NFT_TRACETYPE_RULE;
 
 		if (info->trace)
-			info->nf_trace = info->pkt->skb->nf_trace;
+			info->nf_trace = pkt->skb->nf_trace;
 		break;
 	}
 
-	__nft_trace_packet(info, type);
+	__nft_trace_packet(pkt, info, type);
 }
 
-static inline void nft_trace_verdict(struct nft_traceinfo *info,
+static inline void nft_trace_verdict(const struct nft_pktinfo *pkt,
+				     struct nft_traceinfo *info,
 				     const struct nft_rule_dp *rule,
 				     const struct nft_regs *regs)
 {
 	if (static_branch_unlikely(&nft_trace_enabled)) {
 		info->rule = rule;
-		__nft_trace_verdict(info, regs);
+		__nft_trace_verdict(pkt, info, regs);
 	}
 }
 
@@ -300,7 +303,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		break;
 	}
 
-	nft_trace_verdict(&info, rule, &regs);
+	nft_trace_verdict(pkt, &info, rule, &regs);
 
 	switch (regs.verdict.code & NF_VERDICT_MASK) {
 	case NF_ACCEPT:
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index 3d9b83d84a84..0a0dcf2587fd 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -183,9 +183,9 @@ static const struct nft_chain *nft_trace_get_chain(const struct nft_traceinfo *i
 	return last->chain;
 }
 
-void nft_trace_notify(struct nft_traceinfo *info)
+void nft_trace_notify(const struct nft_pktinfo *pkt,
+		      struct nft_traceinfo *info)
 {
-	const struct nft_pktinfo *pkt = info->pkt;
 	const struct nft_chain *chain;
 	struct nlmsghdr *nlh;
 	struct sk_buff *skb;
@@ -305,7 +305,6 @@ void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
 	info->trace = true;
 	info->nf_trace = pkt->skb->nf_trace;
 	info->packet_dumped = false;
-	info->pkt = pkt;
 	info->verdict = verdict;
 
 	net_get_random_once(&trace_key, sizeof(trace_key));
-- 
2.39.2

