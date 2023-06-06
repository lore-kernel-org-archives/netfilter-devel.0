Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC79C7EE24
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jun 2023 07:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbjFFHiy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 03:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236256AbjFFHiy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 03:38:54 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 007AF106
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2023 00:38:47 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] nft_payload: rebuild vlan header when needed
Date:   Tue,  6 Jun 2023 09:38:42 +0200
Message-Id: <20230606073842.97410-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Skip rebuilding the vlan header when accessing destination and source
mac address.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 14974dc820ea..0107d8e19313 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -171,7 +171,8 @@ void nft_payload_eval(const struct nft_expr *expr,
 		if (!skb_mac_header_was_set(skb))
 			goto err;
 
-		if (skb_vlan_tag_present(skb)) {
+		if (skb_vlan_tag_present(skb) &&
+		    priv->offset >= offsetof(struct ethhdr, h_proto)) {
 			if (!nft_payload_copy_vlan(dest, skb,
 						   priv->offset, priv->len))
 				goto err;
-- 
2.30.2

