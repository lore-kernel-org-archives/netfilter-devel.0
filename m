From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] set: xml: fix key_type parsing
Date: Wed, 04 Sep 2013 18:03:25 +0200
Message-ID: <20130904160324.19268.79096.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:35326 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756855Ab3IDQDf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:03:35 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 45ECB51ED05
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Sep 2013 16:03:33 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eCGUeDIG2CK8 for <netfilter-devel@vger.kernel.org>;
	Wed,  4 Sep 2013 18:03:28 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 0CDC151ED22
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Sep 2013 18:03:26 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bug introduced by myself at 44928cd5 [set: add XML parsing]

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/src/set.c b/src/set.c
index 1168b54..fe30e77 100644
--- a/src/set.c
+++ b/src/set.c
@@ -458,7 +458,7 @@ static int nft_set_xml_parse(struct nft_set *s, const char *xml)
 	s->flags |= (1 << NFT_SET_ATTR_KEY_TYPE);
 
 	if (nft_mxml_num_parse(tree, "key_len", MXML_DESCEND_FIRST,
-			       BASE_DEC, &s->key_type, NFT_TYPE_U32) != 0)
+			       BASE_DEC, &s->key_len, NFT_TYPE_U32) != 0)
 		goto err;
 
 	s->flags |= (1 << NFT_SET_ATTR_KEY_LEN);

