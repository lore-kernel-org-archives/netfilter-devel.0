Return-Path: <SRS0=9u1R=UN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4CB9C31E44
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jun 2019 09:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87E4F21773
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jun 2019 09:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfFNJ6u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Jun 2019 05:58:50 -0400
Received: from mail.us.es ([193.147.175.20]:48890 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbfFNJ6u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 05:58:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7FD75C1A64
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2019 11:58:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6F39EDA705
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2019 11:58:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 64976DA702; Fri, 14 Jun 2019 11:58:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 64E11DA706
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2019 11:58:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 14 Jun 2019 11:58:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4A73D4265A5B
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2019 11:58:46 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] evaluate: double datatype_free() with dynamic integer datatypes
Date:   Fri, 14 Jun 2019 11:58:41 +0200
Message-Id: <20190614095841.18119-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190614095841.18119-1-pablo@netfilter.org>
References: <20190614095841.18119-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

datatype_set() already deals with this case, remove this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h | 1 -
 src/datatype.c     | 5 -----
 src/evaluate.c     | 2 --
 3 files changed, 8 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 23f45ab7d6eb..63617ebd2753 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -260,7 +260,6 @@ extern const struct datatype boolean_type;
 void inet_service_type_print(const struct expr *expr, struct output_ctx *octx);
 
 extern const struct datatype *concat_type_alloc(uint32_t type);
-extern void concat_type_destroy(const struct datatype *dtype);
 
 static inline uint32_t concat_subtype_add(uint32_t type, uint32_t subtype)
 {
diff --git a/src/datatype.c b/src/datatype.c
index 8ae3aa1c3f90..519f79d70b9a 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1162,11 +1162,6 @@ const struct datatype *concat_type_alloc(uint32_t type)
 	return dtype;
 }
 
-void concat_type_destroy(const struct datatype *dtype)
-{
-	datatype_free(dtype);
-}
-
 const struct datatype *set_datatype_alloc(const struct datatype *orig_dtype,
 					  unsigned int byteorder)
 {
diff --git a/src/evaluate.c b/src/evaluate.c
index 337b66c5ad2d..70c7e597f3b0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -71,8 +71,6 @@ static void key_fix_dtype_byteorder(struct expr *key)
 		return;
 
 	datatype_set(key, set_datatype_alloc(dtype, key->byteorder));
-	if (dtype->flags & DTYPE_F_ALLOC)
-		concat_type_destroy(dtype);
 }
 
 static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
-- 
2.11.0

