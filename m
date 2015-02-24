From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft v2] main: display errors through stderr
Date: Tue, 24 Feb 2015 19:32:50 +0100
Message-ID: <1424802770-31213-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, alexandre@r42.ch
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40518 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbbBXS3W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2015 13:29:22 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Debugging still goes through stdout as Patrick requests.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1000
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/main.c b/src/main.c
index b447aad..4590c30 100644
--- a/src/main.c
+++ b/src/main.c
@@ -361,7 +361,7 @@ int main(int argc, char * const *argv)
 		rc = NFT_EXIT_FAILURE;
 out:
 	scanner_destroy(scanner);
-	erec_print_list(stdout, &msgs);
+	erec_print_list(stderr, &msgs);
 
 	xfree(buf);
 	return rc;
-- 
1.7.10.4

