From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 08/10] src: simplify classid printing using %x instead of %04x
Date: Wed, 17 Aug 2016 15:29:59 +0200
Message-ID: <1471440601-5327-9-git-send-email-pablo@netfilter.org>
References: <1471440601-5327-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44048 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbcHQNaP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 09:30:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 16E94E9773
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 03554DA7FD
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D1D21DA7E5
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:11 +0200 (CEST)
In-Reply-To: <1471440601-5327-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

No need to print this in iptables CLASSIFY target format,
eg. 0004:1230, this is innecessarily large.

And always print major and minor numbers.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/meta.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index c7967b0..1b17819 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -80,14 +80,7 @@ static void tchandle_type_print(const struct expr *expr)
 		printf("none");
 		break;
 	default:
-		if (TC_H_MAJ(handle) == 0)
-			printf(":%04x", TC_H_MIN(handle));
-		else if (TC_H_MIN(handle) == 0)
-			printf("%04x:", TC_H_MAJ(handle) >> 16);
-		else {
-			printf("%04x:%04x",
-			       TC_H_MAJ(handle) >> 16, TC_H_MIN(handle));
-		}
+		printf("%0x:%0x", TC_H_MAJ(handle) >> 16, TC_H_MIN(handle));
 		break;
 	}
 }
-- 
2.1.4

