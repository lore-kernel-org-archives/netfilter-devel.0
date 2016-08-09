From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/3] scanner: don't fall back on current directory if include is not found
Date: Tue,  9 Aug 2016 11:29:41 +0200
Message-ID: <1470734982-10298-2-git-send-email-pablo@netfilter.org>
References: <1470734982-10298-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54854 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbcHIJaR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Aug 2016 05:30:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D1BB4E9766
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 11:30:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BF9A81B333F
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 11:30:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 432D21B3325
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 11:30:11 +0200 (CEST)
In-Reply-To: <1470734982-10298-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This resolves an ambiguity if the same file name is used both under
sysconfdir and the current working directory.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1040
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/scanner.l | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index 6f1a551..cb2ea32 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -639,16 +639,15 @@ int scanner_include_file(void *scanner, const char *filename,
 			if (f != NULL)
 				break;
 		}
-	}
-	if (f == NULL) {
+	} else {
 		f = fopen(filename, "r");
-		if (f == NULL) {
-			erec = error(loc, "Could not open file \"%s\": %s\n",
-				     filename, strerror(errno));
-			goto err;
-		}
 		name = filename;
 	}
+	if (f == NULL) {
+		erec = error(loc, "Could not open file \"%s\": %s\n",
+			     filename, strerror(errno));
+		goto err;
+	}
 
 	erec = scanner_push_file(scanner, name, f, loc);
 	if (erec != NULL)
-- 
2.1.4

