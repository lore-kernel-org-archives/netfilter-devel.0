From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/3] libxtables: abolish AI_CANONNAME
Date: Wed,  8 Mar 2017 17:42:09 +0100
Message-ID: <20170308164210.6069-2-jengelh@inai.de>
References: <1488983584-26091-1-git-send-email-pablo@netfilter.org>
 <20170308164210.6069-1-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:43612 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752620AbdCHQmQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 11:42:16 -0500
In-Reply-To: <20170308164210.6069-1-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ares->ai_canonname is never used, so there is no point in requesting
that piece of information with AI_CANONNAME.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 libxtables/xtables.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index ae73a06..891d81a 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1367,7 +1367,6 @@ static struct in_addr *host_to_ipaddr(const char *name, unsigned int *naddr)
 	unsigned int i;
 
 	memset(&hints, 0, sizeof(hints));
-	hints.ai_flags    = AI_CANONNAME;
 	hints.ai_family   = AF_INET;
 	hints.ai_socktype = SOCK_RAW;
 
@@ -1654,7 +1653,6 @@ host_to_ip6addr(const char *name, unsigned int *naddr)
 	unsigned int i;
 
 	memset(&hints, 0, sizeof(hints));
-	hints.ai_flags    = AI_CANONNAME;
 	hints.ai_family   = AF_INET6;
 	hints.ai_socktype = SOCK_RAW;
 
-- 
2.10.2

