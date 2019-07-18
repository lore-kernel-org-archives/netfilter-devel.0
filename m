Return-Path: <SRS0=fTMW=VP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77E1C76192
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 03:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B82B62082F
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 03:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389193AbfGRDhf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Jul 2019 23:37:35 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:33874 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732510AbfGRDhf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jul 2019 23:37:35 -0400
Received: from localhost ([::1]:46964 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hnxEb-0008PD-NM; Thu, 18 Jul 2019 05:37:33 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fwestpha@redhat.com>,
        netfilter-devel@vger.kernel.org
Subject: [nf PATCH] net: nf_tables: Make nft_meta expression more robust
Date:   Thu, 18 Jul 2019 05:37:29 +0200
Message-Id: <20190718033729.12438-1-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft_meta_get_eval()'s tendency to bail out setting NFT_BREAK verdict in
situations where required data is missing breaks inverted checks
like e.g.:

| meta iifname != eth0 accept

This rule will never match if there is no input interface (or it is not
known) which is not intuitive and, what's worse, breaks consistency of
iptables-nft with iptables-legacy.

Fix this by falling back to placing a value in dreg which never matches
(avoiding accidental matches):

{I,O}IF:
	Use invalid ifindex value zero.

{I,O}IFNAME, {I,O}IFKIND:
	Use an empty string which is neither a valid interface name nor
	kind.

{I,O}IFTYPE:
	Use ARPHRD_VOID (0xFFFF).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nft_meta.c | 45 +++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 76866f77e3435..ee3b54692cc7e 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -11,6 +11,7 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/if_arp.h>
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
@@ -60,34 +61,22 @@ void nft_meta_get_eval(const struct nft_expr *expr,
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
-		if (in == NULL)
-			goto err;
-		nft_reg_store16(dest, in->type);
+		nft_reg_store16(dest, in ? in->type : ARPHRD_VOID);
 		break;
 	case NFT_META_OIFTYPE:
-		if (out == NULL)
-			goto err;
-		nft_reg_store16(dest, out->type);
+		nft_reg_store16(dest, out ? out->type : ARPHRD_VOID);
 		break;
 	case NFT_META_SKUID:
 		sk = skb_to_full_sk(skb);
@@ -216,16 +205,20 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		nft_reg_store8(dest, secpath_exists(skb));
 		break;
 #endif
-	case NFT_META_IIFKIND:
-		if (in == NULL || in->rtnl_link_ops == NULL)
-			goto err;
-		strncpy((char *)dest, in->rtnl_link_ops->kind, IFNAMSIZ);
+	case NFT_META_IIFKIND: {
+		const struct rtnl_link_ops *rl_ops =
+			in ? in->rtnl_link_ops : NULL;
+
+		strncpy((char *)dest, rl_ops ? rl_ops->kind : "", IFNAMSIZ);
 		break;
-	case NFT_META_OIFKIND:
-		if (out == NULL || out->rtnl_link_ops == NULL)
-			goto err;
-		strncpy((char *)dest, out->rtnl_link_ops->kind, IFNAMSIZ);
+	}
+	case NFT_META_OIFKIND: {
+		const struct rtnl_link_ops *rl_ops =
+			out ? out->rtnl_link_ops : NULL;
+
+		strncpy((char *)dest, rl_ops ? rl_ops->kind : "", IFNAMSIZ);
 		break;
+	}
 	default:
 		WARN_ON(1);
 		goto err;
-- 
2.22.0

