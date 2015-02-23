From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [iptables PATCH] libxt_quota: fix _save() invert syntax
Date: Mon, 23 Feb 2015 11:31:11 +0100
Message-ID: <20150223103111.2927.44023.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:50435 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751951AbbBWKbX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Feb 2015 05:31:23 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Space is misplaced.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 extensions/libxt_quota.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index ff498da..ff7dd2a 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -37,7 +37,7 @@ quota_save(const void *ip, const struct xt_entry_match *match)
 	const struct xt_quota_info *q = (const void *)match->data;
 
 	if (q->flags & XT_QUOTA_INVERT)
-		printf("! ");
+		printf(" !");
 	printf(" --quota %llu", (unsigned long long) q->quota);
 }
 

