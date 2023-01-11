Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E63C54EBC
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Jan 2023 21:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbjAKVXE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Jan 2023 16:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjAKVXA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Jan 2023 16:23:00 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DFE78E53
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jan 2023 13:22:58 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH net 3/3] netfilter: nft_payload: incorrect arithmetics when fetching VLAN header bits
Date:   Wed, 11 Jan 2023 22:22:51 +0100
Message-Id: <20230111212251.193032-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230111212251.193032-1-pablo@netfilter.org>
References: <20230111212251.193032-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the offset + length goes over the ethernet + vlan header, then the
length is adjusted to copy the bytes that are within the boundaries of
the vlan_ethhdr scratchpad area. The remaining bytes beyond ethernet +
vlan header are copied directly from the skbuff data area.

Fix incorrect arithmetic operator: subtract, not add, the size of the
vlan header in case of double-tagged packets to adjust the length
accordingly to address CVE-2023-0179.

Reported-by: Davide Ornaghi <d.ornaghi97@gmail.com>
Fixes: f6ae9f120dad ("netfilter: nft_payload: add C-VLAN support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 17b418a5a593..3a3c7746e88f 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -63,7 +63,7 @@ nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
 			return false;
 
 		if (offset + len > VLAN_ETH_HLEN + vlan_hlen)
-			ethlen -= offset + len - VLAN_ETH_HLEN + vlan_hlen;
+			ethlen -= offset + len - VLAN_ETH_HLEN - vlan_hlen;
 
 		memcpy(dst_u8, vlanh + offset - vlan_hlen, ethlen);
 
-- 
2.30.2

