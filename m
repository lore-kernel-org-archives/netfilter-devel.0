Return-Path: <SRS0=NVo7=VU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06821C7618B
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 13:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8A84205C9
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 13:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731441AbfGWN2D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 09:28:03 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48448 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731095AbfGWN2D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 09:28:03 -0400
Received: from localhost ([::1]:33306 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hpupm-000886-E5; Tue, 23 Jul 2019 15:28:02 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [PATCH v3 1/2] net: nf_tables: Make nft_meta expression more robust
Date:   Tue, 23 Jul 2019 15:27:52 +0200
Message-Id: <20190723132753.13781-1-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft_meta_get_eval()'s tendency to bail out setting NFT_BREAK verdict in
situations where required data is missing leads to unexpected behaviour
with inverted checks like so:

| meta iifname != eth0 accept

This rule will never match if there is no input interface (or it is not
known) which is not intuitive and, what's worse, breaks consistency of
iptables-nft with iptables-legacy.

Fix this by falling back to placing a value in dreg which never matches
(avoiding accidental matches), i.e. zero for interface index and an
empty string for interface name.
---
Changes since v1:
- Apply same fix to net/bridge/netfilter/nft_meta_bridge.c as well.

Changes since v2:
- Limit this fix to address only expressions returning an interface
  index or name. As Florian correctly criticized, these changes may be
  problematic as they tend to change nftables' behaviour. Hence fix only
  the cases needed to establish iptables-nft compatibility.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/bridge/netfilter/nft_meta_bridge.c |  6 +-----
 net/netfilter/nft_meta.c               | 16 ++++------------
 2 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index bed66f536b345..a98dec2cf0cfd 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -30,13 +30,9 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 	switch (priv->key) {
 	case NFT_META_BRI_IIFNAME:
 		br_dev = nft_meta_get_bridge(in);
-		if (!br_dev)
-			goto err;
 		break;
 	case NFT_META_BRI_OIFNAME:
 		br_dev = nft_meta_get_bridge(out);
-		if (!br_dev)
-			goto err;
 		break;
 	case NFT_META_BRI_IIFPVID: {
 		u16 p_pvid;
@@ -64,7 +60,7 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 		goto out;
 	}
 
-	strncpy((char *)dest, br_dev->name, IFNAMSIZ);
+	strncpy((char *)dest, br_dev ? br_dev->name : "", IFNAMSIZ);
 	return;
 out:
 	return nft_meta_get_eval(expr, regs, pkt);
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index f1b1d948c07b4..f69afb9ff3cbe 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -60,24 +60,16 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		*dest = skb->mark;
 		break;
 	case NFT_META_IIF:
-		if (in == NULL)
-			goto err;
-		*dest = in->ifindex;
+		*dest = in ? in->ifindex : 0;
 		break;
 	case NFT_META_OIF:
-		if (out == NULL)
-			goto err;
-		*dest = out->ifindex;
+		*dest = out ? out->ifindex : 0;
 		break;
 	case NFT_META_IIFNAME:
-		if (in == NULL)
-			goto err;
-		strncpy((char *)dest, in->name, IFNAMSIZ);
+		strncpy((char *)dest, in ? in->name : "", IFNAMSIZ);
 		break;
 	case NFT_META_OIFNAME:
-		if (out == NULL)
-			goto err;
-		strncpy((char *)dest, out->name, IFNAMSIZ);
+		strncpy((char *)dest, out ? out->name : "", IFNAMSIZ);
 		break;
 	case NFT_META_IIFTYPE:
 		if (in == NULL)
-- 
2.22.0

