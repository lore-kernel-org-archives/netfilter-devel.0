From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 4/5] expr: reject: Convert the type of a variable
Date: Wed,  4 Jun 2014 13:38:10 +0200
Message-ID: <1401881891-4990-5-git-send-email-anarey@gmail.com>
References: <1401881891-4990-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:37532 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbaFDLi1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:38:27 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so8440228wes.28
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Jun 2014 04:38:26 -0700 (PDT)
In-Reply-To: <1401881891-4990-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Convert the type of a variable from uint16_t to uint8_t.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/reject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expr/reject.c b/src/expr/reject.c
index 5aa555a..8fc99af 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -128,7 +128,7 @@ nft_rule_expr_reject_json_parse(struct nft_rule_expr *e, json_t *root,
 {
 #ifdef JSON_PARSING
 	uint32_t type;
-	uint16_t code;
+	uint8_t code;
 
 	if (nft_jansson_parse_val(root, "type", NFT_TYPE_U32, &type, err) < 0)
 		return -1;
-- 
2.0.0.rc2

