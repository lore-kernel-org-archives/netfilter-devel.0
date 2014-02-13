From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2 nft] meta: remove line break when printing priority
Date: Thu, 13 Feb 2014 12:41:11 +0100
Message-ID: <1392291672-7885-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43469 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbaBMLlY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:41:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The line break is added after printing the rule.
---
 src/meta.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index 0a3df39..af5c3f9 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -75,11 +75,11 @@ static void tchandle_type_print(const struct expr *expr)
 		printf("none\n");
 	default:
 		if (TC_H_MAJ(handle) == 0)
-			printf(":%04x\n", TC_H_MIN(handle));
+			printf(":%04x", TC_H_MIN(handle));
 		else if (TC_H_MIN(handle) == 0)
-			printf("%04x:\n", TC_H_MAJ(handle) >> 16);
+			printf("%04x:", TC_H_MAJ(handle) >> 16);
 		else {
-			printf("%04x:%04x\n",
+			printf("%04x:%04x",
 			       TC_H_MAJ(handle) >> 16, TC_H_MIN(handle));
 		}
 		break;
-- 
1.7.10.4

