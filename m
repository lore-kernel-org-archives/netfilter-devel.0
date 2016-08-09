From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/3] scanner: don't break line on include error message
Date: Tue,  9 Aug 2016 11:29:42 +0200
Message-ID: <1470734982-10298-3-git-send-email-pablo@netfilter.org>
References: <1470734982-10298-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54860 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbcHIJaQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Aug 2016 05:30:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C0D8DE976E
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 11:30:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B231FFF2D6
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 11:30:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6E1C7FF2D6
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 11:30:12 +0200 (CEST)
In-Reply-To: <1470734982-10298-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For consistency with other error messages in this codebase, don't add a
line break.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/scanner.l | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/scanner.l b/src/scanner.l
index cb2ea32..613c3c9 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -644,7 +644,7 @@ int scanner_include_file(void *scanner, const char *filename,
 		name = filename;
 	}
 	if (f == NULL) {
-		erec = error(loc, "Could not open file \"%s\": %s\n",
+		erec = error(loc, "Could not open file \"%s\": %s",
 			     filename, strerror(errno));
 		goto err;
 	}
-- 
2.1.4

