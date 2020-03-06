Return-Path: <SRS0=2TpG=4X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D52C3F2D6
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Mar 2020 18:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCBEB20578
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Mar 2020 18:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgCFSPY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Mar 2020 13:15:24 -0500
Received: from correo.us.es ([193.147.175.20]:40792 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726859AbgCFSPY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Mar 2020 13:15:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7D39515AEB4
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Mar 2020 19:15:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6EBF9DA788
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Mar 2020 19:15:05 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6475DDA390; Fri,  6 Mar 2020 19:15:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F2D9DA3A4;
        Fri,  6 Mar 2020 19:15:03 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 06 Mar 2020 19:15:03 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 60A264301DE0;
        Fri,  6 Mar 2020 19:15:03 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 08/11] netfilter: nft_tunnel: add missing attribute validation for tunnels
Date:   Fri,  6 Mar 2020 19:15:10 +0100
Message-Id: <20200306181513.656594-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200306181513.656594-1-pablo@netfilter.org>
References: <20200306181513.656594-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

Add missing attribute validation for tunnel source and
destination ports to the netlink policy.

Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tunnel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 4c3f2e24c7cb..764e88682a81 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -339,6 +339,8 @@ static const struct nla_policy nft_tunnel_key_policy[NFTA_TUNNEL_KEY_MAX + 1] =
 	[NFTA_TUNNEL_KEY_FLAGS]	= { .type = NLA_U32, },
 	[NFTA_TUNNEL_KEY_TOS]	= { .type = NLA_U8, },
 	[NFTA_TUNNEL_KEY_TTL]	= { .type = NLA_U8, },
+	[NFTA_TUNNEL_KEY_SPORT]	= { .type = NLA_U16, },
+	[NFTA_TUNNEL_KEY_DPORT]	= { .type = NLA_U16, },
 	[NFTA_TUNNEL_KEY_OPTS]	= { .type = NLA_NESTED, },
 };
 
-- 
2.11.0

