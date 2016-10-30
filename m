From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft] log: rename the log level "warning" to "warn"
Date: Sun, 30 Oct 2016 20:24:27 +0800
Message-ID: <1477830267-12393-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:55065 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751521AbcJ3MY7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 30 Oct 2016 08:24:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

This is to keep compatibility. The original keyword in grammer is
"warn" instead of "warning".

Fixes: 0423caa91ad2 ("src: don't need keyword for log level")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 src/parser_bison.y | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 85234ca..4ed7494 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1540,7 +1540,7 @@ level_type		:	string
 					$$ = LOG_CRIT;
 				else if (!strcmp("err", $1))
 					$$ = LOG_ERR;
-				else if (!strcmp("warning", $1))
+				else if (!strcmp("warn", $1))
 					$$ = LOG_WARNING;
 				else if (!strcmp("notice", $1))
 					$$ = LOG_NOTICE;
-- 
2.5.5


