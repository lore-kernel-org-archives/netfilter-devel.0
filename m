Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B58DC4332B
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 356BA6525F
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhCIPqD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 10:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbhCIPpy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 10:45:54 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE26AC06174A
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 07:45:53 -0800 (PST)
Received: from localhost ([::1]:56670 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lJeYS-00016w-Bl; Tue, 09 Mar 2021 16:45:52 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 06/10] expr/data_reg: Drop output_format parameter
Date:   Tue,  9 Mar 2021 16:45:12 +0100
Message-Id: <20210309154516.4987-7-phil@nwl.cc>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210309154516.4987-1-phil@nwl.cc>
References: <20210309154516.4987-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function nftnl_data_reg_snprintf is exclusively called with
NFTNL_OUTPUT_DEFAULT as parameter, others are not supported - just drop
it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/data_reg.h   |  3 +--
 src/expr/bitwise.c   |  6 +++---
 src/expr/cmp.c       |  2 +-
 src/expr/data_reg.c  | 31 ++++++-------------------------
 src/expr/immediate.c |  6 +++---
 src/expr/range.c     |  4 ++--
 src/set_elem.c       |  3 ---
 7 files changed, 16 insertions(+), 39 deletions(-)

diff --git a/include/data_reg.h b/include/data_reg.h
index 0d6b77829cf89..6d2dc66858bf8 100644
--- a/include/data_reg.h
+++ b/include/data_reg.h
@@ -31,8 +31,7 @@ union nftnl_data_reg {
 
 int nftnl_data_reg_snprintf(char *buf, size_t size,
 			    const union nftnl_data_reg *reg,
-			    uint32_t output_format, uint32_t flags,
-			    int reg_type);
+			    uint32_t flags, int reg_type);
 struct nlattr;
 
 int nftnl_parse_data(union nftnl_data_reg *data, struct nlattr *attr, int *type);
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 139f25f86b802..1d46a97757dfd 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -220,14 +220,14 @@ nftnl_expr_bitwise_snprintf_bool(char *buf, size_t size,
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &bitwise->mask,
-				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+				      0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = snprintf(buf + offset, remain, ") ^ ");
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &bitwise->xor,
-				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+				      0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
@@ -243,7 +243,7 @@ nftnl_expr_bitwise_snprintf_shift(char *buf, size_t size, const char *op,
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &bitwise->data,
-				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+				      0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = snprintf(buf + offset, remain, ") ");
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 6b1c0fa3ac97f..04b9f25806725 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -188,7 +188,7 @@ nftnl_expr_cmp_snprintf(char *buf, size_t size,
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &cmp->data,
-				    NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+				      0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index d3ccc612ce812..bafdc6f3dadd3 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -63,38 +63,19 @@ nftnl_data_reg_verdict_snprintf_def(char *buf, size_t size,
 
 int nftnl_data_reg_snprintf(char *buf, size_t size,
 			    const union nftnl_data_reg *reg,
-			    uint32_t output_format, uint32_t flags,
-			    int reg_type)
+			    uint32_t flags, int reg_type)
 {
 	switch(reg_type) {
 	case DATA_VALUE:
-		switch(output_format) {
-		case NFTNL_OUTPUT_DEFAULT:
-			return nftnl_data_reg_value_snprintf_default(buf, size,
-								   reg, flags);
-		case NFTNL_OUTPUT_JSON:
-		case NFTNL_OUTPUT_XML:
-		default:
-			break;
-		}
-		break;
+		return nftnl_data_reg_value_snprintf_default(buf, size,
+							     reg, flags);
 	case DATA_VERDICT:
 	case DATA_CHAIN:
-		switch(output_format) {
-		case NFTNL_OUTPUT_DEFAULT:
-			return nftnl_data_reg_verdict_snprintf_def(buf, size,
-								 reg, flags);
-		case NFTNL_OUTPUT_JSON:
-		case NFTNL_OUTPUT_XML:
-		default:
-			break;
-		}
-		break;
+		return nftnl_data_reg_verdict_snprintf_def(buf, size,
+							   reg, flags);
 	default:
-		break;
+		return -1;
 	}
-
-	return -1;
 }
 
 static int nftnl_data_parse_cb(const struct nlattr *attr, void *data)
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 08ddd22a54c5f..241aad3b5507c 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -195,17 +195,17 @@ nftnl_expr_immediate_snprintf(char *buf, size_t len,
 
 	if (e->flags & (1 << NFTNL_EXPR_IMM_DATA)) {
 		ret = nftnl_data_reg_snprintf(buf + offset, remain, &imm->data,
-					NFTNL_OUTPUT_DEFAULT, flags, DATA_VALUE);
+					      flags, DATA_VALUE);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	} else if (e->flags & (1 << NFTNL_EXPR_IMM_VERDICT)) {
 		ret = nftnl_data_reg_snprintf(buf + offset, remain, &imm->data,
-				NFTNL_OUTPUT_DEFAULT, flags, DATA_VERDICT);
+					      flags, DATA_VERDICT);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	} else if (e->flags & (1 << NFTNL_EXPR_IMM_CHAIN)) {
 		ret = nftnl_data_reg_snprintf(buf + offset, remain, &imm->data,
-					NFTNL_OUTPUT_DEFAULT, flags, DATA_CHAIN);
+					      flags, DATA_CHAIN);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
diff --git a/src/expr/range.c b/src/expr/range.c
index a93b2ea74d6d4..eed48829a246d 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -195,11 +195,11 @@ static int nftnl_expr_range_snprintf(char *buf, size_t size,
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &range->data_from,
-				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+				      0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &range->data_to,
-				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+				      0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
diff --git a/src/set_elem.c b/src/set_elem.c
index ad528e28475a7..061469a74789c 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -710,7 +710,6 @@ int nftnl_set_elem_snprintf_default(char *buf, size_t size,
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &e->key,
-				      NFTNL_OUTPUT_DEFAULT,
 				      DATA_F_NOPFX, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
@@ -719,7 +718,6 @@ int nftnl_set_elem_snprintf_default(char *buf, size_t size,
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		ret = nftnl_data_reg_snprintf(buf + offset, remain, &e->key_end,
-					      NFTNL_OUTPUT_DEFAULT,
 					      DATA_F_NOPFX, DATA_VALUE);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
@@ -728,7 +726,6 @@ int nftnl_set_elem_snprintf_default(char *buf, size_t size,
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &e->data,
-				      NFTNL_OUTPUT_DEFAULT,
 				      DATA_F_NOPFX, dregtype);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-- 
2.30.1

