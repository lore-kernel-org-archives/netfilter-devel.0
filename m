Return-Path: <SRS0=pcH3=VF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 846F2C606A7
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 10:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 640452064B
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 10:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbfGHKcw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 06:32:52 -0400
Received: from mail.us.es ([193.147.175.20]:34284 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729437AbfGHKcv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 06:32:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B56B6BAE9A
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2019 12:32:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A6100DA801
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2019 12:32:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9BC5C1021A8; Mon,  8 Jul 2019 12:32:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8CB9BDA801;
        Mon,  8 Jul 2019 12:32:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jul 2019 12:32:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5BC8D4265A2F;
        Mon,  8 Jul 2019 12:32:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 08/15] netfilter: nft_meta_bridge: Remove the br_private.h header
Date:   Mon,  8 Jul 2019 12:32:30 +0200
Message-Id: <20190708103237.28061-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190708103237.28061-1-pablo@netfilter.org>
References: <20190708103237.28061-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

nft_bridge_meta should not access the bridge internal API.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nft_meta_bridge.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index dde8651254ac..2ea8acb4bc4a 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -8,7 +8,14 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nft_meta.h>
 
-#include "../br_private.h"
+static const struct net_device *
+nft_meta_get_bridge(const struct net_device *dev)
+{
+	if (dev && netif_is_bridge_port(dev))
+		return netdev_master_upper_dev_get_rcu((struct net_device *)dev);
+
+	return NULL;
+}
 
 static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 				     struct nft_regs *regs,
@@ -17,22 +24,24 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	const struct net_device *in = nft_in(pkt), *out = nft_out(pkt);
 	u32 *dest = &regs->data[priv->dreg];
-	const struct net_bridge_port *p;
+	const struct net_device *br_dev;
 
 	switch (priv->key) {
 	case NFT_META_BRI_IIFNAME:
-		if (in == NULL || (p = br_port_get_rcu(in)) == NULL)
+		br_dev = nft_meta_get_bridge(in);
+		if (!br_dev)
 			goto err;
 		break;
 	case NFT_META_BRI_OIFNAME:
-		if (out == NULL || (p = br_port_get_rcu(out)) == NULL)
+		br_dev = nft_meta_get_bridge(out);
+		if (!br_dev)
 			goto err;
 		break;
 	default:
 		goto out;
 	}
 
-	strncpy((char *)dest, p->br->dev->name, IFNAMSIZ);
+	strncpy((char *)dest, br_dev->name, IFNAMSIZ);
 	return;
 out:
 	return nft_meta_get_eval(expr, regs, pkt);
-- 
2.11.0

