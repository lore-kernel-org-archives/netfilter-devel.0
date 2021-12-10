Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6481C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Dec 2021 00:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbhLJAQP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 19:16:15 -0500
Received: from mail.netfilter.org ([217.70.188.207]:44336 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234811AbhLJAQO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 19:16:14 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id A79FE60098
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Dec 2021 01:10:15 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 3/5] netfilter: nf_tables: consolidate rule verdict trace call
Date:   Fri, 10 Dec 2021 01:12:29 +0100
Message-Id: <20211210001231.144098-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211210001231.144098-1-pablo@netfilter.org>
References: <20211210001231.144098-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add function to consolidate verdict tracing.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c | 39 ++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 41c7509955e6..d026890a9842 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -67,6 +67,36 @@ static void nft_cmp_fast_eval(const struct nft_expr *expr,
 	regs->verdict.code = NFT_BREAK;
 }
 
+static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
+					 const struct nft_chain *chain,
+					 const struct nft_regs *regs)
+{
+	enum nft_trace_types type;
+
+	switch (regs->verdict.code) {
+	case NFT_CONTINUE:
+	case NFT_RETURN:
+		type = NFT_TRACETYPE_RETURN;
+		break;
+	default:
+		type = NFT_TRACETYPE_RULE;
+		break;
+	}
+
+	__nft_trace_packet(info, chain, type);
+}
+
+static inline void nft_trace_verdict(struct nft_traceinfo *info,
+				     const struct nft_chain *chain,
+				     const struct nft_rule *rule,
+				     const struct nft_regs *regs)
+{
+	if (static_branch_unlikely(&nft_trace_enabled)) {
+		info->rule = rule;
+		__nft_trace_verdict(info, chain, regs);
+	}
+}
+
 static bool nft_payload_fast_eval(const struct nft_expr *expr,
 				  struct nft_regs *regs,
 				  const struct nft_pktinfo *pkt)
@@ -205,13 +235,13 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		break;
 	}
 
+	nft_trace_verdict(&info, chain, rule, &regs);
+
 	switch (regs.verdict.code & NF_VERDICT_MASK) {
 	case NF_ACCEPT:
 	case NF_DROP:
 	case NF_QUEUE:
 	case NF_STOLEN:
-		nft_trace_packet(&info, chain, rule,
-				 NFT_TRACETYPE_RULE);
 		return regs.verdict.code;
 	}
 
@@ -224,15 +254,10 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		stackptr++;
 		fallthrough;
 	case NFT_GOTO:
-		nft_trace_packet(&info, chain, rule,
-				 NFT_TRACETYPE_RULE);
-
 		chain = regs.verdict.chain;
 		goto do_chain;
 	case NFT_CONTINUE:
 	case NFT_RETURN:
-		nft_trace_packet(&info, chain, rule,
-				 NFT_TRACETYPE_RETURN);
 		break;
 	default:
 		WARN_ON(1);
-- 
2.30.2

