From: Wes Campaigne <westacular@gmail.com>
Subject: [PATCH 2/4] xtables: fix excessive memory allocation in host_to_ipaddr
Date: Mon, 21 Feb 2011 19:10:11 -0500
Message-ID: <1298333413-14253-3-git-send-email-westacular@gmail.com>
References: <1298333413-14253-1-git-send-email-westacular@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60696 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab1BVAKn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Feb 2011 19:10:43 -0500
Received: by iyb26 with SMTP id 26so1267218iyb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Feb 2011 16:10:42 -0800 (PST)
In-Reply-To: <1298333413-14253-1-git-send-email-westacular@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

host_to_ipaddr was unnecessarily asking for an array of length n^2
to store just n addresses.

Signed-off-by: Wes Campaigne <westacular@gmail.com>
---
 xtables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/xtables.c b/xtables.c
index aea32ca..9a51e81 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1143,7 +1143,7 @@ static struct in_addr *host_to_ipaddr(const char *name, unsigned int *naddr)
 
 		while (host->h_addr_list[*naddr] != NULL)
 			++*naddr;
-		addr = xtables_calloc(*naddr, sizeof(struct in_addr) * *naddr);
+		addr = xtables_calloc(*naddr, sizeof(struct in_addr));
 		for (i = 0; i < *naddr; i++)
 			memcpy(&addr[i], host->h_addr_list[i],
 			       sizeof(struct in_addr));
-- 
1.7.1

