Return-Path: <SRS0=5AJI=YR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C905CC47E49
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 10:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F1FA2084C
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 10:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407948AbfJXKfi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 06:35:38 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:44986 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407888AbfJXKfh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 06:35:37 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 7D9AE41B23;
        Thu, 24 Oct 2019 18:35:36 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 4/5] netfilter: nft_tunnel: support NFT_TUNNEL_IPV6_SRC/DST match
Date:   Thu, 24 Oct 2019 18:35:35 +0800
Message-Id: <1571913336-13431-5-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571913336-13431-1-git-send-email-wenxu@ucloud.cn>
References: <1571913336-13431-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUlDQkJCQkxJSE9IT09ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OAg6Tgw*Ezg1PR4YOUIPPwkR
        FBFPCQFVSlVKTkxKQkpISEhNTk5DVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlCT083Bg++
X-HM-Tid: 0a6dfd5606d02086kuqy7d9ae41b23
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add new two NFT_TUNNEL_IPV6_SRC/DST match in nft_tunnel

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_tunnel.c               | 28 ++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 7f65019..584868d 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1777,6 +1777,8 @@ enum nft_tunnel_keys {
 	NFT_TUNNEL_ID,
 	NFT_TUNNEL_IPV4_SRC,
 	NFT_TUNNEL_IPV4_DST,
+	NFT_TUNNEL_IPV6_SRC,
+	NFT_TUNNEL_IPV6_DST,
 	__NFT_TUNNEL_MAX
 };
 #define NFT_TUNNEL_MAX	(__NFT_TUNNEL_MAX - 1)
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 580b51b..0a3005d 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -96,6 +96,30 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 		else
 			regs->verdict.code = NFT_BREAK;
 		break;
+	case NFT_TUNNEL_IPV6_SRC:
+		if (!tun_info) {
+			regs->verdict.code = NFT_BREAK;
+			return;
+		}
+		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode,
+					     NFT_INET_IPV6_TYPE))
+			memcpy(dest, &tun_info->key.u.ipv6.src,
+			       sizeof(struct in6_addr));
+		else
+			regs->verdict.code = NFT_BREAK;
+		break;
+	case NFT_TUNNEL_IPV6_DST:
+		if (!tun_info) {
+			regs->verdict.code = NFT_BREAK;
+			return;
+		}
+		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode,
+					     NFT_INET_IPV6_TYPE))
+			memcpy(dest, &tun_info->key.u.ipv6.dst,
+			       sizeof(struct in6_addr));
+		else
+			regs->verdict.code = NFT_BREAK;
+		break;
 	default:
 		WARN_ON(1);
 		regs->verdict.code = NFT_BREAK;
@@ -129,6 +153,10 @@ static int nft_tunnel_get_init(const struct nft_ctx *ctx,
 	case NFT_TUNNEL_IPV4_DST:
 		len = sizeof(u32);
 		break;
+	case NFT_TUNNEL_IPV6_SRC:
+	case NFT_TUNNEL_IPV6_DST:
+		len = sizeof(struct in6_addr);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
1.8.3.1

