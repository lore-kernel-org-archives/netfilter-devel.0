From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] tests: fix undefined symbol
Date: Thu, 07 Nov 2013 10:39:55 +0100
Message-ID: <20131107093955.24819.37152.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:37706 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750802Ab3KGJkG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Nov 2013 04:40:06 -0500
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id BD37E51ED71
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2013 09:40:02 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uuBEcwQBsisT for <netfilter-devel@vger.kernel.org>;
	Thu,  7 Nov 2013 10:39:57 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id CB4DC51ED6D
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2013 10:39:57 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Kill undefined and unused symbol.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/nft-parsing-test.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index e2931a6..9fa69ae 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -274,15 +274,15 @@ static int test_xml(const char *filename)
 	fclose(fp);
 
 	if (tree == NULL) {
-		printf("unable to build XML tree from file %s %s\n", filename,
-		       FAILED_STR);
+		printf("unable to build XML tree from file "
+		       "%s \033[31mFAILED\e[0m\n", filename);
 		return -1;
 	}
 
 	xml = mxmlSaveAllocString(tree, MXML_NO_CALLBACK);
 	if (xml == NULL) {
-		printf("unable to alloc string from XML tree from %s %s\n",
-		       filename, FAILED_STR);
+		printf("unable to alloc string from XML tree from %s "
+		       "\033[31mFAILED\e[0m\n", filename);
 		return -1;
 	}
 

