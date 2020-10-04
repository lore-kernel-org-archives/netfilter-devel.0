Return-Path: <SRS0=OxIk=DL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A9F3C4727D
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Oct 2020 19:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3AA22067D
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Oct 2020 19:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgJDTu0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 4 Oct 2020 15:50:26 -0400
Received: from correo.us.es ([193.147.175.20]:34950 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726570AbgJDTuN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Oct 2020 15:50:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BD7E3EF433
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2020 21:50:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B0B46DA730
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2020 21:50:10 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A61ABDA78C; Sun,  4 Oct 2020 21:50:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B030DA730;
        Sun,  4 Oct 2020 21:50:08 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 04 Oct 2020 21:50:08 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 52F2942EF9E2;
        Sun,  4 Oct 2020 21:50:08 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 05/11] netfilter: nf_tables: use nla_memdup to copy udata
Date:   Sun,  4 Oct 2020 21:49:34 +0200
Message-Id: <20201004194940.7368-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201004194940.7368-1-pablo@netfilter.org>
References: <20201004194940.7368-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: "Jose M. Guisado Gomez" <guigom@riseup.net>

When userdata support was added to tables and objects, user data coming
from user space was allocated and copied using kzalloc + nla_memcpy.

Use nla_memdup to copy userdata of tables and objects.

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b3c3c3fc1969..0473316aa392 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -986,7 +986,6 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	struct nft_table *table;
 	struct nft_ctx ctx;
 	u32 flags = 0;
-	u16 udlen = 0;
 	int err;
 
 	lockdep_assert_held(&net->nft.commit_mutex);
@@ -1023,13 +1022,11 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 		goto err_strdup;
 
 	if (nla[NFTA_TABLE_USERDATA]) {
-		udlen = nla_len(nla[NFTA_TABLE_USERDATA]);
-		table->udata = kzalloc(udlen, GFP_KERNEL);
+		table->udata = nla_memdup(nla[NFTA_TABLE_USERDATA], GFP_KERNEL);
 		if (table->udata == NULL)
 			goto err_table_udata;
 
-		nla_memcpy(table->udata, nla[NFTA_TABLE_USERDATA], udlen);
-		table->udlen = udlen;
+		table->udlen = nla_len(nla[NFTA_TABLE_USERDATA]);
 	}
 
 	err = rhltable_init(&table->chains_ht, &nft_chain_ht_params);
@@ -5900,7 +5897,6 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 	struct nft_object *obj;
 	struct nft_ctx ctx;
 	u32 objtype;
-	u16 udlen;
 	int err;
 
 	if (!nla[NFTA_OBJ_TYPE] ||
@@ -5957,13 +5953,11 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 	}
 
 	if (nla[NFTA_OBJ_USERDATA]) {
-		udlen = nla_len(nla[NFTA_OBJ_USERDATA]);
-		obj->udata = kzalloc(udlen, GFP_KERNEL);
+		obj->udata = nla_memdup(nla[NFTA_OBJ_USERDATA], GFP_KERNEL);
 		if (obj->udata == NULL)
 			goto err_userdata;
 
-		nla_memcpy(obj->udata, nla[NFTA_OBJ_USERDATA], udlen);
-		obj->udlen = udlen;
+		obj->udlen = nla_len(nla[NFTA_OBJ_USERDATA]);
 	}
 
 	err = nft_trans_obj_add(&ctx, NFT_MSG_NEWOBJ, obj);
-- 
2.20.1

