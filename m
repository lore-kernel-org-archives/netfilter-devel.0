Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F0E7C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6154F6525F
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:46:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbhCIPp7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 10:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbhCIPpa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 10:45:30 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928EDC06174A
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 07:45:29 -0800 (PST)
Received: from localhost ([::1]:56638 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lJeY1-00016D-IJ; Tue, 09 Mar 2021 16:45:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 01/10] expr: Fix snprintf buffer length updates
Date:   Tue,  9 Mar 2021 16:45:07 +0100
Message-Id: <20210309154516.4987-2-phil@nwl.cc>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210309154516.4987-1-phil@nwl.cc>
References: <20210309154516.4987-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Subsequent calls to snprintf() sometimes reuse 'len' variable although
they should refer to the updated value in 'remain' instead.

Fixes: 676ea569bbe5a ("src: Change parameters of SNPRINTF_BUFFER_SIZE macro.")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/expr/ct.c    |  2 +-
 src/expr/dup.c   |  4 ++--
 src/expr/queue.c | 12 ++++++------
 src/expr/redir.c |  6 +++---
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/src/expr/ct.c b/src/expr/ct.c
index 124de9dd2b33a..1a21c953c9be2 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -230,7 +230,7 @@ nftnl_expr_ct_snprintf_default(char *buf, size_t size,
 	struct nftnl_expr_ct *ct = nftnl_expr_data(e);
 
 	if (e->flags & (1 << NFTNL_EXPR_CT_SREG)) {
-		ret = snprintf(buf, size, "set %s with reg %u ",
+		ret = snprintf(buf, remain, "set %s with reg %u ",
 				ctkey2str(ct->key), ct->sreg);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
diff --git a/src/expr/dup.c b/src/expr/dup.c
index ac398394aed06..7a3ee96361644 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -119,12 +119,12 @@ static int nftnl_expr_dup_snprintf_default(char *buf, size_t len,
 	struct nftnl_expr_dup *dup = nftnl_expr_data(e);
 
 	if (e->flags & (1 << NFTNL_EXPR_DUP_SREG_ADDR)) {
-		ret = snprintf(buf + offset, len, "sreg_addr %u ", dup->sreg_addr);
+		ret = snprintf(buf + offset, remain, "sreg_addr %u ", dup->sreg_addr);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (e->flags & (1 << NFTNL_EXPR_DUP_SREG_DEV)) {
-		ret = snprintf(buf + offset, len, "sreg_dev %u ", dup->sreg_dev);
+		ret = snprintf(buf + offset, remain, "sreg_dev %u ", dup->sreg_dev);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
diff --git a/src/expr/queue.c b/src/expr/queue.c
index 051ef71e72fdb..b892b57bc4897 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -153,31 +153,31 @@ static int nftnl_expr_queue_snprintf_default(char *buf, size_t len,
 	if (e->flags & (1 << NFTNL_EXPR_QUEUE_NUM)) {
 		total_queues = queue->queuenum + queue->queues_total - 1;
 
-		ret = snprintf(buf + offset, len, "num %u", queue->queuenum);
+		ret = snprintf(buf + offset, remain, "num %u", queue->queuenum);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		if (queue->queues_total && total_queues != queue->queuenum) {
-			ret = snprintf(buf + offset, len, "-%u", total_queues);
+			ret = snprintf(buf + offset, remain, "-%u", total_queues);
 			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		}
 
-		ret = snprintf(buf + offset, len, " ");
+		ret = snprintf(buf + offset, remain, " ");
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (e->flags & (1 << NFTNL_EXPR_QUEUE_SREG_QNUM)) {
-		ret = snprintf(buf + offset, len, "sreg_qnum %u ",
+		ret = snprintf(buf + offset, remain, "sreg_qnum %u ",
 			       queue->sreg_qnum);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (e->flags & (1 << NFTNL_EXPR_QUEUE_FLAGS)) {
 		if (queue->flags & (NFT_QUEUE_FLAG_BYPASS)) {
-			ret = snprintf(buf + offset, len, "bypass ");
+			ret = snprintf(buf + offset, remain, "bypass ");
 			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		}
 		if (queue->flags & (NFT_QUEUE_FLAG_CPU_FANOUT)) {
-			ret = snprintf(buf + offset, len, "fanout ");
+			ret = snprintf(buf + offset, remain, "fanout ");
 			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		}
 	}
diff --git a/src/expr/redir.c b/src/expr/redir.c
index 477659a320db1..c00c2a6ddf3cf 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -138,19 +138,19 @@ static int nftnl_expr_redir_snprintf_default(char *buf, size_t len,
 	struct nftnl_expr_redir *redir = nftnl_expr_data(e);
 
 	if (nftnl_expr_is_set(e, NFTNL_EXPR_REDIR_REG_PROTO_MIN)) {
-		ret = snprintf(buf + offset, len, "proto_min reg %u ",
+		ret = snprintf(buf + offset, remain, "proto_min reg %u ",
 			       redir->sreg_proto_min);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (nftnl_expr_is_set(e, NFTNL_EXPR_REDIR_REG_PROTO_MAX)) {
-		ret = snprintf(buf + offset, len, "proto_max reg %u ",
+		ret = snprintf(buf + offset, remain, "proto_max reg %u ",
 			       redir->sreg_proto_max);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (nftnl_expr_is_set(e, NFTNL_EXPR_REDIR_FLAGS)) {
-		ret = snprintf(buf + offset, len, "flags 0x%x ",
+		ret = snprintf(buf + offset, remain, "flags 0x%x ",
 			       redir->flags);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
-- 
2.30.1

