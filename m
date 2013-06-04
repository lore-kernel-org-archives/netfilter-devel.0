From: Eric Leblond <eric@regit.org>
Subject: [libnftables PATCH 1/3] examples: delete payload code in nft-chain-add
Date: Tue,  4 Jun 2013 10:05:21 +0200
Message-ID: <1370333124-11674-2-git-send-email-eric@regit.org>
References: <1370333124-11674-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:50698 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab3FDIFi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:05:38 -0400
In-Reply-To: <1370333124-11674-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

'make check' was not working due to the fact that
'libnftables/payload.h' was not present. As the payload
related code was commented, the "I've got an axe" solution
was to remove all payload related code. This is done in this
patch.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 examples/nft-rule-add.c |   25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
index b906715..c2b8968 100644
--- a/examples/nft-rule-add.c
+++ b/examples/nft-rule-add.c
@@ -21,7 +21,6 @@
 #include <libmnl/libmnl.h>
 #include <libnftables/rule.h>
 #include <libnftables/expr.h>
-#include <libnftables/payload.h>
 
 #include <linux/netfilter_ipv4/ipt_LOG.h>
 #include <linux/netfilter/xt_iprange.h>
@@ -93,29 +92,6 @@ static void add_expr_match(struct nft_rule *r)
 
 #define field_sizeof(t, f)	(sizeof(((t *)NULL)->f))
 
-static void add_payload2(struct nft_rule_expr *e)
-{
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_BASE,
-			      NFT_PAYLOAD_NETWORK_HEADER);
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_DREG, NFT_REG_1);
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_OFFSET,
-			      offsetof(struct iphdr, protocol));
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_LEN, 1);
-}
-
-static void add_payload(struct nft_rule *r)
-{
-	struct nft_rule_expr *expr;
-
-	expr = nft_rule_expr_alloc("payload");
-	if (expr == NULL)
-		return;
-
-	add_payload2(expr);
-
-	nft_rule_add_expr(r, expr);
-}
-
 int main(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
@@ -153,7 +129,6 @@ int main(int argc, char *argv[])
 
 	add_expr_match(r);
 	add_expr_target(r);
-//	add_payload(r);
 
 	char tmp[1024];
 	nft_rule_snprintf(tmp, sizeof(tmp), r, 0, 0);
-- 
1.7.10.4

