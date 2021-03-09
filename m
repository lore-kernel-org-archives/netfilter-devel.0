Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A246C433E6
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51EA16523F
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhCIPqa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 10:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbhCIPqE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 10:46:04 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C85C06174A
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 07:46:04 -0800 (PST)
Received: from localhost ([::1]:56682 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lJeYc-000176-Uq; Tue, 09 Mar 2021 16:46:03 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 10/10] ruleset: Eliminate tag and separator helpers
Date:   Tue,  9 Mar 2021 16:45:16 +0100
Message-Id: <20210309154516.4987-11-phil@nwl.cc>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210309154516.4987-1-phil@nwl.cc>
References: <20210309154516.4987-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Those were used for JSON and XML output only with the exception of
separator helper which at the same time served as conditional nop if no
"previous" object as passed. Replace it by a string variable updated at
the end of each loop iteration and just drop the other helpers.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/ruleset.c | 151 ++++++++++++++++++++------------------------------
 1 file changed, 59 insertions(+), 92 deletions(-)

diff --git a/src/ruleset.c b/src/ruleset.c
index 4788cc09b8fca..185aa48737e50 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -305,43 +305,6 @@ int nftnl_ruleset_parse_file(struct nftnl_ruleset *rs, enum nftnl_parse_type typ
 	return nftnl_ruleset_parse_file_cb(type, fp, err, rs, nftnl_ruleset_cb);
 }
 
-static const char *nftnl_ruleset_o_opentag(uint32_t type)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_JSON:
-		return "{\"nftables\":[";
-	case NFTNL_OUTPUT_XML:
-	default:
-		return "";
-	}
-}
-
-static const char *nftnl_ruleset_o_separator(void *obj, uint32_t type)
-{
-	if (obj == NULL)
-		return "";
-
-	switch (type) {
-	case NFTNL_OUTPUT_JSON:
-		return ",";
-	case NFTNL_OUTPUT_DEFAULT:
-		return "\n";
-	default:
-		return "";
-	}
-}
-
-static const char *nftnl_ruleset_o_closetag(uint32_t type)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_JSON:
-		return "]}";
-	case NFTNL_OUTPUT_XML:
-	default:
-		return "";
-	}
-}
-
 static int
 nftnl_ruleset_snprintf_table(char *buf, size_t remain,
 			   const struct nftnl_ruleset *rs, uint32_t type,
@@ -349,6 +312,7 @@ nftnl_ruleset_snprintf_table(char *buf, size_t remain,
 {
 	struct nftnl_table *t;
 	struct nftnl_table_list_iter *ti;
+	const char *sep = "";
 	int ret, offset = 0;
 
 	ti = nftnl_table_list_iter_create(rs->table_list);
@@ -357,14 +321,14 @@ nftnl_ruleset_snprintf_table(char *buf, size_t remain,
 
 	t = nftnl_table_list_iter_next(ti);
 	while (t != NULL) {
+		ret = snprintf(buf + offset, remain, "%s", sep);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
 		ret = nftnl_table_snprintf(buf + offset, remain, t, type, flags);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		t = nftnl_table_list_iter_next(ti);
-
-		ret = snprintf(buf + offset, remain, "%s",
-			       nftnl_ruleset_o_separator(t, type));
-		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		sep = "\n";
 	}
 	nftnl_table_list_iter_destroy(ti);
 
@@ -378,6 +342,7 @@ nftnl_ruleset_snprintf_chain(char *buf, size_t remain,
 {
 	struct nftnl_chain *c;
 	struct nftnl_chain_list_iter *ci;
+	const char *sep = "";
 	int ret, offset = 0;
 
 	ci = nftnl_chain_list_iter_create(rs->chain_list);
@@ -386,14 +351,14 @@ nftnl_ruleset_snprintf_chain(char *buf, size_t remain,
 
 	c = nftnl_chain_list_iter_next(ci);
 	while (c != NULL) {
+		ret = snprintf(buf + offset, remain, "%s", sep);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
 		ret = nftnl_chain_snprintf(buf + offset, remain, c, type, flags);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		c = nftnl_chain_list_iter_next(ci);
-
-		ret = snprintf(buf + offset, remain, "%s",
-			       nftnl_ruleset_o_separator(c, type));
-		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		sep = "\n";
 	}
 	nftnl_chain_list_iter_destroy(ci);
 
@@ -407,6 +372,7 @@ nftnl_ruleset_snprintf_set(char *buf, size_t remain,
 {
 	struct nftnl_set *s;
 	struct nftnl_set_list_iter *si;
+	const char *sep = "";
 	int ret, offset = 0;
 
 	si = nftnl_set_list_iter_create(rs->set_list);
@@ -415,14 +381,14 @@ nftnl_ruleset_snprintf_set(char *buf, size_t remain,
 
 	s = nftnl_set_list_iter_next(si);
 	while (s != NULL) {
+		ret = snprintf(buf + offset, remain, "%s", sep);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
 		ret = nftnl_set_snprintf(buf + offset, remain, s, type, flags);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		s = nftnl_set_list_iter_next(si);
-
-		ret = snprintf(buf + offset, remain, "%s",
-			       nftnl_ruleset_o_separator(s, type));
-		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		sep = "\n";
 	}
 	nftnl_set_list_iter_destroy(si);
 
@@ -436,6 +402,7 @@ nftnl_ruleset_snprintf_rule(char *buf, size_t remain,
 {
 	struct nftnl_rule *r;
 	struct nftnl_rule_list_iter *ri;
+	const char *sep = "";
 	int ret, offset = 0;
 
 	ri = nftnl_rule_list_iter_create(rs->rule_list);
@@ -444,14 +411,14 @@ nftnl_ruleset_snprintf_rule(char *buf, size_t remain,
 
 	r = nftnl_rule_list_iter_next(ri);
 	while (r != NULL) {
+		ret = snprintf(buf + offset, remain, "%s", sep);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
 		ret = nftnl_rule_snprintf(buf + offset, remain, r, type, flags);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		r = nftnl_rule_list_iter_next(ri);
-
-		ret = snprintf(buf + offset, remain, "%s",
-			       nftnl_ruleset_o_separator(r, type));
-		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		sep = "\n";
 	}
 	nftnl_rule_list_iter_destroy(ri);
 
@@ -464,8 +431,8 @@ nftnl_ruleset_do_snprintf(char *buf, size_t remain,
 			  uint32_t cmd, uint32_t type, uint32_t flags)
 {
 	uint32_t inner_flags = flags;
+	const char *sep = "";
 	int ret, offset = 0;
-	void *prev = NULL;
 
 	/* dont pass events flags to child calls of _snprintf() */
 	inner_flags &= ~NFTNL_OF_EVENT_ANY;
@@ -477,13 +444,12 @@ nftnl_ruleset_do_snprintf(char *buf, size_t remain,
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		if (ret > 0)
-			prev = rs->table_list;
+			sep = "\n";
 	}
 
 	if (nftnl_ruleset_is_set(rs, NFTNL_RULESET_CHAINLIST) &&
 	    (!nftnl_chain_list_is_empty(rs->chain_list))) {
-		ret = snprintf(buf + offset, remain, "%s",
-			       nftnl_ruleset_o_separator(prev, type));
+		ret = snprintf(buf + offset, remain, "%s", sep);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		ret = nftnl_ruleset_snprintf_chain(buf + offset, remain, rs,
@@ -491,13 +457,12 @@ nftnl_ruleset_do_snprintf(char *buf, size_t remain,
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		if (ret > 0)
-			prev = rs->chain_list;
+			sep = "\n";
 	}
 
 	if (nftnl_ruleset_is_set(rs, NFTNL_RULESET_SETLIST) &&
 	    (!nftnl_set_list_is_empty(rs->set_list))) {
-		ret = snprintf(buf + offset, remain, "%s",
-			       nftnl_ruleset_o_separator(prev, type));
+		ret = snprintf(buf + offset, remain, "%s", sep);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		ret = nftnl_ruleset_snprintf_set(buf + offset, remain, rs,
@@ -505,13 +470,12 @@ nftnl_ruleset_do_snprintf(char *buf, size_t remain,
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		if (ret > 0)
-			prev = rs->set_list;
+			sep = "\n";
 	}
 
 	if (nftnl_ruleset_is_set(rs, NFTNL_RULESET_RULELIST) &&
 	    (!nftnl_rule_list_is_empty(rs->rule_list))) {
-		ret = snprintf(buf + offset, remain, "%s",
-			       nftnl_ruleset_o_separator(prev, type));
+		ret = snprintf(buf + offset, remain, "%s", sep);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		ret = nftnl_ruleset_snprintf_rule(buf + offset, remain, rs,
@@ -543,6 +507,7 @@ static int nftnl_ruleset_fprintf_tables(FILE *fp, const struct nftnl_ruleset *rs
 	int len = 0, ret = 0;
 	struct nftnl_table *t;
 	struct nftnl_table_list_iter *ti;
+	const char *sep = "";
 
 	ti = nftnl_table_list_iter_create(rs->table_list);
 	if (ti == NULL)
@@ -550,19 +515,21 @@ static int nftnl_ruleset_fprintf_tables(FILE *fp, const struct nftnl_ruleset *rs
 
 	t = nftnl_table_list_iter_next(ti);
 	while (t != NULL) {
-		ret = nftnl_table_fprintf(fp, t, type, flags);
+		ret = fprintf(fp, "%s", sep);
 		if (ret < 0)
 			goto err;
 
 		len += ret;
 
-		t = nftnl_table_list_iter_next(ti);
-
-		ret = fprintf(fp, "%s", nftnl_ruleset_o_separator(t, type));
+		ret = nftnl_table_fprintf(fp, t, type, flags);
 		if (ret < 0)
 			goto err;
 
 		len += ret;
+
+		t = nftnl_table_list_iter_next(ti);
+		sep = "\n";
+
 	}
 	nftnl_table_list_iter_destroy(ti);
 
@@ -578,6 +545,7 @@ static int nftnl_ruleset_fprintf_chains(FILE *fp, const struct nftnl_ruleset *rs
 	int len = 0, ret = 0;
 	struct nftnl_chain *o;
 	struct nftnl_chain_list_iter *i;
+	const char *sep = "";
 
 	i = nftnl_chain_list_iter_create(rs->chain_list);
 	if (i == NULL)
@@ -585,19 +553,20 @@ static int nftnl_ruleset_fprintf_chains(FILE *fp, const struct nftnl_ruleset *rs
 
 	o = nftnl_chain_list_iter_next(i);
 	while (o != NULL) {
-		ret = nftnl_chain_fprintf(fp, o, type, flags);
+		ret = fprintf(fp, "%s", sep);
 		if (ret < 0)
 			goto err;
 
 		len += ret;
 
-		o = nftnl_chain_list_iter_next(i);
-
-		ret = fprintf(fp, "%s", nftnl_ruleset_o_separator(o, type));
+		ret = nftnl_chain_fprintf(fp, o, type, flags);
 		if (ret < 0)
 			goto err;
 
 		len += ret;
+
+		o = nftnl_chain_list_iter_next(i);
+		sep = "\n";
 	}
 	nftnl_chain_list_iter_destroy(i);
 
@@ -613,6 +582,7 @@ static int nftnl_ruleset_fprintf_sets(FILE *fp, const struct nftnl_ruleset *rs,
 	int len = 0, ret = 0;
 	struct nftnl_set *o;
 	struct nftnl_set_list_iter *i;
+	const char *sep = "";
 
 	i = nftnl_set_list_iter_create(rs->set_list);
 	if (i == NULL)
@@ -620,19 +590,20 @@ static int nftnl_ruleset_fprintf_sets(FILE *fp, const struct nftnl_ruleset *rs,
 
 	o = nftnl_set_list_iter_next(i);
 	while (o != NULL) {
-		ret = nftnl_set_fprintf(fp, o, type, flags);
+		ret = fprintf(fp, "%s", sep);
 		if (ret < 0)
 			goto err;
 
 		len += ret;
 
-		o = nftnl_set_list_iter_next(i);
-
-		ret = fprintf(fp, "%s", nftnl_ruleset_o_separator(o, type));
+		ret = nftnl_set_fprintf(fp, o, type, flags);
 		if (ret < 0)
 			goto err;
 
 		len += ret;
+
+		o = nftnl_set_list_iter_next(i);
+		sep = "\n";
 	}
 	nftnl_set_list_iter_destroy(i);
 
@@ -648,6 +619,7 @@ static int nftnl_ruleset_fprintf_rules(FILE *fp, const struct nftnl_ruleset *rs,
 	int len = 0, ret = 0;
 	struct nftnl_rule *o;
 	struct nftnl_rule_list_iter *i;
+	const char *sep = "";
 
 	i = nftnl_rule_list_iter_create(rs->rule_list);
 	if (i == NULL)
@@ -655,19 +627,20 @@ static int nftnl_ruleset_fprintf_rules(FILE *fp, const struct nftnl_ruleset *rs,
 
 	o = nftnl_rule_list_iter_next(i);
 	while (o != NULL) {
-		ret = nftnl_rule_fprintf(fp, o, type, flags);
+		ret = fprintf(fp, "%s", sep);
 		if (ret < 0)
 			goto err;
 
 		len += ret;
 
-		o = nftnl_rule_list_iter_next(i);
-
-		ret = fprintf(fp, "%s", nftnl_ruleset_o_separator(o, type));
+		ret = nftnl_rule_fprintf(fp, o, type, flags);
 		if (ret < 0)
 			goto err;
 
 		len += ret;
+
+		o = nftnl_rule_list_iter_next(i);
+		sep = "\n";
 	}
 	nftnl_rule_list_iter_destroy(i);
 
@@ -686,60 +659,54 @@ static int nftnl_ruleset_cmd_fprintf(FILE *fp, const struct nftnl_ruleset *rs,
 				   uint32_t cmd, uint32_t type, uint32_t flags)
 {
 	int len = 0, ret = 0;
-	void *prev = NULL;
 	uint32_t inner_flags = flags;
+	const char *sep = "";
 
 	/* dont pass events flags to child calls of _snprintf() */
 	inner_flags &= ~NFTNL_OF_EVENT_ANY;
 
-	ret = fprintf(fp, "%s", nftnl_ruleset_o_opentag(type));
-	NFTNL_FPRINTF_RETURN_OR_FIXLEN(ret, len);
-
 	if ((nftnl_ruleset_is_set(rs, NFTNL_RULESET_TABLELIST)) &&
 	    (!nftnl_table_list_is_empty(rs->table_list))) {
 		ret = nftnl_ruleset_fprintf_tables(fp, rs, type, inner_flags);
 		NFTNL_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 
 		if (ret > 0)
-			prev = rs->table_list;
+			sep = "\n";
 	}
 
 	if ((nftnl_ruleset_is_set(rs, NFTNL_RULESET_CHAINLIST)) &&
 	    (!nftnl_chain_list_is_empty(rs->chain_list))) {
-		ret = fprintf(fp, "%s", nftnl_ruleset_o_separator(prev, type));
+		ret = fprintf(fp, "%s", sep);
 		NFTNL_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 
 		ret = nftnl_ruleset_fprintf_chains(fp, rs, type, inner_flags);
 		NFTNL_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 
 		if (ret > 0)
-			prev = rs->chain_list;
+			sep = "\n";
 	}
 
 	if ((nftnl_ruleset_is_set(rs, NFTNL_RULESET_SETLIST)) &&
 	    (!nftnl_set_list_is_empty(rs->set_list))) {
-		ret = fprintf(fp, "%s", nftnl_ruleset_o_separator(prev, type));
+		ret = fprintf(fp, "%s", sep);
 		NFTNL_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 
 		ret = nftnl_ruleset_fprintf_sets(fp, rs, type, inner_flags);
 		NFTNL_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 
 		if (ret > 0)
-			prev = rs->set_list;
+			sep = "\n";
 	}
 
 	if ((nftnl_ruleset_is_set(rs, NFTNL_RULESET_RULELIST)) &&
 	    (!nftnl_rule_list_is_empty(rs->rule_list))) {
-		ret = fprintf(fp, "%s", nftnl_ruleset_o_separator(prev, type));
+		ret = fprintf(fp, "%s", sep);
 		NFTNL_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 
 		ret = nftnl_ruleset_fprintf_rules(fp, rs, type, inner_flags);
 		NFTNL_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 	}
 
-	ret = fprintf(fp, "%s", nftnl_ruleset_o_closetag(type));
-	NFTNL_FPRINTF_RETURN_OR_FIXLEN(ret, len);
-
 	return len;
 }
 
-- 
2.30.1

