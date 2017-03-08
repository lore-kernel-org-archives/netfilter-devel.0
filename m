From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] libxtables: duplicated loopback address via host_to_ipaddr()
Date: Wed,  8 Mar 2017 15:33:04 +0100
Message-ID: <1488983584-26091-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60926 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751633AbdCHOeP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 09:34:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1E1CD2470B
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 15:33:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D1E1DA811
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 15:33:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BD589DA7FA
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 15:33:08 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Originally reported as a iptables-translate problem, but this also
affects iptables and ip6tables.

 $ iptables-translate -A INPUT -s localhost -j ACCEPT

gives duplicated rules:

 nft add rule ip filter INPUT ip saddr 127.0.0.1 counter accept
 nft add rule ip filter INPUT ip saddr 127.0.0.1 counter accept

This handling sucks, but libc seem to need if we have 127.0.0.1 and ::1
entries in /etc/hosts that are common in many distros.

For more info, see:

https://sourceware.org/bugzilla/show_bug.cgi?id=4980
https://bugzilla.redhat.com/show_bug.cgi?id=496300

Reported-by: Alexander Alemayhu <alexander@alemayhu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
What a beauty...

 libxtables/xtables.c | 40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index d43f97066ea9..80b00420e039 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1358,12 +1358,18 @@ static struct in_addr *network_to_ipaddr(const char *name)
 	return NULL;
 }
 
+static const struct in_addr *addrinfo_get_sin_addr(const struct addrinfo *addr)
+{
+	return &((const struct sockaddr_in *)addr->ai_addr)->sin_addr;
+}
+
 static struct in_addr *host_to_ipaddr(const char *name, unsigned int *naddr)
 {
 	struct in_addr *addr;
 	struct addrinfo hints;
 	struct addrinfo *res, *p;
 	int err;
+	bool loopback_seen;
 	unsigned int i;
 
 	memset(&hints, 0, sizeof(hints));
@@ -1375,13 +1381,39 @@ static struct in_addr *host_to_ipaddr(const char *name, unsigned int *naddr)
 	if ((err = getaddrinfo(name, NULL, &hints, &res)) != 0) {
 		return NULL;
 	} else {
-		for (p = res; p != NULL; p = p->ai_next)
+		loopback_seen = false;
+		for (p = res; p != NULL; p = p->ai_next) {
+			/*
+			 * This handling sucks, but libc seem to need this
+			 * workaround when 127.0.0.1 and ::1 entries in
+			 * /etc/hosts that are common in many distros, see:
+			 *
+			 * https://sourceware.org/bugzilla/show_bug.cgi?id=4980
+			 * https://bugzilla.redhat.com/show_bug.cgi?id=496300
+			 *
+			 * Note that we cannot use AI_ADDRCONFIG because this
+			 * needs to work with br_netfilter, where we may have no
+			 * configured address.
+			 */
+			if (loopback_seen)
+				continue;
+			if (addrinfo_get_sin_addr(p)->s_addr ==
+							htonl(INADDR_LOOPBACK))
+				loopback_seen = true;
+
 			++*naddr;
+		}
+		loopback_seen = false;
 		addr = xtables_calloc(*naddr, sizeof(struct in_addr));
-		for (i = 0, p = res; p != NULL; p = p->ai_next)
-			memcpy(&addr[i++],
-			       &((const struct sockaddr_in *)p->ai_addr)->sin_addr,
+		for (i = 0, p = res; p != NULL; p = p->ai_next) {
+			if (loopback_seen)
+				continue;
+			if (addrinfo_get_sin_addr(p)->s_addr ==
+							htonl(INADDR_LOOPBACK))
+				loopback_seen = true;
+			memcpy(&addr[i++], addrinfo_get_sin_addr(p),
 			       sizeof(struct in_addr));
+		}
 		freeaddrinfo(res);
 		return addr;
 	}
-- 
2.1.4

