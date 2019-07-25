Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 313BAC41514
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 04:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10F0722ADA
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 04:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfGYEJ4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 00:09:56 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:3903 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfGYEJ4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 00:09:56 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 49107417A2;
        Thu, 25 Jul 2019 12:09:49 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/5] netfilter: nft_tunnel: support NFT_TUNNEL_SRC/DST_IP match
Date:   Thu, 25 Jul 2019 12:09:37 +0800
Message-Id: <1564027781-24882-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564027781-24882-1-git-send-email-wenxu@ucloud.cn>
References: <1564027781-24882-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSk9IS0tLSklOQ0NOS0pZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MxQ6Lyo5DTg0NlY6GRo6PBUZ
        AiNPCilVSlVKTk1PS0lMTENCSENCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9JSkw3Bg++
X-HM-Tid: 0a6c275220002086kuqy49107417a2
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add new two NFT_TUNNEL_SRC/DST_IP match in nft_tunnel

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_tunnel.c               | 46 +++++++++++++++++++++++++-------
 2 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 82abaa1..173690a 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1765,6 +1765,8 @@ enum nft_tunnel_key_attributes {
 enum nft_tunnel_keys {
 	NFT_TUNNEL_PATH,
 	NFT_TUNNEL_ID,
+	NFT_TUNNEL_SRC_IP,
+	NFT_TUNNEL_DST_IP,
 	__NFT_TUNNEL_MAX
 };
 #define NFT_TUNNEL_MAX	(__NFT_TUNNEL_MAX - 1)
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index c9f4585..c081c9c 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -18,6 +18,18 @@ struct nft_tunnel {
 	enum nft_tunnel_mode	mode:8;
 };
 
+bool nft_tunnel_mode_validate(enum nft_tunnel_mode priv_mode, u8 tun_mode)
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
@@ -34,11 +46,7 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
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
@@ -48,15 +56,31 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 			regs->verdict.code = NFT_BREAK;
 			return;
 		}
-		if (priv->mode == NFT_TUNNEL_MODE_NONE ||
-		    (priv->mode == NFT_TUNNEL_MODE_RX &&
-		     !(tun_info->mode & IP_TUNNEL_INFO_TX)) ||
-		    (priv->mode == NFT_TUNNEL_MODE_TX &&
-		     (tun_info->mode & IP_TUNNEL_INFO_TX)))
+		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode))
 			*dest = tunnel_id_to_key32(tun_info->key.tun_id);
 		else
 			regs->verdict.code = NFT_BREAK;
 		break;
+	case NFT_TUNNEL_SRC_IP:
+		if (!tun_info) {
+			regs->verdict.code = NFT_BREAK;
+			return;
+		}
+		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode))
+			*dest = tun_info->key.u.ipv4.src;
+		else
+			regs->verdict.code = NFT_BREAK;
+		break;
+	case NFT_TUNNEL_DST_IP:
+		if (!tun_info) {
+			regs->verdict.code = NFT_BREAK;
+			return;
+		}
+		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode))
+			*dest = tun_info->key.u.ipv4.dst;
+		else
+			regs->verdict.code = NFT_BREAK;
+		break;
 	default:
 		WARN_ON(1);
 		regs->verdict.code = NFT_BREAK;
@@ -86,6 +110,8 @@ static int nft_tunnel_get_init(const struct nft_ctx *ctx,
 		len = sizeof(u8);
 		break;
 	case NFT_TUNNEL_ID:
+	case NFT_TUNNEL_SRC_IP:
+	case NFT_TUNNEL_DST_IP:
 		len = sizeof(u32);
 		break;
 	default:
-- 
1.8.3.1

