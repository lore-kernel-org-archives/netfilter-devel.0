Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8991C432C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 20:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9707621D7A
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 20:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392624AbfIYUaW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 16:30:22 -0400
Received: from correo.us.es ([193.147.175.20]:44558 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388605AbfIYUaW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 16:30:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9D790C5159
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2019 22:30:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8E1C6CE17F
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2019 22:30:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B4F64A7DB1; Wed, 25 Sep 2019 22:30:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AF543A7E35;
        Wed, 25 Sep 2019 22:30:13 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 25 Sep 2019 22:30:13 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7C0C14265A5A;
        Wed, 25 Sep 2019 22:30:13 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/5] netfilter: nf_tables: add NFT_CHAIN_POLICY_UNSET and use it
Date:   Wed, 25 Sep 2019 22:29:59 +0200
Message-Id: <20190925203003.20112-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190925203003.20112-1-pablo@netfilter.org>
References: <20190925203003.20112-1-pablo@netfilter.org>
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

