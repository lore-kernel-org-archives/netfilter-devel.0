From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] build: fix build error
Date: Mon, 16 Sep 2013 20:20:34 +0200
Message-ID: <20130916182034.6685.68337.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54603 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751149Ab3IPSUo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Sep 2013 14:20:44 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 7611751ED32
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Sep 2013 18:20:41 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EmTC2d9yJ5Z7 for <netfilter-devel@vger.kernel.org>;
	Mon, 16 Sep 2013 20:20:36 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id A9C8F51ED25
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Sep 2013 20:20:36 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This declaration was missing and is needed in case you compile libnftables
without XML parsing support.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/data_reg.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/expr/data_reg.h b/src/expr/data_reg.h
index f41a483..98c3a4c 100644
--- a/src/expr/data_reg.h
+++ b/src/expr/data_reg.h
@@ -23,6 +23,10 @@ union nft_data_reg {
 #define json_t void
 #endif
 
+#ifndef XML_PARSING
+#define mxml_node_t void
+#endif
+
 int nft_data_reg_snprintf(char *buf, size_t size, union nft_data_reg *reg,
                         uint32_t output_format, uint32_t flags, int reg_type);
 int nft_data_reg_xml_parse(union nft_data_reg *reg, mxml_node_t *tree);

