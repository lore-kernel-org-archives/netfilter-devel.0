From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 7/9] xtables: fix excessive memory allocation in host_to_ipaddr
Date: Sun, 27 Feb 2011 02:31:17 +0100
Message-ID: <1298770280-7652-8-git-send-email-jengelh@medozas.de>
References: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52525 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab1B0Bbe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Feb 2011 20:31:34 -0500
In-Reply-To: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Wes Campaigne <westacular@gmail.com>

host_to_ipaddr was unnecessarily asking for an array of length n^2 to
store just n addresses.

Signed-off-by: Wes Campaigne <westacular@gmail.com>
---
 xtables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/xtables.c b/xtables.c
index 83c5b41..b45bf92 100644
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

