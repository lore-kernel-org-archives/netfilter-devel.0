Return-Path: <SRS0=r9U9=2U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C510BC2D0D3
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A41AF206E4
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfL3LWa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 06:22:30 -0500
Received: from correo.us.es ([193.147.175.20]:59224 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbfL3LV5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 06:21:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A517B4DE730
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:21:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 98650DA713
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:21:55 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8E3D9DA711; Mon, 30 Dec 2019 12:21:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9575ADA710;
        Mon, 30 Dec 2019 12:21:53 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 12:21:53 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [185.124.28.61])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 14F2141E4800;
        Mon, 30 Dec 2019 12:21:52 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 05/17] netfilter: nft_tunnel: also dump ERSPAN_VERSION
Date:   Mon, 30 Dec 2019 12:21:31 +0100
Message-Id: <20191230112143.121708-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230112143.121708-1-pablo@netfilter.org>
References: <20191230112143.121708-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

This is not necessary, but it'll be easier to parse in userspace,
also given that other places like act_tunnel_key, cls_flower and
ip_tunnel_core are also doing so.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tunnel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 6538895466e0..b3a9b10ff43d 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -479,6 +479,9 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 				 htonl(opts->u.vxlan.gbp)))
 			return -1;
 	} else if (opts->flags & TUNNEL_ERSPAN_OPT) {
+		if (nla_put_be32(skb, NFTA_TUNNEL_KEY_ERSPAN_VERSION,
+				 htonl(opts->u.erspan.version)))
+			return -1;
 		switch (opts->u.erspan.version) {
 		case ERSPAN_VERSION:
 			if (nla_put_be32(skb, NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX,
-- 
2.11.0

