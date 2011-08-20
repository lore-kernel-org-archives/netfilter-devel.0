From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/6] libxt_string: fix space around arguments
Date: Sat, 20 Aug 2011 21:24:53 +0200
Message-ID: <1313868294-21471-7-git-send-email-jengelh@medozas.de>
References: <1313868294-21471-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40060 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087Ab1HTTZE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Aug 2011 15:25:04 -0400
In-Reply-To: <1313868294-21471-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Dwight Davis <sivad_thgiwd@yahoo.ca>

Fix oversight from commit v1.4.11~80.

References: http://bugs.debian.org/637499
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_string.c |    4 ++--
 tests/options-most.rules  |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 8cee335..257f5f8 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -229,7 +229,7 @@ print_hex_string(const char *str, const unsigned short int len)
 {
 	unsigned int i;
 	/* start hex block */
-	printf("\"|");
+	printf(" \"|");
 	for (i=0; i < len; i++) {
 		/* see if we need to prepend a zero */
 		if ((unsigned char) str[i] <= 0x0F)
@@ -238,7 +238,7 @@ print_hex_string(const char *str, const unsigned short int len)
 			printf("%x", (unsigned char) str[i]);
 	}
 	/* close hex block */
-	printf("|\" ");
+	printf("|\"");
 }
 
 static void
diff --git a/tests/options-most.rules b/tests/options-most.rules
index c2e30f2..4a3cd99 100644
--- a/tests/options-most.rules
+++ b/tests/options-most.rules
@@ -37,6 +37,7 @@
 -A INPUT -p tcp -m recent --rcheck --name DEFAULT --rsource
 -A INPUT -p tcp -m socket --transparent
 -A INPUT -p tcp -m string --string "foobar" --algo kmp --from 1 --to 2 --icase
+-A INPUT -p tcp -m string --hex-string "|00|" --algo kmp --from 1 --to 2 --icase
 -A INPUT -p tcp -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN
 -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN
 -A INPUT -p tcp -m tos --tos 0xff/0x01
-- 
1.7.3.4

