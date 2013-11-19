From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] src: expr: log: fixed error in nft_rule_expr_log_build
Date: Tue, 19 Nov 2013 17:56:18 +0100
Message-ID: <1384880178-32530-1-git-send-email-anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35711 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3KSQ7L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:59:11 -0500
Received: by mail-wg0-f47.google.com with SMTP id y10so7799999wgg.2
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2013 08:59:10 -0800 (PST)
Received: from tuxhiba.colubris.lan (250.Red-80-33-69.staticIP.rima-tde.net. [80.33.69.250])
        by mx.google.com with ESMTPSA id gb1sm6593531wic.0.2013.11.19.08.59.09
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2013 08:59:09 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If I run my automatic unit test of libnftable, It shows:
"ERROR: Expr NFT_EXPR_LOG_PREFIX mismatches"
a: test
b: test

The problem was in nft_rule_expr_log_build function.

With the attached patch, we use "mnl_attr_put_strz" in instead of
"mnl_attr_put_str".
---
 src/expr/log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expr/log.c b/src/expr/log.c
index 495c1bd..76657a9 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -119,7 +119,7 @@ nft_rule_expr_log_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
 	struct nft_expr_log *log = nft_expr_data(e);
 
 	if (e->flags & (1 << NFT_EXPR_LOG_PREFIX))
-		mnl_attr_put_str(nlh, NFTA_LOG_PREFIX, log->prefix);
+		mnl_attr_put_strz(nlh, NFTA_LOG_PREFIX, log->prefix);
 	if (e->flags & (1 << NFT_EXPR_LOG_GROUP))
 		mnl_attr_put_u16(nlh, NFTA_LOG_GROUP, htons(log->group));
 	if (e->flags & (1 << NFT_EXPR_LOG_SNAPLEN))
-- 
1.8.4.rc3

