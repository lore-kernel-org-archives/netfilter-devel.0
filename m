Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C7AC433FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 10:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85242205F4
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 10:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfHNKQz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 06:16:55 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:55542 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbfHNKQx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 06:16:53 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 2F57641B60;
        Wed, 14 Aug 2019 18:16:50 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v4 06/12] netfilter: nft_tunnel: support NFT_TUNNEL_IP_SRC/DST match
Date:   Wed, 14 Aug 2019 18:16:42 +0800
Message-Id: <1565777808-28735-7-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1565777808-28735-1-git-send-email-wenxu@ucloud.cn>
References: <1565777808-28735-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUNPS0tLS0hCSktLTU5ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MS46Hxw5MDg9NTkZAjE5CDQf
        SAIKCi1VSlVKTk1OTExMQ0pLSUJKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlMTEo3Bg++
X-HM-Tid: 0a6c8fa1532a2086kuqy2f57641b60
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add new two NFT_TUNNEL_IP_SRC/DST match in nft_tunnel

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v4: don't convert ipaddr to host

 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_tunnel.c               | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 82abaa1..4f1e5ef 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1765,6 +1765,8 @@ enum nft_tunnel_key_attributes {
 enum nft_tunnel_keys {
 	NFT_TUNNEL_PATH,
 	NFT_TUNNEL_ID,
+	NFT_TUNNEL_IP_SRC,
+	NFT_TUNNEL_IP_DST,
 	__NFT_TUNNEL_MAX
 };
 #define NFT_TUNNEL_MAX	(__NFT_TUNNEL_MAX - 1)
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index d374466..fe544bf 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -61,6 +61,26 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 		else
 			regs->verdict.code = NFT_BREAK;
 		break;
+	case NFT_TUNNEL_IP_SRC:
+		if (!tun_info) {
+			regs->verdict.code = NFT_BREAK;
+			return;
+		}
+		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode))
+			*dest = tun_info->key.u.ipv4.src;
+		else
+			regs->verdict.code = NFT_BREAK;
+		break;
+	case NFT_TUNNEL_IP_DST:
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
@@ -90,6 +110,8 @@ static int nft_tunnel_get_init(const struct nft_ctx *ctx,
 		len = sizeof(u8);
 		break;
 	case NFT_TUNNEL_ID:
+	case NFT_TUNNEL_IP_SRC:
+	case NFT_TUNNEL_IP_DST:
 		len = sizeof(u32);
 		break;
 	default:
-- 
1.8.3.1

