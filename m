From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 7/7] quota: support for consumed bytes
Date: Fri,  9 Dec 2016 14:31:59 +0100
Message-ID: <1481290319-10156-7-git-send-email-pablo@netfilter.org>
References: <1481290319-10156-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35586 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753676AbcLINcQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Dec 2016 08:32:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C246C96EC6
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2016 14:32:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B1D37524CE
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2016 14:32:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 93FB9524CF
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2016 14:32:06 +0100 (CET)
In-Reply-To: <1481290319-10156-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch extends the quota support to account for consumed bytes.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/expr.h |  1 +
 src/expr/quota.c        | 26 +++++++++++++++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index ee0784928550..74e986de6b4b 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -196,6 +196,7 @@ enum {
 enum {
 	NFTNL_EXPR_QUOTA_BYTES	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_QUOTA_FLAGS,
+	NFTNL_EXPR_QUOTA_CONSUMED,
 };
 
 enum {
diff --git a/src/expr/quota.c b/src/expr/quota.c
index 7740b24c45f3..667e6e17c28c 100644
--- a/src/expr/quota.c
+++ b/src/expr/quota.c
@@ -22,6 +22,7 @@
 
 struct nftnl_expr_quota {
 	uint64_t	bytes;
+	uint64_t	consumed;
 	uint32_t	flags;
 };
 
@@ -34,6 +35,9 @@ static int nftnl_expr_quota_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_QUOTA_BYTES:
 		quota->bytes = *((uint64_t *)data);
 		break;
+	case NFTNL_EXPR_QUOTA_CONSUMED:
+		quota->consumed = *((uint64_t *)data);
+		break;
 	case NFTNL_EXPR_QUOTA_FLAGS:
 		quota->flags = *((uint32_t *)data);
 		break;
@@ -52,6 +56,9 @@ static const void *nftnl_expr_quota_get(const struct nftnl_expr *e,
 	case NFTNL_EXPR_QUOTA_BYTES:
 		*data_len = sizeof(quota->bytes);
 		return &quota->bytes;
+	case NFTNL_EXPR_QUOTA_CONSUMED:
+		*data_len = sizeof(quota->consumed);
+		return &quota->consumed;
 	case NFTNL_EXPR_QUOTA_FLAGS:
 		*data_len = sizeof(quota->flags);
 		return &quota->flags;
@@ -69,6 +76,7 @@ static int nftnl_expr_quota_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_QUOTA_BYTES:
+	case NFTA_QUOTA_CONSUMED:
 		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
 			abi_breakage();
 		break;
@@ -89,6 +97,8 @@ nftnl_expr_quota_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 
 	if (e->flags & (1 << NFTNL_EXPR_QUOTA_BYTES))
 		mnl_attr_put_u64(nlh, NFTA_QUOTA_BYTES, htobe64(quota->bytes));
+	if (e->flags & (1 << NFTNL_EXPR_QUOTA_CONSUMED))
+		mnl_attr_put_u64(nlh, NFTA_QUOTA_CONSUMED, htobe64(quota->consumed));
 	if (e->flags & (1 << NFTNL_EXPR_QUOTA_FLAGS))
 		mnl_attr_put_u32(nlh, NFTA_QUOTA_FLAGS, htonl(quota->flags));
 }
@@ -106,6 +116,10 @@ nftnl_expr_quota_parse(struct nftnl_expr *e, struct nlattr *attr)
 		quota->bytes = be64toh(mnl_attr_get_u64(tb[NFTA_QUOTA_BYTES]));
 		e->flags |= (1 << NFTNL_EXPR_QUOTA_BYTES);
 	}
+	if (tb[NFTA_QUOTA_CONSUMED]) {
+		quota->consumed = be64toh(mnl_attr_get_u64(tb[NFTA_QUOTA_CONSUMED]));
+		e->flags |= (1 << NFTNL_EXPR_QUOTA_CONSUMED);
+	}
 	if (tb[NFTA_QUOTA_FLAGS]) {
 		quota->flags = ntohl(mnl_attr_get_u32(tb[NFTA_QUOTA_FLAGS]));
 		e->flags |= (1 << NFTNL_EXPR_QUOTA_FLAGS);
@@ -119,12 +133,15 @@ nftnl_expr_quota_json_parse(struct nftnl_expr *e, json_t *root,
 				 struct nftnl_parse_err *err)
 {
 #ifdef JSON_PARSING
-	uint64_t bytes;
+	uint64_t bytes, consumed;
 	uint32_t flags;
 
 	if (nftnl_jansson_parse_val(root, "bytes", NFTNL_TYPE_U64, &bytes,
 				  err) == 0)
 		nftnl_expr_set_u64(e, NFTNL_EXPR_QUOTA_BYTES, bytes);
+	if (nftnl_jansson_parse_val(root, "consumed", NFTNL_TYPE_U64, &consumed,
+				  err) == 0)
+		nftnl_expr_set_u64(e, NFTNL_EXPR_QUOTA_CONSUMED, consumed);
 	if (nftnl_jansson_parse_val(root, "flags", NFTNL_TYPE_U32, &flags,
 				  err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_QUOTA_FLAGS, flags);
@@ -144,6 +161,8 @@ static int nftnl_expr_quota_export(char *buf, size_t size,
 
 	if (e->flags & (1 << NFTNL_EXPR_QUOTA_BYTES))
 		nftnl_buf_u64(&b, type, quota->bytes, BYTES);
+	if (e->flags & (1 << NFTNL_EXPR_QUOTA_CONSUMED))
+		nftnl_buf_u64(&b, type, quota->consumed, CONSUMED);
 	if (e->flags & (1 << NFTNL_EXPR_QUOTA_FLAGS))
 		nftnl_buf_u32(&b, type, quota->flags, FLAGS);
 
@@ -155,8 +174,9 @@ static int nftnl_expr_quota_snprintf_default(char *buf, size_t len,
 {
 	struct nftnl_expr_quota *quota = nftnl_expr_data(e);
 
-	return snprintf(buf, len, "bytes %"PRIu64" flags %u ",
-			quota->bytes, quota->flags);
+	return snprintf(buf, len,
+			"bytes %"PRIu64" consumed %"PRIu64" flags %u ",
+			quota->bytes, quota->consumed, quota->flags);
 }
 
 static int nftnl_expr_quota_snprintf(char *buf, size_t len, uint32_t type,
-- 
2.1.4

