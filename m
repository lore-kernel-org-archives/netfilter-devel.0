From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] netlink_delinearize: add assertion to prevent infinite loop
Date: Fri,  2 Feb 2018 13:32:01 +0100
Message-ID: <20180202123201.7091-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36248 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751544AbeBBMcI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Feb 2018 07:32:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7B03DE2C40
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2018 13:32:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 683DADA247
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2018 13:32:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76D79DA2CD
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2018 13:32:05 +0100 (CET)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5F646418BB40
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2018 13:32:05 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following configuration:

 table inet filter {
	chain input {
		ct original ip daddr {1.2.3.4} accept
	}
 }

is triggering an infinite loop.

This problem also exists with concatenations and ct ip {s,d}addr. Until
we have a solution for this, let's just prevent infinite loops.

Now we hit this:

 # nft list ruleset
 nft: netlink_delinearize.c:124: netlink_parse_concat_expr: Assertion `consumed > 0' failed.
 Abort

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Just a band aid before releasing 0.8.2, ct ip {s,daddr} with inet family
needs a closer look, will be sending a RFC patch to discuss this asap.

 src/netlink_delinearize.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 2637f4baaec4..256552b5b46e 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -108,6 +108,7 @@ static struct expr *netlink_parse_concat_expr(struct netlink_parse_ctx *ctx,
 					      unsigned int len)
 {
 	struct expr *concat, *expr;
+	unsigned int consumed;
 
 	concat = concat_expr_alloc(loc);
 	while (len > 0) {
@@ -119,7 +120,9 @@ static struct expr *netlink_parse_concat_expr(struct netlink_parse_ctx *ctx,
 		}
 		compound_expr_add(concat, expr);
 
-		len -= netlink_padded_len(expr->len);
+		consumed = netlink_padded_len(expr->len);
+		assert(consumed > 0);
+		len -= consumed;
 		reg += netlink_register_space(expr->len);
 	}
 	return concat;
-- 
2.11.0

