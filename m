From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH] utils: Don't return directly from SNPRINTF_BUFFER_SIZE
Date: Fri, 12 Aug 2016 14:39:50 +0200
Message-ID: <1471005590-18276-1-git-send-email-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Phil Sutter <psutter@redhat.com>,
	Arturo Borrero <arturo.borrero.glez@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:45166 "EHLO mail.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbcHLMkD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 08:40:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Phil Sutter <psutter@redhat.com>

Apart from being a bad idea in general, the return statement contained
in that macro in some cases leads to returning from functions without
properly cleaning up, thereby causing memory leaks.

Instead, just sanitize the value in 'ret' to not harm further calls of
snprintf() (as 'len' will eventually just become zero).

Cc: Arturo Borrero <arturo.borrero.glez@gmail.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
This is actually v2 of "[libnftnl PATCH 2/7] ruleset: Prevent memleak in
nftnl_ruleset_snprintf_*() functions" but since it's a completely
different approach there was no use in keeping the old subject line.
---
 include/utils.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/utils.h b/include/utils.h
index 21694b6ab1912..924df324aa603 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -54,7 +54,7 @@ void __nftnl_assert_attr_exists(uint16_t attr, uint16_t attr_max,
 
 #define SNPRINTF_BUFFER_SIZE(ret, size, len, offset)	\
 	if (ret < 0)					\
-		return ret;				\
+		ret = 0;				\
 	offset += ret;					\
 	if (ret > len)					\
 		ret = len;				\
-- 
2.8.2

