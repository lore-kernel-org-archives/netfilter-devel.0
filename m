From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 2/6] test: fix memleak in XML testing
Date: Thu, 31 Oct 2013 13:36:23 +0100
Message-ID: <20131031123623.32572.16985.stgit@nfdev.cica.es>
References: <20131031123618.32572.24929.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:57588 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752982Ab3JaMg2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:36:28 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 4A04D51EEA5
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2013 12:36:26 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O5nl0553A7nG for <netfilter-devel@vger.kernel.org>;
	Thu, 31 Oct 2013 13:36:26 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 2B2D351EDBA
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2013 13:36:26 +0100 (CET)
In-Reply-To: <20131031123618.32572.24929.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ensure the tree is freed when done.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/nft-parsing-test.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 70028a0..5eaaa1e 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -335,9 +335,11 @@ static int test_xml(const char *filename)
 		}
 	}
 
+	mxmlDelete(tree);
 	return ret;
 
 failparsing:
+	mxmlDelete(tree);
 	printf("parsing %s: ", filename);
 	printf("\033[31mFAILED\e[0m (%s)\n", strerror(errno));
 	return -1;

