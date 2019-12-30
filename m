Return-Path: <SRS0=r9U9=2U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F4DC2D0C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76730206E4
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbfL3LWC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 06:22:02 -0500
Received: from correo.us.es ([193.147.175.20]:59240 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727429AbfL3LV6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 06:21:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C20F54DE724
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:21:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B431EDA715
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:21:56 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A9C24DA701; Mon, 30 Dec 2019 12:21:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A81ECDA701;
        Mon, 30 Dec 2019 12:21:54 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 12:21:54 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [185.124.28.61])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2FCD741E4800;
        Mon, 30 Dec 2019 12:21:54 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/17] netfilter: nft_tunnel: also dump OPTS_ERSPAN/VXLAN
Date:   Mon, 30 Dec 2019 12:21:32 +0100
Message-Id: <20191230112143.121708-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230112143.121708-1-pablo@netfilter.org>
References: <20191230112143.121708-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

This patch is to add the nest attr OPTS_ERSPAN/VXLAN when dumping
KEY_OPTS, and it would be helpful when parsing in userpace. Also,
this is needed for supporting multiple geneve opts in the future
patches.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tunnel.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index b3a9b10ff43d..eb1740236526 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -468,17 +468,24 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 				struct nft_tunnel_obj *priv)
 {
 	struct nft_tunnel_opts *opts = &priv->opts;
-	struct nlattr *nest;
+	struct nlattr *nest, *inner;
 
 	nest = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS);
 	if (!nest)
 		return -1;
 
 	if (opts->flags & TUNNEL_VXLAN_OPT) {
+		inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_VXLAN);
+		if (!inner)
+			return -1;
 		if (nla_put_be32(skb, NFTA_TUNNEL_KEY_VXLAN_GBP,
 				 htonl(opts->u.vxlan.gbp)))
 			return -1;
+		nla_nest_end(skb, inner);
 	} else if (opts->flags & TUNNEL_ERSPAN_OPT) {
+		inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_ERSPAN);
+		if (!inner)
+			return -1;
 		if (nla_put_be32(skb, NFTA_TUNNEL_KEY_ERSPAN_VERSION,
 				 htonl(opts->u.erspan.version)))
 			return -1;
@@ -496,6 +503,7 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 				return -1;
 			break;
 		}
+		nla_nest_end(skb, inner);
 	}
 	nla_nest_end(skb, nest);
 
-- 
2.11.0

