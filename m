Return-Path: <SRS0=r9U9=2U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D2DC2D0C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E2A5206E4
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfL3LV5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 06:21:57 -0500
Received: from correo.us.es ([193.147.175.20]:59240 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727399AbfL3LV4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 06:21:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 75A4B4DE722
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:21:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6765FDA71A
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:21:53 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5CEA8DA714; Mon, 30 Dec 2019 12:21:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 606BDDA709;
        Mon, 30 Dec 2019 12:21:51 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 12:21:51 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [185.124.28.61])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CC2E541E4801;
        Mon, 30 Dec 2019 12:21:50 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 03/17] netfilter: nft_tunnel: no need to call htons() when dumping ports
Date:   Mon, 30 Dec 2019 12:21:29 +0100
Message-Id: <20191230112143.121708-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230112143.121708-1-pablo@netfilter.org>
References: <20191230112143.121708-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

info->key.tp_src and tp_dst are __be16, when using nla_put_be16()
to dump them, htons() is not needed, so remove it in this patch.

Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tunnel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 3d4c2ae605a8..ef2065dd4f8a 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -501,8 +501,8 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 static int nft_tunnel_ports_dump(struct sk_buff *skb,
 				 struct ip_tunnel_info *info)
 {
-	if (nla_put_be16(skb, NFTA_TUNNEL_KEY_SPORT, htons(info->key.tp_src)) < 0 ||
-	    nla_put_be16(skb, NFTA_TUNNEL_KEY_DPORT, htons(info->key.tp_dst)) < 0)
+	if (nla_put_be16(skb, NFTA_TUNNEL_KEY_SPORT, info->key.tp_src) < 0 ||
+	    nla_put_be16(skb, NFTA_TUNNEL_KEY_DPORT, info->key.tp_dst) < 0)
 		return -1;
 
 	return 0;
-- 
2.11.0

