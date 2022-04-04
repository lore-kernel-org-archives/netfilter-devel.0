Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4EEEC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244598AbiDDMbE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344931AbiDDMbD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:31:03 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151A2EF
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4nsoYQ2bgmrXih9U6b3FulBAW95OoWRWepWvUC5G4ig=; b=GnRZEO1VLgOeuVjx+IB23R3w10
        a6G3LwooAVpYph90vqIaA/oEbKXMrT2X+q3Wkxb1psLmcng8/BZP9ekv94py4ry7TquPjchxo3KCD
        fHp9Cy2aEKzfrvZxFusNrIQhvTpi2lMJ97EYSTYKOA03+8ayg81h/JKrve2NS06SYvP9KXVT4Nk+x
        gfboyqbOQfn9KA1Llk4sj4hWR721y+9WPcYf4ioeHvKwqOAaWtKS9+yIorLcfdpMcQZayRdpw4f0s
        qKVa7SJzmKPUWJ5XFp0eOGYL2k2f11bHNuCT6FdZl3421OAdM8Z9PsHoXnND2mwgCcoyhvVFqRFgO
        uygfSCvw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbK-007FTC-7M; Mon, 04 Apr 2022 13:14:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 18/32] include: add new bitwise boolean attributes to nf_tables.h
Date:   Mon,  4 Apr 2022 13:13:56 +0100
Message-Id: <20220404121410.188509-19-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404121410.188509-1-jeremy@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The kernel now has native support for AND, OR and XOR bitwise
operations.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter/nf_tables.h | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index f3dcc4a34ff1..cd3e9e4ac646 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -539,16 +539,27 @@ enum nft_immediate_attributes {
 /**
  * enum nft_bitwise_ops - nf_tables bitwise operations
  *
- * @NFT_BITWISE_BOOL: mask-and-xor operation used to implement NOT, AND, OR and
- *                    XOR boolean operations
+ * @NFT_BITWISE_MASK_XOR: mask-and-xor operation used to implement NOT, AND, OR
+ *                        and XOR boolean operations
  * @NFT_BITWISE_LSHIFT: left-shift operation
  * @NFT_BITWISE_RSHIFT: right-shift operation
+ * @NFT_BITWISE_AND: and operation
+ * @NFT_BITWISE_OR: or operation
+ * @NFT_BITWISE_XOR: xor operation
  */
 enum nft_bitwise_ops {
-	NFT_BITWISE_BOOL,
+	NFT_BITWISE_MASK_XOR,
 	NFT_BITWISE_LSHIFT,
 	NFT_BITWISE_RSHIFT,
+	NFT_BITWISE_AND,
+	NFT_BITWISE_OR,
+	NFT_BITWISE_XOR,
 };
+/*
+ * Old name for NFT_BITWISE_MASK_XOR, predating the addition of NFT_BITWISE_AND,
+ * NFT_BITWISE_OR and NFT_BITWISE_XOR.  Retained for backwards-compatibility.
+ */
+#define NFT_BITWISE_BOOL NFT_BITWISE_MASK_XOR
 
 /**
  * enum nft_bitwise_attributes - nf_tables bitwise expression netlink attributes
@@ -562,6 +573,7 @@ enum nft_bitwise_ops {
  * @NFTA_BITWISE_DATA: argument for non-boolean operations
  *                     (NLA_NESTED: nft_data_attributes)
  * @NFTA_BITWISE_NBITS: length of operation in bits (NLA_U32)
+ * @NFTA_BITWISE_SREG2: second source register (NLA_U32: nft_registers)
  *
  * The bitwise expression supports boolean and shift operations.  It implements
  * the boolean operations by performing the following operation:
@@ -586,6 +598,7 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_OP,
 	NFTA_BITWISE_DATA,
 	NFTA_BITWISE_NBITS,
+	NFTA_BITWISE_SREG2,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
-- 
2.35.1

