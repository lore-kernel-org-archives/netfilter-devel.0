From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 2/4] iptables: iptables: Remove assignment in if condition
Date: Fri, 31 Mar 2017 21:43:49 +0530
Message-ID: <20170331161351.26141-3-arushisinghal19971997@gmail.com>
References: <20170331161351.26141-1-arushisinghal19971997@gmail.com>
Cc: Arushi Singhal <arushisinghal19971997@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35181 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933126AbdCaQOM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Mar 2017 12:14:12 -0400
Received: by mail-pg0-f65.google.com with SMTP id g2so18325634pge.2
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Mar 2017 09:14:11 -0700 (PDT)
In-Reply-To: <20170331161351.26141-1-arushisinghal19971997@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove the assignment from if condition to follow kernel coding style
and make the code more clear and readable.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 iptables/getethertype.c | 3 ++-
 iptables/nft-arp.c      | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/iptables/getethertype.c b/iptables/getethertype.c
index bf3e408..11c121a 100644
--- a/iptables/getethertype.c
+++ b/iptables/getethertype.c
@@ -84,7 +84,8 @@ struct ethertypeent *getethertypeent(void)
 	}
 
 again:
-	if ((e = fgets(line, BUFSIZ, etherf)) == NULL) {
+	e = fgets(line, BUFSIZ, etherf);
+	if (!e) {
 		return (NULL);
 	}
 	if (*e == '#')
diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 0e13b8c..37ed956 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -70,7 +70,8 @@ addr_to_network(const struct in_addr *addr)
 {
 	struct netent *net;
 
-	if ((net = getnetbyaddr((long) ntohl(addr->s_addr), AF_INET)) != NULL)
+	net = getnetbyaddr((long) ntohl(addr->s_addr), AF_INET);
+	if (net)
 		return (char *) net->n_name;
 
 	return (char *) NULL;
-- 
2.11.0

