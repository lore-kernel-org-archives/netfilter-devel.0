From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 1/2] common: add wrapper to represent events
Date: Tue, 15 Apr 2014 11:40:30 +0200
Message-ID: <20140415094030.23739.71580.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60773 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750873AbaDOJkn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:40:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a simple string wrapper to represent nf_tables events.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/libnftnl/common.h |    6 +++++
 src/common.c              |   59 +++++++++++++++++++++++++++++++++++++++++++++
 src/libnftnl.map          |    3 ++
 3 files changed, 68 insertions(+)

diff --git a/include/libnftnl/common.h b/include/libnftnl/common.h
index f0c20f0..96f8155 100644
--- a/include/libnftnl/common.h
+++ b/include/libnftnl/common.h
@@ -2,6 +2,7 @@
 #define _LIBNFTNL_COMMON_H_
 
 #include <stdint.h>
+#include <stdio.h>
 
 enum {
 	NFT_PARSE_EBADINPUT	= 0,
@@ -30,4 +31,9 @@ struct nlmsghdr *nft_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family,
 struct nft_parse_err *nft_parse_err_alloc(void);
 void nft_parse_err_free(struct nft_parse_err *);
 int nft_parse_perror(const char *str, struct nft_parse_err *err);
+int nft_event_snprintf(char *buf, size_t bufsiz, const char *content,
+		       uint32_t format, uint32_t type);
+int nft_event_fprintf(FILE *fp, const char *content,
+		      uint32_t format, uint32_t type);
+
 #endif
diff --git a/src/common.c b/src/common.c
index 336d2b4..5ded0de 100644
--- a/src/common.c
+++ b/src/common.c
@@ -8,9 +8,11 @@
  */
 
 #include <stdlib.h>
+#include <stdio.h>
 #include <sys/socket.h>
 #include <linux/netlink.h>
 #include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nf_tables.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/common.h>
@@ -66,3 +68,60 @@ int nft_parse_perror(const char *str, struct nft_parse_err *err)
 	}
 }
 EXPORT_SYMBOL(nft_parse_perror);
+
+int nft_event_snprintf(char *buf, size_t bufsiz, const char *content,
+		       uint32_t format, uint32_t type)
+{
+	const char *type_str = "unknown";
+	int ret;
+
+	switch (type) {
+	case NFT_MSG_NEWTABLE:
+	case NFT_MSG_NEWCHAIN:
+	case NFT_MSG_NEWSET:
+	case NFT_MSG_NEWRULE:
+	case NFT_MSG_NEWSETELEM:
+		type_str = "new";
+		break;
+	case NFT_MSG_DELTABLE:
+	case NFT_MSG_DELCHAIN:
+	case NFT_MSG_DELSET:
+	case NFT_MSG_DELRULE:
+	case NFT_MSG_DELSETELEM:
+		type_str = "destroy";
+		break;
+	}
+
+	switch (format) {
+	case NFT_OUTPUT_XML:
+		ret = snprintf(buf, bufsiz, "<event><type>%s</type>"
+			       "<nftables>%s</nftables></event>",
+			       type_str, content);
+		break;
+	case NFT_OUTPUT_JSON:
+		ret = snprintf(buf, bufsiz, "{event:{type:\"%s\","
+			       "{\"nftables\":[\"%s\"]}}}",
+			       type_str, content);
+		break;
+	default:
+		ret = snprintf(buf, bufsiz, "[%s] %s", type_str, content);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_event_snprintf);
+
+static int nft_event_do_snprintf(char *buf, size_t bufsiz, void *content,
+				 uint32_t format, uint32_t type)
+{
+	return nft_event_snprintf(buf, bufsiz, (const char *)content,
+				  format, type);
+}
+
+int nft_event_fprintf(FILE *fp, const char *content,
+		      uint32_t format, uint32_t type)
+{
+	return nft_fprintf(fp, (void *)content, format, type,
+			   nft_event_do_snprintf);
+}
+EXPORT_SYMBOL(nft_event_fprintf);
diff --git a/src/libnftnl.map b/src/libnftnl.map
index b11db67..18e58fa 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -205,4 +205,7 @@ LIBNFTNL_1.1 {
   nft_rule_attr_get_data;
   nft_set_attr_set_data;
   nft_set_attr_get_data;
+
+  nft_event_snprintf;
+  nft_event_fprintf;
 } LIBNFTNL_1.0;

