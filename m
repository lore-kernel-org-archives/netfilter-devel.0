From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables PATCH] nft-arp: wrong condition in parse_payload
Date: Fri,  7 Mar 2014 15:21:10 +0100
Message-ID: <1394202070-6510-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:53003 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaCGOU0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:20:26 -0500
Received: by mail-ee0-f53.google.com with SMTP id e51so1777738eek.12
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Mar 2014 06:20:25 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

the current condition doesn't permit to parse ip addresses
when they should be.
Obviously they are not printed.

arptables-compat -A INPUT -s 1.1.1.1 -i eth0 -j ACCEPT
arptables-compat -L

Chain INPUT (policy ACCEPT)
target     prot opt source               destination
-j ACCEPT -i eth0

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-arp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 1af7202..3af1b4b 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -345,7 +345,7 @@ static void nft_arp_parse_payload(struct nft_rule_expr_iter *iter,
 			fw->arp.invflags |= ARPT_INV_ARPOP;
 		break;
 	default:
-		if (!fw->arp.arhln)
+		if (fw->arp.arhln < 0)
 			break;
 
 		if (offset == sizeof(struct arphdr) + fw->arp.arhln) {
-- 
1.8.3.2

