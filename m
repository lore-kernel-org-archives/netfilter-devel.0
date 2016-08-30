From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] expr: numgen: add missing nftnl_expr_ng_cmp()
Date: Tue, 30 Aug 2016 16:17:10 +0200
Message-ID: <1472566630-15744-1-git-send-email-pablo@netfilter.org>
Cc: nevola@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59748 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751029AbcH3ORU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 10:17:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AAE561D94AD
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 16:17:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9B2091B326F
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 16:17:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9C4E21B3552
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 16:17:13 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the missing comparator interface, most likely due to
race between the patchset that has added this and the introduction of
numgen.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/numgen.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index e8fa9a1..0669eda 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -238,10 +238,28 @@ nftnl_expr_ng_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
+static bool nftnl_expr_ng_cmp(const struct nftnl_expr *e1,
+			      const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_ng *n1 = nftnl_expr_data(e1);
+	struct nftnl_expr_ng *n2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_NG_DREG))
+		eq &= (n1->dreg == n2->dreg);
+	if (e1->flags & (1 << NFTNL_EXPR_NG_UNTIL))
+		eq &= (n1->until == n2->until);
+	if (e1->flags & (1 << NFTNL_EXPR_NG_TYPE))
+		eq &= (n1->type == n2->type);
+
+	return eq;
+}
+
 struct expr_ops expr_ops_ng = {
 	.name		= "numgen",
 	.alloc_len	= sizeof(struct nftnl_expr_ng),
 	.max_attr	= NFTA_NG_MAX,
+	.cmp		= nftnl_expr_ng_cmp,
 	.set		= nftnl_expr_ng_set,
 	.get		= nftnl_expr_ng_get,
 	.parse		= nftnl_expr_ng_parse,
-- 
2.1.4

