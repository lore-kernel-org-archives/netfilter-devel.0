From: Eric Leblond <eric@regit.org>
Subject: [libnftables PATCH 3/3] expr: fix display of dreg expression
Date: Tue,  4 Jun 2013 10:05:23 +0200
Message-ID: <1370333124-11674-4-git-send-email-eric@regit.org>
References: <1370333124-11674-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:50703 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab3FDIFn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:05:43 -0400
In-Reply-To: <1370333124-11674-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/expr/immediate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 7cfb4bf..295054d 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -335,7 +335,7 @@ nft_rule_expr_immediate_snprintf_default(char *buf, size_t len,
 	int size = len, offset = 0, ret;
 	struct nft_expr_immediate *imm = (struct nft_expr_immediate *)e->data;
 
-	ret = snprintf(buf, len, "dreg=%u", imm->dreg);
+	ret = snprintf(buf, len, "dreg=%u ", imm->dreg);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (e->flags & (1 << NFT_EXPR_IMM_DATA)) {
-- 
1.7.10.4

