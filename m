From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nf_tables: fix nf_log_trace based tracing
Date: Wed,  9 Dec 2015 16:31:21 +0100
Message-ID: <1449675081-29519-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44682 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183AbbLIPb0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 10:31:26 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_log_trace() outputs bogus 'TRACE:' strings because I forgot to update
the comments array.

Fixes: 33d5a7b14bfd0 ("netfilter: nf_tables: extend tracing infrastructure")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 67fa41d..e9f8dff 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -23,16 +23,10 @@
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
+static const char *const comments[__NFT_TRACETYPE_MAX] = {
+	[NFT_TRACETYPE_POLICY]	= "policy",
+	[NFT_TRACETYPE_RETURN]	= "return",
+	[NFT_TRACETYPE_RULE]	= "rule",
 };
 
 static struct nf_loginfo trace_loginfo = {
@@ -47,7 +41,7 @@ static struct nf_loginfo trace_loginfo = {
 
 static noinline void __nft_trace_packet(struct nft_traceinfo *info,
 					const struct nft_chain *chain,
-					int rulenum, enum nft_trace type)
+					int rulenum, enum nft_trace_types type)
 {
 	const struct nft_pktinfo *pkt = info->pkt;
 
-- 
2.4.10

