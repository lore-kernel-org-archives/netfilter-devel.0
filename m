From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH 2/4] nfct: correct command list in timeout usage error message.
Date: Fri,  8 Apr 2016 08:18:42 +0200
Message-ID: <1460096324-17426-3-git-send-email-mart.frauenlob@chello.at>
References: <1460096324-17426-1-git-send-email-mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at03-2.mx.upcmail.net ([62.179.121.152]:51733 "EHLO
	vie01a-dmta-at03-2.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752616AbcDHGS4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 02:18:56 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-at03.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1aoPks-0004R3-1N
	for netfilter-devel@vger.kernel.org; Fri, 08 Apr 2016 08:18:54 +0200
In-Reply-To: <1460096324-17426-1-git-send-email-mart.frauenlob@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
---
 src/nfct-extensions/timeout.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/nfct-extensions/timeout.c b/src/nfct-extensions/timeout.c
index 1cb04a1..30f9464 100644
--- a/src/nfct-extensions/timeout.c
+++ b/src/nfct-extensions/timeout.c
@@ -32,7 +32,7 @@ static void
 nfct_cmd_timeout_usage(char *argv[])
 {
 	fprintf(stderr, "nfct v%s: Missing command\n"
-			"%s <list|add|delete|get|flush|set> timeout "
+			"%s <list|add|delete|get|default-set|default-get|flush> timeout "
 			"[<parameters>, ...]\n", VERSION, argv[0]);
 }
 
-- 
1.7.2.5

