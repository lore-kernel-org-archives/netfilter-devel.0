From: Wes Campaigne <westacular@gmail.com>
Subject: [PATCH 4/4] xtables: use the correct loop count when applying masks to addresses
Date: Mon, 21 Feb 2011 19:10:13 -0500
Message-ID: <1298333413-14253-5-git-send-email-westacular@gmail.com>
References: <1298333413-14253-1-git-send-email-westacular@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60696 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab1BVAKp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Feb 2011 19:10:45 -0500
Received: by mail-iy0-f174.google.com with SMTP id 26so1267218iyb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Feb 2011 16:10:45 -0800 (PST)
In-Reply-To: <1298333413-14253-1-git-send-email-westacular@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

'n' is a subtotal from the inner loop; 'count' is the total number
of addrs/masks. This problem wasn't merely cosmetic -- rules where
the address has not been zeroed in accordance with the mask are 
silently ignored by netfilter.

Signed-off-by: Wes Campaigne <westacular@gmail.com>
---
 xtables.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/xtables.c b/xtables.c
index c96efa0..f872754 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1272,7 +1272,7 @@ void xtables_ipparse_multiple(const char *name, struct in_addr **addrpp,
 		free(addrp);
 	}
 	*naddrs = count;
-	for (i = 0; i < n; ++i)
+	for (i = 0; i < count; ++i)
 		(*addrpp+i)->s_addr &= (*maskpp+i)->s_addr;
 }
 
@@ -1581,7 +1581,7 @@ xtables_ip6parse_multiple(const char *name, struct in6_addr **addrpp,
 		free(addrp);
 	}
 	*naddrs = count;
-	for (i = 0; i < n; ++i)
+	for (i = 0; i < count; ++i)
 		for (j = 0; j < 4; ++j)
 			(*addrpp+i)->s6_addr32[j] &= (*maskpp+i)->s6_addr32[j];
 }
-- 
1.7.1

