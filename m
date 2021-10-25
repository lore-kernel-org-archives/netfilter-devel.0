Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B24C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Oct 2021 13:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6B9F60F9B
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Oct 2021 13:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbhJYNp7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Oct 2021 09:45:59 -0400
Received: from mail.netfilter.org ([217.70.188.207]:42154 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbhJYNp7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Oct 2021 09:45:59 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9F6B963F1F
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Oct 2021 15:41:47 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nft_meta: add NFT_META_IFTYPE
Date:   Mon, 25 Oct 2021 15:43:29 +0200
Message-Id: <20211025134329.1030333-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Generalize NFT_META_IIFTYPE to NFT_META_IFTYPE which allows you to match
on the interface type of the skb->dev field. This field is used by the
netdev family to add an implicit dependency to skip non-ethernet packets
when matching on layer 3 and 4 TCP/IP header fields.

For backward compatibility, add the NFT_META_IIFTYPE alias to
NFT_META_IFTYPE.

Add __NFT_META_IIFTYPE, to be used by userspace in the future to match
specifically on the iiftype.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 4 +++-
 net/netfilter/nft_meta.c                 | 6 +++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index e94d1fa554cb..08db4ee06ab6 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -896,7 +896,8 @@ enum nft_meta_keys {
 	NFT_META_OIF,
 	NFT_META_IIFNAME,
 	NFT_META_OIFNAME,
-	NFT_META_IIFTYPE,
+	NFT_META_IFTYPE,
+#define NFT_META_IIFTYPE	NFT_META_IFTYPE
 	NFT_META_OIFTYPE,
 	NFT_META_SKUID,
 	NFT_META_SKGID,
@@ -923,6 +924,7 @@ enum nft_meta_keys {
 	NFT_META_TIME_HOUR,
 	NFT_META_SDIF,
 	NFT_META_SDIFNAME,
+	__NFT_META_IIFTYPE,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index a7e01e9952f1..516e74635bae 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -244,7 +244,11 @@ static bool nft_meta_get_eval_ifname(enum nft_meta_keys key, u32 *dest,
 	case NFT_META_OIF:
 		nft_meta_store_ifindex(dest, nft_out(pkt));
 		break;
-	case NFT_META_IIFTYPE:
+	case NFT_META_IFTYPE:
+		if (!nft_meta_store_iftype(dest, pkt->skb->dev))
+			return false;
+		break;
+	case __NFT_META_IIFTYPE:
 		if (!nft_meta_store_iftype(dest, nft_in(pkt)))
 			return false;
 		break;
-- 
2.30.2

