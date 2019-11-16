Return-Path: <SRS0=YpW3=ZI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67FABC43141
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Nov 2019 07:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BCC620730
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Nov 2019 07:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfKPHt3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Nov 2019 02:49:29 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:57394 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbfKPHt2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Nov 2019 02:49:28 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id A058F4162F;
        Sat, 16 Nov 2019 15:49:24 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v2 3/4] netfilter: nft_tunnel: support NFT_TUNNEL_IPV6_SRC/DST match
Date:   Sat, 16 Nov 2019 15:49:23 +0800
Message-Id: <1573890564-16500-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573890564-16500-1-git-send-email-wenxu@ucloud.cn>
References: <1573890564-16500-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkhOS0tLSktCTUxJTk5ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Okk6LSo4Kzg8AwoSDwETPzcB
        ElEwCxpVSlVKTkxIQ0JLTk1PTEhNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhPS0g3Bg++
X-HM-Tid: 0a6e733022392086kuqya058f4162f
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add new two NFT_TUNNEL_IPV6_SRC/DST match in nft_tunnel

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v2: add nft_tunnel_mode_match_ip6

 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_tunnel.c               | 36 ++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 1621d72..d067ee7 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1779,6 +1779,8 @@ enum nft_tunnel_keys {
 	NFT_TUNNEL_ID,
 	NFT_TUNNEL_IPV4_SRC,
 	NFT_TUNNEL_IPV4_DST,
+	NFT_TUNNEL_IPV6_SRC,
+	NFT_TUNNEL_IPV6_DST,
 	__NFT_TUNNEL_MAX
 };
 #define NFT_TUNNEL_MAX	(__NFT_TUNNEL_MAX - 1)
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 67f7718..943a704 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -41,6 +41,16 @@ static bool nft_tunnel_mode_match_ip(enum nft_tunnel_mode priv_mode,
 	return false;
 }
 
+static bool nft_tunnel_mode_match_ip6(enum nft_tunnel_mode priv_mode,
+				       struct ip_tunnel_info *tun_info)
+{
+	if (nft_tunnel_mode_match(priv_mode, tun_info->mode) &&
+	    ip_tunnel_info_af(tun_info) == AF_INET6)
+		return true;
+
+	return false;
+}
+
 static void nft_tunnel_get_eval(const struct nft_expr *expr,
 				struct nft_regs *regs,
 				const struct nft_pktinfo *pkt)
@@ -90,6 +100,28 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 		else
 			regs->verdict.code = NFT_BREAK;
 		break;
+	case NFT_TUNNEL_IPV6_SRC:
+		if (!tun_info) {
+			regs->verdict.code = NFT_BREAK;
+			return;
+		}
+		if (nft_tunnel_mode_match_ip6(priv->mode, tun_info))
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
+		if (nft_tunnel_mode_match_ip6(priv->mode, tun_info))
+			memcpy(dest, &tun_info->key.u.ipv6.dst,
+			       sizeof(struct in6_addr));
+		else
+			regs->verdict.code = NFT_BREAK;
+		break;
 	default:
 		WARN_ON(1);
 		regs->verdict.code = NFT_BREAK;
@@ -123,6 +155,10 @@ static int nft_tunnel_get_init(const struct nft_ctx *ctx,
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

