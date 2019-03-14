Return-Path: <SRS0=rsEJ=RR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05398C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 10:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C895E2077B
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 10:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfCNKYh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 06:24:37 -0400
Received: from mail.us.es ([193.147.175.20]:56358 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726737AbfCNKYh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 06:24:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 14CC520A531
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2019 11:24:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E95F0DA8F0
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2019 11:24:34 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E39B1DA57A; Thu, 14 Mar 2019 11:24:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E3FF1DA86C;
        Thu, 14 Mar 2019 11:24:32 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 Mar 2019 11:24:32 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B94044265A4E;
        Thu, 14 Mar 2019 11:24:32 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     nevola@gmail.com
Subject: [PATCH nf] netfilter: nf_tables: bogus EBUSY in helper removal from transaction
Date:   Thu, 14 Mar 2019 11:24:28 +0100
Message-Id: <20190314102428.26753-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Proper use counter updates when activating and deactivating the object,
otherwise, this hits bogus EBUSY error.

Reported-by: Laura Garcia <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_objref.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 457a9ceb46af..8dfa798ea683 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -65,21 +65,34 @@ static int nft_objref_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
-static void nft_objref_destroy(const struct nft_ctx *ctx,
-			       const struct nft_expr *expr)
+static void nft_objref_deactivate(const struct nft_ctx *ctx,
+				  const struct nft_expr *expr,
+				  enum nft_trans_phase phase)
 {
 	struct nft_object *obj = nft_objref_priv(expr);
 
+	if (phase == NFT_TRANS_COMMIT)
+		return;
+
 	obj->use--;
 }
 
+static void nft_objref_activate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr)
+{
+	struct nft_object *obj = nft_objref_priv(expr);
+
+	obj->use++;
+}
+
 static struct nft_expr_type nft_objref_type;
 static const struct nft_expr_ops nft_objref_ops = {
 	.type		= &nft_objref_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_object *)),
 	.eval		= nft_objref_eval,
 	.init		= nft_objref_init,
-	.destroy	= nft_objref_destroy,
+	.activate	= nft_objref_activate,
+	.deactivate	= nft_objref_deactivate,
 	.dump		= nft_objref_dump,
 };
 
-- 
2.11.0

