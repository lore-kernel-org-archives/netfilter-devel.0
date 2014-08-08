From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH] nft-arp: remove wrong conditions
Date: Sat,  9 Aug 2014 01:04:17 +0200
Message-ID: <1407539057-4781-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33053 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbaHHXAz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Aug 2014 19:00:55 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so6210147wgg.12
        for <netfilter-devel@vger.kernel.org>; Fri, 08 Aug 2014 16:00:54 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Removes wrong conditions in flags translating functions
that doesn't permit to delete rule with inverse flags set.

For instance, the following command doesn't remove the rule:
arptables-compat -D INPUT -i ! eth1 -j ACCEPT

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-arp.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index c1cbbc0..c3cfee9 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -155,9 +155,6 @@ static uint8_t arpt_to_ipt_flags(uint16_t invflags)
 	if (invflags & ARPT_INV_ARPPRO)
 		result |= IPT_INV_PROTO;
 
-	if (invflags & ARPT_INV_MASK)
-		result |= IPT_INV_MASK;
-
 	return result;
 }
 
@@ -257,9 +254,6 @@ static uint16_t ipt_to_arpt_flags(uint8_t invflags)
 	if (invflags & IPT_INV_PROTO)
 		result |= ARPT_INV_ARPPRO;
 
-	if (invflags & IPT_INV_MASK)
-		result |= ARPT_INV_MASK;
-
 	return result;
 }
 
-- 
1.8.3.2

