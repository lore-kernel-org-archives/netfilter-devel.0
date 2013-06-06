From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 1/4] Add functions for to export tables to JSON
 format
Date: Thu, 06 Jun 2013 15:17:06 +0200
Message-ID: <20130606131706.18048.11297.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: julien@linuxwall.info
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:45735 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979Ab3FFNRS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:17:18 -0400
Received: by mail-we0-f180.google.com with SMTP id w56so1999558wes.25
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Jun 2013 06:17:17 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---
 0 files changed

diff --git a/src/table.c b/src/table.c
index a868da4..57ea586 100644
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
+			"\"version\" : \"%d\","
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

