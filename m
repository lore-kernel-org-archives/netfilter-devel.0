From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 6/6] test: report compilation without support
Date: Thu, 31 Oct 2013 13:36:44 +0100
Message-ID: <20131031123644.32572.55345.stgit@nfdev.cica.es>
References: <20131031123618.32572.24929.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:57617 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753480Ab3JaMgs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:36:48 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 19DE751EDC3
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2013 12:36:47 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id j8KX9QHgBiOg for <netfilter-devel@vger.kernel.org>;
	Thu, 31 Oct 2013 13:36:47 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id EA5F651EDBA
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2013 13:36:46 +0100 (CET)
In-Reply-To: <20131031123618.32572.24929.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Print a message when there is no support for some parser.

Remove those EOPNOTSUPPs because they are unused.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/nft-parsing-test.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index e147e79..32c8837 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -260,7 +260,7 @@ failparsing:
 	json_decref(root);
 	return -1;
 #else
-	errno = EOPNOTSUPP;
+	printf("Compiled without support for JSON.\n");
 	return -1;
 #endif
 }
@@ -361,7 +361,7 @@ failparsing:
 	       strerror(errno));
 	return -1;
 #else
-	errno = EOPNOTSUPP;
+	printf("Compiled without support for XML.\n");
 	return -1;
 #endif
 }

