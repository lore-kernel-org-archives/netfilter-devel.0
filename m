From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft] meta: fix memory leak in tc classid parser
Date: Sun, 28 Aug 2016 16:36:22 +0800
Message-ID: <1472373382-20104-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:37681 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755220AbcH1IhM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Aug 2016 04:37:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

We forgot to free the str which was allocated by xstrdup,
so memory leak will happen.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 src/meta.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/meta.c b/src/meta.c
index 5a6fee5..87eafee 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -90,7 +90,7 @@ static struct error_record *tchandle_type_parse(const struct expr *sym,
 						struct expr **res)
 {
 	uint32_t handle;
-	char *str;
+	char *str = NULL;
 
 	if (strcmp(sym->identifier, "root") == 0)
 		handle = TC_H_ROOT;
@@ -127,6 +127,7 @@ static struct error_record *tchandle_type_parse(const struct expr *sym,
 		handle = strtoull(sym->identifier, NULL, 0);
 	}
 out:
+	xfree(str);
 	*res = constant_expr_alloc(&sym->location, sym->dtype,
 				   BYTEORDER_HOST_ENDIAN,
 				   sizeof(handle) * BITS_PER_BYTE, &handle);
-- 
2.5.5


