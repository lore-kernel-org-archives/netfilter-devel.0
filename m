From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 1/2] tests: fix deprecation warning xt_LOG
Date: Thu, 28 Nov 2013 12:30:10 +0100
Message-ID: <20131128113010.11152.61271.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:34074 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758544Ab3K1LaO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:30:14 -0500
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 695CA51ED8F
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2013 11:30:12 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7rjFb+B9O4k6 for <netfilter-devel@vger.kernel.org>;
	Thu, 28 Nov 2013 12:30:12 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 27C7651ED76
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2013 12:30:11 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This fix the warning:

In file included from nft-expr_target-test.c:19:0:
/usr/include/linux/netfilter_ipv4/ipt_LOG.h:4:2: warning:
#warning "Please update iptables, this file will be removed soon!" [-Wcpp]

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/nft-expr_target-test.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/nft-expr_target-test.c b/tests/nft-expr_target-test.c
index 3d0368f..7bde348 100644
--- a/tests/nft-expr_target-test.c
+++ b/tests/nft-expr_target-test.c
@@ -16,7 +16,7 @@
 #include <netinet/ip.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/xt_iprange.h>
-#include <linux/netfilter_ipv4/ipt_LOG.h>
+#include <linux/netfilter/xt_LOG.h>
 #include <libmnl/libmnl.h>
 #include <libnftables/rule.h>
 #include <libnftables/expr.h>
@@ -57,7 +57,7 @@ int main(int argc, char *argv[])
 	struct nft_rule *a, *b;
 	struct nft_rule_expr *ex;
 	struct nlmsghdr *nlh;
-	struct ipt_log_info *info;
+	struct xt_log_info *info;
 	char buf[4096];
 	struct nft_rule_expr_iter *iter_a, *iter_b;
 	struct nft_rule_expr *rule_a, *rule_b;
@@ -73,7 +73,7 @@ int main(int argc, char *argv[])
 	nft_rule_expr_set(ex, NFT_EXPR_TG_NAME, "test", strlen("test"));
 	nft_rule_expr_set_u32(ex, NFT_EXPR_TG_REV, 0x12345678);
 
-	info = calloc(1, sizeof(struct ipt_log_info));
+	info = calloc(1, sizeof(struct xt_log_info));
 	if (info == NULL)
 		print_err("OOM");
 	sprintf(info->prefix, "test: ");

