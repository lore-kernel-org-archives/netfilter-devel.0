From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 18/23] netfilter: nf_tables: fix nf_log_trace based tracing
Date: Fri, 18 Dec 2015 21:26:44 +0100
Message-ID: <1450470409-31427-19-git-send-email-pablo@netfilter.org>
References: <1450470409-31427-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57981 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965205AbbLRUeK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2015 15:34:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9F57117F1B0
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 21:34:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4AEF5DA245
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 21:34:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8D067DA87E
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 21:34:06 +0100 (CET)
In-Reply-To: <1450470409-31427-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

nf_log_trace() outputs bogus 'TRACE:' strings because I forgot to update
the comments array.

Fixes: 33d5a7b14bfd0 ("netfilter: nf_tables: extend tracing infrastructure")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

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
2.1.4

