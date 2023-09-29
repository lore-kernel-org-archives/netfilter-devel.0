Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F65E743FA
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 08:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbjI2ImZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 04:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbjI2ImW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 04:42:22 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719B71BC
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 01:42:19 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qm94j-0004jn-NO; Fri, 29 Sep 2023 10:42:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, David Ward <david.ward@ll.mit.edu>
Subject: [PATCH nf] netfilter: nft_payload: rebuild vlan header on h_proto access
Date:   Fri, 29 Sep 2023 10:42:10 +0200
Message-ID: <20230929084213.19401-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft can perform merging of adjacent payload requests.
This means that:

ether saddr 00:11 ... ether type 8021ad ...

is a single payload expression, for 8 bytes, starting at the
ethernet source offset.

Check that offset+length is fully within the source/destination mac
addersses.

This bug prevents 'ether type' from matching the correct h_proto in case
vlan tag got stripped.

Fixes: de6843be3082 ("netfilter: nft_payload: rebuild vlan header when needed")
Reported-by: David Ward <david.ward@ll.mit.edu>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_payload.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 8cb800989947..120f6d395b98 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -154,6 +154,17 @@ int nft_payload_inner_offset(const struct nft_pktinfo *pkt)
 	return pkt->inneroff;
 }
 
+static bool nft_payload_need_vlan_copy(const struct nft_payload *priv)
+{
+	unsigned int len = priv->offset + priv->len;
+
+	/* data past ether src/dst requested, copy needed */
+	if (len > offsetof(struct ethhdr, h_proto))
+		return true;
+
+	return false;
+}
+
 void nft_payload_eval(const struct nft_expr *expr,
 		      struct nft_regs *regs,
 		      const struct nft_pktinfo *pkt)
@@ -172,7 +183,7 @@ void nft_payload_eval(const struct nft_expr *expr,
 			goto err;
 
 		if (skb_vlan_tag_present(skb) &&
-		    priv->offset >= offsetof(struct ethhdr, h_proto)) {
+		    nft_payload_need_vlan_copy(priv)) {
 			if (!nft_payload_copy_vlan(dest, skb,
 						   priv->offset, priv->len))
 				goto err;
-- 
2.41.0

