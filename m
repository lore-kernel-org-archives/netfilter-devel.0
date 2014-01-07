From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 2/6] set_elem: add json parsing to API
Date: Tue, 07 Jan 2014 12:47:21 +0100
Message-ID: <20140107114721.12841.19345.stgit@nfdev.cica.es>
References: <20140107114518.12841.35778.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:53930 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751054AbaAGLra (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:47:30 -0500
In-Reply-To: <20140107114518.12841.35778.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add missing support in the API function to parse a JSON set_elem.

I've renamed the main JSON parsing function to prevent clashing.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/src/internal.h b/src/internal.h
index 9ef505f..5fef6d6 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -105,8 +105,8 @@ int nft_jansson_data_reg_parse(json_t *root, const char *node_name,
 			       union nft_data_reg *data_reg,
 			       struct nft_parse_err *err);
 struct nft_set_elem;
-int nft_set_elem_json_parse(struct nft_set_elem *e, json_t *root,
-			    struct nft_parse_err *err);
+int nft_jansson_set_elem_parse(struct nft_set_elem *e, json_t *root,
+			       struct nft_parse_err *err);
 struct nft_table;
 int nft_jansson_parse_table(struct nft_table *t, json_t *tree,
 			    struct nft_parse_err *err);
diff --git a/src/jansson.c b/src/jansson.c
index 54a56b9..e62116b 100644
--- a/src/jansson.c
+++ b/src/jansson.c
@@ -244,8 +244,8 @@ int nft_jansson_data_reg_parse(json_t *root, const char *node_name,
 	}
 }
 
-int nft_set_elem_json_parse(struct nft_set_elem *e, json_t *root,
-			    struct nft_parse_err *err)
+int nft_jansson_set_elem_parse(struct nft_set_elem *e, json_t *root,
+			       struct nft_parse_err *err)
 {
 	uint32_t uval32;
 	int set_elem_data;
diff --git a/src/set.c b/src/set.c
index 32c7fff..9317b9c 100644
--- a/src/set.c
+++ b/src/set.c
@@ -357,7 +357,8 @@ int nft_jansson_parse_set(struct nft_set *s, json_t *tree,
 			if (json_elem == NULL)
 				goto err;
 
-			if (nft_set_elem_json_parse(elem, json_elem, err) < 0)
+			if (nft_jansson_set_elem_parse(elem,
+						       json_elem, err) < 0)
 				goto err;
 
 			list_add_tail(&elem->head, &s->element_list);
diff --git a/src/set_elem.c b/src/set_elem.c
index 7365aff..14bf6f4 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -414,6 +414,24 @@ static int nft_set_elem_xml_parse(struct nft_set_elem *e, const char *xml,
 #endif
 }
 
+static int nft_set_elem_json_parse(struct nft_set_elem *e, const void *json,
+				   struct nft_parse_err *err)
+{
+#ifdef JSON_PARSING
+	json_t *tree;
+	json_error_t error;
+
+	tree = nft_jansson_create_root(json, &error, err);
+	if (tree == NULL)
+		return -1;
+
+	return nft_jansson_set_elem_parse(e, tree, err);
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
 int nft_set_elem_parse(struct nft_set_elem *e,
 		       enum nft_parse_type type, const char *data,
 		       struct nft_parse_err *err) {
@@ -423,6 +441,9 @@ int nft_set_elem_parse(struct nft_set_elem *e,
 	case NFT_PARSE_XML:
 		ret = nft_set_elem_xml_parse(e, data, err);
 		break;
+	case NFT_PARSE_JSON:
+		ret = nft_set_elem_json_parse(e, data, err);
+		break;
 	default:
 		errno = EOPNOTSUPP;
 		ret = -1;

