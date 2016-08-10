From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/9] netfilter: nf_tables: s/MFT_REG32_01/NFT_REG32_01
Date: Wed, 10 Aug 2016 21:16:38 +0200
Message-ID: <1470856605-7903-3-git-send-email-pablo@netfilter.org>
References: <1470856605-7903-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58006 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S941232AbcHJTRA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 15:17:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D70241F18CD
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 21:16:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C780D100A57
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 21:16:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E0DE5FF6F7
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 21:16:51 +0200 (CEST)
In-Reply-To: <1470856605-7903-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

MFT_REG32_01 is a typo, rename this to NFT_REG32_01.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 01751fa..c674ba2 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -24,7 +24,7 @@ enum nft_registers {
 	__NFT_REG_MAX,
 
 	NFT_REG32_00	= 8,
-	MFT_REG32_01,
+	NFT_REG32_01,
 	NFT_REG32_02,
 	NFT_REG32_03,
 	NFT_REG32_04,
-- 
2.1.4

