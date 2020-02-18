Return-Path: <SRS0=aYEw=4G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FECC34026
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Feb 2020 13:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44D482173E
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Feb 2020 13:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgBRNmW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Feb 2020 08:42:22 -0500
Received: from correo.us.es ([193.147.175.20]:42436 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbgBRNmW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Feb 2020 08:42:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 76E91C1B6C
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Feb 2020 14:42:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6822EDA3A0
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Feb 2020 14:42:20 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5DCB1DA390; Tue, 18 Feb 2020 14:42:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 54CF1DA7B2;
        Tue, 18 Feb 2020 14:42:18 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Feb 2020 14:42:18 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3A7C942EE38E;
        Tue, 18 Feb 2020 14:42:18 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH libnftnl] src: add nftnl_*_{get,set}_array()
Date:   Tue, 18 Feb 2020 14:42:15 +0100
Message-Id: <20200218134215.560717-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The original intention in eb58f53372e7 ("src: add flowtable support")
was to introduce this helper function. Add helper to set and to get
array of strings.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/chain.h     |  2 ++
 include/libnftnl/flowtable.h |  4 ++--
 src/chain.c                  | 18 ++++++++++++++++++
 src/flowtable.c              | 18 ++++++++++++++++++
 src/libnftnl.map             |  4 ++++
 5 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/include/libnftnl/chain.h b/include/libnftnl/chain.h
index 33d04e19b05f..edb1279a20c2 100644
--- a/include/libnftnl/chain.h
+++ b/include/libnftnl/chain.h
@@ -46,6 +46,7 @@ void nftnl_chain_set_u32(struct nftnl_chain *t, uint16_t attr, uint32_t data);
 void nftnl_chain_set_s32(struct nftnl_chain *t, uint16_t attr, int32_t data);
 void nftnl_chain_set_u64(struct nftnl_chain *t, uint16_t attr, uint64_t data);
 int nftnl_chain_set_str(struct nftnl_chain *t, uint16_t attr, const char *str);
+int nftnl_chain_set_array(struct nftnl_chain *t, uint16_t attr, const char **data);
 
 const void *nftnl_chain_get(const struct nftnl_chain *c, uint16_t attr);
 const void *nftnl_chain_get_data(const struct nftnl_chain *c, uint16_t attr,
@@ -55,6 +56,7 @@ uint8_t nftnl_chain_get_u8(const struct nftnl_chain *c, uint16_t attr);
 uint32_t nftnl_chain_get_u32(const struct nftnl_chain *c, uint16_t attr);
 int32_t nftnl_chain_get_s32(const struct nftnl_chain *c, uint16_t attr);
 uint64_t nftnl_chain_get_u64(const struct nftnl_chain *c, uint16_t attr);
+const char * const *nftnl_chain_get_array(const struct nftnl_chain *c, uint16_t attr);
 
 void nftnl_chain_rule_add(struct nftnl_rule *rule, struct nftnl_chain *c);
 void nftnl_chain_rule_del(struct nftnl_rule *rule);
diff --git a/include/libnftnl/flowtable.h b/include/libnftnl/flowtable.h
index bdff114aba54..352f8a50adef 100644
--- a/include/libnftnl/flowtable.h
+++ b/include/libnftnl/flowtable.h
@@ -41,7 +41,7 @@ void nftnl_flowtable_set_u32(struct nftnl_flowtable *t, uint16_t attr, uint32_t
 void nftnl_flowtable_set_s32(struct nftnl_flowtable *t, uint16_t attr, int32_t data);
 void nftnl_flowtable_set_u64(struct nftnl_flowtable *t, uint16_t attr, uint64_t data);
 int nftnl_flowtable_set_str(struct nftnl_flowtable *t, uint16_t attr, const char *str);
-void nftnl_flowtable_set_array(struct nftnl_flowtable *t, uint16_t attr, const char **data);
+int nftnl_flowtable_set_array(struct nftnl_flowtable *t, uint16_t attr, const char **data);
 
 const void *nftnl_flowtable_get(const struct nftnl_flowtable *c, uint16_t attr);
 const void *nftnl_flowtable_get_data(const struct nftnl_flowtable *c, uint16_t attr,
@@ -50,7 +50,7 @@ const char *nftnl_flowtable_get_str(const struct nftnl_flowtable *c, uint16_t at
 uint32_t nftnl_flowtable_get_u32(const struct nftnl_flowtable *c, uint16_t attr);
 int32_t nftnl_flowtable_get_s32(const struct nftnl_flowtable *c, uint16_t attr);
 uint64_t nftnl_flowtable_get_u64(const struct nftnl_flowtable *c, uint16_t attr);
-const char **nftnl_flowtable_get_array(const struct nftnl_flowtable *t, uint16_t attr);
+const char * const *nftnl_flowtable_get_array(const struct nftnl_flowtable *t, uint16_t attr);
 
 struct nlmsghdr;
 
diff --git a/src/chain.c b/src/chain.c
index b4066e4d4e88..e25eb0f5934b 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -319,6 +319,13 @@ int nftnl_chain_set_str(struct nftnl_chain *c, uint16_t attr, const char *str)
 	return nftnl_chain_set_data(c, attr, str, strlen(str) + 1);
 }
 
+EXPORT_SYMBOL(nftnl_chain_set_array);
+int nftnl_chain_set_array(struct nftnl_chain *c, uint16_t attr,
+			  const char **data)
+{
+	return nftnl_chain_set_data(c, attr, data, 0);
+}
+
 EXPORT_SYMBOL(nftnl_chain_get_data);
 const void *nftnl_chain_get_data(const struct nftnl_chain *c, uint16_t attr,
 				 uint32_t *data_len)
@@ -426,6 +433,17 @@ uint8_t nftnl_chain_get_u8(const struct nftnl_chain *c, uint16_t attr)
 	return val ? *val : 0;
 }
 
+EXPORT_SYMBOL(nftnl_chain_get_array);
+const char * const *nftnl_chain_get_array(const struct nftnl_chain *c, uint16_t attr)
+{
+	uint32_t data_len;
+	const char * const *val = nftnl_chain_get_data(c, attr, &data_len);
+
+	nftnl_assert(val, attr, attr == NFTNL_CHAIN_DEVICES);
+
+	return val;
+}
+
 EXPORT_SYMBOL(nftnl_chain_nlmsg_build_payload);
 void nftnl_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_chain *c)
 {
diff --git a/src/flowtable.c b/src/flowtable.c
index 1e235d0ba50f..6e18dde8242e 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -206,6 +206,13 @@ void nftnl_flowtable_set_u64(struct nftnl_flowtable *c, uint16_t attr, uint64_t
 	nftnl_flowtable_set_data(c, attr, &data, sizeof(uint64_t));
 }
 
+EXPORT_SYMBOL(nftnl_flowtable_set_array);
+int nftnl_flowtable_set_array(struct nftnl_flowtable *c, uint16_t attr,
+			      const char **data)
+{
+	return nftnl_flowtable_set_data(c, attr, data, 0);
+}
+
 EXPORT_SYMBOL(nftnl_flowtable_get_data);
 const void *nftnl_flowtable_get_data(const struct nftnl_flowtable *c,
 				     uint16_t attr, uint32_t *data_len)
@@ -290,6 +297,17 @@ int32_t nftnl_flowtable_get_s32(const struct nftnl_flowtable *c, uint16_t attr)
 	return val ? *val : 0;
 }
 
+EXPORT_SYMBOL(nftnl_flowtable_get_array);
+const char * const *nftnl_flowtable_get_array(const struct nftnl_flowtable *c, uint16_t attr)
+{
+	uint32_t data_len;
+	const char * const *val = nftnl_flowtable_get_data(c, attr, &data_len);
+
+	nftnl_assert(val, attr, attr == NFTNL_FLOWTABLE_DEVICES);
+
+	return val;
+}
+
 EXPORT_SYMBOL(nftnl_flowtable_nlmsg_build_payload);
 void nftnl_flowtable_nlmsg_build_payload(struct nlmsghdr *nlh,
 					 const struct nftnl_flowtable *c)
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 5ba8d995440e..f62640f83e6b 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -363,4 +363,8 @@ LIBNFTNL_13 {
 LIBNFTNL_14 {
   nftnl_udata_nest_start;
   nftnl_udata_nest_end;
+  nftnl_chain_set_array;
+  nftnl_chain_get_array;
+  nftnl_flowtable_set_array;
+  nftnl_flowtable_get_array;
 } LIBNFTNL_13;
-- 
2.11.0

