From: Alexander Alemayhu <alexander@alemayhu.com>
Subject: [PATCH iptables] libxtables: fix wrong naddr when using localhost
Date: Wed,  8 Mar 2017 00:28:13 +0100
Message-ID: <20170307232813.17428-1-alexander@alemayhu.com>
Cc: Alexander Alemayhu <alexander@alemayhu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:36804 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756507AbdCGX2q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2017 18:28:46 -0500
Received: by mail-lf0-f47.google.com with SMTP id y193so7854281lfd.3
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Mar 2017 15:28:19 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

$ iptables-translate -A INPUT -p tcp -s localhost --dport 8000 -j ACCEPT

gives

 nft add rule ip filter INPUT ip saddr 127.0.0.1 tcp dport 8000 counter accept
 add rule ip filter INPUT ip saddr 127.0.0.1 tcp dport 8000 counter accept

with this patch we get

 nft add rule ip filter INPUT ip saddr 127.0.0.1 tcp dport 8000 counter accept

Signed-off-by: Alexander Alemayhu <alexander@alemayhu.com>
---
 libxtables/xtables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index d43f97066ea9..defc57414de3 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1376,7 +1376,7 @@ static struct in_addr *host_to_ipaddr(const char *name, unsigned int *naddr)
 		return NULL;
 	} else {
 		for (p = res; p != NULL; p = p->ai_next)
-			++*naddr;
+			*naddr++;
 		addr = xtables_calloc(*naddr, sizeof(struct in_addr));
 		for (i = 0, p = res; p != NULL; p = p->ai_next)
 			memcpy(&addr[i++],
-- 
2.9.3

