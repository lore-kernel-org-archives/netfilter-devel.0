From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 1/2] Add function for exporting chain to JSON
 Format
Date: Sat, 08 Jun 2013 15:36:04 +0200
Message-ID: <20130608133604.10197.76262.stgit@Ph0enix>
References: <20130608133222.10197.21456.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36748 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab3FHNgI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jun 2013 09:36:08 -0400
Received: by mail-wi0-f177.google.com with SMTP id ey16so2030138wid.4
        for <netfilter-devel@vger.kernel.org>; Sat, 08 Jun 2013 06:36:07 -0700 (PDT)
Received: from [127.0.1.1] (89.153.20.95.dynamic.jazztel.es. [95.20.153.89])
        by mx.google.com with ESMTPSA id r9sm2353060wik.1.2013.06.08.06.36.06
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 08 Jun 2013 06:36:06 -0700 (PDT)
In-Reply-To: <20130608133222.10197.21456.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Alvaro Neira Ayuso <alvaroneay@gmail.com>


---
 include/libnftables/chain.h |    1 +
 src/chain.c                 |   27 +++++++++++++++++++++++++++
 src/internal.h              |    1 +
 3 files changed, 29 insertions(+)

diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index f06f743..3645eaa 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -44,6 +44,7 @@ void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_chain
 enum {
 	NFT_CHAIN_O_DEFAULT	= 0,
 	NFT_CHAIN_O_XML,
+	NFT_CHAIN_O_JSON,
 };
 
 enum nft_chain_parse_type {
diff --git a/src/chain.c b/src/chain.c
index 7775dfc..1c53daa 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -688,6 +688,31 @@ int nft_chain_parse(struct nft_chain *c, enum nft_chain_parse_type type,
 }
 EXPORT_SYMBOL(nft_chain_parse);
 
+static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_chain *c)
+{
+	return snprintf(buf, size,
+		"{ \"chain\": {"
+			"\"name\": \"%s\","
+			"\"handle\": %lu,"
+			"\"bytes\": %lu,"
+			"\"packets\": %lu,"
+			"\"version\": %d,"
+			"\"properties\": {"
+				"\"type\" : \"%s\","
+				"\"table\" : \"%s\","
+				"\"prio\" : %d,"
+				"\"use\" : %d,"
+				"\"hooknum\" : %d,"
+				"\"policy\" : %d,"
+				"\"family\" : %d"
+			"}"
+		"}"
+		"}",
+			c->name, c->handle, c->bytes, c->packets,
+			NFT_CHAIN_JSON_VERSION, c->type, c->table,
+			c->prio, c->use, c->hooknum, c->policy, c->family);
+}
+
 static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
 {
 	return snprintf(buf, size,
@@ -721,6 +746,8 @@ int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *c,
 		       uint32_t type, uint32_t flags)
 {
 	switch(type) {
+	case NFT_CHAIN_O_JSON:
+		return nft_chain_snprintf_json(buf, size, c);
 	case NFT_CHAIN_O_XML:
 		return nft_chain_snprintf_xml(buf, size, c);
 	case NFT_CHAIN_O_DEFAULT:
diff --git a/src/internal.h b/src/internal.h
index 0c5de21..769926b 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -21,6 +21,7 @@
 #define NFT_CHAIN_XML_VERSION 0
 #define NFT_RULE_XML_VERSION 0
 #define NFT_TABLE_JSON_VERSION 0
+#define NFT_CHAIN_JSON_VERSION 0
 
 struct expr_ops;
 

