From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH 3/5] conntrack: show --src and --dst options in usage output.
Date: Thu,  7 Apr 2016 20:31:40 +0200
Message-ID: <1460053902-2200-4-git-send-email-mart.frauenlob@chello.at>
References: <1460053902-2200-1-git-send-email-mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at01-2.mx.upcmail.net ([62.179.121.146]:17998 "EHLO
	vie01a-dmta-at01-2.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757198AbcDGScW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 14:32:22 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-at01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1aoEj6-0006GL-4T
	for netfilter-devel@vger.kernel.org; Thu, 07 Apr 2016 20:32:20 +0200
In-Reply-To: <1460053902-2200-1-git-send-email-mart.frauenlob@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
---
 src/conntrack.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 162caa9..0312166 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -547,8 +547,8 @@ static const char usage_update_parameters[] =
 
 static const char usage_parameters[] =
 	"Common parameters and options:\n"
-	"  -s, --orig-src ip\t\tSource address from original direction\n"
-	"  -d, --orig-dst ip\t\tDestination address from original direction\n"
+	"  -s, --src, --orig-src ip\t\tSource address from original direction\n"
+	"  -d, --dst, --orig-dst ip\t\tDestination address from original direction\n"
 	"  -r, --reply-src ip\t\tSource addres from reply direction\n"
 	"  -q, --reply-dst ip\t\tDestination address from reply direction\n"
 	"  -p, --proto, --protonum proto\t\tLayer 4 Protocol, eg. 'tcp'\n"
-- 
1.7.2.5

