From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] src: expr: target: fixed error in nft_rule_expr_target_parse
Date: Tue, 19 Nov 2013 18:54:14 +0100
Message-ID: <1384883654-10040-1-git-send-email-anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:52684 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3KSR5E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Nov 2013 12:57:04 -0500
Received: by mail-wi0-f169.google.com with SMTP id hj6so1694094wib.0
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2013 09:57:03 -0800 (PST)
Received: from tuxhiba.colubris.lan (250.Red-80-33-69.staticIP.rima-tde.net. [80.33.69.250])
        by mx.google.com with ESMTPSA id s2sm7702457wiy.7.2013.11.19.09.57.01
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2013 09:57:02 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If I run my automatic unit test of libnftable, It shows:

ERROR: Expr NFT_EXPR_TG_INFO size mismatches size a: 32 b: 36

The problem was in nft_rule_expr_target_parse function.

With the attached patch, we use "mnl_attr_get_payload_len" in instead of
"mnl_attr_get_len".
---
 src/expr/target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expr/target.c b/src/expr/target.c
index 20bf2af..23dff3a 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -149,7 +149,7 @@ static int nft_rule_expr_target_parse(struct nft_rule_expr *e, struct nlattr *at
 	}
 
 	if (tb[NFTA_TARGET_INFO]) {
-		uint32_t len = mnl_attr_get_len(tb[NFTA_TARGET_INFO]);
+		uint32_t len = mnl_attr_get_payload_len(tb[NFTA_TARGET_INFO]);
 		void *target_data;
 
 		if (target->data)
-- 
1.8.4.rc3

