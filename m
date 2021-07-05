Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AE00C11F66
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jul 2021 18:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31A326198A
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jul 2021 18:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhGESlk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jul 2021 14:41:40 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48560 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhGESlj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jul 2021 14:41:39 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id B4C8B61654
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jul 2021 20:38:51 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] expr: last: add NFTNL_EXPR_LAST_SET
Date:   Mon,  5 Jul 2021 20:38:59 +0200
Message-Id: <20210705183859.11064-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Honor NFTA_LAST_SET netlink attribute, it tells us if a packet has ever
updated this expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/expr.h |  1 +
 src/expr/last.c         | 22 +++++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 9b90e3ea3569..00c63ab9d19b 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -313,6 +313,7 @@ enum {
 
 enum {
 	NFTNL_EXPR_LAST_MSECS = NFTNL_EXPR_BASE,
+	NFTNL_EXPR_LAST_SET,
 };
 
 #ifdef __cplusplus
diff --git a/src/expr/last.c b/src/expr/last.c
index 0020fbcd24dc..e2a60c49b866 100644
--- a/src/expr/last.c
+++ b/src/expr/last.c
@@ -22,6 +22,7 @@
 
 struct nftnl_expr_last {
 	uint64_t	msecs;
+	uint32_t	set;
 };
 
 static int nftnl_expr_last_set(struct nftnl_expr *e, uint16_t type,
@@ -33,6 +34,9 @@ static int nftnl_expr_last_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_LAST_MSECS:
 		memcpy(&last->msecs, data, sizeof(last->msecs));
 		break;
+	case NFTNL_EXPR_LAST_SET:
+		memcpy(&last->set, data, sizeof(last->set));
+		break;
 	default:
 		return -1;
 	}
@@ -48,6 +52,9 @@ static const void *nftnl_expr_last_get(const struct nftnl_expr *e,
 	case NFTNL_EXPR_LAST_MSECS:
 		*data_len = sizeof(last->msecs);
 		return &last->msecs;
+	case NFTNL_EXPR_LAST_SET:
+		*data_len = sizeof(last->set);
+		return &last->set;
 	}
 	return NULL;
 }
@@ -65,6 +72,10 @@ static int nftnl_expr_last_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
 			abi_breakage();
 		break;
+	case NFTA_LAST_SET:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
 	}
 
 	tb[type] = attr;
@@ -78,6 +89,8 @@ nftnl_expr_last_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 
 	if (e->flags & (1 << NFTNL_EXPR_LAST_MSECS))
 		mnl_attr_put_u64(nlh, NFTA_LAST_MSECS, htobe64(last->msecs));
+	if (e->flags & (1 << NFTNL_EXPR_LAST_SET))
+		mnl_attr_put_u32(nlh, NFTA_LAST_SET, htonl(last->set));
 }
 
 static int
@@ -93,6 +106,10 @@ nftnl_expr_last_parse(struct nftnl_expr *e, struct nlattr *attr)
 		last->msecs = be64toh(mnl_attr_get_u64(tb[NFTA_LAST_MSECS]));
 		e->flags |= (1 << NFTNL_EXPR_LAST_MSECS);
 	}
+	if (tb[NFTA_LAST_SET]) {
+		last->set = ntohl(mnl_attr_get_u32(tb[NFTA_LAST_SET]));
+		e->flags |= (1 << NFTNL_EXPR_LAST_SET);
+	}
 
 	return 0;
 }
@@ -103,7 +120,10 @@ static int nftnl_expr_last_snprintf(char *buf, size_t len,
 {
 	struct nftnl_expr_last *last = nftnl_expr_data(e);
 
-	return snprintf(buf, len, "last %"PRIu64" ", last->msecs);
+	if (!last->set)
+		return snprintf(buf, len, "never ");
+
+	return snprintf(buf, len, "%"PRIu64" ", last->msecs);
 }
 
 struct expr_ops expr_ops_last = {
-- 
2.20.1

