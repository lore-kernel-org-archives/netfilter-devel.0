From: balazs.scheidler@balabit.com
Subject: [PATCH] redir: fix snprintf to return the number of bytes printed
Date: Fri, 26 Jun 2015 11:57:53 +0200
Message-ID: <1435312673-32048-1-git-send-email-balazs.scheidler@balabit.com>
Cc: Balazs Scheidler <balazs.scheidler@balabit.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:35058 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbbFZJ6B (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2015 05:58:01 -0400
Received: by wgjx7 with SMTP id x7so10837639wgj.2
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jun 2015 02:57:59 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Balazs Scheidler <balazs.scheidler@balabit.com>

This fixes --debug netlink output when a redir target is included.

Signed-off-by: Balazs Scheidler <balazs.scheidler@balabit.com>
---
 src/expr/redir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expr/redir.c b/src/expr/redir.c
index b6adf88..69bd94f 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -223,7 +223,7 @@ static int nft_rule_expr_redir_snprintf_default(char *buf, size_t len,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	return 0;
+	return offset;
 }
 
 static int
-- 
2.1.0

