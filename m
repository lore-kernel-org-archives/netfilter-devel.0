From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] log: fix qthreshold data type
Date: Thu, 25 Jul 2013 11:59:41 +0200
Message-ID: <20130725095941.22630.18584.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:47875 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753121Ab3GYJ74 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:59:56 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 1C6F751EEBF
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2013 09:59:53 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ECC9KJSRaf9v for <netfilter-devel@vger.kernel.org>;
	Thu, 25 Jul 2013 11:59:48 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 3C0D551EEB7
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2013 11:59:45 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As stated in include/net/netfilter/nf_log.h, qthreshold is uint16_t instead of uint32_t.

This patch fixes it.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/log.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/expr/log.c b/src/expr/log.c
index 1ffd1d9..d8502e5 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -25,7 +25,7 @@
 struct nft_expr_log {
 	uint32_t		group;
 	uint32_t		snaplen;
-	uint32_t		qthreshold;
+	uint16_t		qthreshold;
 	char			*prefix;
 };
 
@@ -49,7 +49,7 @@ nft_rule_expr_log_set(struct nft_rule_expr *e, uint16_t type,
 		log->snaplen = *((uint32_t *)data);
 		break;
 	case NFT_EXPR_LOG_QTHRESHOLD:
-		log->qthreshold = *((uint32_t *)data);
+		log->qthreshold = *((uint16_t *)data);
 		break;
 	default:
 		return -1;
@@ -197,7 +197,7 @@ static int nft_rule_expr_log_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 		goto err;
 
 	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT32_MAX || tmp < 0 || *endptr)
+	if (tmp > UINT16_MAX || tmp < 0 || *endptr)
 		goto err;
 
 	log->qthreshold = tmp;

