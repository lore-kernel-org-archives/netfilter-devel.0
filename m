Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C8CC4360F
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB47820838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfCBSh2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:37:28 -0500
Received: from mail.us.es ([193.147.175.20]:36362 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726754AbfCBSh2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:37:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AF9AB1361AE
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:37:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9C026DA85D
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:37:26 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8E976DA84E; Sat,  2 Mar 2019 19:37:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4BD7DA844;
        Sat,  2 Mar 2019 19:37:24 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:37:24 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3F45A4265A2F;
        Sat,  2 Mar 2019 19:37:24 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 20/29] netfilter: nft_tunnel: Add dst_cache support
Date:   Sat,  2 Mar 2019 19:37:11 +0100
Message-Id: <20190302183720.3220-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The metadata_dst does not initialize the dst_cache field, this causes
problems to ip_md_tunnel_xmit() since it cannot use this cache, hence,
Triggering a route lookup for every packet.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tunnel.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index ea28588c5eed..b113fcac94e1 100644
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
2.11.0


