Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3EA9C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Oct 2022 22:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiJEWht (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 18:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiJEWhs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 18:37:48 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41A787F25C
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 15:37:47 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 6/6] netfilter: nft_inner: add geneve support
Date:   Thu,  6 Oct 2022 00:37:40 +0200
Message-Id: <20221005223740.22991-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221005223740.22991-1-pablo@netfilter.org>
References: <20221005223740.22991-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Geneve tunnel header may contain options, parse geneve header and update
offset to point to the link layer header according to the opt_len field.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  1 +
 net/netfilter/nft_inner.c                | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 4608646f2103..d7b25a6693eb 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -783,6 +783,7 @@ enum nft_payload_csum_flags {
 enum nft_inner_type {
 	NFT_INNER_UNSPEC	= 0,
 	NFT_INNER_VXLAN,
+	NFT_INNER_GENEVE,
 };
 
 enum nft_inner_flags {
diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index 6e874a986bfa..b2006a00d862 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -17,6 +17,7 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <net/gre.h>
+#include <net/geneve.h>
 #include <net/ip.h>
 #include <linux/icmpv6.h>
 #include <linux/ip.h>
@@ -170,6 +171,22 @@ static int nft_inner_parse_tunhdr(const struct nft_inner *priv,
 	ctx->flags |= NFT_PAYLOAD_CTX_INNER_TUN;
 	*off += priv->hdrsize;
 
+	switch (priv->type) {
+	case NFT_INNER_GENEVE: {
+		struct genevehdr *gnvh, _gnvh;
+
+		gnvh = skb_header_pointer(pkt->skb, pkt->inneroff,
+					  sizeof(_gnvh), &_gnvh);
+		if (!gnvh)
+			return -1;
+
+		*off += gnvh->opt_len * 4;
+		}
+		break;
+	default:
+		break;
+	}
+
 	return 0;
 }
 
-- 
2.30.2

