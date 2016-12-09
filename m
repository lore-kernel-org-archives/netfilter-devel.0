From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH] libxtables: xtables.c: Use getnameinfo()
Date: Fri,  9 Dec 2016 17:20:00 +0530
Message-ID: <1481284200-6104-1-git-send-email-mayhs11saini@gmail.com>
Cc: Shyam Saini <mayhs11saini@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33048 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932677AbcLILul (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Dec 2016 06:50:41 -0500
Received: by mail-pg0-f65.google.com with SMTP id 3so2150386pgd.0
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Dec 2016 03:50:41 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use getnameinfo() instead of deprecated gethostbyaddr()

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 libxtables/xtables.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 921dfe9..338e325 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1210,13 +1210,28 @@ const char *xtables_ipaddr_to_numeric(const struct in_addr *addrp)
 
 static const char *ipaddr_to_host(const struct in_addr *addr)
 {
-	struct hostent *host;
+	static char hostname[NI_MAXHOST];
+	struct sockaddr_in saddr;
+	int err;
 
-	host = gethostbyaddr(addr, sizeof(struct in_addr), AF_INET);
-	if (host == NULL)
-		return NULL;
+	memset(&saddr, 0, sizeof(struct sockaddr_in));
+	memcpy(&saddr.sin_addr, addr, sizeof(*addr));
+	saddr.sin_family = AF_INET;
+
+	err = getnameinfo((const void *)&saddr, sizeof(struct sockaddr_in),
+			              hostname, sizeof(hostname) - 1, NULL, 0, 0);
+
+	 if (err != 0) {
+#ifdef DEBUG
+		 fprintf(stderr,"IP2Name: %s\n",gai_strerror(err));
+#endif
+		 return NULL;
+	}
 
-	return host->h_name;
+#ifdef DEBUG
+		fprintf (stderr, "\naddr2host: %s\n", hostname);
+#endif
+		return hostname;
 }
 
 static const char *ipaddr_to_network(const struct in_addr *addr)
-- 
2.7.4

