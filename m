From: Eric Leblond <eric@regit.org>
Subject: [nftables 1/3] erec: fix buffer overflow
Date: Wed, 24 Jun 2015 09:51:49 +0200
Message-ID: <1435132311-31452-2-git-send-email-eric@regit.org>
References: <1435132311-31452-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:47460 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbbFXHwO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jun 2015 03:52:14 -0400
In-Reply-To: <1435132311-31452-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A static array was used to read data and to write information in
it without checking the limit of the array. The result was a buffer
overflow when the line was longer than 1024.

This patch now uses a allocated buffer to avoid the problem.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/erec.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/src/erec.c b/src/erec.c
index 810e9bf..75a3f74 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -12,6 +12,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <stdarg.h>
+#include <stdlib.h>
 
 #include <netlink.h>
 #include <gmputil.h>
@@ -82,6 +83,7 @@ void erec_print(FILE *f, const struct error_record *erec)
 	const struct input_descriptor *indesc = loc->indesc, *tmp;
 	const char *line = NULL; /* silence gcc */
 	char buf[1024];
+	char *pbuf = NULL;
 	unsigned int i, end;
 	int l, ret;
 
@@ -141,17 +143,24 @@ void erec_print(FILE *f, const struct error_record *erec)
 		if (indesc->type != INDESC_INTERNAL)
 			fprintf(f, "%s\n", line);
 
-		memset(buf, ' ', sizeof(buf));
 		end = 0;
 		for (l = erec->num_locations - 1; l >= 0; l--) {
 			loc = &erec->locations[l];
+			end = max(end, loc->last_column);
+		}
+		pbuf = malloc(end + 1);
+		if (pbuf == NULL)
+			return;
+		memset(pbuf, ' ', end + 1);
+		for (l = erec->num_locations - 1; l >= 0; l--) {
+			loc = &erec->locations[l];
 			for (i = loc->first_column ? loc->first_column - 1 : 0;
 			     i < loc->last_column; i++)
-				buf[i] = l ? '~' : '^';
-			end = max(end, loc->last_column);
+				pbuf[i] = l ? '~' : '^';
 		}
-		buf[end] = '\0';
-		fprintf(f, "%s", buf);
+		pbuf[end] = '\0';
+		fprintf(f, "%s", pbuf);
+		free(pbuf);
 	}
 	fprintf(f, "\n");
 }
-- 
2.1.4

