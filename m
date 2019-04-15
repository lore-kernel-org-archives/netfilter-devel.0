Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52642C282DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D14B2075B
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbfDORAm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:00:42 -0400
Received: from mail.us.es ([193.147.175.20]:50436 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727455AbfDORAi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 13:00:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CA9CB1C4433
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA582DA710
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B94DCDA707; Mon, 15 Apr 2019 19:00:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B3531DA707;
        Mon, 15 Apr 2019 19:00:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 19:00:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 806EC4265A31;
        Mon, 15 Apr 2019 19:00:34 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 02/22] netfilter: nf_tables: remove unused parameter ctx
Date:   Mon, 15 Apr 2019 19:00:08 +0200
Message-Id: <20190415170028.3470-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190415170028.3470-1-pablo@netfilter.org>
References: <20190415170028.3470-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Function nf_tables_set_desc_parse parameter ctx is not being used
so remove it as it is redundant.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ee1b0d1445aa..2d28b138ed18 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3436,8 +3436,7 @@ static int nf_tables_getset(struct net *net, struct sock *nlsk,
 	return err;
 }
 
-static int nf_tables_set_desc_parse(const struct nft_ctx *ctx,
-				    struct nft_set_desc *desc,
+static int nf_tables_set_desc_parse(struct nft_set_desc *desc,
 				    const struct nlattr *nla)
 {
 	struct nlattr *da[NFTA_SET_DESC_MAX + 1];
@@ -3563,7 +3562,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 		policy = ntohl(nla_get_be32(nla[NFTA_SET_POLICY]));
 
 	if (nla[NFTA_SET_DESC] != NULL) {
-		err = nf_tables_set_desc_parse(&ctx, &desc, nla[NFTA_SET_DESC]);
+		err = nf_tables_set_desc_parse(&desc, nla[NFTA_SET_DESC]);
 		if (err < 0)
 			return err;
 	}
-- 
2.11.0

