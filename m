Return-Path: <SRS0=EuAs=XL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD84EC49ED7
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:33:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEAFB2184D
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732614AbfIPQdV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Sep 2019 12:33:21 -0400
Received: from correo.us.es ([193.147.175.20]:52764 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbfIPQdV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Sep 2019 12:33:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0368BFC5EA
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Sep 2019 18:33:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA45EA7E1F
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Sep 2019 18:33:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E00DFA7E1E; Mon, 16 Sep 2019 18:33:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 71D67A7E25
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Sep 2019 18:33:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 16 Sep 2019 18:33:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [193.47.165.251])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1EAF642EF4E3
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Sep 2019 18:33:12 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/2] netfilter: nf_tables: add NFT_CHAIN_POLICY_UNSET and use it
Date:   Mon, 16 Sep 2019 18:33:08 +0200
Message-Id: <20190916163309.16946-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Default policy is defined as a unsigned 8-bit field, do not use a
negative value to leave it unset, use this new NFT_CHAIN_POLICY_UNSET
instead.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 2 ++
 net/netfilter/nf_tables_api.c     | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2655e03dbe1b..a26d64056fc8 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -889,6 +889,8 @@ enum nft_chain_flags {
 	NFT_CHAIN_HW_OFFLOAD		= 0x2,
 };
 
+#define NFT_CHAIN_POLICY_UNSET		U8_MAX
+
 /**
  *	struct nft_chain - nf_tables chain
  *
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e4a68dc42694..4a5d6ef2b706 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1715,7 +1715,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		goto err2;
 	}
 
-	nft_trans_chain_policy(trans) = -1;
+	nft_trans_chain_policy(trans) = NFT_CHAIN_POLICY_UNSET;
 	if (nft_is_base_chain(chain))
 		nft_trans_chain_policy(trans) = policy;
 
-- 
2.11.0

