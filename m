From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH] conntrack: Add missing tables dying and unconfirmed to usage output.
Date: Mon,  4 Apr 2016 11:43:57 +0200
Message-ID: <1459763037-10400-1-git-send-email-mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at02-3.mx.upcmail.net ([62.179.121.150]:61194 "EHLO
	vie01a-dmta-at02-3.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810AbcDDJoC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Apr 2016 05:44:02 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-pe01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1an13A-0000zT-KZ
	for netfilter-devel@vger.kernel.org; Mon, 04 Apr 2016 11:44:00 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
---
 src/conntrack.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index d40f23f..b384e07 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -520,7 +520,7 @@ static const char usage_commands[] =
 	"  -S\t\t\t\tShow statistics\n";
 
 static const char usage_tables[] =
-	"Tables: conntrack, expect\n";
+	"Tables: conntrack, expect, dying, unconfirmed\n";
 
 static const char usage_conntrack_parameters[] =
 	"Conntrack parameters and options:\n"
-- 
1.7.2.5

