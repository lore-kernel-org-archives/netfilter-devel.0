Return-Path: <SRS0=r9U9=2U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B018EC2D0C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91549206E4
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfL3LWG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 06:22:06 -0500
Received: from correo.us.es ([193.147.175.20]:59224 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727479AbfL3LWF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 06:22:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EFB324DE72B
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:22:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E2194DA717
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:22:03 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D7626DA714; Mon, 30 Dec 2019 12:22:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C61F5DA70F;
        Mon, 30 Dec 2019 12:22:01 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 12:22:01 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [185.124.28.61])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3E3EF41E4803;
        Mon, 30 Dec 2019 12:22:01 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 13/17] netfilter: nft_meta: move interface kind handling to helper
Date:   Mon, 30 Dec 2019 12:21:39 +0100
Message-Id: <20191230112143.121708-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230112143.121708-1-pablo@netfilter.org>
References: <20191230112143.121708-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

checkpatch complains about == NULL checks in original code,
so use !in instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 3fca1c3ec361..2f7cc64b0c15 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -175,6 +175,30 @@ nft_meta_get_eval_cgroup(u32 *dest, const struct nft_pktinfo *pkt)
 }
 #endif
 
+static noinline bool nft_meta_get_eval_kind(enum nft_meta_keys key,
+					    u32 *dest,
+					    const struct nft_pktinfo *pkt)
+{
+	const struct net_device *in = nft_in(pkt), *out = nft_out(pkt);
+
+	switch (key) {
+	case NFT_META_IIFKIND:
+		if (!in || !in->rtnl_link_ops)
+			return false;
+		strncpy((char *)dest, in->rtnl_link_ops->kind, IFNAMSIZ);
+		break;
+	case NFT_META_OIFKIND:
+		if (!out || !out->rtnl_link_ops)
+			return false;
+		strncpy((char *)dest, out->rtnl_link_ops->kind, IFNAMSIZ);
+		break;
+	default:
+		return false;
+	}
+
+	return true;
+}
+
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
@@ -286,14 +310,9 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		break;
 #endif
 	case NFT_META_IIFKIND:
-		if (in == NULL || in->rtnl_link_ops == NULL)
-			goto err;
-		strncpy((char *)dest, in->rtnl_link_ops->kind, IFNAMSIZ);
-		break;
 	case NFT_META_OIFKIND:
-		if (out == NULL || out->rtnl_link_ops == NULL)
+		if (!nft_meta_get_eval_kind(priv->key, dest, pkt))
 			goto err;
-		strncpy((char *)dest, out->rtnl_link_ops->kind, IFNAMSIZ);
 		break;
 	case NFT_META_TIME_NS:
 	case NFT_META_TIME_DAY:
-- 
2.11.0

