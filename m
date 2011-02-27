From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 9/9] xtables: use all IPv6 addresses resolved from a hostname
Date: Sun, 27 Feb 2011 02:31:19 +0100
Message-ID: <1298770280-7652-10-git-send-email-jengelh@medozas.de>
References: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52529 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab1B0Bbg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Feb 2011 20:31:36 -0500
In-Reply-To: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Wes Campaigne <westacular@gmail.com>

Fixes a long-standing issue where host_to_ip6addr would only ever
examine/return the first item of the address chain returned by
getaddrinfo, instead of traversing the chain and copying each of them.

This has always been how host_to_ip6addr behaves, and all of the other
related IPv6 code is already written to handle multiple possible
addresses.

[Style fixups. Removal of redundant i<*naddrs check. -j.eng]

Signed-off-by: Wes Campaigne <westacular@gmail.com>
---
 xtables.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/xtables.c b/xtables.c
index 660fbd0..2f00e39 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1420,10 +1420,11 @@ struct in6_addr *xtables_numeric_to_ip6addr(const char *num)
 static struct in6_addr *
 host_to_ip6addr(const char *name, unsigned int *naddr)
 {
-	static struct in6_addr *addr;
+	struct in6_addr *addr;
 	struct addrinfo hints;
-	struct addrinfo *res;
+	struct addrinfo *res, *p;
 	int err;
+	unsigned int i;
 
 	memset(&hints, 0, sizeof(hints));
 	hints.ai_flags    = AI_CANONNAME;
@@ -1437,20 +1438,20 @@ host_to_ip6addr(const char *name, unsigned int *naddr)
 #endif
 		return NULL;
 	} else {
-		if (res->ai_family != AF_INET6 ||
-		    res->ai_addrlen != sizeof(struct sockaddr_in6))
-			return NULL;
-
+		/* Find length of address chain */
+		for (p = res; p != NULL; p = p->ai_next)
+			++*naddr;
 #ifdef DEBUG
 		fprintf(stderr, "resolved: len=%d  %s ", res->ai_addrlen,
 		        xtables_ip6addr_to_numeric(&((struct sockaddr_in6 *)res->ai_addr)->sin6_addr));
 #endif
-		/* Get the first element of the address-chain */
-		addr = xtables_malloc(sizeof(struct in6_addr));
-		memcpy(addr, &((const struct sockaddr_in6 *)res->ai_addr)->sin6_addr,
-		       sizeof(struct in6_addr));
+		/* Copy each element of the address chain */
+		addr = xtables_calloc(*naddr, sizeof(struct in6_addr));
+		for (i = 0, p = res; p != NULL; p = p->ai_next)
+			memcpy(&addr[i++],
+			       &((const struct sockaddr_in6 *)p->ai_addr)->sin6_addr,
+			       sizeof(struct in6_addr));
 		freeaddrinfo(res);
-		*naddr = 1;
 		return addr;
 	}
 
@@ -1562,12 +1563,6 @@ xtables_ip6parse_multiple(const char *name, struct in6_addr **addrpp,
 			strcpy(buf, "::");
 
 		addrp = ip6parse_hostnetwork(buf, &n);
-		/* ip6parse_hostnetwork only ever returns one IP
-		address (it exits if the resolution fails).
-		Therefore, n will always be 1 here.  Leaving the
-		code below in anyway in case ip6parse_hostnetwork
-		is improved some day to behave like
-		ipparse_hostnetwork: */
 		if (n > 1) {
 			count += n - 1;
 			*addrpp = xtables_realloc(*addrpp,
-- 
1.7.1

