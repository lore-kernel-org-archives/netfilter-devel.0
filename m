Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C079EC4CEC7
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 15:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A318B20830
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 15:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390505AbfIMPDW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 11:03:22 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:47461 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390486AbfIMPDV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 11:03:21 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id B371C41624;
        Fri, 13 Sep 2019 23:03:11 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v6 3/8] netfilter: nft_tunnel: add ipv6 check in nft_tunnel_mode_validate
Date:   Fri, 13 Sep 2019 23:03:05 +0800
Message-Id: <1568386990-29660-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568386990-29660-1-git-send-email-wenxu@ucloud.cn>
References: <1568386990-29660-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSk5KS0tLSU1KSEtNTE1ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MRA6Chw5Czg*SCs9ATcaDx5M
        Dx9PCiNVSlVKTk1DSENNQkJKQ0pPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhIQ0o3Bg++
X-HM-Tid: 0a6d2b2646802086kuqyb371c41624
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add ipv6 tunnel check in nft_tunnel_mode_validate.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nft_tunnel.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 9a55546..3ca7d80 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -18,9 +18,19 @@ struct nft_tunnel {
 	enum nft_tunnel_mode	mode:8;
 };
 
+enum nft_inet_type {
+	NFT_INET_NONE_TYPE,
+	NFT_INET_IP_TYPE,
+	NFT_INET_IP6_TYPE,
+};
+
 static bool nft_tunnel_mode_validate(enum nft_tunnel_mode priv_mode,
-				     u8 tun_mode)
+				     u8 tun_mode, enum nft_inet_type type)
 {
+	if ((type == NFT_INET_IP6_TYPE && !(tun_mode & IP_TUNNEL_INFO_IPV6)) ||
+	    (type == NFT_INET_IP_TYPE && (tun_mode & IP_TUNNEL_INFO_IPV6)))
+		return false;
+
 	if (priv_mode == NFT_TUNNEL_MODE_NONE ||
 	    (priv_mode == NFT_TUNNEL_MODE_RX &&
 	     !(tun_mode & IP_TUNNEL_INFO_TX)) ||
@@ -47,7 +57,8 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 			nft_reg_store8(dest, false);
 			return;
 		}
-		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode))
+		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode,
+					     NFT_INET_NONE_TYPE))
 			nft_reg_store8(dest, true);
 		else
 			nft_reg_store8(dest, false);
@@ -57,7 +68,8 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 			regs->verdict.code = NFT_BREAK;
 			return;
 		}
-		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode))
+		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode,
+					     NFT_INET_NONE_TYPE))
 			*dest = ntohl(tunnel_id_to_key32(tun_info->key.tun_id));
 		else
 			regs->verdict.code = NFT_BREAK;
@@ -67,7 +79,8 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 			regs->verdict.code = NFT_BREAK;
 			return;
 		}
-		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode))
+		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode,
+					     NFT_INET_IP_TYPE))
 			*dest = tun_info->key.u.ipv4.src;
 		else
 			regs->verdict.code = NFT_BREAK;
@@ -77,7 +90,8 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 			regs->verdict.code = NFT_BREAK;
 			return;
 		}
-		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode))
+		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode,
+					     NFT_INET_IP_TYPE))
 			*dest = tun_info->key.u.ipv4.dst;
 		else
 			regs->verdict.code = NFT_BREAK;
-- 
1.8.3.1

