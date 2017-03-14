From: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 1/2] object: extend set/get api for u8/u16 types
Date: Tue, 14 Mar 2017 20:54:00 +0100
Message-ID: <20170314195401.1334-2-fw@strlen.de>
References: <20170314195401.1334-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:42120 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750937AbdCNTxs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 15:53:48 -0400
In-Reply-To: <20170314195401.1334-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/libnftnl/object.h |  4 ++++
 src/libnftnl.map          |  4 ++++
 src/object.c              | 26 ++++++++++++++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
index 074a37789734..ca3abeae66cc 100644
--- a/include/libnftnl/object.h
+++ b/include/libnftnl/object.h
@@ -44,12 +44,16 @@ void nftnl_obj_unset(struct nftnl_obj *ne, uint16_t attr);
 void nftnl_obj_set_data(struct nftnl_obj *ne, uint16_t attr, const void *data,
 			uint32_t data_len);
 void nftnl_obj_set(struct nftnl_obj *ne, uint16_t attr, const void *data);
+void nftnl_obj_set_u8(struct nftnl_obj *ne, uint16_t attr, uint8_t val);
+void nftnl_obj_set_u16(struct nftnl_obj *ne, uint16_t attr, uint16_t val);
 void nftnl_obj_set_u32(struct nftnl_obj *ne, uint16_t attr, uint32_t val);
 void nftnl_obj_set_u64(struct nftnl_obj *obj, uint16_t attr, uint64_t val);
 void nftnl_obj_set_str(struct nftnl_obj *ne, uint16_t attr, const char *str);
 const void *nftnl_obj_get_data(struct nftnl_obj *ne, uint16_t attr,
 			       uint32_t *data_len);
 const void *nftnl_obj_get(struct nftnl_obj *ne, uint16_t attr);
+uint8_t nftnl_obj_get_u8(struct nftnl_obj *ne, uint16_t attr);
+uint16_t nftnl_obj_get_u16(struct nftnl_obj *obj, uint16_t attr);
 uint32_t nftnl_obj_get_u32(struct nftnl_obj *ne, uint16_t attr);
 uint64_t nftnl_obj_get_u64(struct nftnl_obj *obj, uint16_t attr);
 const char *nftnl_obj_get_str(struct nftnl_obj *ne, uint16_t attr);
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 4c082102aa29..1892c983eb50 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -278,9 +278,13 @@ global:
   nftnl_obj_unset;
   nftnl_obj_set;
   nftnl_obj_get;
+  nftnl_obj_set_u8;
+  nftnl_obj_set_u16;
   nftnl_obj_set_u32;
   nftnl_obj_set_u64;
   nftnl_obj_set_str;
+  nftnl_obj_get_u8;
+  nftnl_obj_get_u16;
   nftnl_obj_get_u32;
   nftnl_obj_get_str;
   nftnl_obj_get_u64;
diff --git a/src/object.c b/src/object.c
index 773eff6a5a18..e635f6a8ff0e 100644
--- a/src/object.c
+++ b/src/object.c
@@ -107,6 +107,18 @@ void nftnl_obj_set(struct nftnl_obj *obj, uint16_t attr, const void *data)
 }
 EXPORT_SYMBOL(nftnl_obj_set);
 
+void nftnl_obj_set_u8(struct nftnl_obj *obj, uint16_t attr, uint8_t val)
+{
+	nftnl_obj_set_data(obj, attr, &val, sizeof(uint8_t));
+}
+EXPORT_SYMBOL(nftnl_obj_set_u8);
+
+void nftnl_obj_set_u16(struct nftnl_obj *obj, uint16_t attr, uint16_t val)
+{
+	nftnl_obj_set_data(obj, attr, &val, sizeof(uint16_t));
+}
+EXPORT_SYMBOL(nftnl_obj_set_u16);
+
 void nftnl_obj_set_u32(struct nftnl_obj *obj, uint16_t attr, uint32_t val)
 {
 	nftnl_obj_set_data(obj, attr, &val, sizeof(uint32_t));
@@ -164,6 +176,20 @@ const void *nftnl_obj_get(struct nftnl_obj *obj, uint16_t attr)
 }
 EXPORT_SYMBOL(nftnl_obj_get);
 
+uint8_t nftnl_obj_get_u8(struct nftnl_obj *obj, uint16_t attr)
+{
+	const void *ret = nftnl_obj_get(obj, attr);
+	return ret == NULL ? 0 : *((uint8_t *)ret);
+}
+EXPORT_SYMBOL(nftnl_obj_get_u8);
+
+uint16_t nftnl_obj_get_u16(struct nftnl_obj *obj, uint16_t attr)
+{
+	const void *ret = nftnl_obj_get(obj, attr);
+	return ret == NULL ? 0 : *((uint16_t *)ret);
+}
+EXPORT_SYMBOL(nftnl_obj_get_u16);
+
 uint32_t nftnl_obj_get_u32(struct nftnl_obj *obj, uint16_t attr)
 {
 	const void *ret = nftnl_obj_get(obj, attr);
-- 
2.10.2

