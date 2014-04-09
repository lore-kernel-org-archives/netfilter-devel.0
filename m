From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/3] ruleset: Add an end of line in the exit of ruleset.
Date: Wed,  9 Apr 2014 10:53:59 +0200
Message-ID: <15bbda6958ec01d0088c386537288dcfe1ad8731.1397032579.git.anarey@gmail.com>
References: <cover.1397032579.git.anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:63920 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbaDIIyO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2014 04:54:14 -0400
Received: by mail-wi0-f176.google.com with SMTP id r20so8469853wiv.9
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Apr 2014 01:54:13 -0700 (PDT)
In-Reply-To: <cover.1397032579.git.anarey@gmail.com>
In-Reply-To: <cover.1397032579.git.anarey@gmail.com>
References: <cover.1397032579.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add an end of line in the exit of ruleset.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/ruleset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/ruleset.c b/src/ruleset.c
index 3cbec09..181aeae 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -818,7 +818,7 @@ nft_ruleset_do_snprintf(char *buf, size_t size, const struct nft_ruleset *rs,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	ret = snprintf(buf+offset, size, "%s", nft_ruleset_o_closetag(type));
+	ret = snprintf(buf+offset, size, "%s\n", nft_ruleset_o_closetag(type));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
-- 
1.9.0

