From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 4/6] test: report errors building XML tree
Date: Thu, 31 Oct 2013 13:36:34 +0100
Message-ID: <20131031123634.32572.95881.stgit@nfdev.cica.es>
References: <20131031123618.32572.24929.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:57607 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753445Ab3JaMgm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:36:42 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 6B04851EEA5
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2013 12:36:41 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eelWHCWP0TQN for <netfilter-devel@vger.kernel.org>;
	Thu, 31 Oct 2013 13:36:36 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 8F2DE51EDBA
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2013 13:36:36 +0100 (CET)
In-Reply-To: <20131031123618.32572.24929.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Report error when building XML tree.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/nft-parsing-test.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 5333dbd..3d26c3a 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -274,12 +274,18 @@ static int test_xml(const char *filename)
 	tree = mxmlLoadFile(NULL, fp, MXML_NO_CALLBACK);
 	fclose(fp);
 
-	if (tree == NULL)
+	if (tree == NULL) {
+		printf("unable to build XML tree from file %s %s\n", filename,
+		       FAILED_STR);
 		return -1;
+	}
 
 	xml = mxmlSaveAllocString(tree, MXML_NO_CALLBACK);
-	if (xml == NULL)
+	if (xml == NULL) {
+		printf("unable to alloc string from XML tree from %s %s\n",
+		       filename, FAILED_STR);
 		return -1;
+	}
 
 	/* Check what parsing should be done */
 	if (strcmp(tree->value.opaque, "table") == 0) {

