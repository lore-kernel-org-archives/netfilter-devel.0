Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC7FC433FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC75420843
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfHNIet (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 04:34:49 -0400
Received: from correo.us.es ([193.147.175.20]:57468 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbfHNIet (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 04:34:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BD40CC4144
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 10:34:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AFD6C203F2
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 10:34:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A57C3DA7E1; Wed, 14 Aug 2019 10:34:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9753721FE4;
        Wed, 14 Aug 2019 10:34:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Aug 2019 10:34:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5F5704265A32;
        Wed, 14 Aug 2019 10:34:44 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft,v2] gmputil: assert length is non-zero
Date:   Wed, 14 Aug 2019 10:34:42 +0200
Message-Id: <20190814083442.24470-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Importing, exporting and byteswapping zero length data should not
happen.

Add inline functions so we know from where the assertion is triggered in
the code for easier diagnosing in the future.

When importing datatype.h from gmputil.h, it seems gcc complains on
missing declarations in json.h.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: use inline for easier diagnosing.

 include/gmputil.h | 38 +++++++++++++++++++++++++++++++-------
 include/json.h    |  4 ++++
 src/gmputil.c     | 16 +++++++---------
 3 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/include/gmputil.h b/include/gmputil.h
index ad63d67b4e05..38aa0e0dc11a 100644
--- a/include/gmputil.h
+++ b/include/gmputil.h
@@ -52,12 +52,36 @@ extern uint32_t mpz_get_be32(const mpz_t op);
 extern uint16_t mpz_get_be16(const mpz_t op);
 
 enum byteorder;
-extern void *mpz_export_data(void *data, const mpz_t op,
-			     enum byteorder byteorder,
-			     unsigned int len);
-extern void mpz_import_data(mpz_t rop, const void *data,
-			    enum byteorder byteorder,
-			    unsigned int len);
-extern void mpz_switch_byteorder(mpz_t rop, unsigned int len);
+extern void *__mpz_export_data(void *data, const mpz_t op,
+			       enum byteorder byteorder, unsigned int len);
+extern void __mpz_import_data(mpz_t rop, const void *data,
+			      enum byteorder byteorder, unsigned int len);
+extern void __mpz_switch_byteorder(mpz_t rop, unsigned int len);
+
+#include <assert.h>
+#include <datatype.h>
+
+static inline void *mpz_export_data(void *data, const mpz_t op,
+				    enum byteorder byteorder, unsigned int len)
+{
+	assert(len > 0);
+
+	return __mpz_export_data(data, op, byteorder, len);
+}
+
+static inline void mpz_import_data(mpz_t rop, const void *data,
+				   enum byteorder byteorder, unsigned int len)
+{
+	assert(len > 0);
+
+	__mpz_import_data(rop, data, byteorder, len);
+}
+
+static inline void mpz_switch_byteorder(mpz_t rop, unsigned int len)
+{
+	assert(len > 0);
+
+	__mpz_switch_byteorder(rop, len);
+}
 
 #endif /* NFTABLES_GMPUTIL_H */
diff --git a/include/json.h b/include/json.h
index 7f2df7c8220f..20d6c2a4a8e7 100644
--- a/include/json.h
+++ b/include/json.h
@@ -15,6 +15,10 @@ struct stmt;
 struct symbol_table;
 struct table;
 struct netlink_mon_handler;
+struct nft_ctx;
+struct location;
+struct output_ctx;
+struct list_head;
 
 #ifdef HAVE_LIBJANSSON
 
diff --git a/src/gmputil.c b/src/gmputil.c
index a25f42ee2b64..b356460fa739 100644
--- a/src/gmputil.c
+++ b/src/gmputil.c
@@ -87,9 +87,8 @@ uint16_t mpz_get_be16(const mpz_t op)
 	return mpz_get_type(uint16_t, MPZ_BIG_ENDIAN, op);
 }
 
-void *mpz_export_data(void *data, const mpz_t op,
-		      enum byteorder byteorder,
-		      unsigned int len)
+void *__mpz_export_data(void *data, const mpz_t op, enum byteorder byteorder,
+			unsigned int len)
 {
 	enum mpz_word_order order;
 	enum mpz_byte_order endian;
@@ -111,9 +110,8 @@ void *mpz_export_data(void *data, const mpz_t op,
 	return data;
 }
 
-void mpz_import_data(mpz_t rop, const void *data,
-		     enum byteorder byteorder,
-		     unsigned int len)
+void __mpz_import_data(mpz_t rop, const void *data, enum byteorder byteorder,
+		       unsigned int len)
 {
 	enum mpz_word_order order;
 	enum mpz_byte_order endian;
@@ -133,12 +131,12 @@ void mpz_import_data(mpz_t rop, const void *data,
 	mpz_import(rop, len, order, 1, endian, 0, data);
 }
 
-void mpz_switch_byteorder(mpz_t rop, unsigned int len)
+void __mpz_switch_byteorder(mpz_t rop, unsigned int len)
 {
 	char data[len];
 
-	mpz_export_data(data, rop, BYTEORDER_BIG_ENDIAN, len);
-	mpz_import_data(rop, data, BYTEORDER_HOST_ENDIAN, len);
+	__mpz_export_data(data, rop, BYTEORDER_BIG_ENDIAN, len);
+	__mpz_import_data(rop, data, BYTEORDER_HOST_ENDIAN, len);
 }
 
 #ifndef HAVE_LIBGMP
-- 
2.11.0


