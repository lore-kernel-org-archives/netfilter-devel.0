Return-Path: <SRS0=yr9h=Q5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A06CBC43381
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Feb 2019 09:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7927F2077B
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Feb 2019 09:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfBVJAu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 04:00:50 -0500
Received: from m9783.mail.qiye.163.com ([220.181.97.83]:44368 "EHLO
        m9783.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfBVJAu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 04:00:50 -0500
Received: from 10.19.61.167master (unknown [123.59.132.129])
        by m9783.mail.qiye.163.com (Hmail) with ESMTPA id C0999C1AF7;
        Fri, 22 Feb 2019 17:00:47 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH net-next] netfilter: nft_tunnel: Add dst_cache support
Date:   Fri, 22 Feb 2019 17:00:43 +0800
Message-Id: <1550826043-21278-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kIGBQJHllBS1VLV1koWUFJQjdXWS1ZQUlXWQkOFx4IWUFZMjUtOjcyP0
        FLVUtZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MVE6Ehw4DDkBHQ8sFk8qHE8f
        DjwaCk9VSlVKTk5LQ0lNS09MQkpPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpPTks3Bg++
X-HM-Tid: 0a69146f893d2085kuqyc0999c1af7
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The metadata_dst is not init the dst_cache which make the
ip_md_tunnel_xmit can't use the dst_cache. It will lookup
route table every packets.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nft_tunnel.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index ea28588..b113fca 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -406,6 +406,13 @@ static int nft_tunnel_obj_init(const struct nft_ctx *ctx,
 		return -ENOMEM;
 
 	memcpy(&md->u.tun_info, &info, sizeof(info));
+#ifdef CONFIG_DST_CACHE
+	err = dst_cache_init(&md->u.tun_info.dst_cache, GFP_KERNEL);
+	if (err < 0) {
+		metadata_dst_free(md);
+		return err;
+	}
+#endif
 	ip_tunnel_info_opts_set(&md->u.tun_info, &priv->opts.u, priv->opts.len,
 				priv->opts.flags);
 	priv->md = md;
-- 
1.8.3.1

