From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH 2/2] libxtables: xtables: Use getnameinfo()
Date: Mon, 12 Dec 2016 20:23:57 +0530
Message-ID: <1481554437-20319-2-git-send-email-mayhs11saini@gmail.com>
References: <1481554437-20319-1-git-send-email-mayhs11saini@gmail.com>
Cc: Shyam Saini <mayhs11saini@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32937 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbcLLOyO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Dec 2016 09:54:14 -0500
Received: by mail-pf0-f194.google.com with SMTP id 144so4518089pfv.0
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Dec 2016 06:54:14 -0800 (PST)
In-Reply-To: <1481554437-20319-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Replace gethostbyaddr() with getnameinfo() as getnameinfo()
deprecates the former and allows programs to
eliminate IPv4-versus-IPv6 dependencies

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 libxtables/xtables.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 6e75c15..e1512b1 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1210,13 +1210,18 @@ const char *xtables_ipaddr_to_numeric(const struct in_addr *addrp)
 
 static const char *ipaddr_to_host(const struct in_addr *addr)
 {
-	struct hostent *host;
+	static char hostname[NI_MAXHOST];
+	struct sockaddr_in saddr = { .sin_family = AF_INET, };
+	saddr.sin_addr = *addr;
+	int err;
 
-	host = gethostbyaddr(addr, sizeof(struct in_addr), AF_INET);
-	if (host == NULL)
-		return NULL;
 
-	return host->h_name;
+	err = getnameinfo((const void *)&saddr, sizeof(struct sockaddr_in),
+		       hostname, sizeof(hostname) - 1, NULL, 0, 0);
+	if (err != 0)
+		return NULL;
+
+	return hostname;
 }
 
 static const char *ipaddr_to_network(const struct in_addr *addr)
-- 
2.7.4

