From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] ruleset: fix erroneus call to snprintf
Date: Tue, 06 May 2014 17:09:33 +0200
Message-ID: <20140506150933.31175.48901.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55207 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757574AbaEFPJr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 May 2014 11:09:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This snprintf call is taking an erroneus value for size.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/ruleset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/ruleset.c b/src/ruleset.c
index 98c4367..a19cbc1 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -825,7 +825,7 @@ nft_ruleset_do_snprintf(char *buf, size_t size, const struct nft_ruleset *rs,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	ret = snprintf(buf+offset, size, "%s", nft_ruleset_o_closetag(type));
+	ret = snprintf(buf+offset, len, "%s", nft_ruleset_o_closetag(type));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = nft_event_footer_snprintf(buf+offset, len, type, flags);

