Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BFCEC46470
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 12:27:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5235121019
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 12:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389436AbfETM06 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 08:26:58 -0400
Received: from mail.us.es ([193.147.175.20]:34214 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389355AbfETM05 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 08:26:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CC2361D94AA
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 14:26:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BBA1BDA708
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 14:26:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B0C09DA702; Mon, 20 May 2019 14:26:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8857DA705;
        Mon, 20 May 2019 14:26:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 20 May 2019 14:26:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 853084265A32;
        Mon, 20 May 2019 14:26:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH iptables 3/6] nft: add __nft_table_builtin_find()
Date:   Mon, 20 May 2019 14:26:43 +0200
Message-Id: <20190520122646.17788-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190520122646.17788-1-pablo@netfilter.org>
References: <20190520122646.17788-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 6c6cd787c06f..b0a15e9b3f7c 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -688,25 +688,31 @@ static void nft_chain_builtin_add(struct nft_handle *h,
 	nftnl_chain_list_add_tail(c, h->cache->table[table->type].chains);
 }
 
-/* find if built-in table already exists */
-const struct builtin_table *
-nft_table_builtin_find(struct nft_handle *h, const char *table)
+static const struct builtin_table *
+__nft_table_builtin_find(const struct builtin_table *tables, const char *table)
 {
 	int i;
 	bool found = false;
 
 	for (i = 0; i < NFT_TABLE_MAX; i++) {
-		if (h->tables[i].name == NULL)
+		if (tables[i].name == NULL)
 			continue;
 
-		if (strcmp(h->tables[i].name, table) != 0)
+		if (strcmp(tables[i].name, table) != 0)
 			continue;
 
 		found = true;
 		break;
 	}
 
-	return found ? &h->tables[i] : NULL;
+	return found ? &tables[i] : NULL;
+}
+
+/* find if built-in table already exists */
+const struct builtin_table *
+nft_table_builtin_find(struct nft_handle *h, const char *table)
+{
+	return __nft_table_builtin_find(h->tables, table);
 }
 
 /* find if built-in chain already exists */
-- 
2.11.0

