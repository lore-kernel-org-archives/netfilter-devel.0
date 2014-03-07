From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH] nft-arp: fix is_same_interfaces arguments
Date: Fri,  7 Mar 2014 11:43:13 +0100
Message-ID: <1394188993-4752-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:54073 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaCGKm3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:42:29 -0500
Received: by mail-ea0-f177.google.com with SMTP id h10so2238869eak.8
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Mar 2014 02:42:27 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Wrong arguments are passed to is_same_interfaces
that causes sometimes to delete a wrong rule.
See the example below:

arptables-compat -A INPUT -i eth0 -j ACCEPT
arptables-compat -A INPUT -i eth1 -j ACCEPT
arptables-compat -A INPUT -i eth2 -j ACCEPT

arptables-compat -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
-j ACCEPT -i eth0
-j ACCEPT -i eth1
-j ACCEPT -i eth2

arptables-compat -D INPUT -i eth2 -j ACCEPT

arptables-compat -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
-j ACCEPT -i eth1
-j ACCEPT -i eth2

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-arp.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index a494ee6..1af7202 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -631,14 +631,14 @@ static bool nft_arp_is_same(const void *data_a,
 		return false;
 	}
 
-	return is_same_interfaces(a->arp.src_devaddr.addr,
-				  a->arp.tgt_devaddr.addr,
-				  (unsigned char*)a->arp.src_devaddr.mask,
-				  (unsigned char*)a->arp.tgt_devaddr.mask,
-				  b->arp.src_devaddr.addr,
-				  a->arp.tgt_devaddr.addr,
-				  (unsigned char*)b->arp.src_devaddr.mask,
-				  (unsigned char*)b->arp.tgt_devaddr.mask);
+	return is_same_interfaces(a->arp.iniface,
+				  a->arp.outiface,
+				  (unsigned char *)a->arp.iniface_mask,
+				  (unsigned char *)a->arp.outiface_mask,
+				  b->arp.iniface,
+				  b->arp.outiface,
+				  (unsigned char *)b->arp.iniface_mask,
+				  (unsigned char *)b->arp.outiface_mask);
 }
 
 static bool nft_arp_rule_find(struct nft_family_ops *ops, struct nft_rule *r,
-- 
1.8.3.2

