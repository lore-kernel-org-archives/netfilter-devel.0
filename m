From: Eric Leblond <eric@regit.org>
Subject: [PATCH 1/2] netfilter: nft: fix issue with verdict support
Date: Sat, 30 Nov 2013 11:56:17 +0100
Message-ID: <1385808978-19833-1-git-send-email-eric@regit.org>
References: <1385808722.4321.19.camel@ice-age2.regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:38760 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab3K3K4e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Nov 2013 05:56:34 -0500
In-Reply-To: <1385808722.4321.19.camel@ice-age2.regit.org>
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
1.8.4.4

