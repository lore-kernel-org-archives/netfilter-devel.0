From: Aaron Conole <aconole@bytheb.org>
Subject: [PATCH libnftnl] expr: dup: Fix json parsing
Date: Thu,  8 Oct 2015 17:09:30 -0400
Message-ID: <1444338570-9254-1-git-send-email-aconole@bytheb.org>
Cc: Aaron Conole <aconole@bytheb.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:35930 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758570AbbJHVJy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Oct 2015 17:09:54 -0400
Received: by qkht68 with SMTP id t68so24892805qkh.3
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Oct 2015 14:09:54 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

fixes 760768890e60 ("src: rename existing functions...") by using the
correct NFTNL_TYPE_U32.
fixes 42365e5fec55 ("expr: add dup expression support...") by adding
a declaration for the ret variable.

Signed-off-by: Aaron Conole <aconole@bytheb.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/dup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/expr/dup.c b/src/expr/dup.c
index d0fa35f..17957df 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -119,10 +119,10 @@ static int nftnl_expr_dup_json_parse(struct nftnl_expr *e, json_t *root,
 	uint32_t sreg_addr, sreg_dev;
 	int datareg_type;
 
-	ret = nftnl_jansson_parse_val(root, "sreg_addr", NFT_TYPE_U32, &sreg_addr, err);
+	int ret = nftnl_jansson_parse_val(root, "sreg_addr", NFTNL_TYPE_U32, &sreg_addr, err);
 	if (ret >= 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_DUP_SREG_DEV, sreg_addr);
-	ret = nftnl_jansson_parse_val(root, "sreg_dev", NFT_TYPE_U32, &sreg_dev, err);
+	ret = nftnl_jansson_parse_val(root, "sreg_dev", NFTNL_TYPE_U32, &sreg_dev, err);
 	if (ret >= 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_DUP_SREG_DEV, sreg_dev);
 
-- 
1.8.3.1

