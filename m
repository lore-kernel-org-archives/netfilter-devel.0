Return-Path: <SRS0=HFPz=AM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41C4C433E1
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Jul 2020 20:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D1D42082F
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Jul 2020 20:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgGAUxL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Jul 2020 16:53:11 -0400
Received: from correo.us.es ([193.147.175.20]:35384 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgGAUxK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Jul 2020 16:53:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 82DB4D28CB
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Jul 2020 22:53:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 74B17DA72F
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Jul 2020 22:53:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6A6EEDA722; Wed,  1 Jul 2020 22:53:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 352A8DA73D
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Jul 2020 22:53:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 01 Jul 2020 22:53:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 200C74265A2F
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Jul 2020 22:53:06 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 5/6] netfilter: nf_tables: add nft_chain_add()
Date:   Wed,  1 Jul 2020 22:53:00 +0200
Message-Id: <20200701205301.17204-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200701205301.17204-1-pablo@netfilter.org>
References: <20200701205301.17204-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds a helper function to add the chain to the hashtable and
the chain list.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes:

 net/netfilter/nf_tables_api.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 03fc2538e7c9..572f049d7de4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1914,6 +1914,20 @@ static int nft_basechain_init(struct nft_base_chain *basechain, u8 family,
 	return 0;
 }
 
+static int nft_chain_add(struct nft_table *table, struct nft_chain *chain)
+{
+	int err;
+
+	err = rhltable_insert_key(&table->chains_ht, chain->name,
+				  &chain->rhlhead, nft_chain_ht_params);
+	if (err)
+		return err;
+
+	list_add_tail_rcu(&chain->list, &table->chains);
+
+	return 0;
+}
+
 static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 			      u8 policy, u32 flags)
 {
@@ -1991,16 +2005,9 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	if (err < 0)
 		goto err1;
 
-	err = rhltable_insert_key(&table->chains_ht, chain->name,
-				  &chain->rhlhead, nft_chain_ht_params);
-	if (err)
-		goto err2;
-
 	trans = nft_trans_chain_add(ctx, NFT_MSG_NEWCHAIN);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
-		rhltable_remove(&table->chains_ht, &chain->rhlhead,
-				nft_chain_ht_params);
 		goto err2;
 	}
 
@@ -2008,8 +2015,13 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	if (nft_is_base_chain(chain))
 		nft_trans_chain_policy(trans) = policy;
 
+	err = nft_chain_add(table, chain);
+	if (err < 0) {
+		nft_trans_destroy(trans);
+		goto err2;
+	}
+
 	table->use++;
-	list_add_tail_rcu(&chain->list, &table->chains);
 
 	return 0;
 err2:
-- 
2.20.1

