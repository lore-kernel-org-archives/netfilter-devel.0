From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] tests: use the error reporting infraestructure
Date: Sat, 18 Jan 2014 22:23:02 +0100
Message-ID: <20140118212302.12195.86634.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55818 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751400AbaARVXR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Jan 2014 16:23:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In commit dec6874 [data_reg: fix verdict format approach] I added an unrelated
loose line to nft-parsing-test.c

That line made use of the libnftables parsing error reporting, and is actually
really useful.

So lets use it officially in nft-parsing-test.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/nft-parsing-test.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index df981ad..63f7950 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -121,7 +121,7 @@ failparsing:
 	fclose(fp);
 	printf("parsing %s: ", filename);
 	printf("\033[31mFAILED\e[0m (%s)\n", strerror(errno));
-	nft_parse_perror("fail", err);
+	nft_parse_perror("Detailed error", err);
 	return -1;
 }
 
@@ -158,6 +158,7 @@ failparsing:
 	fclose(fp);
 	printf("parsing %s: ", filename);
 	printf("\033[31mFAILED\e[0m (%s)\n", strerror(errno));
+	nft_parse_perror("Detailed error", err);
 	return -1;
 }
 

