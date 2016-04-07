From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH 2/2] conntrackd: remove unnecessary separator character from usage output.
Date: Thu,  7 Apr 2016 10:21:44 +0200
Message-ID: <1460017304-21888-3-git-send-email-mart.frauenlob@chello.at>
References: <1460017304-21888-1-git-send-email-mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at02-3.mx.upcmail.net ([62.179.121.150]:25508 "EHLO
	vie01a-dmta-at02-3.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755373AbcDGIWH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 04:22:07 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-pe01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1ao5CX-0007c6-C4
	for netfilter-devel@vger.kernel.org; Thu, 07 Apr 2016 10:22:05 +0200
In-Reply-To: <1460017304-21888-1-git-send-email-mart.frauenlob@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
---
 src/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/main.c b/src/main.c
index 161f654..d12fe18 100644
--- a/src/main.c
+++ b/src/main.c
@@ -43,12 +43,12 @@ static const char usage_daemon_commands[] =
 static const char usage_client_commands[] =
 	"Client mode commands:\n"
 	"  -c [ct|expect], commit external cache to conntrack table\n"
-	"  -f [|internal|external], flush internal and external cache\n"
+	"  -f [internal|external], flush internal and external cache\n"
 	"  -F [ct|expect], flush kernel conntrack table\n"
 	"  -i [ct|expect], display content of the internal cache\n"
 	"  -e [ct|expect], display the content of the external cache\n"
 	"  -k, kill conntrack daemon\n"
-	"  -s  [|network|cache|runtime|link|rsqueue|queue|ct|expect], "
+	"  -s  [network|cache|runtime|link|rsqueue|queue|ct|expect], "
 		"dump statistics\n"
 	"  -R [ct|expect], resync with kernel conntrack table\n"
 	"  -n, request resync with other node (only FT-FW and NOTRACK modes)\n"
-- 
1.7.2.5

