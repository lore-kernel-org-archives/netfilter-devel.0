From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] utils: fix nft_str2verdict return value
Date: Sat, 18 Jan 2014 17:01:44 +0100
Message-ID: <20140118160144.20804.20179.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:47817 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751305AbaARQB4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Jan 2014 11:01:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some verdicts have a negative value.

The caller of nft_str2verdict() checking if return was < 0 clash with
enum nft_verdict.

While at it, add error reporting of invalid verdicts.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/chain.c         |   16 +++++++++++-----
 src/expr/data_reg.c |   14 ++++++++++----
 src/internal.h      |    2 +-
 src/utils.c         |   28 +++++++++++++++++-----------
 4 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 18a52da..37515bb 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -503,7 +503,7 @@ int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree,
 {
 	json_t *root;
 	uint64_t uval64;
-	uint32_t policy;
+	int policy;
 	int32_t val32;
 	const char *valstr;
 
@@ -575,9 +575,12 @@ int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree,
 		if (valstr == NULL)
 			goto err;
 
-		policy = nft_str2verdict(valstr);
-		if (policy == -1)
+		if (nft_str2verdict(valstr, &policy) != 0) {
+			errno = EINVAL;
+			err->node_name = "policy";
+			err->error = NFT_PARSE_EBADTYPE;
 			goto err;
+		}
 
 		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_POLICY, policy);
 	}
@@ -697,9 +700,12 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c,
 		if (policy_str == NULL)
 			return -1;
 
-		policy = nft_str2verdict(policy_str);
-		if (policy == -1)
+		if (nft_str2verdict(policy_str, &policy) != 0) {
+			errno = EINVAL;
+			err->node_name = "policy";
+			err->error = NFT_PARSE_EBADTYPE;
 			return -1;
+		}
 
 		c->policy = policy;
 		c->flags |= (1 << NFT_CHAIN_ATTR_POLICY);
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index e487bc7..8812daf 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -37,9 +37,12 @@ static int nft_data_reg_verdict_json_parse(union nft_data_reg *reg, json_t *data
 	if (verdict_str == NULL)
 		return -1;
 
-	verdict = nft_str2verdict(verdict_str);
-	if (verdict < 0)
+	if (nft_str2verdict(verdict_str, &verdict) != 0) {
+		err->node_name = "verdict";
+		err->error = NFT_PARSE_EBADTYPE;
+		errno = EINVAL;
 		return -1;
+	}
 
 	reg->verdict = (uint32_t)verdict;
 
@@ -118,9 +121,12 @@ static int nft_data_reg_verdict_xml_parse(union nft_data_reg *reg,
 	if (verdict_str == NULL)
 		return DATA_NONE;
 
-	verdict = nft_str2verdict(verdict_str);
-	if (verdict < 0)
+	if (nft_str2verdict(verdict_str, &verdict) != 0) {
+		err->node_name = "verdict";
+		err->error = NFT_PARSE_EBADTYPE;
+		errno = EINVAL;
 		return DATA_NONE;
+	}
 
 	reg->verdict = (uint32_t)verdict;
 
diff --git a/src/internal.h b/src/internal.h
index ab12cec..256dd3d 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -131,7 +131,7 @@ const char *nft_family2str(uint32_t family);
 int nft_str2family(const char *family);
 int nft_strtoi(const char *string, int base, void *number, enum nft_type type);
 const char *nft_verdict2str(uint32_t verdict);
-int nft_str2verdict(const char *verdict);
+int nft_str2verdict(const char *verdict, int *verdict_num);
 int nft_get_value(enum nft_type type, void *val, void *out);
 
 #include <stdio.h>
diff --git a/src/utils.c b/src/utils.c
index 2415917..dd7fd1d 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -154,18 +154,24 @@ const char *nft_verdict2str(uint32_t verdict)
 	}
 }
 
-int nft_str2verdict(const char *verdict)
+int nft_str2verdict(const char *verdict, int *verdict_num)
 {
-	if (strcmp(verdict, "accept") == 0)
-		return NF_ACCEPT;
-	else if (strcmp(verdict, "drop") == 0)
-		return NF_DROP;
-	else if (strcmp(verdict, "return") == 0)
-		return NFT_RETURN;
-	else if (strcmp(verdict, "jump") == 0)
-		return NFT_JUMP;
-	else if (strcmp(verdict, "goto") == 0)
-		return NFT_GOTO;
+	if (strcmp(verdict, "accept") == 0) {
+		*verdict_num = NF_ACCEPT;
+		return 0;
+	} else if (strcmp(verdict, "drop") == 0) {
+		*verdict_num = NF_DROP;
+		return 0;
+	} else if (strcmp(verdict, "return") == 0) {
+		*verdict_num = NFT_RETURN;
+		return 0;
+	} else if (strcmp(verdict, "jump") == 0) {
+		*verdict_num = NFT_JUMP;
+		return 0;
+	} else if (strcmp(verdict, "goto") == 0) {
+		*verdict_num = NFT_GOTO;
+		return 0;
+	}
 
 	return -1;
 }

