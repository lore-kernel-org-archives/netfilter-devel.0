From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH 3/4] nfct: helper: correct error messages.
Date: Fri,  8 Apr 2016 08:18:43 +0200
Message-ID: <1460096324-17426-4-git-send-email-mart.frauenlob@chello.at>
References: <1460096324-17426-1-git-send-email-mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at02-1.mx.upcmail.net ([62.179.121.148]:64388 "EHLO
	vie01a-dmta-at02-1.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753001AbcDHGS4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 02:18:56 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-pe01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1aoPks-0003h4-3w
	for netfilter-devel@vger.kernel.org; Fri, 08 Apr 2016 08:18:54 +0200
In-Reply-To: <1460096324-17426-1-git-send-email-mart.frauenlob@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
---
 src/nfct-extensions/helper.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/nfct-extensions/helper.c b/src/nfct-extensions/helper.c
index dfc55e7..0569827 100644
--- a/src/nfct-extensions/helper.c
+++ b/src/nfct-extensions/helper.c
@@ -33,7 +33,7 @@ static void
 nfct_cmd_helper_usage(char *argv[])
 {
 	fprintf(stderr, "nfct v%s: Missing command\n"
-			"%s helper list|add|delete|get|flush "
+			"%s helper list|add|delete|disable|get|flush "
 			"[parameters...]\n", VERSION, argv[0]);
 }
 
@@ -408,7 +408,7 @@ nfct_cmd_helper_disable(struct mnl_socket *nl, int argc, char *argv[])
 
 	if (argc < 6) {
 		nfct_perror("missing parameters\n"
-			    "syntax: nfct add helper name family protocol");
+			    "syntax: nfct disable helper name family protocol");
 		return -1;
 	}
 
-- 
1.7.2.5

