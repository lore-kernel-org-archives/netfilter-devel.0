From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH libnftnl 1/3] expr: log: fix typo in nftnl_expr_log_export
Date: Sun, 25 Sep 2016 16:54:33 +0800
Message-ID: <1474793675-4542-2-git-send-email-zlpnobody@163.com>
References: <1474793675-4542-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:41383 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753023AbcIYIz3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 04:55:29 -0400
In-Reply-To: <1474793675-4542-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

After test NFTNL_EXPR_LOG_FLAGS is set, we should put "log->flags"
instead of "log->level".

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 src/expr/log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expr/log.c b/src/expr/log.c
index 57490d9..e965448 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -264,7 +264,7 @@ static int nftnl_expr_log_export(char *buf, size_t size,
 	if (e->flags & (1 << NFTNL_EXPR_LOG_LEVEL))
 		nftnl_buf_u32(&b, type, log->level, LEVEL);
 	if (e->flags & (1 << NFTNL_EXPR_LOG_FLAGS))
-		nftnl_buf_u32(&b, type, log->level, FLAGS);
+		nftnl_buf_u32(&b, type, log->flags, FLAGS);
 
 	return nftnl_buf_done(&b);
 }
-- 
2.5.5


