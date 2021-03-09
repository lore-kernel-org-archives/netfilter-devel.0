Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EBE7C4332D
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E90765295
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhCIPqC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 10:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbhCIPps (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 10:45:48 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4E2C06174A
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 07:45:48 -0800 (PST)
Received: from localhost ([::1]:56662 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lJeYN-00016p-0h; Tue, 09 Mar 2021 16:45:47 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 09/10] Get rid of single option switch statements
Date:   Tue,  9 Mar 2021 16:45:15 +0100
Message-Id: <20210309154516.4987-10-phil@nwl.cc>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210309154516.4987-1-phil@nwl.cc>
References: <20210309154516.4987-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace each by a conditional testing the only valid case.

There is one odd example, namely src/set.c: When printing a set with
type NFTNL_OUTPUT_XML, the relevant function would return 0 instead of
-1 like all others. Just drop it assuming nothing depends on that
(faulty) behaviour.

Cc: Arturo Borrero <arturo.borrero.glez@gmail.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/chain.c     | 12 +++---------
 src/flowtable.c | 13 +++----------
 src/gen.c       | 10 +++-------
 src/object.c    | 13 +++----------
 src/rule.c      | 14 ++++----------
 src/ruleset.c   | 26 +++-----------------------
 src/set.c       | 17 +++++------------
 src/set_elem.c  | 15 ++++-----------
 src/table.c     | 12 +++---------
 9 files changed, 31 insertions(+), 101 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 7906bf44ff72d..cb5ec6b462197 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -890,17 +890,11 @@ static int nftnl_chain_cmd_snprintf(char *buf, size_t remain,
 {
 	int ret, offset = 0;
 
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		ret = nftnl_chain_snprintf_default(buf + offset, remain, c);
-		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
-		break;
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
+	if (type != NFTNL_OUTPUT_DEFAULT)
 		return -1;
-	}
 
+	ret = nftnl_chain_snprintf_default(buf + offset, remain, c);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	return offset;
 }
 
diff --git a/src/flowtable.c b/src/flowtable.c
index d651066273460..e6c24753525c8 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -630,18 +630,11 @@ static int nftnl_flowtable_cmd_snprintf(char *buf, size_t remain,
 {
 	int ret, offset = 0;
 
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		ret = nftnl_flowtable_snprintf_default(buf + offset, remain, c);
-		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
-		break;
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-		break;
-	default:
+	if (type != NFTNL_OUTPUT_DEFAULT)
 		return -1;
-	}
 
+	ret = nftnl_flowtable_snprintf_default(buf + offset, remain, c);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	return offset;
 }
 
diff --git a/src/gen.c b/src/gen.c
index 362132eb2766f..88efbaaba9acc 100644
--- a/src/gen.c
+++ b/src/gen.c
@@ -162,15 +162,11 @@ static int nftnl_gen_cmd_snprintf(char *buf, size_t remain,
 {
 	int ret, offset = 0;
 
-	switch(type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		ret = snprintf(buf, remain, "ruleset generation ID %u", gen->id);
-		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
-		break;
-	default:
+	if (type != NFTNL_OUTPUT_DEFAULT)
 		return -1;
-	}
 
+	ret = snprintf(buf, remain, "ruleset generation ID %u", gen->id);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	return offset;
 }
 
diff --git a/src/object.c b/src/object.c
index 4eb4d35d874c9..46e208b666cae 100644
--- a/src/object.c
+++ b/src/object.c
@@ -411,18 +411,11 @@ static int nftnl_obj_cmd_snprintf(char *buf, size_t remain,
 {
 	int ret, offset = 0;
 
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		ret = nftnl_obj_snprintf_dflt(buf + offset, remain, obj, type,
-					      flags);
-		break;
-	case NFTNL_OUTPUT_JSON:
-	case NFTNL_OUTPUT_XML:
-	default:
+	if (type != NFTNL_OUTPUT_DEFAULT)
 		return -1;
-	}
-	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
+	ret = nftnl_obj_snprintf_dflt(buf + offset, remain, obj, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	return offset;
 }
 
diff --git a/src/rule.c b/src/rule.c
index 439e451330233..0bb1c2a0583c1 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -644,18 +644,12 @@ static int nftnl_rule_cmd_snprintf(char *buf, size_t remain,
 
 	inner_flags &= ~NFTNL_OF_EVENT_ANY;
 
-	switch(type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		ret = nftnl_rule_snprintf_default(buf + offset, remain, r, type,
-						inner_flags);
-		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
-		break;
-	case NFTNL_OUTPUT_JSON:
-	case NFTNL_OUTPUT_XML:
-	default:
+	if (type != NFTNL_OUTPUT_DEFAULT)
 		return -1;
-	}
 
+	ret = nftnl_rule_snprintf_default(buf + offset, remain, r, type,
+					inner_flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	return offset;
 }
 
diff --git a/src/ruleset.c b/src/ruleset.c
index f904aa4ca94a7..4788cc09b8fca 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -522,21 +522,6 @@ nftnl_ruleset_do_snprintf(char *buf, size_t remain,
 	return offset;
 }
 
-static int nftnl_ruleset_cmd_snprintf(char *buf, size_t size,
-				    const struct nftnl_ruleset *r, uint32_t cmd,
-				    uint32_t type, uint32_t flags)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-	case NFTNL_OUTPUT_JSON:
-		return nftnl_ruleset_do_snprintf(buf, size, r, cmd, type, flags);
-	case NFTNL_OUTPUT_XML:
-	default:
-		errno = EOPNOTSUPP;
-		return -1;
-	}
-}
-
 EXPORT_SYMBOL(nftnl_ruleset_snprintf);
 int nftnl_ruleset_snprintf(char *buf, size_t size, const struct nftnl_ruleset *r,
 			 uint32_t type, uint32_t flags)
@@ -544,17 +529,12 @@ int nftnl_ruleset_snprintf(char *buf, size_t size, const struct nftnl_ruleset *r
 	if (size)
 		buf[0] = '\0';
 
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-	case NFTNL_OUTPUT_JSON:
-		return nftnl_ruleset_cmd_snprintf(buf, size, r,
-						nftnl_flag2cmd(flags), type,
-						flags);
-	case NFTNL_OUTPUT_XML:
-	default:
+	if (type != NFTNL_OUTPUT_DEFAULT) {
 		errno = EOPNOTSUPP;
 		return -1;
 	}
+	return nftnl_ruleset_do_snprintf(buf, size, r, nftnl_flag2cmd(flags),
+					 type, flags);
 }
 
 static int nftnl_ruleset_fprintf_tables(FILE *fp, const struct nftnl_ruleset *rs,
diff --git a/src/set.c b/src/set.c
index 021543e8b7752..1c29dd26e88dc 100644
--- a/src/set.c
+++ b/src/set.c
@@ -843,22 +843,15 @@ static int nftnl_set_cmd_snprintf(char *buf, size_t remain,
 	uint32_t inner_flags = flags;
 	int ret, offset = 0;
 
-	if (type == NFTNL_OUTPUT_XML)
-		return 0;
+	if (type != NFTNL_OUTPUT_DEFAULT)
+		return -1;
 
 	/* prevent set_elems to print as events */
 	inner_flags &= ~NFTNL_OF_EVENT_ANY;
 
-	switch(type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		ret = nftnl_set_snprintf_default(buf + offset, remain, s, type,
-					       inner_flags);
-		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
-		break;
-	default:
-		return -1;
-	}
-
+	ret = nftnl_set_snprintf_default(buf + offset, remain, s, type,
+					 inner_flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	return offset;
 }
 
diff --git a/src/set_elem.c b/src/set_elem.c
index a1764e232d335..90632a2983126 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -757,19 +757,12 @@ static int nftnl_set_elem_cmd_snprintf(char *buf, size_t remain,
 {
 	int ret, offset = 0;
 
-	switch(type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		ret = nftnl_set_elem_snprintf_default(buf + offset, remain, e,
-						      NFT_DATA_VALUE);
-		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
-		break;
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-		break;
-	default:
+	if (type != NFTNL_OUTPUT_DEFAULT)
 		return -1;
-	}
 
+	ret = nftnl_set_elem_snprintf_default(buf + offset, remain, e,
+					      NFT_DATA_VALUE);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	return offset;
 }
 
diff --git a/src/table.c b/src/table.c
index 5835788dce2e2..59e7053ac3c0d 100644
--- a/src/table.c
+++ b/src/table.c
@@ -373,17 +373,11 @@ static int nftnl_table_cmd_snprintf(char *buf, size_t remain,
 {
 	int ret, offset = 0;
 
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		ret = nftnl_table_snprintf_default(buf + offset, remain, t);
-		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
-		break;
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
+	if (type != NFTNL_OUTPUT_DEFAULT)
 		return -1;
-	}
 
+	ret = nftnl_table_snprintf_default(buf + offset, remain, t);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	return offset;
 }
 
-- 
2.30.1

