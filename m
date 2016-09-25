From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH libnftnl 2/3] expr: log: do not print prefix if it is not set
Date: Sun, 25 Sep 2016 16:54:34 +0800
Message-ID: <1474793675-4542-3-git-send-email-zlpnobody@163.com>
References: <1474793675-4542-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:41591 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938995AbcIYIzc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 04:55:32 -0400
In-Reply-To: <1474793675-4542-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

This will avoid the following ugly display output:
  [ log prefix (null) ]

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 src/expr/log.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/expr/log.c b/src/expr/log.c
index e965448..a231bac 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -230,8 +230,10 @@ static int nftnl_expr_log_snprintf_default(char *buf, size_t size,
 	struct nftnl_expr_log *log = nftnl_expr_data(e);
 	int ret, offset = 0, len = size;
 
-	ret = snprintf(buf, len, "prefix %s ", log->prefix);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFTNL_EXPR_LOG_PREFIX)) {
+		ret = snprintf(buf, len, "prefix %s ", log->prefix);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
 	if (e->flags & (1 << NFTNL_EXPR_LOG_GROUP)) {
 		ret = snprintf(buf + offset, len,
-- 
2.5.5


