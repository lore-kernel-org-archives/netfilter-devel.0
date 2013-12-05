From: Eric Leblond <eric@regit.org>
Subject: [PATCHv4 1/3] netfilter: nft: fix issue with verdict support
Date: Fri,  6 Dec 2013 00:24:11 +0100
Message-ID: <1386285853-464-2-git-send-email-eric@regit.org>
References: <20131205214133.GA4307@localhost>
 <1386285853-464-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:59305 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab3LEXYe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:24:34 -0500
In-Reply-To: <1386285853-464-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The test on verdict was simply done on the value of the verdict
which is not correct as far as queue is concern. In fact, the test
of verdict test must be done with respect to the verdict mask for
verdicts which are not internal to nftables.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 net/netfilter/nf_tables_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index cb9e685..e8fcc34 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -164,7 +164,7 @@ next_rule:
 		break;
 	}
 
-	switch (data[NFT_REG_VERDICT].verdict) {
+	switch (data[NFT_REG_VERDICT].verdict & NF_VERDICT_MASK) {
 	case NF_ACCEPT:
 	case NF_DROP:
 	case NF_QUEUE:
@@ -172,6 +172,9 @@ next_rule:
 			nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
 
 		return data[NFT_REG_VERDICT].verdict;
+	}
+
+	switch (data[NFT_REG_VERDICT].verdict) {
 	case NFT_JUMP:
 		if (unlikely(pkt->skb->nf_trace))
 			nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
-- 
1.8.5

