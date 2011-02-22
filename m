From: Wes Campaigne <westacular@gmail.com>
Subject: [PATCH 1/4] xtables: use *all* IPv6 addresses resolved from a hostname
Date: Mon, 21 Feb 2011 19:10:10 -0500
Message-ID: <1298333413-14253-2-git-send-email-westacular@gmail.com>
References: <1298333413-14253-1-git-send-email-westacular@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65058 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab1BVAKl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Feb 2011 19:10:41 -0500
Received: by mail-iw0-f174.google.com with SMTP id 34so21597iwn.19
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Feb 2011 16:10:41 -0800 (PST)
In-Reply-To: <1298333413-14253-1-git-send-email-westacular@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes a long-standing issue where host_to_ip6addr would only ever
examine/return the only the first item of the address chain
returned by getaddrinfo, instead of traversing the chain and
copying each of them.

This has always been how host_to_ipaddr behaves, and all of the other
related ipv6 code is already written to handle multiple possible addresses.

Signed-off-by: Wes Campaigne <westacular@gmail.com>
---
 xtables.c |   29 +++++++++++------------------
 1 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/xtables.c b/xtables.c
index 57d5d13..aea32ca 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1415,17 +1415,17 @@ struct in6_addr *xtables_numeric_to_ip6addr(const char *num)
 static struct in6_addr *
 host_to_ip6addr(const char *name, unsigned int *naddr)
 {
-	static struct in6_addr *addr;
+	struct in6_addr *addr;
 	struct addrinfo hints;
 	struct addrinfo *res;
+	struct addrinfo *p;
 	int err;
+	unsigned int i;
 
 	memset(&hints, 0, sizeof(hints));
 	hints.ai_flags    = AI_CANONNAME;
 	hints.ai_family   = AF_INET6;
 	hints.ai_socktype = SOCK_RAW;
-	hints.ai_protocol = IPPROTO_IPV6;
-	hints.ai_next     = NULL;
 
 	*naddr = 0;
 	if ((err = getaddrinfo(name, NULL, &hints, &res)) != 0) {
@@ -1434,20 +1434,19 @@ host_to_ip6addr(const char *name, unsigned int *naddr)
 #endif
 		return NULL;
 	} else {
-		if (res->ai_family != AF_INET6 ||
-		    res->ai_addrlen != sizeof(struct sockaddr_in6))
-			return NULL;
-
+		/* Find length of address-chain */
+		for(p = res; p != NULL; p = p->ai_next)
+			(*naddr)++;
 #ifdef DEBUG
 		fprintf(stderr, "resolved: len=%d  %s ", res->ai_addrlen,
 		        xtables_ip6addr_to_numeric(&((struct sockaddr_in6 *)res->ai_addr)->sin6_addr));
 #endif
-		/* Get the first element of the address-chain */
-		addr = xtables_malloc(sizeof(struct in6_addr));
-		memcpy(addr, &((const struct sockaddr_in6 *)res->ai_addr)->sin6_addr,
-		       sizeof(struct in6_addr));
+		/* Copy each element of the address-chain */
+		addr = xtables_calloc(*naddr, sizeof(struct in6_addr));
+		for(p = res, i = 0; p != NULL && i < *naddr; p = p->ai_next, i++)
+			memcpy(&addr[i], &((const struct sockaddr_in6 *)p->ai_addr)->sin6_addr,
+			       sizeof(struct in6_addr));
 		freeaddrinfo(res);
-		*naddr = 1;
 		return addr;
 	}
 
@@ -1559,12 +1558,6 @@ xtables_ip6parse_multiple(const char *name, struct in6_addr **addrpp,
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

