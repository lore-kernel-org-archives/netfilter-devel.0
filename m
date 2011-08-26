From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/5] libxt_string: simplify hex output routine
Date: Fri, 26 Aug 2011 15:15:11 +0200
Message-ID: <1314364516-7875-2-git-send-email-jengelh@medozas.de>
References: <1314364516-7875-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41480 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab1HZNRz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Aug 2011 09:17:55 -0400
In-Reply-To: <1314364516-7875-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_string.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 257f5f8..365019f 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -230,13 +230,8 @@ print_hex_string(const char *str, const unsigned short int len)
 	unsigned int i;
 	/* start hex block */
 	printf(" \"|");
-	for (i=0; i < len; i++) {
-		/* see if we need to prepend a zero */
-		if ((unsigned char) str[i] <= 0x0F)
-			printf("0%x", (unsigned char) str[i]);
-		else
-			printf("%x", (unsigned char) str[i]);
-	}
+	for (i=0; i < len; i++)
+		printf("%02x", (unsigned char)str[i]);
 	/* close hex block */
 	printf("|\"");
 }
-- 
1.7.3.4

