From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH 1/5] conntrack: add --proto to usage output.
Date: Thu,  7 Apr 2016 20:31:38 +0200
Message-ID: <1460053902-2200-2-git-send-email-mart.frauenlob@chello.at>
References: <1460053902-2200-1-git-send-email-mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at02-3.mx.upcmail.net ([62.179.121.150]:31791 "EHLO
	vie01a-dmta-at02-3.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757314AbcDGScX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 14:32:23 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-pe01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1aoEj5-0004KO-Vc
	for netfilter-devel@vger.kernel.org; Thu, 07 Apr 2016 20:32:19 +0200
In-Reply-To: <1460053902-2200-1-git-send-email-mart.frauenlob@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
---
 src/conntrack.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index dadbea5..162caa9 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -551,7 +551,7 @@ static const char usage_parameters[] =
 	"  -d, --orig-dst ip\t\tDestination address from original direction\n"
 	"  -r, --reply-src ip\t\tSource addres from reply direction\n"
 	"  -q, --reply-dst ip\t\tDestination address from reply direction\n"
-	"  -p, --protonum proto\t\tLayer 4 Protocol, eg. 'tcp'\n"
+	"  -p, --proto, --protonum proto\t\tLayer 4 Protocol, eg. 'tcp'\n"
 	"  -f, --family proto\t\tLayer 3 Protocol, eg. 'ipv6'\n"
 	"  -t, --timeout timeout\t\tSet timeout\n"
 	"  -u, --status status\t\tSet status, eg. ASSURED\n"
-- 
1.7.2.5

