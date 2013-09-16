From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 1/4] nat: add mandatory family attribute
Date: Mon, 16 Sep 2013 18:27:35 +0200
Message-ID: <1379348858-29187-2-git-send-email-eric@regit.org>
References: <1379348858-29187-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:37449 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3IPRHm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Sep 2013 13:07:42 -0400
In-Reply-To: <1379348858-29187-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

NFT_EXPR_NAT_FAMILY is a mandatory attribute for NAT rules and
it was not set by nftables.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/netlink_linearize.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 427fdb6..72c59e5 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -572,10 +572,14 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 	enum nft_registers amin_reg, amax_reg;
 	enum nft_registers pmin_reg, pmax_reg;
 	int registers = 0;
+	int family;
 
 	nle = alloc_nft_expr("nat");
 	nft_rule_expr_set_u32(nle, NFT_EXPR_NAT_TYPE, stmt->nat.type);
 
+	family = nft_rule_attr_get_u32(ctx->nlr, NFT_RULE_ATTR_FAMILY);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_NAT_FAMILY, family);
+
 	if (stmt->nat.addr) {
 		amin_reg = get_register(ctx);
 		registers++;
-- 
1.8.4.rc3

