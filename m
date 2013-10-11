From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nftables PATCH v2] src: fix return code
Date: Fri, 11 Oct 2013 13:03:08 +0200
Message-ID: <20131011110235.2912.77468.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:43062 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932304Ab3JKLDU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:03:20 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 961F651ED67
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2013 11:03:17 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TxwUq4ktzQIG for <netfilter-devel@vger.kernel.org>;
	Fri, 11 Oct 2013 13:03:12 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 8BB8B51ED53
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2013 13:03:11 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Exit with NFT_EXIT_FAILURE if something went wrong in the netlink zone.

Before this patch:

# nft list chain filter asd ; echo $?
internal:0:0-0: Error: Could not find chain `asd' in table `filter': [...]

0

After this patch:

# nft list chain filter asd ; echo $?
internal:0:0-0: Error: Could not find chain `asd' in table `filter': [...]

1

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: assume NFT_EXIT_SUCCESS. Do return rc instead of exit(rc).

 src/main.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/main.c b/src/main.c
index 3ddcb71..0c97120 100644
--- a/src/main.c
+++ b/src/main.c
@@ -222,7 +222,7 @@ int main(int argc, char * const *argv)
 	char *buf = NULL, *filename = NULL;
 	unsigned int len;
 	bool interactive = false;
-	int i, val;
+	int i, val, rc = NFT_EXIT_SUCCESS;
 
 	while (1) {
 		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
@@ -318,11 +318,12 @@ int main(int argc, char * const *argv)
 		exit(NFT_EXIT_FAILURE);
 	}
 
-	nft_run(scanner, &state, &msgs);
+	if (nft_run(scanner, &state, &msgs) != 0)
+		rc = NFT_EXIT_FAILURE;
 out:
 	scanner_destroy(scanner);
 	erec_print_list(stdout, &msgs);
 
 	xfree(buf);
-	return 0;
+	return rc;
 }

