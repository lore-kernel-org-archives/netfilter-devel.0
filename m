Return-Path: <SRS0=5AJI=YR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A53CA9EAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 10:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2778E2084C
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 10:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407902AbfJXKfi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 06:35:38 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:44954 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407876AbfJXKfh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 06:35:37 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 40F1641A99;
        Thu, 24 Oct 2019 18:35:36 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/5] netfilter: nft_tunnel: add nft_tunnel_mode_validate function
Date:   Thu, 24 Oct 2019 18:35:32 +0800
Message-Id: <1571913336-13431-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571913336-13431-1-git-send-email-wenxu@ucloud.cn>
References: <1571913336-13431-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSk9PS0tLS05IT0tOTE1ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OTY6ODo4DjgzLR4WKUw4Pw4j
        Fz8aFDxVSlVKTkxKQkpISEhNSEpNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlDQk43Bg++
X-HM-Tid: 0a6dfd5605d82086kuqy40f1641a99
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Move mode validate  common code to nft_tunnel_mode_validate
function.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nft_tunnel.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 3d4c2ae..78b6e8f 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -18,6 +18,19 @@ struct nft_tunnel {
 	enum nft_tunnel_mode	mode:8;
 };
 
+static bool nft_tunnel_mode_validate(enum nft_tunnel_mode priv_mode,
+				     u8 tun_mode)
+{
+	if (priv_mode == NFT_TUNNEL_MODE_NONE ||
+	    (priv_mode == NFT_TUNNEL_MODE_RX &&
+	     !(tun_mode & IP_TUNNEL_INFO_TX)) ||
+	    (priv_mode == NFT_TUNNEL_MODE_TX &&
+	     (tun_mode & IP_TUNNEL_INFO_TX)))
+		return true;
+
+	return false;
+}
+
 static void nft_tunnel_get_eval(const struct nft_expr *expr,
 				struct nft_regs *regs,
 				const struct nft_pktinfo *pkt)
@@ -34,11 +47,7 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 			nft_reg_store8(dest, false);
 			return;
 		}
-		if (priv->mode == NFT_TUNNEL_MODE_NONE ||
-		    (priv->mode == NFT_TUNNEL_MODE_RX &&
-		     !(tun_info->mode & IP_TUNNEL_INFO_TX)) ||
-		    (priv->mode == NFT_TUNNEL_MODE_TX &&
-		     (tun_info->mode & IP_TUNNEL_INFO_TX)))
+		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode))
 			nft_reg_store8(dest, true);
 		else
 			nft_reg_store8(dest, false);
@@ -48,11 +57,7 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 			regs->verdict.code = NFT_BREAK;
 			return;
 		}
-		if (priv->mode == NFT_TUNNEL_MODE_NONE ||
-		    (priv->mode == NFT_TUNNEL_MODE_RX &&
-		     !(tun_info->mode & IP_TUNNEL_INFO_TX)) ||
-		    (priv->mode == NFT_TUNNEL_MODE_TX &&
-		     (tun_info->mode & IP_TUNNEL_INFO_TX)))
+		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode))
 			*dest = ntohl(tunnel_id_to_key32(tun_info->key.tun_id));
 		else
 			regs->verdict.code = NFT_BREAK;
-- 
1.8.3.1

