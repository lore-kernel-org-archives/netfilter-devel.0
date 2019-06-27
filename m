Return-Path: <SRS0=TR/Z=U2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BFB7C48BD6
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 13:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4F662084B
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 13:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfF0NHX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 09:07:23 -0400
Received: from m9783.mail.qiye.163.com ([220.181.97.83]:42647 "EHLO
        m9783.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfF0NHW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 09:07:22 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9783.mail.qiye.163.com (Hmail) with ESMTPA id B9E1FC1ADF;
        Thu, 27 Jun 2019 21:07:16 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/2 nf-next v2] netfilter: nft_meta: add NFT_META_BRI_O/IIFVPROTO support
Date:   Thu, 27 Jun 2019 21:07:14 +0800
Message-Id: <1561640835-4507-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVPSEtCQkJCQk9JTExCTllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6ORw6MCo6KTg2CAtDLSkZUUxI
        Nk0wCzVVSlVKTk1KTU9LQ0hNQ0pDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlCQkk3Bg++
X-HM-Tid: 0a6b990c1eaf2085kuqyb9e1fc1adf
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch provide a meta to get the bridge vlan proto

nft add rule bridge firewall zones counter meta br_iifvproto 0x8100

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/uapi/linux/netfilter/nf_tables.h |  4 ++++
 net/netfilter/nft_meta.c                 | 18 ++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 8859535..0f75a6d 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -796,6 +796,8 @@ enum nft_exthdr_attributes {
  * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_BRI_PVID: packet input bridge port pvid
+ * @NFT_META_BRI_IIFVPROTO: packet input bridge port vlan proto
+ * @NFT_META_BRI_OIFVPROTO: packet output bridge port vlan proto
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -827,6 +829,8 @@ enum nft_meta_keys {
 	NFT_META_IIFKIND,
 	NFT_META_OIFKIND,
 	NFT_META_BRI_PVID,
+	NFT_META_BRI_IIFVPROTO,
+	NFT_META_BRI_OIFVPROTO,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 4f8116d..e7e10fb 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -248,6 +248,22 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 			return;
 		}
 		goto err;
+	case NFT_META_BRI_IIFVPROTO:
+		if (in == NULL || (p = br_port_get_rtnl_rcu(in)) == NULL)
+			goto err;
+		if (br_opt_get(p->br, BROPT_VLAN_ENABLED)) {
+			nft_reg_store16(dest, p->br->vlan_proto);
+			return;
+		}
+		goto err;
+	case NFT_META_BRI_OIFVPROTO:
+		if (out == NULL || (p = br_port_get_rtnl_rcu(out)) == NULL)
+			goto err;
+		if (br_opt_get(p->br, BROPT_VLAN_ENABLED)) {
+			nft_reg_store16(dest, p->br->vlan_proto);
+			return;
+		}
+		goto err;
 #endif
 	case NFT_META_IIFKIND:
 		if (in == NULL || in->rtnl_link_ops == NULL)
@@ -376,6 +392,8 @@ static int nft_meta_get_init(const struct nft_ctx *ctx,
 		len = IFNAMSIZ;
 		break;
 	case NFT_META_BRI_PVID:
+	case NFT_META_BRI_IIFVPROTO:
+	case NFT_META_BRI_OIFVPROTO:
 		if (ctx->family != NFPROTO_BRIDGE)
 			return -EOPNOTSUPP;
 		len = sizeof(u16);
-- 
1.8.3.1

