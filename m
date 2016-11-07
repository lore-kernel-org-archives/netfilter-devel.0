From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] iptables: xtables-arp: Use getaddrinfo()
Date: Mon, 7 Nov 2016 17:58:46 +0530
Message-ID: <20161107122846.GA11799@Novo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36110 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbcKGM3h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Nov 2016 07:29:37 -0500
Received: by mail-pf0-f194.google.com with SMTP id n85so16052804pfi.3
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Nov 2016 04:29:37 -0800 (PST)
Received: from Novo ([2405:204:1207:f944:556c:a4cf:c53d:130e])
        by smtp.gmail.com with ESMTPSA id cp2sm40335300pad.3.2016.11.07.04.29.34
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Nov 2016 04:29:36 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Replace gethostbyname() with getaddrinfo() as getaddrinfo()
deprecates the former and allows programs to eliminate
IPv4-versus-IPv6 dependencies.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 iptables/xtables-arp.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 346bece..bd6d57c 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -587,22 +587,30 @@ check_inverse(const char option[], int *invert, int *optidx, int argc)
 static struct in_addr *
 host_to_addr(const char *name, unsigned int *naddr)
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
-			return (struct in_addr *) NULL;
+	memset(&hints, 0, sizeof(hints));
+	hints.ai_flags	  = AI_CANONNAME;
+	hints.ai_family	  = AF_INET;
+	hints.ai_socktype = SOCK_RAW;
 
-		while (host->h_addr_list[*naddr] != (char *) NULL)
+	*naddr = 0;
+	err = getaddrinfo(name, NULL, &hints, &res);
+	if (err != 0)
+		return NULL;
+	else {
+		for (p = res; p != NULL; p = p->ai_next)
 			(*naddr)++;
 		addr = xtables_calloc(*naddr, sizeof(struct in_addr));
-		for (i = 0; i < *naddr; i++)
-			inaddrcpy(&(addr[i]),
-				  (struct in_addr *) host->h_addr_list[i]);
+		for (i = 0, p = res; p != NULL; p = p->ai_next)
+			memcpy(&addr[i++],
+			       &((const struct sockaddr_in *)p->ai_addr)->sin_addr,
+			       sizeof(struct in_addr));
+		freeaddrinfo(res);
 		return addr;
 	}
 
-- 
2.7.4

