From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH libnftnl 1/3] expr: queue: remove redundant NFTNL_EXPR_QUEUE_NUM set in json parse
Date: Sun, 11 Sep 2016 22:11:22 +0800
Message-ID: <1473603084-33964-2-git-send-email-zlpnobody@163.com>
References: <1473603084-33964-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:49478 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755728AbcIKOL7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Sep 2016 10:11:59 -0400
In-Reply-To: <1473603084-33964-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

We have already set NFTNL_EXPR_QUEUE_NUM when parse "num" successfully,
here is wrong and redundant, remove it.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 src/expr/queue.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/expr/queue.c b/src/expr/queue.c
index 522231b..033c542 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -136,7 +136,6 @@ nftnl_expr_queue_json_parse(struct nftnl_expr *e, json_t *root,
 
 	if (nftnl_jansson_parse_val(root, "num", NFTNL_TYPE_U16, &type, err) == 0)
 		nftnl_expr_set_u16(e, NFTNL_EXPR_QUEUE_NUM, type);
-	nftnl_expr_set_u16(e, NFTNL_EXPR_QUEUE_NUM, type);
 
 	if (nftnl_jansson_parse_val(root, "total", NFTNL_TYPE_U16, &code, err) == 0)
 		nftnl_expr_set_u16(e, NFTNL_EXPR_QUEUE_TOTAL, code);
-- 
2.5.5


