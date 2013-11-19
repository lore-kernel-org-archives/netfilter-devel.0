From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] expr: log: fixed error in nft_rule_expr_parse
Date: Tue, 19 Nov 2013 13:01:16 +0100
Message-ID: <1384862476-3413-1-git-send-email-anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:51036 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3KSMEJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Nov 2013 07:04:09 -0500
Received: by mail-wi0-f180.google.com with SMTP id c19so516893wiw.1
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2013 04:04:07 -0800 (PST)
Received: from localhost.localdomain (143.149.20.95.dynamic.jazztel.es. [95.20.149.143])
        by mx.google.com with ESMTPSA id uc12sm5022397wib.3.2013.11.19.04.04.06
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2013 04:04:06 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I fix it by allocating the correct value.
---
 src/expr/log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expr/log.c b/src/expr/log.c
index 2d3e0cf..495c1bd 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -142,7 +142,7 @@ nft_rule_expr_log_parse(struct nft_rule_expr *e, struct nlattr *attr)
 			xfree(log->prefix);
 
 		log->prefix = strdup(mnl_attr_get_str(tb[NFTA_LOG_PREFIX]));
-		e->flags |= (1 << NFT_EXPR_LOG_GROUP);
+		e->flags |= (1 << NFT_EXPR_LOG_PREFIX);
 	}
 	if (tb[NFTA_LOG_GROUP]) {
 		log->group = ntohs(mnl_attr_get_u16(tb[NFTA_LOG_GROUP]));
-- 
1.8.4.rc3

