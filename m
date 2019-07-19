Return-Path: <SRS0=2jko=VQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B5CC76196
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 16:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF3512187F
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 16:46:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732113AbfGSQq3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Jul 2019 12:46:29 -0400
Received: from mail.us.es ([193.147.175.20]:50216 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728391AbfGSQq3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 12:46:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 62A23BAEE1
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jul 2019 18:46:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 543C8FF6CC
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jul 2019 18:46:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 49C2DDA704; Fri, 19 Jul 2019 18:46:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2C8ABDA704;
        Fri, 19 Jul 2019 18:46:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 19 Jul 2019 18:46:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.47.94])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BEEAC4265A2F;
        Fri, 19 Jul 2019 18:46:23 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 10/14] netfilter: nf_tables: Support auto-loading for inet nat
Date:   Fri, 19 Jul 2019 18:46:14 +0200
Message-Id: <20190719164618.29581-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Trying to create an inet family nat chain would not cause
nft_chain_nat.ko module to auto-load due to missing module alias. Add a
proper one with hard-coded family value 1 for the pseudo-family
NFPROTO_INET.

Fixes: d164385ec572 ("netfilter: nat: add inet family nat support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_chain_nat.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_chain_nat.c b/net/netfilter/nft_chain_nat.c
index 2f89bde3c61c..ff9ac8ae0031 100644
--- a/net/netfilter/nft_chain_nat.c
+++ b/net/netfilter/nft_chain_nat.c
@@ -142,3 +142,6 @@ MODULE_ALIAS_NFT_CHAIN(AF_INET, "nat");
 #ifdef CONFIG_NF_TABLES_IPV6
 MODULE_ALIAS_NFT_CHAIN(AF_INET6, "nat");
 #endif
+#ifdef CONFIG_NF_TABLES_INET
+MODULE_ALIAS_NFT_CHAIN(1, "nat");	/* NFPROTO_INET */
+#endif
-- 
2.11.0


