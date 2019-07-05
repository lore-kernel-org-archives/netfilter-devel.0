Return-Path: <SRS0=b56t=VC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94150C46499
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 13:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77F9C218CA
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 13:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbfGENQt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 09:16:49 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:49056 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfGENQs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 09:16:48 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id C25D241955;
        Fri,  5 Jul 2019 21:16:39 +0800 (CST)
From:   wenxu@ucloud.cn
To:     nikolay@cumulusnetworks.com, pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [PATCH 4/7 nf-next v2] netfilter: nft_meta_bridge: add NFT_META_BRI_IIFPVID support
Date:   Fri,  5 Jul 2019 21:16:35 +0800
Message-Id: <1562332598-17415-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562332598-17415-1-git-send-email-wenxu@ucloud.cn>
References: <1562332598-17415-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS0xCQkJCQ0tPT0JNTExZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MyI6Lzo*LzgyLggOTjcsVjdP
        ShQwCRVVSlVKTk1JSEhJTkJCQ05JVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhMSkk3Bg++
X-HM-Tid: 0a6bc24796092086kuqyc25d241955
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

nft add table bridge firewall
nft add chain bridge firewall zones { type filter hook prerouting priority - 300 \; }
nft add rule bridge firewall zones counter ct zone set vlan id map { 100 : 1, 200 : 2 }

As above set the bridge port with pvid, the received packet don't contain
the vlan tag which means the packet should belong to vlan 200 through pvid.
With this pacth user can get the pvid of bridge ports.

So add the following rule for as the first rule in the chain of zones.

nft add rule bridge firewall zones counter meta vlan set meta briifpvid

Signed-off-by: wenxu <wenxu@ucloud.cn>
Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/bridge/netfilter/nft_meta_bridge.c   | 15 +++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index c6c8ec5..8a1bd0b 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -795,6 +795,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
  * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
+ * @NFT_META_BRI_IIFPVID: packet input bridge port pvid
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -825,6 +826,7 @@ enum nft_meta_keys {
 	NFT_META_SECPATH,
 	NFT_META_IIFKIND,
 	NFT_META_OIFKIND,
+	NFT_META_BRI_IIFPVID,
 };
 
 /**
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 2ea8acb..9487d42 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -7,6 +7,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nft_meta.h>
+#include <linux/if_bridge.h>
 
 static const struct net_device *
 nft_meta_get_bridge(const struct net_device *dev)
@@ -37,6 +38,17 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 		if (!br_dev)
 			goto err;
 		break;
+	case NFT_META_BRI_IIFPVID: {
+		u16 p_pvid;
+
+		br_dev = nft_meta_get_bridge(in);
+		if (!br_dev || !br_vlan_enabled(br_dev))
+			goto err;
+
+		br_vlan_get_pvid_rcu(in, &p_pvid);
+		nft_reg_store16(dest, p_pvid);
+		return;
+	}
 	default:
 		goto out;
 	}
@@ -62,6 +74,9 @@ static int nft_meta_bridge_get_init(const struct nft_ctx *ctx,
 	case NFT_META_BRI_OIFNAME:
 		len = IFNAMSIZ;
 		break;
+	case NFT_META_BRI_IIFPVID:
+		len = sizeof(u16);
+		break;
 	default:
 		return nft_meta_get_init(ctx, expr, tb);
 	}
-- 
1.8.3.1

