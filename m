From: Arpan Kapoor <rpnkpr@gmail.com>
Subject: [PATCH] iptables: Replace gethostbyname() with getaddrinfo()
Date: Thu, 17 Mar 2016 18:27:19 +0530
Message-ID: <1458219439-561-1-git-send-email-rpnkpr@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34182 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936000AbcCQM5i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Mar 2016 08:57:38 -0400
Received: by mail-pf0-f194.google.com with SMTP id n5so11004187pfn.1
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2016 05:57:38 -0700 (PDT)
Received: from arch.localdomain ([49.249.92.252])
        by smtp.gmail.com with ESMTPSA id 16sm13364659pfk.28.2016.03.17.05.57.35
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 17 Mar 2016 05:57:37 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make the function host_to_ipaddr() similar to host_to_ip6addr(),
using getaddrinfo() instead of the obsoleted gethostbyname().

Signed-off-by: Arpan Kapoor <rpnkpr@gmail.com>
---
 libxtables/xtables.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index fe24caa..1c6684d 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1353,22 +1353,36 @@ static struct in_addr *network_to_ipaddr(const char *name)
 
 static struct in_addr *host_to_ipaddr(const char *name, unsigned int *naddr)
 {
-	struct hostent *host;
 	struct in_addr *addr;
+	struct addrinfo hints;
+	struct addrinfo *res, *p;
+	int err;
 	unsigned int i;
 
-	*naddr = 0;
-	if ((host = gethostbyname(name)) != NULL) {
-		if (host->h_addrtype != AF_INET ||
-		    host->h_length != sizeof(struct in_addr))
-			return NULL;
+	memset(&hints, 0, sizeof(hints));
+	hints.ai_flags    = AI_CANONNAME;
+	hints.ai_family   = AF_INET;
+	hints.ai_socktype = SOCK_RAW;
 
-		while (host->h_addr_list[*naddr] != NULL)
+	*naddr = 0;
+	if ((err = getaddrinfo(name, NULL, &hints, &res)) != 0) {
+#ifdef DEBUG
+		fprintf(stderr,"Name2IP: %s\n",gai_strerror(err));
+#endif
+		return NULL;
+	} else {
+		for (p = res; p != NULL; p = p->ai_next)
 			++*naddr;
+#ifdef DEBUG
+		fprintf(stderr, "resolved: len=%d  %s ", res->ai_addrlen,
+		        xtables_ipaddr_to_numeric(&((struct sockaddr_in *)res->ai_addr)->sin_addr));
+#endif
 		addr = xtables_calloc(*naddr, sizeof(struct in_addr));
-		for (i = 0; i < *naddr; i++)
-			memcpy(&addr[i], host->h_addr_list[i],
+		for (i = 0, p = res; p != NULL; p = p->ai_next)
+			memcpy(&addr[i++],
+			       &((const struct sockaddr_in *)p->ai_addr)->sin_addr,
 			       sizeof(struct in_addr));
+		freeaddrinfo(res);
 		return addr;
 	}
 
-- 
2.7.3

