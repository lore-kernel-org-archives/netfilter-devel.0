Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAFE0C433E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Jan 2021 19:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B362422AAD
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Jan 2021 19:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbhAPTIM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Jan 2021 14:08:12 -0500
Received: from correo.us.es ([193.147.175.20]:59934 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725964AbhAPTIL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Jan 2021 14:08:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 836781BFA80
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Jan 2021 20:06:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7574BDA722
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Jan 2021 20:06:41 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6B164DA704; Sat, 16 Jan 2021 20:06:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B145DA730
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Jan 2021 20:06:39 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 16 Jan 2021 20:06:39 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 46F7242DC6DF
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Jan 2021 20:06:39 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_dynset: dump expressions when set definition contains no expressions
Date:   Sat, 16 Jan 2021 20:07:24 +0100
Message-Id: <20210116190724.17499-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the set definition provides no stateful expressions, then include the
stateful expression in the ruleset listing. Without this fix, the dynset
rule listing shows the stateful expressions provided by the set
definition.

Fixes: 65038428b2c6 ("netfilter: nf_tables: allow to specify stateful expression in set definition")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_dynset.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 218c09e4fddd..d164ef9e6843 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -384,22 +384,25 @@ static int nft_dynset_dump(struct sk_buff *skb, const struct nft_expr *expr)
 			 nf_jiffies64_to_msecs(priv->timeout),
 			 NFTA_DYNSET_PAD))
 		goto nla_put_failure;
-	if (priv->num_exprs == 1) {
-		if (nft_expr_dump(skb, NFTA_DYNSET_EXPR, priv->expr_array[0]))
-			goto nla_put_failure;
-	} else if (priv->num_exprs > 1) {
-		struct nlattr *nest;
-
-		nest = nla_nest_start_noflag(skb, NFTA_DYNSET_EXPRESSIONS);
-		if (!nest)
-			goto nla_put_failure;
-
-		for (i = 0; i < priv->num_exprs; i++) {
-			if (nft_expr_dump(skb, NFTA_LIST_ELEM,
-					  priv->expr_array[i]))
+	if (priv->set->num_exprs == 0) {
+		if (priv->num_exprs == 1) {
+			if (nft_expr_dump(skb, NFTA_DYNSET_EXPR,
+					  priv->expr_array[0]))
 				goto nla_put_failure;
+		} else if (priv->num_exprs > 1) {
+			struct nlattr *nest;
+
+			nest = nla_nest_start_noflag(skb, NFTA_DYNSET_EXPRESSIONS);
+			if (!nest)
+				goto nla_put_failure;
+
+			for (i = 0; i < priv->num_exprs; i++) {
+				if (nft_expr_dump(skb, NFTA_LIST_ELEM,
+						  priv->expr_array[i]))
+					goto nla_put_failure;
+			}
+			nla_nest_end(skb, nest);
 		}
-		nla_nest_end(skb, nest);
 	}
 	if (nla_put_be32(skb, NFTA_DYNSET_FLAGS, htonl(flags)))
 		goto nla_put_failure;
-- 
2.20.1

