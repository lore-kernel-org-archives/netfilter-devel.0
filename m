From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] xml: expr: limit: fix wrong assignation when
	parsing
Date: Mon, 12 Aug 2013 09:35:23 +0200
Message-ID: <20130812073523.20663.74939.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:59725 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754462Ab3HLHfe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Aug 2013 03:35:34 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 82A1B51ED77
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Aug 2013 07:35:31 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N+demvFJUdRd for <netfilter-devel@vger.kernel.org>;
	Mon, 12 Aug 2013 09:35:26 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 6457C51ED6E
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Aug 2013 09:35:26 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This assignation was wrong.

Introduced at commit e13819c
(src: xml: consolidate common XML code via nft_mxml_num_parse).


Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/src/expr/limit.c b/src/expr/limit.c
index 9f20c38..336bdb0 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -130,7 +130,7 @@ static int nft_rule_expr_limit_xml_parse(struct nft_rule_expr *e, mxml_node_t *t
 	e->flags |= (1 << NFT_EXPR_LIMIT_RATE);
 
 	if (nft_mxml_num_parse(tree, "depth", MXML_DESCEND_FIRST, BASE_DEC,
-			       &limit->rate, NFT_TYPE_U64) != 0)
+			       &limit->depth, NFT_TYPE_U64) != 0)
 		return -1;
 
 	e->flags |= (1 << NFT_EXPR_LIMIT_DEPTH);

