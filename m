Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B2AC04AAC
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 14:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91EB4216B7
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 14:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391828AbfETOl1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 10:41:27 -0400
Received: from mail.us.es ([193.147.175.20]:37328 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730630AbfETOlY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 10:41:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 200ACC1A63
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 16:41:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 100BCDA70E
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 16:41:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0F368DA707; Mon, 20 May 2019 16:41:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0BB64DA70E;
        Mon, 20 May 2019 16:41:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 20 May 2019 16:41:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D51FE4265A32;
        Mon, 20 May 2019 16:41:19 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, phil@nwl.cc
Subject: [PATCH iptables RFC 1/4] nft: don't check for table existence from __nft_table_flush()
Date:   Mon, 20 May 2019 16:41:12 +0200
Message-Id: <20190520144115.29732-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190520144115.29732-1-pablo@netfilter.org>
References: <20190520144115.29732-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a partial revert of d3e378b4a93f ("xtables: add skip flag to
objects"). This should be handled from the ERESTART case.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 172beec9ae27..0f0492bc200c 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2103,10 +2103,9 @@ int nft_for_each_table(struct nft_handle *h,
 	return 0;
 }
 
-static int __nft_table_flush(struct nft_handle *h, const char *table, bool exists)
+static int __nft_table_flush(struct nft_handle *h, const char *table)
 {
 	const struct builtin_table *_t;
-	struct obj_update *obj;
 	struct nftnl_table *t;
 
 	t = nftnl_table_alloc();
@@ -2115,14 +2114,7 @@ static int __nft_table_flush(struct nft_handle *h, const char *table, bool exist
 
 	nftnl_table_set_str(t, NFTNL_TABLE_NAME, table);
 
-	obj = batch_table_add(h, NFT_COMPAT_TABLE_FLUSH, t);
-	if (!obj) {
-		nftnl_table_free(t);
-		return -1;
-	}
-
-	if (!exists)
-		obj->skip = 1;
+	batch_table_add(h, NFT_COMPAT_TABLE_FLUSH, t);
 
 	_t = nft_table_builtin_find(h, table);
 	assert(_t);
@@ -2138,7 +2130,6 @@ int nft_table_flush(struct nft_handle *h, const char *table)
 	struct nftnl_table_list_iter *iter;
 	struct nftnl_table_list *list;
 	struct nftnl_table *t;
-	bool exists = false;
 	int ret = 0;
 
 	nft_fn = nft_table_flush;
@@ -2160,15 +2151,17 @@ int nft_table_flush(struct nft_handle *h, const char *table)
 		const char *table_name =
 			nftnl_table_get_str(t, NFTNL_TABLE_NAME);
 
-		if (strcmp(table_name, table) == 0) {
-			exists = true;
-			break;
-		}
+		if (strcmp(table_name, table) != 0)
+			goto next;
 
+		ret = __nft_table_flush(h, table);
+		if (ret < 0)
+			goto err_table_iter;
+next:
 		t = nftnl_table_list_iter_next(iter);
 	}
 
-	ret = __nft_table_flush(h, table, exists);
+err_table_iter:
 	nftnl_table_list_iter_destroy(iter);
 err_table_list:
 err_out:
-- 
2.11.0

