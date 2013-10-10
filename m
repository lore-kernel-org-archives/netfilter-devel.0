From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nftables PATCH] src: fix return code
Date: Thu, 10 Oct 2013 23:11:56 +0200
Message-ID: <20131010211156.12209.65147.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:47959 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755470Ab3JJVMC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:12:02 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 712CB51ED67
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2013 21:12:00 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4scQ9NSc5a5i for <netfilter-devel@vger.kernel.org>;
	Thu, 10 Oct 2013 23:12:00 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 509C951ED2B
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2013 23:12:00 +0200 (CEST)
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
 src/main.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/main.c b/src/main.c
index 3ddcb71..9aa5f1b 100644
--- a/src/main.c
+++ b/src/main.c
@@ -222,7 +222,7 @@ int main(int argc, char * const *argv)
 	char *buf = NULL, *filename = NULL;
 	unsigned int len;
 	bool interactive = false;
-	int i, val;
+	int i, val, rc = NFT_EXIT_FAILURE;
 
 	while (1) {
 		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
@@ -318,11 +318,12 @@ int main(int argc, char * const *argv)
 		exit(NFT_EXIT_FAILURE);
 	}
 
-	nft_run(scanner, &state, &msgs);
+	if (nft_run(scanner, &state, &msgs) == 0)
+		rc = NFT_EXIT_SUCCESS;
 out:
 	scanner_destroy(scanner);
 	erec_print_list(stdout, &msgs);
 
 	xfree(buf);
-	return 0;
+	exit(rc);
 }

