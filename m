From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables-nftables PATCH] nft: initialize flags in nft_arp_parse_meta
Date: Thu,  3 Oct 2013 16:31:39 +0200
Message-ID: <1380810699-2872-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:48888 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab3JCObd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 10:31:33 -0400
Received: by mail-ea0-f177.google.com with SMTP id f15so1137793eak.22
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Oct 2013 07:31:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This small patch initialize the flags in nft_arp_parse_meta,
now the nft_arp_rule_find is working properly.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-arp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index cf8fe28..3d753c2 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -267,7 +267,7 @@ static void nft_arp_parse_meta(struct nft_rule_expr *e, uint8_t key,
 			       void *data)
 {
 	struct arpt_entry *fw = data;
-	uint8_t flags;
+	uint8_t flags = 0;
 
 	parse_meta(e, key, fw->arp.iniface, fw->arp.iniface_mask,
 		   fw->arp.outiface, fw->arp.outiface_mask,
-- 
1.7.8.6

