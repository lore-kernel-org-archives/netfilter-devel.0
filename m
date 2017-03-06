From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] udata: add nftnl_udata_put_u32() and nftnl_udata_get_u32()
Date: Mon,  6 Mar 2017 17:47:54 +0100
Message-ID: <1488818874-4089-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44700 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932067AbdCFQsD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Mar 2017 11:48:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2A592E62A
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 17:48:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A87ADA811
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 17:48:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B0E71DA81C
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 17:47:57 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add new helper function to put and to fetch tlv that comes with u32
payload.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/udata.h |  3 +++
 src/libnftnl.map         |  2 ++
 src/udata.c              | 15 +++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/include/libnftnl/udata.h b/include/libnftnl/udata.h
index d36cef73feb5..e6f80f98b012 100644
--- a/include/libnftnl/udata.h
+++ b/include/libnftnl/udata.h
@@ -24,6 +24,8 @@ struct nftnl_udata *nftnl_udata_end(const struct nftnl_udata_buf *buf);
 /* putters */
 bool nftnl_udata_put(struct nftnl_udata_buf *buf, uint8_t type, uint32_t len,
 		     const void *value);
+bool nftnl_udata_put_u32(struct nftnl_udata_buf *buf, uint8_t type,
+			 uint32_t data);
 bool nftnl_udata_put_strz(struct nftnl_udata_buf *buf, uint8_t type,
 			  const char *strz);
 
@@ -31,6 +33,7 @@ bool nftnl_udata_put_strz(struct nftnl_udata_buf *buf, uint8_t type,
 uint8_t nftnl_udata_type(const struct nftnl_udata *attr);
 uint8_t nftnl_udata_len(const struct nftnl_udata *attr);
 void *nftnl_udata_get(const struct nftnl_udata *attr);
+uint32_t nftnl_udata_get_u32(const struct nftnl_udata *attr);
 
 /* iterator */
 struct nftnl_udata *nftnl_udata_next(const struct nftnl_udata *attr);
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 4282367db5b8..4c082102aa29 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -261,9 +261,11 @@ global:
   nftnl_udata_end;
   nftnl_udata_put;
   nftnl_udata_put_strz;
+  nftnl_udata_put_u32;
   nftnl_udata_type;
   nftnl_udata_len;
   nftnl_udata_get;
+  nftnl_udata_get_u32;
   nftnl_udata_next;
   nftnl_udata_parse;
 
diff --git a/src/udata.c b/src/udata.c
index 60c2f34fa3f5..d679dd053d11 100644
--- a/src/udata.c
+++ b/src/udata.c
@@ -94,6 +94,13 @@ bool nftnl_udata_put_strz(struct nftnl_udata_buf *buf, uint8_t type,
 }
 EXPORT_SYMBOL(nftnl_udata_put_strz);
 
+bool nftnl_udata_put_u32(struct nftnl_udata_buf *buf, uint8_t type,
+			 uint32_t data)
+{
+	return nftnl_udata_put(buf, type, sizeof(data), &data);
+}
+EXPORT_SYMBOL(nftnl_udata_put_u32);
+
 uint8_t nftnl_udata_type(const struct nftnl_udata *attr)
 {
 	return attr->type;
@@ -112,6 +119,14 @@ void *nftnl_udata_get(const struct nftnl_udata *attr)
 }
 EXPORT_SYMBOL(nftnl_udata_get);
 
+uint32_t nftnl_udata_get_u32(const struct nftnl_udata *attr)
+{
+	uint32_t *data = (uint32_t *)attr->value;
+
+	return *data;
+}
+EXPORT_SYMBOL(nftnl_udata_get_u32);
+
 struct nftnl_udata *nftnl_udata_next(const struct nftnl_udata *attr)
 {
 	return (struct nftnl_udata *)&attr->value[attr->len];
-- 
2.1.4

