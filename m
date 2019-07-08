Return-Path: <SRS0=pcH3=VF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A00FC606AB
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 10:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D3EB2064B
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 10:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbfGHKdC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 06:33:02 -0400
Received: from mail.us.es ([193.147.175.20]:34262 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730111AbfGHKcx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 06:32:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5957EBAE97
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2019 12:32:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A7B0114D9A
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2019 12:32:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3FC96A0ADB; Mon,  8 Jul 2019 12:32:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4492DA0AAC;
        Mon,  8 Jul 2019 12:32:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jul 2019 12:32:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 179F74265A31;
        Mon,  8 Jul 2019 12:32:50 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 13/15] netfilter: nf_tables: add nft_expr_type_request_module()
Date:   Mon,  8 Jul 2019 12:32:35 +0200
Message-Id: <20190708103237.28061-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190708103237.28061-1-pablo@netfilter.org>
References: <20190708103237.28061-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This helper function makes sure the family specific extension is loaded.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index cae5c46e2dd4..582f4e475d67 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2019,6 +2019,19 @@ static const struct nft_expr_type *__nft_expr_type_get(u8 family,
 	return NULL;
 }
 
+#ifdef CONFIG_MODULES
+static int nft_expr_type_request_module(struct net *net, u8 family,
+					struct nlattr *nla)
+{
+	nft_request_module(net, "nft-expr-%u-%.*s", family,
+			   nla_len(nla), (char *)nla_data(nla));
+	if (__nft_expr_type_get(family, nla))
+		return -EAGAIN;
+
+	return 0;
+}
+#endif
+
 static const struct nft_expr_type *nft_expr_type_get(struct net *net,
 						     u8 family,
 						     struct nlattr *nla)
@@ -2035,9 +2048,7 @@ static const struct nft_expr_type *nft_expr_type_get(struct net *net,
 	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
 	if (type == NULL) {
-		nft_request_module(net, "nft-expr-%u-%.*s", family,
-				   nla_len(nla), (char *)nla_data(nla));
-		if (__nft_expr_type_get(family, nla))
+		if (nft_expr_type_request_module(net, family, nla) == -EAGAIN)
 			return ERR_PTR(-EAGAIN);
 
 		nft_request_module(net, "nft-expr-%.*s",
-- 
2.11.0

