From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] include: table: chain: added set and get for u8 values in chain and table.
Date: Tue, 19 Nov 2013 13:01:56 +0100
Message-ID: <1384862516-3518-1-git-send-email-anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:50600 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab3KSMEl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Nov 2013 07:04:41 -0500
Received: by mail-wi0-f180.google.com with SMTP id c19so516600wiw.13
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2013 04:04:40 -0800 (PST)
Received: from localhost.localdomain (143.149.20.95.dynamic.jazztel.es. [95.20.149.143])
        by mx.google.com with ESMTPSA id f15sm20323652wik.6.2013.11.19.04.04.39
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2013 04:04:40 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I need it to allocate and show some values for chain and table.
I missed it doing the tests of libnftables.
---
 include/libnftables/chain.h |  2 ++
 include/libnftables/table.h |  2 ++
 src/chain.c                 | 13 +++++++++++++
 src/libnftables.map         |  4 ++++
 src/table.c                 | 13 +++++++++++++
 5 files changed, 34 insertions(+)

diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index 28f837f..a642b83 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -35,6 +35,7 @@ enum {
 bool nft_chain_attr_is_set(const struct nft_chain *c, uint16_t attr);
 void nft_chain_attr_unset(struct nft_chain *c, uint16_t attr);
 void nft_chain_attr_set(struct nft_chain *t, uint16_t attr, const void *data);
+void nft_chain_attr_set_u8(struct nft_chain *t, uint16_t attr, uint8_t data);
 void nft_chain_attr_set_u32(struct nft_chain *t, uint16_t attr, uint32_t data);
 void nft_chain_attr_set_s32(struct nft_chain *t, uint16_t attr, int32_t data);
 void nft_chain_attr_set_u64(struct nft_chain *t, uint16_t attr, uint64_t data);
@@ -42,6 +43,7 @@ void nft_chain_attr_set_str(struct nft_chain *t, uint16_t attr, const char *str)
 
 const void *nft_chain_attr_get(struct nft_chain *c, uint16_t attr);
 const char *nft_chain_attr_get_str(struct nft_chain *c, uint16_t attr);
+uint8_t nft_chain_attr_get_u8(struct nft_chain *c, uint16_t attr);
 uint32_t nft_chain_attr_get_u32(struct nft_chain *c, uint16_t attr);
 int32_t nft_chain_attr_get_s32(struct nft_chain *c, uint16_t attr);
 uint64_t nft_chain_attr_get_u64(struct nft_chain *c, uint16_t attr);
diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index 63a737e..9b0d866 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -28,8 +28,10 @@ void nft_table_attr_unset(struct nft_table *t, uint16_t attr);
 void nft_table_attr_set(struct nft_table *t, uint16_t attr, const void *data);
 const void *nft_table_attr_get(struct nft_table *t, uint16_t attr);
 
+void nft_table_attr_set_u8(struct nft_table *t, uint16_t attr, uint8_t data);
 void nft_table_attr_set_u32(struct nft_table *t, uint16_t attr, uint32_t data);
 void nft_table_attr_set_str(struct nft_table *t, uint16_t attr, const char *str);
+uint8_t nft_table_attr_get_u8(struct nft_table *t, uint16_t attr);
 uint32_t nft_table_attr_get_u32(struct nft_table *t, uint16_t attr);
 const char *nft_table_attr_get_str(struct nft_table *t, uint16_t attr);
 
diff --git a/src/chain.c b/src/chain.c
index a58999d..0145d32 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -206,6 +206,12 @@ void nft_chain_attr_set_u64(struct nft_chain *c, uint16_t attr, uint64_t data)
 }
 EXPORT_SYMBOL(nft_chain_attr_set_u64);
 
+void nft_chain_attr_set_u8(struct nft_chain *c, uint16_t attr, uint8_t data)
+{
+	nft_chain_attr_set(c, attr, &data);
+}
+EXPORT_SYMBOL(nft_chain_attr_set_u8);
+
 void nft_chain_attr_set_str(struct nft_chain *c, uint16_t attr, const char *str)
 {
 	nft_chain_attr_set(c, attr, str);
@@ -272,6 +278,13 @@ uint64_t nft_chain_attr_get_u64(struct nft_chain *c, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_chain_attr_get_u64);
 
+uint8_t nft_chain_attr_get_u8(struct nft_chain *c, uint16_t attr)
+{
+	const uint8_t *val = nft_chain_attr_get(c, attr);
+	return val ? *val : 0;
+}
+EXPORT_SYMBOL(nft_chain_attr_get_u8);
+
 struct nlmsghdr *
 nft_chain_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family,
 			  uint16_t type, uint32_t seq)
diff --git a/src/libnftables.map b/src/libnftables.map
index aa47714..3bdfeda 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -6,8 +6,10 @@ global:
   nft_table_attr_unset;
   nft_table_attr_set;
   nft_table_attr_get;
+  nft_table_attr_set_u8;
   nft_table_attr_set_u32;
   nft_table_attr_set_str;
+  nft_table_attr_get_u8;
   nft_table_attr_get_u32;
   nft_table_attr_get_str;
   nft_table_parse;
@@ -32,11 +34,13 @@ global:
   nft_chain_attr_is_set;
   nft_chain_attr_unset;
   nft_chain_attr_set;
+  nft_chain_attr_set_u8;
   nft_chain_attr_set_u32;
   nft_chain_attr_set_s32;
   nft_chain_attr_set_u64;
   nft_chain_attr_set_str;
   nft_chain_attr_get;
+  nft_chain_attr_get_u8;
   nft_chain_attr_get_u32;
   nft_chain_attr_get_s32;
   nft_chain_attr_get_u64;
diff --git a/src/table.c b/src/table.c
index fe37f90..cf24cae 100644
--- a/src/table.c
+++ b/src/table.c
@@ -103,6 +103,12 @@ void nft_table_attr_set_u32(struct nft_table *t, uint16_t attr, uint32_t val)
 }
 EXPORT_SYMBOL(nft_table_attr_set_u32);
 
+void nft_table_attr_set_u8(struct nft_table *t, uint16_t attr, uint8_t val)
+{
+	nft_table_attr_set(t, attr, &val);
+}
+EXPORT_SYMBOL(nft_table_attr_set_u8);
+
 void nft_table_attr_set_str(struct nft_table *t, uint16_t attr, const char *str)
 {
 	nft_table_attr_set(t, attr, str);
@@ -133,6 +139,13 @@ uint32_t nft_table_attr_get_u32(struct nft_table *t, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_table_attr_get_u32);
 
+uint8_t nft_table_attr_get_u8(struct nft_table *t, uint16_t attr)
+{
+	const void *ret = nft_table_attr_get(t, attr);
+	return ret == NULL ? 0 : *((uint8_t *)ret);
+}
+EXPORT_SYMBOL(nft_table_attr_get_u8);
+
 const char *nft_table_attr_get_str(struct nft_table *t, uint16_t attr)
 {
 	return nft_table_attr_get(t, attr);
-- 
1.8.4.rc3

