From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 1/2] Add functions for exporting tables to JSON
 format
Date: Fri, 07 Jun 2013 11:14:16 +0200
Message-ID: <20130607091415.13002.47323.stgit@Ph0enix>
References: <20130607091043.13002.66552.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38071 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab3FGJOT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:14:19 -0400
Received: by mail-wi0-f182.google.com with SMTP id cb5so1036567wib.9
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Jun 2013 02:14:18 -0700 (PDT)
Received: from [127.0.1.1] (85.136.70.56.dyn.user.ono.com. [85.136.70.56])
        by mx.google.com with ESMTPSA id b19sm15302285wik.10.2013.06.07.02.14.17
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 07 Jun 2013 02:14:17 -0700 (PDT)
In-Reply-To: <20130607091043.13002.66552.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---
 include/libnftables/table.h |    1 +
 src/internal.h              |    1 +
 src/table.c                 |   18 ++++++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index 658230c..19f322c 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -31,6 +31,7 @@ void nft_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_table
 enum {
 	NFT_TABLE_O_DEFAULT	= 0,
 	NFT_TABLE_O_XML,
+	NFT_TABLE_O_JSON,
 };
 
 enum nft_table_parse_type {
diff --git a/src/internal.h b/src/internal.h
index 3ad5e89..0c5de21 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -20,6 +20,7 @@
 #define NFT_TABLE_XML_VERSION 0
 #define NFT_CHAIN_XML_VERSION 0
 #define NFT_RULE_XML_VERSION 0
+#define NFT_TABLE_JSON_VERSION 0
 
 struct expr_ops;
 
diff --git a/src/table.c b/src/table.c
index a868da4..de106bb 100644
--- a/src/table.c
+++ b/src/table.c
@@ -300,6 +300,22 @@ int nft_table_parse(struct nft_table *t, enum nft_table_parse_type type,
 }
 EXPORT_SYMBOL(nft_table_parse);
 
+static int nft_table_snprintf_json(char *buf, size_t size, struct nft_table *t)
+{
+	return snprintf(buf, size,
+			"{\"table\" : {"
+			"\"name\" : \"%s\","
+			"\"version\" : %d,"
+			"\"properties\" : {"
+				"\"family\" : %u,"
+				"\"table_flags\" : %d"
+				"}"
+			"}"
+			"}" ,
+			t->name, NFT_TABLE_JSON_VERSION,
+			t->family, t->table_flags);
+}
+
 static int nft_table_snprintf_xml(char *buf, size_t size, struct nft_table *t)
 {
 	return snprintf(buf, size,
@@ -325,6 +341,8 @@ int nft_table_snprintf(char *buf, size_t size, struct nft_table *t,
 	switch(type) {
 	case NFT_TABLE_O_XML:
 		return nft_table_snprintf_xml(buf, size, t);
+	case NFT_TABLE_O_JSON:
+		return nft_table_snprintf_json(buf, size, t);
 	case NFT_TABLE_O_DEFAULT:
 		return nft_table_snprintf_default(buf, size, t);
 	default:

