From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftables] expr: log: release prefix
Date: Mon, 18 Nov 2013 14:20:04 +0100
Message-ID: <1384780804-31740-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50505 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab3KRNUN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:20:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ana Rey reported a leak in the log expression. Fix it by using
the new .free interface added in (3cf788a expr: fix leak in target
and match expressions).

Reported-by: Ana Rey Botello <anarey@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/log.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/src/expr/log.c b/src/expr/log.c
index 1f88246..2d3e0cf 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -268,10 +268,18 @@ nft_rule_expr_log_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
+static void nft_rule_expr_log_free(struct nft_rule_expr *e)
+{
+	struct nft_expr_log *log = nft_expr_data(e);
+
+	xfree(log->prefix);
+}
+
 struct expr_ops expr_ops_log = {
 	.name		= "log",
 	.alloc_len	= sizeof(struct nft_expr_log),
 	.max_attr	= NFTA_LOG_MAX,
+	.free		= nft_rule_expr_log_free,
 	.set		= nft_rule_expr_log_set,
 	.get		= nft_rule_expr_log_get,
 	.parse		= nft_rule_expr_log_parse,
-- 
1.7.10.4

