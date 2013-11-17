From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 2/3] jump: fix logic in netlink linearize.
Date: Mon, 18 Nov 2013 00:54:44 +0100
Message-ID: <1384732485-12944-3-git-send-email-eric@regit.org>
References: <DUB109-W87FE1E5161E5C42ED6593AE1F80@phx.gbl>
 <1384732485-12944-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	Alex Chapman <ajchapman88@hotmail.co.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:42593 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab3KRARq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Nov 2013 19:17:46 -0500
In-Reply-To: <1384732485-12944-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Logic in the test was inverted. The result was the jump string
not to be set.

Reported-by: Alex Chapman <ajchapman88@hotmail.co.uk>
Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/netlink_linearize.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index da8be20..e64e92a 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -440,7 +440,8 @@ static void netlink_gen_immediate(struct netlink_linearize_ctx *ctx,
 		nft_rule_expr_set(nle, NFT_EXPR_IMM_DATA, nld.value, nld.len);
 		break;
 	case EXPR_VERDICT:
-		if (nft_rule_expr_is_set(nle, NFT_EXPR_IMM_CHAIN)) {
+		if ((expr->chain != NULL) &&
+		    !nft_rule_expr_is_set(nle, NFT_EXPR_IMM_CHAIN)) {
 			nft_rule_expr_set_str(nle, NFT_EXPR_IMM_CHAIN,
 					      nld.chain);
 		}
-- 
1.8.4.3

