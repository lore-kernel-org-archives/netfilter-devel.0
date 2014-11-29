From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH] scanner: fix reading of really long line
Date: Sat, 29 Nov 2014 17:24:38 +0100
Message-ID: <1417278278-30206-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:60015 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaK2Qtt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Nov 2014 11:49:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Current code is causing a failure in adding a set containing
a really long list of elements. The failure occurs as soon as
the line is longer than flex read buffer.

When a line is longer than scanner buffer size, the code in YY_INPUT
forces a rewind to the beginning of the string because it does not
find a end of line. The result is that the string is never parsed.

This patch updates the code by rewinding till we found a space.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/scanner.l | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/scanner.l b/src/scanner.l
index f0ed8d4..2fafa71 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -47,7 +47,8 @@
 		clearerr(yyin);							\
 	}									\
 	if (result > 1) {							\
-		while (result > 1 && buf[result - 1] != '\n')			\
+		while (result > 1 && 						\
+		       (buf[result - 1] != '\n' &&  buf[result - 1] != ' '))	\
 			result--, n++;						\
 		result--, n++;							\
 		fseek(yyin, -n, SEEK_CUR);					\
-- 
2.1.3

