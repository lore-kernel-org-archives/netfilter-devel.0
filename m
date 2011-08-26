From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/5] libxt_string: replace hex codes by char equivalents
Date: Fri, 26 Aug 2011 15:15:12 +0200
Message-ID: <1314364516-7875-3-git-send-email-jengelh@medozas.de>
References: <1314364516-7875-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41483 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab1HZNR4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Aug 2011 09:17:56 -0400
In-Reply-To: <1314364516-7875-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_string.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 365019f..472035f 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -218,7 +218,7 @@ is_hex_string(const char *str, const unsigned short int len)
 		if (! isprint(str[i]))
 			return 1;  /* string contains at least one non-printable char */
 	/* use hex output if the last char is a "\" */
-	if ((unsigned char) str[len-1] == 0x5c)
+	if (str[len-1] == '\\')
 		return 1;
 	return 0;
 }
@@ -242,8 +242,8 @@ print_string(const char *str, const unsigned short int len)
 	unsigned int i;
 	printf(" \"");
 	for (i=0; i < len; i++) {
-		if ((unsigned char) str[i] == 0x22)  /* escape any embedded quotes */
-			printf("%c", 0x5c);
+		if (str[i] == '\"')  /* escape any embedded quotes */
+			putchar('\\');
 		printf("%c", (unsigned char) str[i]);
 	}
 	printf("\"");  /* closing quote */
-- 
1.7.3.4

