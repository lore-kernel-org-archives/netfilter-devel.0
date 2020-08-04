Return-Path: <SRS0=6lPY=BO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C625C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 14:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F07F2075F
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 14:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgHDOJB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Aug 2020 10:09:01 -0400
Received: from correo.us.es ([193.147.175.20]:39756 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728024AbgHDOJB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 10:09:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F2D73FB366
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 16:08:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E422EDA73D
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 16:08:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D9A25DA72F; Tue,  4 Aug 2020 16:08:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B17CBDA73F
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 16:08:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 04 Aug 2020 16:08:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [213.143.49.65])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 40ED44265A2F
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 16:08:55 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] udata: add cookie support
Date:   Tue,  4 Aug 2020 16:08:27 +0200
Message-Id: <20200804140827.6270-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch extends userdata to store a unsigned 64-bit cookie value.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/udata.h |  6 ++++++
 src/libnftnl.map         |  5 +++++
 src/udata.c              | 17 +++++++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/include/libnftnl/udata.h b/include/libnftnl/udata.h
index 661493b48618..2c846978f5c3 100644
--- a/include/libnftnl/udata.h
+++ b/include/libnftnl/udata.h
@@ -12,6 +12,7 @@ extern "C" {
 enum nftnl_udata_rule_types {
 	NFTNL_UDATA_RULE_COMMENT,
 	NFTNL_UDATA_RULE_EBTABLES_POLICY,
+	NFTNL_UDATA_RULE_COOKIE,
 	__NFTNL_UDATA_RULE_MAX
 };
 #define NFTNL_UDATA_RULE_MAX (__NFTNL_UDATA_RULE_MAX - 1)
@@ -26,6 +27,7 @@ enum nftnl_udata_set_types {
 	NFTNL_UDATA_SET_DATA_TYPEOF,
 	NFTNL_UDATA_SET_EXPR,
 	NFTNL_UDATA_SET_DATA_INTERVAL,
+	NFTNL_UDATA_SET_COOKIE,
 	__NFTNL_UDATA_SET_MAX
 };
 #define NFTNL_UDATA_SET_MAX (__NFTNL_UDATA_SET_MAX - 1)
@@ -40,6 +42,7 @@ enum {
 enum nftnl_udata_set_elem_types {
 	NFTNL_UDATA_SET_ELEM_COMMENT,
 	NFTNL_UDATA_SET_ELEM_FLAGS,
+	NFTNL_UDATA_SET_ELEM_COOKIE,
 	__NFTNL_UDATA_SET_ELEM_MAX
 };
 #define NFTNL_UDATA_SET_ELEM_MAX (__NFTNL_UDATA_SET_ELEM_MAX - 1)
@@ -74,6 +77,8 @@ bool nftnl_udata_put(struct nftnl_udata_buf *buf, uint8_t type, uint32_t len,
 		     const void *value);
 bool nftnl_udata_put_u32(struct nftnl_udata_buf *buf, uint8_t type,
 			 uint32_t data);
+bool nftnl_udata_put_u64(struct nftnl_udata_buf *buf, uint8_t type,
+			 uint64_t data);
 bool nftnl_udata_put_strz(struct nftnl_udata_buf *buf, uint8_t type,
 			  const char *strz);
 
@@ -87,6 +92,7 @@ uint8_t nftnl_udata_type(const struct nftnl_udata *attr);
 uint8_t nftnl_udata_len(const struct nftnl_udata *attr);
 void *nftnl_udata_get(const struct nftnl_udata *attr);
 uint32_t nftnl_udata_get_u32(const struct nftnl_udata *attr);
+uint64_t nftnl_udata_get_u64(const struct nftnl_udata *attr);
 
 /* iterator */
 struct nftnl_udata *nftnl_udata_next(const struct nftnl_udata *attr);
diff --git a/src/libnftnl.map b/src/libnftnl.map
index f62640f83e6b..cbb5f0ae54c5 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -368,3 +368,8 @@ LIBNFTNL_14 {
   nftnl_flowtable_set_array;
   nftnl_flowtable_get_array;
 } LIBNFTNL_13;
+
+LIBNFTNL_15 {
+  nftnl_udata_get_u64;
+  nftnl_udata_put_u64;
+} LIBNFTNL_14;
diff --git a/src/udata.c b/src/udata.c
index 0cc3520ccede..a257663089e1 100644
--- a/src/udata.c
+++ b/src/udata.c
@@ -101,6 +101,13 @@ bool nftnl_udata_put_u32(struct nftnl_udata_buf *buf, uint8_t type,
 	return nftnl_udata_put(buf, type, sizeof(data), &data);
 }
 
+EXPORT_SYMBOL(nftnl_udata_put_u64);
+bool nftnl_udata_put_u64(struct nftnl_udata_buf *buf, uint8_t type,
+			 uint64_t data)
+{
+	return nftnl_udata_put(buf, type, sizeof(data), &data);
+}
+
 EXPORT_SYMBOL(nftnl_udata_type);
 uint8_t nftnl_udata_type(const struct nftnl_udata *attr)
 {
@@ -129,6 +136,16 @@ uint32_t nftnl_udata_get_u32(const struct nftnl_udata *attr)
 	return data;
 }
 
+EXPORT_SYMBOL(nftnl_udata_get_u64);
+uint64_t nftnl_udata_get_u64(const struct nftnl_udata *attr)
+{
+	uint64_t data;
+
+	memcpy(&data, attr->value, sizeof(data));
+
+	return data;
+}
+
 EXPORT_SYMBOL(nftnl_udata_next);
 struct nftnl_udata *nftnl_udata_next(const struct nftnl_udata *attr)
 {
-- 
2.20.1

