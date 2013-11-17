From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 3/3] verdict: fix delinearize in case of jump
Date: Mon, 18 Nov 2013 00:54:45 +0100
Message-ID: <1384732485-12944-4-git-send-email-eric@regit.org>
References: <DUB109-W87FE1E5161E5C42ED6593AE1F80@phx.gbl>
 <1384732485-12944-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	Alex Chapman <ajchapman88@hotmail.co.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:42594 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab3KRARs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Nov 2013 19:17:48 -0500
In-Reply-To: <1384732485-12944-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The name of the chain was not handled in case of a jump or a goto.
This patch adds parsing of the chain.

Reported-by: Alex Chapman <ajchapman88@hotmail.co.uk>
Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/netlink_delinearize.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 3bb143b..7e4e38c 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -81,9 +81,13 @@ static void netlink_parse_immediate(struct netlink_parse_ctx *ctx,
 	struct stmt *stmt;
 	struct expr *expr;
 
-	if (nft_rule_expr_is_set(nle, NFT_EXPR_IMM_VERDICT))
+	if (nft_rule_expr_is_set(nle, NFT_EXPR_IMM_VERDICT)) {
 		nld.verdict = nft_rule_expr_get_u32(nle, NFT_EXPR_IMM_VERDICT); 
-	else if (nft_rule_expr_is_set(nle, NFT_EXPR_IMM_DATA)) {
+		if  (nft_rule_expr_is_set(nle, NFT_EXPR_IMM_CHAIN)) {
+			nld.chain = nft_rule_expr_get(nle, NFT_EXPR_IMM_CHAIN,
+						      &nld.len);
+		}
+	} else if (nft_rule_expr_is_set(nle, NFT_EXPR_IMM_DATA)) {
 		nld.value = nft_rule_expr_get(nle, NFT_EXPR_IMM_DATA, &nld.len);
 	}
 
-- 
1.8.4.3

