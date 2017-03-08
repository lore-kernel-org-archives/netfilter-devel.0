From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 3/3] libxtables: avoid returning duplicate address for host resolution
Date: Wed,  8 Mar 2017 17:42:10 +0100
Message-ID: <20170308164210.6069-3-jengelh@inai.de>
References: <1488983584-26091-1-git-send-email-pablo@netfilter.org>
 <20170308164210.6069-1-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:43614 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753476AbdCHQmQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 11:42:16 -0500
In-Reply-To: <20170308164210.6069-1-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A long-standing problem has been that `iptables -s any_host_here`
could yield multiple rules with the same address if the DNS was
indeed so populated.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 libxtables/xtables.c | 44 ++++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 891d81a..d994306 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1364,7 +1364,7 @@ static struct in_addr *host_to_ipaddr(const char *name, unsigned int *naddr)
 	struct addrinfo hints;
 	struct addrinfo *res, *p;
 	int err;
-	unsigned int i;
+	size_t i, j;
 
 	memset(&hints, 0, sizeof(hints));
 	hints.ai_family   = AF_INET;
@@ -1374,14 +1374,23 @@ static struct in_addr *host_to_ipaddr(const char *name, unsigned int *naddr)
 	err = getaddrinfo(name, NULL, &hints, &res);
 	if (err != 0)
 		return NULL;
-	for (p = res; p != NULL; p = p->ai_next)
-		++*naddr;
 	addr = xtables_calloc(*naddr, sizeof(struct in_addr));
-	for (i = 0, p = res; p != NULL; p = p->ai_next)
-		memcpy(&addr[i++],
-		       &((const struct sockaddr_in *)p->ai_addr)->sin_addr,
-		       sizeof(struct in_addr));
+	for (i = 0, p = res; p != NULL; p = p->ai_next) {
+		const struct sockaddr_in *newaddr = (const void *)p->ai_addr;
+		bool seen = false;
+
+		for (j = 0; j < i; ++j) {
+			if (memcmp(newaddr, &addr[j], sizeof(*newaddr)) == 0) {
+				seen = true;
+				break;
+			}
+		}
+		if (seen)
+			continue;
+		memcpy(&addr[i++], &newaddr->sin_addr, sizeof(newaddr->sin_addr));
+	}
 	freeaddrinfo(res);
+	*naddr = i;
 	return addr;
 }
 
@@ -1650,7 +1659,7 @@ host_to_ip6addr(const char *name, unsigned int *naddr)
 	struct addrinfo hints;
 	struct addrinfo *res, *p;
 	int err;
-	unsigned int i;
+	size_t i, j;
 
 	memset(&hints, 0, sizeof(hints));
 	hints.ai_family   = AF_INET6;
@@ -1665,11 +1674,22 @@ host_to_ip6addr(const char *name, unsigned int *naddr)
 		++*naddr;
 	/* Copy each element of the address chain */
 	addr = xtables_calloc(*naddr, sizeof(struct in6_addr));
-	for (i = 0, p = res; p != NULL; p = p->ai_next)
-		memcpy(&addr[i++],
-		       &((const struct sockaddr_in6 *)p->ai_addr)->sin6_addr,
-		       sizeof(struct in6_addr));
+	for (i = 0, p = res; p != NULL; p = p->ai_next) {
+		const struct sockaddr_in6 *newaddr = (const void *)p->ai_addr;
+		bool seen = false;
+
+		for (j = 0; j < i; ++j) {
+			if (memcmp(newaddr, &addr[j], sizeof(*newaddr)) == 0) {
+				seen = true;
+				break;
+			}
+		}
+		if (seen)
+			continue;
+		memcpy(&addr[i++], &newaddr->sin6_addr, sizeof(newaddr->sin6_addr));
+	}
 	freeaddrinfo(res);
+	*naddr = i;
 	return addr;
 }
 
-- 
2.10.2

