From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables 2/2] libxtables: pass AI_ADDRCONFIG flag to getaddrinfo()
Date: Wed,  8 Mar 2017 14:16:10 +0100
Message-ID: <1488978970-30802-2-git-send-email-pablo@netfilter.org>
References: <1488978970-30802-1-git-send-email-pablo@netfilter.org>
Cc: alexander@alemayhu.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55178 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753130AbdCHNZq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 08:25:46 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 03B2C1A2089
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 14:16:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E6A97DA807
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 14:16:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9C55ADA7F7
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 14:16:15 +0100 (CET)
In-Reply-To: <1488978970-30802-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

According to man getaddrinfo(3):

If hints.ai_flags includes the AI_ADDRCONFIG flag, then IPv4 addresses
are returned in the list pointed to by res only if the local system has
at least one IPv4 address configured, and IPv6 addresses are only
returned if the local system has at least one IPv6 address configured.
The loopback address is not considered for this case as valid as a
configured address.

This patch removes AI_CANONNAME since we don't need the ->ai_canonname
field set in this code.

hints.ai_family has been changed to AF_UNSPEC otherwise the
AI_ADDRCONFIG flag is ignored.

Originally reported as a problem for iptables-translate, but this also
affects iptables and ip6tables.

 $ iptables-translate -A INPUT -s localhost -j ACCEPT

gives duplicated rules:

 nft add rule ip filter INPUT ip saddr 127.0.0.1 counter accept
 nft add rule ip filter INPUT ip saddr 127.0.0.1 counter accept

Reported-by: Alexander Alemayhu <alexander@alemayhu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 libxtables/xtables.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index d43f97066ea9..aa0b1eb71c0c 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1367,21 +1367,29 @@ static struct in_addr *host_to_ipaddr(const char *name, unsigned int *naddr)
 	unsigned int i;
 
 	memset(&hints, 0, sizeof(hints));
-	hints.ai_flags    = AI_CANONNAME;
-	hints.ai_family   = AF_INET;
+	hints.ai_flags    = AI_ADDRCONFIG;
+	hints.ai_family   = AF_UNSPEC;
 	hints.ai_socktype = SOCK_RAW;
 
 	*naddr = 0;
 	if ((err = getaddrinfo(name, NULL, &hints, &res)) != 0) {
 		return NULL;
 	} else {
-		for (p = res; p != NULL; p = p->ai_next)
+		for (p = res; p != NULL; p = p->ai_next) {
+			if (p->ai_family != AF_INET)
+				continue;
+
 			++*naddr;
+		}
 		addr = xtables_calloc(*naddr, sizeof(struct in_addr));
-		for (i = 0, p = res; p != NULL; p = p->ai_next)
+		for (i = 0, p = res; p != NULL; p = p->ai_next) {
+			if (p->ai_family != AF_INET)
+				continue;
+
 			memcpy(&addr[i++],
 			       &((const struct sockaddr_in *)p->ai_addr)->sin_addr,
 			       sizeof(struct in_addr));
+		}
 		freeaddrinfo(res);
 		return addr;
 	}
@@ -1657,8 +1665,8 @@ host_to_ip6addr(const char *name, unsigned int *naddr)
 	unsigned int i;
 
 	memset(&hints, 0, sizeof(hints));
-	hints.ai_flags    = AI_CANONNAME;
-	hints.ai_family   = AF_INET6;
+	hints.ai_flags    = AI_ADDRCONFIG;
+	hints.ai_family   = AF_UNSPEC;
 	hints.ai_socktype = SOCK_RAW;
 
 	*naddr = 0;
@@ -1666,14 +1674,22 @@ host_to_ip6addr(const char *name, unsigned int *naddr)
 		return NULL;
 	} else {
 		/* Find length of address chain */
-		for (p = res; p != NULL; p = p->ai_next)
+		for (p = res; p != NULL; p = p->ai_next) {
+			if (p->ai_family != AF_INET6)
+				continue;
+
 			++*naddr;
+		}
 		/* Copy each element of the address chain */
 		addr = xtables_calloc(*naddr, sizeof(struct in6_addr));
-		for (i = 0, p = res; p != NULL; p = p->ai_next)
+		for (i = 0, p = res; p != NULL; p = p->ai_next) {
+			if (p->ai_family != AF_INET6)
+				continue;
+
 			memcpy(&addr[i++],
 			       &((const struct sockaddr_in6 *)p->ai_addr)->sin6_addr,
 			       sizeof(struct in6_addr));
+		}
 		freeaddrinfo(res);
 		return addr;
 	}
-- 
2.1.4

