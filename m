From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/3] libxtables: remove unnecessary nesting from host_to_ip(6)addr
Date: Wed,  8 Mar 2017 17:26:56 +0100
Message-ID: <20170308162658.5697-2-jengelh@inai.de>
References: <1488983584-26091-1-git-send-email-pablo@netfilter.org>
 <20170308162658.5697-1-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:43260 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752501AbdCHQiD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 11:38:03 -0500
In-Reply-To: <20170308162658.5697-1-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The error path already terminally returns from the function, so there
is no point in having an explicit else block.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 libxtables/xtables.c | 54 +++++++++++++++++++++++-----------------------------
 1 file changed, 24 insertions(+), 30 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index d43f970..ae73a06 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1372,21 +1372,18 @@ static struct in_addr *host_to_ipaddr(const char *name, unsigned int *naddr)
 	hints.ai_socktype = SOCK_RAW;
 
 	*naddr = 0;
-	if ((err = getaddrinfo(name, NULL, &hints, &res)) != 0) {
+	err = getaddrinfo(name, NULL, &hints, &res);
+	if (err != 0)
 		return NULL;
-	} else {
-		for (p = res; p != NULL; p = p->ai_next)
-			++*naddr;
-		addr = xtables_calloc(*naddr, sizeof(struct in_addr));
-		for (i = 0, p = res; p != NULL; p = p->ai_next)
-			memcpy(&addr[i++],
-			       &((const struct sockaddr_in *)p->ai_addr)->sin_addr,
-			       sizeof(struct in_addr));
-		freeaddrinfo(res);
-		return addr;
-	}
-
-	return NULL;
+	for (p = res; p != NULL; p = p->ai_next)
+		++*naddr;
+	addr = xtables_calloc(*naddr, sizeof(struct in_addr));
+	for (i = 0, p = res; p != NULL; p = p->ai_next)
+		memcpy(&addr[i++],
+		       &((const struct sockaddr_in *)p->ai_addr)->sin_addr,
+		       sizeof(struct in_addr));
+	freeaddrinfo(res);
+	return addr;
 }
 
 static struct in_addr *
@@ -1662,23 +1659,20 @@ host_to_ip6addr(const char *name, unsigned int *naddr)
 	hints.ai_socktype = SOCK_RAW;
 
 	*naddr = 0;
-	if ((err = getaddrinfo(name, NULL, &hints, &res)) != 0) {
+	err = getaddrinfo(name, NULL, &hints, &res);
+	if (err != 0)
 		return NULL;
-	} else {
-		/* Find length of address chain */
-		for (p = res; p != NULL; p = p->ai_next)
-			++*naddr;
-		/* Copy each element of the address chain */
-		addr = xtables_calloc(*naddr, sizeof(struct in6_addr));
-		for (i = 0, p = res; p != NULL; p = p->ai_next)
-			memcpy(&addr[i++],
-			       &((const struct sockaddr_in6 *)p->ai_addr)->sin6_addr,
-			       sizeof(struct in6_addr));
-		freeaddrinfo(res);
-		return addr;
-	}
-
-	return NULL;
+	/* Find length of address chain */
+	for (p = res; p != NULL; p = p->ai_next)
+		++*naddr;
+	/* Copy each element of the address chain */
+	addr = xtables_calloc(*naddr, sizeof(struct in6_addr));
+	for (i = 0, p = res; p != NULL; p = p->ai_next)
+		memcpy(&addr[i++],
+		       &((const struct sockaddr_in6 *)p->ai_addr)->sin6_addr,
+		       sizeof(struct in6_addr));
+	freeaddrinfo(res);
+	return addr;
 }
 
 static struct in6_addr *network_to_ip6addr(const char *name)
-- 
2.10.2

