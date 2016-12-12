From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH 1/2] libxtables: xtables: remove unnecessary debug code
Date: Mon, 12 Dec 2016 20:23:56 +0530
Message-ID: <1481554437-20319-1-git-send-email-mayhs11saini@gmail.com>
Cc: Shyam Saini <mayhs11saini@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35520 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbcLLOyL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Dec 2016 09:54:11 -0500
Received: by mail-pg0-f68.google.com with SMTP id p66so1195905pga.2
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Dec 2016 06:54:10 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove unnecessary debug code

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 libxtables/xtables.c | 33 +++++----------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 921dfe9..6e75c15 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1366,17 +1366,10 @@ static struct in_addr *host_to_ipaddr(const char *name, unsigned int *naddr)
 
 	*naddr = 0;
 	if ((err = getaddrinfo(name, NULL, &hints, &res)) != 0) {
-#ifdef DEBUG
-		fprintf(stderr,"Name2IP: %s\n",gai_strerror(err));
-#endif
 		return NULL;
 	} else {
 		for (p = res; p != NULL; p = p->ai_next)
 			++*naddr;
-#ifdef DEBUG
-		fprintf(stderr, "resolved: len=%d  %s ", res->ai_addrlen,
-		        xtables_ipaddr_to_numeric(&((struct sockaddr_in *)res->ai_addr)->sin_addr));
-#endif
 		addr = xtables_calloc(*naddr, sizeof(struct in_addr));
 		for (i = 0, p = res; p != NULL; p = p->ai_next)
 			memcpy(&addr[i++],
@@ -1576,18 +1569,11 @@ static const char *ip6addr_to_host(const struct in6_addr *addr)
 	memcpy(&saddr.sin6_addr, addr, sizeof(*addr));
 	saddr.sin6_family = AF_INET6;
 
-	err = getnameinfo((const void *)&saddr, sizeof(struct sockaddr_in6),
-	      hostname, sizeof(hostname) - 1, NULL, 0, 0);
-	if (err != 0) {
-#ifdef DEBUG
-		fprintf(stderr,"IP2Name: %s\n",gai_strerror(err));
-#endif
+	err = getnameinfo((const void *)&saddr, sizeof(struct sockaddr_in6),
+			hostname, sizeof(hostname) - 1, NULL, 0, 0);
+	if (err != 0)
 		return NULL;
-	}
-
-#ifdef DEBUG
-	fprintf (stderr, "\naddr2host: %s\n", hostname);
-#endif
+
 	return hostname;
 }
 
@@ -1650,9 +1636,7 @@ struct in6_addr *xtables_numeric_to_ip6addr(const char *num)
 
 	if ((err = inet_pton(AF_INET6, num, &ap)) == 1)
 		return &ap;
-#ifdef DEBUG
-	fprintf(stderr, "\nnumeric2addr: %d\n", err);
-#endif
+
 	return NULL;
 }
 
@@ -1672,18 +1656,11 @@ host_to_ip6addr(const char *name, unsigned int *naddr)
 
 	*naddr = 0;
 	if ((err = getaddrinfo(name, NULL, &hints, &res)) != 0) {
-#ifdef DEBUG
-		fprintf(stderr,"Name2IP: %s\n",gai_strerror(err));
-#endif
 		return NULL;
 	} else {
 		/* Find length of address chain */
 		for (p = res; p != NULL; p = p->ai_next)
 			++*naddr;
-#ifdef DEBUG
-		fprintf(stderr, "resolved: len=%d  %s ", res->ai_addrlen,
-		        xtables_ip6addr_to_numeric(&((struct sockaddr_in6 *)res->ai_addr)->sin6_addr));
-#endif
 		/* Copy each element of the address chain */
 		addr = xtables_calloc(*naddr, sizeof(struct in6_addr));
 		for (i = 0, p = res; p != NULL; p = p->ai_next)
-- 
2.7.4

