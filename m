From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 3/6] internal: rework parsing symbol logic
Date: Tue, 07 Jan 2014 12:47:27 +0100
Message-ID: <20140107114726.12841.59406.stgit@nfdev.cica.es>
References: <20140107114518.12841.35778.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:53943 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751054AbaAGLrf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:47:35 -0500
In-Reply-To: <20140107114518.12841.35778.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rework parsing symbols logic, so we get a cleaner file.

Also, this allows us to use XML(libmxml)/JSON(libjannson) internal datatypes
without fear.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/src/internal.h b/src/internal.h
index 5fef6d6..83cb4e8 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -40,6 +40,10 @@ struct nft_parse_err {
 
 #ifdef XML_PARSING
 #include <mxml.h>
+#else
+#define mxml_node_t void
+#endif /* XML_PARSING */
+
 #define NFT_XML_MAND 0
 #define NFT_XML_OPT (1 << 0)
 mxml_node_t *nft_mxml_build_tree(const char *xml, const char *treename,
@@ -78,10 +82,13 @@ int nft_mxml_rule_parse(mxml_node_t *tree, struct nft_rule *r,
 struct nft_set;
 int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s,
 		       struct nft_parse_err *err);
-#endif
 
 #ifdef JSON_PARSING
 #include <jansson.h>
+#else
+#define json_t void
+#define json_err_t void
+#endif /* JSON_PARSING */
 
 int nft_jansson_parse_val(json_t *root, const char *node_name, int type,
 			  void *out, struct nft_parse_err *err);
@@ -119,7 +126,6 @@ int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree,
 struct nft_set;
 int nft_jansson_parse_set(struct nft_set *s, json_t *tree,
 			  struct nft_parse_err *err);
-#endif
 
 const char *nft_family2str(uint32_t family);
 int nft_str2family(const char *family);

