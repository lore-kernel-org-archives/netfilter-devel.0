From: Oliver Ford <ojford@gmail.com>
Subject: [PATCH 1/1] libxtables: Display weird character warning for wildcards
Date: Fri,  5 May 2017 11:11:50 +0000
Message-ID: <1493982710-10847-1-git-send-email-ojford@gmail.com>
Cc: Oliver Ford <ojford@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36253 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751090AbdEELMU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2017 07:12:20 -0400
Received: by mail-wm0-f68.google.com with SMTP id u65so652418wmu.3
        for <netfilter-devel@vger.kernel.org>; Fri, 05 May 2017 04:12:20 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Change the scope of the weird character check loop so that
it checks for invalid characters when the interface name
contains a wildcard.

Fixes Bugzilla #1085.

Signed-off-by: Oliver Ford <ojford@gmail.com>
---
 libxtables/xtables.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 891d81a..57a1102 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -538,15 +538,15 @@ void xtables_parse_interface(const char *arg, char *vianame,
 	} else {
 		/* Include nul-terminator in match */
 		memset(mask, 0xFF, vialen + 1);
-		for (i = 0; vianame[i]; i++) {
-			if (vianame[i] == '/' ||
-			    vianame[i] == ' ') {
-				fprintf(stderr,
-					"Warning: weird character in interface"
-					" `%s' ('/' and ' ' are not allowed by the kernel).\n",
-					vianame);
-				break;
-			}
+	}
+
+	/* Display warning on invalid characters */
+	for (i = 0; vianame[i]; i++) {
+		if (vianame[i] == '/' || vianame[i] == ' ') {
+			fprintf(stderr,	"Warning: weird character in interface"
+				" `%s' ('/' and ' ' are not allowed by the kernel).\n",
+				vianame);
+			break;
 		}
 	}
 }
-- 
2.11.0


