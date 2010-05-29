From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] RAWNAT: fix rawnat_ipv6_mask()
Date: Sat, 29 May 2010 16:10:51 +0800
Message-ID: <1275120651-18360-1-git-send-email-xiaosuo@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33613 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab0E2IML (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 May 2010 04:12:11 -0400
Received: by pwj2 with SMTP id 2so88378pwj.19
        for <netfilter-devel@vger.kernel.org>; Sat, 29 May 2010 01:12:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

fix rawnat_ipv6_mask()

I really think it is a typo mistake. :)

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
---
 extensions/xt_RAWNAT.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)
diff --git a/extensions/xt_RAWNAT.c b/extensions/xt_RAWNAT.c
index f256e4c..063dcbe 100644
--- a/extensions/xt_RAWNAT.c
+++ b/extensions/xt_RAWNAT.c
@@ -48,7 +48,7 @@ rawnat_ipv6_mask(__be32 *addr, const __be32 *repl, unsigned int mask)
 		break;
 	case 33 ... 63:
 		addr[0] = repl[0];
-		addr[1] = remask(addr[1], repl[1], mask - 64);
+		addr[1] = remask(addr[1], repl[1], mask - 32);
 		break;
 	case 64:
 		addr[0] = repl[0];
@@ -57,7 +57,7 @@ rawnat_ipv6_mask(__be32 *addr, const __be32 *repl, unsigned int mask)
 	case 65 ... 95:
 		addr[0] = repl[0];
 		addr[1] = repl[1];
-		addr[2] = remask(addr[2], repl[2], mask - 96);
+		addr[2] = remask(addr[2], repl[2], mask - 64);
 	case 96:
 		addr[0] = repl[0];
 		addr[1] = repl[1];
@@ -67,7 +67,7 @@ rawnat_ipv6_mask(__be32 *addr, const __be32 *repl, unsigned int mask)
 		addr[0] = repl[0];
 		addr[1] = repl[1];
 		addr[2] = repl[2];
-		addr[3] = remask(addr[3], repl[3], mask - 128);
+		addr[3] = remask(addr[3], repl[3], mask - 96);
 		break;
 	case 128:
 		addr[0] = repl[0];
