Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9740EC19F2B
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Aug 2022 17:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbiHARQG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Aug 2022 13:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbiHARPu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Aug 2022 13:15:50 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2792640E
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2022 10:15:48 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oIZ19-0001hW-7j; Mon, 01 Aug 2022 19:15:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH nf 1/2] netfilter: nf_tables: fix crash when nf_trace is enabled
Date:   Mon,  1 Aug 2022 19:15:35 +0200
Message-Id: <20220801171536.21372-2-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220801171536.21372-1-fw@strlen.de>
References: <20220801171536.21372-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft_traceinfo is not initialized in info->trace is 0, so unconditional
access to info->pkt (or any other field except ->trace) is illegal.

Pass nft_pktinfo directly to avoid this.

Fixes: e34b9ed96ce3 ("netfilter: nf_tables: avoid skb access on nf_stolen")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_core.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 3ddce24ac76d..cee3e4e905ec 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -34,25 +34,23 @@ static noinline void __nft_trace_packet(struct nft_traceinfo *info,
 	nft_trace_notify(info);
 }
 
-static inline void nft_trace_packet(struct nft_traceinfo *info,
+static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
+				    struct nft_traceinfo *info,
 				    const struct nft_chain *chain,
 				    const struct nft_rule_dp *rule,
 				    enum nft_trace_types type)
 {
 	if (static_branch_unlikely(&nft_trace_enabled)) {
-		const struct nft_pktinfo *pkt = info->pkt;
-
 		info->nf_trace = pkt->skb->nf_trace;
 		info->rule = rule;
 		__nft_trace_packet(info, chain, type);
 	}
 }
 
-static inline void nft_trace_copy_nftrace(struct nft_traceinfo *info)
+static inline void nft_trace_copy_nftrace(const struct nft_pktinfo *pkt,
+					  struct nft_traceinfo *info)
 {
 	if (static_branch_unlikely(&nft_trace_enabled)) {
-		const struct nft_pktinfo *pkt = info->pkt;
-
 		if (info->trace)
 			info->nf_trace = pkt->skb->nf_trace;
 	}
@@ -96,7 +94,6 @@ static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
 					 const struct nft_chain *chain,
 					 const struct nft_regs *regs)
 {
-	const struct nft_pktinfo *pkt = info->pkt;
 	enum nft_trace_types type;
 
 	switch (regs->verdict.code) {
@@ -110,7 +107,9 @@ static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
 		break;
 	default:
 		type = NFT_TRACETYPE_RULE;
-		info->nf_trace = pkt->skb->nf_trace;
+
+		if (info->trace)
+			info->nf_trace = info->pkt->skb->nf_trace;
 		break;
 	}
 
@@ -271,10 +270,10 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		switch (regs.verdict.code) {
 		case NFT_BREAK:
 			regs.verdict.code = NFT_CONTINUE;
-			nft_trace_copy_nftrace(&info);
+			nft_trace_copy_nftrace(pkt, &info);
 			continue;
 		case NFT_CONTINUE:
-			nft_trace_packet(&info, chain, rule,
+			nft_trace_packet(pkt, &info, chain, rule,
 					 NFT_TRACETYPE_RULE);
 			continue;
 		}
@@ -318,7 +317,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		goto next_rule;
 	}
 
-	nft_trace_packet(&info, basechain, NULL, NFT_TRACETYPE_POLICY);
+	nft_trace_packet(pkt, &info, basechain, NULL, NFT_TRACETYPE_POLICY);
 
 	if (static_branch_unlikely(&nft_counters_enabled))
 		nft_update_chain_stats(basechain, pkt);
-- 
2.35.1

