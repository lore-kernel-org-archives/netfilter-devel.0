From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 1/2] src: add flag to add event wrapping in output
	functions
Date: Tue, 15 Apr 2014 14:50:30 +0200
Message-ID: <20140415125030.2590.5501.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54065 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754996AbaDOMup (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:50:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch uses the flag option of each output function to print an
event wrapper string in each object.

In order to use this functionality, the caller must pass a flag with either
NFT_OUTPUT_FLAG_EVENTNEW or NFT_OUTPUT_FLAG_EVENTDEL activated.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/libnftnl/common.h |    5 +++
 src/chain.c               |   37 ++++++++++++++++++++++---
 src/internal.h            |    2 +
 src/rule.c                |   43 ++++++++++++++++++++++++++---
 src/ruleset.c             |   66 ++++++++++++++++++++++++++++++++++++++++-----
 src/set.c                 |   42 +++++++++++++++++++++++++----
 src/set_elem.c            |   37 ++++++++++++++++++++++---
 src/table.c               |   36 +++++++++++++++++++++----
 src/utils.c               |   45 +++++++++++++++++++++++++++++++
 9 files changed, 280 insertions(+), 33 deletions(-)

diff --git a/include/libnftnl/common.h b/include/libnftnl/common.h
index f0c20f0..f105c9a 100644
--- a/include/libnftnl/common.h
+++ b/include/libnftnl/common.h
@@ -15,6 +15,11 @@ enum nft_output_type {
 	NFT_OUTPUT_JSON,
 };
 
+enum {
+	NFT_OUTPUT_FLAG_EVENTNEW	= 0,
+	NFT_OUTPUT_FLAG_EVENTDEL,
+};
+
 enum nft_parse_type {
 	NFT_PARSE_NONE		= 0,
 	NFT_PARSE_XML,
diff --git a/src/chain.c b/src/chain.c
index 472203e..87558a1 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -924,17 +924,44 @@ static int nft_chain_snprintf_default(char *buf, size_t size,
 int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *c,
 		       uint32_t type, uint32_t flags)
 {
+	int ret, len = size, offset = 0;
+
+	if (flags & (1 << NFT_OUTPUT_FLAG_EVENTNEW)) {
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_event_opentag(NFT_OUTPUT_FLAG_EVENTNEW,
+						 type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	} else if (flags & (1 << NFT_OUTPUT_FLAG_EVENTDEL)) {
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_event_opentag(NFT_OUTPUT_FLAG_EVENTDEL,
+						 type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	switch(type) {
 	case NFT_OUTPUT_DEFAULT:
-		return nft_chain_snprintf_default(buf, size, c);
+		ret = nft_chain_snprintf_default(buf+offset, len, c);
+		break;
 	case NFT_OUTPUT_XML:
-		return nft_chain_snprintf_xml(buf, size, c);
+		ret = nft_chain_snprintf_xml(buf+offset, len, c);
+		break;
 	case NFT_OUTPUT_JSON:
-		return nft_chain_snprintf_json(buf, size, c);
-	default:
+		ret = nft_chain_snprintf_json(buf+offset, len, c);
 		break;
+	default:
+		return -1;
 	}
-	return -1;
+
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if ((flags & (1 << NFT_OUTPUT_FLAG_EVENTNEW)) ||
+	    (flags & (1 << NFT_OUTPUT_FLAG_EVENTDEL))) {
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_event_closetag(type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
 }
 EXPORT_SYMBOL(nft_chain_snprintf);
 
diff --git a/src/internal.h b/src/internal.h
index ba994c8..8979bb7 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -136,6 +136,8 @@ int nft_get_value(enum nft_type type, void *val, void *out);
 
 #include <stdio.h>
 int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags, int (*snprintf_cb)(char *buf, size_t bufsiz, void *obj, uint32_t type, uint32_t flags));
+const char *nft_event_opentag(uint32_t event, uint32_t format);
+const char *nft_event_closetag(uint32_t format);
 
 void xfree(const void *ptr);
 
diff --git a/src/rule.c b/src/rule.c
index df9dd80..0a9ee1d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -967,17 +967,50 @@ static int nft_rule_snprintf_default(char *buf, size_t size, struct nft_rule *r,
 int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *r,
 		       uint32_t type, uint32_t flags)
 {
+	int ret, len = size, offset = 0;
+	uint32_t noevent_flags = flags;
+
+	if (flags & (1 << NFT_OUTPUT_FLAG_EVENTNEW)) {
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_event_opentag(NFT_OUTPUT_FLAG_EVENTNEW,
+						 type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		noevent_flags &= ~(1 << NFT_OUTPUT_FLAG_EVENTNEW);
+	} else if (flags & (1 << NFT_OUTPUT_FLAG_EVENTDEL)) {
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_event_opentag(NFT_OUTPUT_FLAG_EVENTDEL,
+						 type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		noevent_flags &= ~(1 << NFT_OUTPUT_FLAG_EVENTDEL);
+	}
+
 	switch(type) {
 	case NFT_OUTPUT_DEFAULT:
-		return nft_rule_snprintf_default(buf, size, r, type, flags);
+		ret = nft_rule_snprintf_default(buf+offset, len, r, type,
+						noevent_flags);
+		break;
 	case NFT_OUTPUT_XML:
-		return nft_rule_snprintf_xml(buf, size, r, type, flags);
+		ret = nft_rule_snprintf_xml(buf+offset, len, r, type,
+					    noevent_flags);
+		break;
 	case NFT_OUTPUT_JSON:
-		return nft_rule_snprintf_json(buf, size, r, type, flags);
-	default:
+		ret = nft_rule_snprintf_json(buf+offset, len, r, type,
+					     noevent_flags);
 		break;
+	default:
+		return -1;
 	}
-	return -1;
+
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if ((flags & (1 << NFT_OUTPUT_FLAG_EVENTNEW)) ||
+	    (flags & (1 << NFT_OUTPUT_FLAG_EVENTDEL))) {
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_event_closetag(type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
 }
 EXPORT_SYMBOL(nft_rule_snprintf);
 
diff --git a/src/ruleset.c b/src/ruleset.c
index 3cbec09..2b249ef 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -765,6 +765,24 @@ nft_ruleset_do_snprintf(char *buf, size_t size, const struct nft_ruleset *rs,
 {
 	int ret, len = size, offset = 0;
 	void *prev = NULL;
+	uint32_t noevent_flags;
+
+	/* dont pass events flags to child calls of _snprintf() */
+	noevent_flags = flags;
+
+	if (flags & (1 << NFT_OUTPUT_FLAG_EVENTNEW)) {
+		ret = snprintf(buf+offset, size, "%s",
+			       nft_event_opentag(NFT_OUTPUT_FLAG_EVENTNEW,
+						 type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		noevent_flags &= ~(1 << NFT_OUTPUT_FLAG_EVENTNEW);
+	} else if (flags & (1 << NFT_OUTPUT_FLAG_EVENTDEL)) {
+		ret = snprintf(buf+offset, size, "%s",
+			       nft_event_opentag(NFT_OUTPUT_FLAG_EVENTDEL,
+						 type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		noevent_flags &= ~(1 << NFT_OUTPUT_FLAG_EVENTDEL);
+	}
 
 	ret = snprintf(buf+offset, size, "%s", nft_ruleset_o_opentag(type));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
@@ -772,7 +790,7 @@ nft_ruleset_do_snprintf(char *buf, size_t size, const struct nft_ruleset *rs,
 	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_TABLELIST) &&
 	    (!nft_table_list_is_empty(rs->table_list))) {
 		ret = nft_ruleset_snprintf_table(buf+offset, len, rs,
-						 type, flags);
+						 type, noevent_flags);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		if (ret > 0)
@@ -786,7 +804,7 @@ nft_ruleset_do_snprintf(char *buf, size_t size, const struct nft_ruleset *rs,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		ret = nft_ruleset_snprintf_chain(buf+offset, len, rs,
-						 type, flags);
+						 type, noevent_flags);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		if (ret > 0)
@@ -800,7 +818,7 @@ nft_ruleset_do_snprintf(char *buf, size_t size, const struct nft_ruleset *rs,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		ret = nft_ruleset_snprintf_set(buf+offset, len, rs,
-					       type, flags);
+					       type, noevent_flags);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		if (ret > 0)
@@ -814,13 +832,20 @@ nft_ruleset_do_snprintf(char *buf, size_t size, const struct nft_ruleset *rs,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		ret = nft_ruleset_snprintf_rule(buf+offset, len, rs,
-						type, flags);
+						type, noevent_flags);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
 	ret = snprintf(buf+offset, size, "%s", nft_ruleset_o_closetag(type));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+	if ((flags & (1 << NFT_OUTPUT_FLAG_EVENTNEW)) ||
+	    (flags & (1 << NFT_OUTPUT_FLAG_EVENTDEL))) {
+		ret = snprintf(buf+offset, size, "%s",
+			       nft_event_closetag(type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	return offset;
 }
 
@@ -989,13 +1014,32 @@ int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type,
 {
 	int len = 0, ret = 0;
 	void *prev = NULL;
+	uint32_t noevent_flags;
+
+	/* dont pass events flags to child calls of _snprintf() */
+	noevent_flags = flags;
+
+	if (flags & (1 << NFT_OUTPUT_FLAG_EVENTNEW)) {
+		ret = fprintf(fp, "%s",
+			      nft_event_opentag(NFT_OUTPUT_FLAG_EVENTNEW,
+						type));
+		NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
+		noevent_flags &= ~(1 << NFT_OUTPUT_FLAG_EVENTNEW);
+
+	} else if (flags & (1 << NFT_OUTPUT_FLAG_EVENTDEL)) {
+		ret = fprintf(fp, "%s",
+			      nft_event_opentag(NFT_OUTPUT_FLAG_EVENTDEL,
+						type));
+		NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
+		noevent_flags &= ~(1 << NFT_OUTPUT_FLAG_EVENTNEW);
+	}
 
 	ret = fprintf(fp, "%s", nft_ruleset_o_opentag(type));
 	NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 
 	if ((nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_TABLELIST)) &&
 	    (!nft_table_list_is_empty(rs->table_list))) {
-		ret = nft_ruleset_fprintf_tables(fp, rs, type, flags);
+		ret = nft_ruleset_fprintf_tables(fp, rs, type, noevent_flags);
 		NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 
 		if (ret > 0)
@@ -1007,7 +1051,7 @@ int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type,
 		ret = fprintf(fp, "%s", nft_ruleset_o_separator(prev, type));
 		NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 
-		ret = nft_ruleset_fprintf_chains(fp, rs, type, flags);
+		ret = nft_ruleset_fprintf_chains(fp, rs, type, noevent_flags);
 		NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 
 		if (ret > 0)
@@ -1019,7 +1063,7 @@ int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type,
 		ret = fprintf(fp, "%s", nft_ruleset_o_separator(prev, type));
 		NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 
-		ret = nft_ruleset_fprintf_sets(fp, rs, type, flags);
+		ret = nft_ruleset_fprintf_sets(fp, rs, type, noevent_flags);
 		NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 
 		if (ret > 0)
@@ -1031,13 +1075,19 @@ int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type,
 		ret = fprintf(fp, "%s", nft_ruleset_o_separator(prev, type));
 		NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 
-		ret = nft_ruleset_fprintf_rules(fp, rs, type, flags);
+		ret = nft_ruleset_fprintf_rules(fp, rs, type, noevent_flags);
 		NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 	}
 
 	ret = fprintf(fp, "%s", nft_ruleset_o_closetag(type));
 	NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 
+	if ((flags & (1 << NFT_OUTPUT_FLAG_EVENTNEW)) ||
+	    (flags & (1 << NFT_OUTPUT_FLAG_EVENTDEL))) {
+		ret = fprintf(fp, "%s", nft_event_closetag(type));
+		NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
+	}
+
 	return len;
 }
 EXPORT_SYMBOL(nft_ruleset_fprintf);
diff --git a/src/set.c b/src/set.c
index 550c262..59832aa 100644
--- a/src/set.c
+++ b/src/set.c
@@ -704,17 +704,49 @@ static int nft_set_snprintf_xml(char *buf, size_t size, struct nft_set *s,
 int nft_set_snprintf(char *buf, size_t size, struct nft_set *s,
 		     uint32_t type, uint32_t flags)
 {
+	int ret, len = size, offset = 0;
+	uint32_t noevent_flags = flags;
+
+	if (flags & (1 << NFT_OUTPUT_FLAG_EVENTNEW)) {
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_event_opentag(NFT_OUTPUT_FLAG_EVENTNEW,
+						 type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		noevent_flags &= ~(1 << NFT_OUTPUT_FLAG_EVENTNEW);
+	} else if (flags & (1 << NFT_OUTPUT_FLAG_EVENTDEL)) {
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_event_opentag(NFT_OUTPUT_FLAG_EVENTDEL,
+						 type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		noevent_flags &= ~(1 << NFT_OUTPUT_FLAG_EVENTDEL);
+	}
+
 	switch(type) {
 	case NFT_OUTPUT_DEFAULT:
-		return nft_set_snprintf_default(buf, size, s, type, flags);
+		ret = nft_set_snprintf_default(buf+offset, len, s, type,
+					       noevent_flags);
+		break;
 	case NFT_OUTPUT_XML:
-		return nft_set_snprintf_xml(buf, size, s, flags);
+		ret = nft_set_snprintf_xml(buf+offset, len, s, noevent_flags);
+		break;
 	case NFT_OUTPUT_JSON:
-		return nft_set_snprintf_json(buf, size, s, type, flags);
-	default:
+		ret = nft_set_snprintf_json(buf+offset, len, s, type,
+					    noevent_flags);
 		break;
+	default:
+		return -1;
 	}
-	return -1;
+
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if ((flags & (1 << NFT_OUTPUT_FLAG_EVENTNEW)) ||
+	    (flags & (1 << NFT_OUTPUT_FLAG_EVENTDEL))) {
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_event_closetag(type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
 }
 EXPORT_SYMBOL(nft_set_snprintf);
 
diff --git a/src/set_elem.c b/src/set_elem.c
index a747ba6..9181a10 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -591,17 +591,44 @@ static int nft_set_elem_snprintf_xml(char *buf, size_t size,
 int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem *e,
 			   uint32_t type, uint32_t flags)
 {
+	int ret, len = size, offset = 0;
+
+	if (flags & (1 << NFT_OUTPUT_FLAG_EVENTNEW)) {
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_event_opentag(NFT_OUTPUT_FLAG_EVENTNEW,
+						 type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	} else if (flags & (1 << NFT_OUTPUT_FLAG_EVENTDEL)) {
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_event_opentag(NFT_OUTPUT_FLAG_EVENTDEL,
+						 type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	switch(type) {
 	case NFT_OUTPUT_DEFAULT:
-		return nft_set_elem_snprintf_default(buf, size, e);
+		ret = nft_set_elem_snprintf_default(buf+offset, len, e);
+		break;
 	case NFT_OUTPUT_XML:
-		return nft_set_elem_snprintf_xml(buf, size, e, flags);
+		ret = nft_set_elem_snprintf_xml(buf+offset, len, e, flags);
+		break;
 	case NFT_OUTPUT_JSON:
-		return nft_set_elem_snprintf_json(buf, size, e, flags);
-	default:
+		ret = nft_set_elem_snprintf_json(buf+offset, len, e, flags);
 		break;
+	default:
+		return -1;
 	}
-	return -1;
+
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if ((flags & (1 << NFT_OUTPUT_FLAG_EVENTNEW)) ||
+	    (flags & (1 << NFT_OUTPUT_FLAG_EVENTDEL))) {
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_event_closetag(type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
 }
 EXPORT_SYMBOL(nft_set_elem_snprintf);
 
diff --git a/src/table.c b/src/table.c
index 44e9a7b..82ca84d 100644
--- a/src/table.c
+++ b/src/table.c
@@ -441,17 +441,43 @@ static int nft_table_snprintf_default(char *buf, size_t size, struct nft_table *
 int nft_table_snprintf(char *buf, size_t size, struct nft_table *t,
 		       uint32_t type, uint32_t flags)
 {
+	int ret, len = size, offset = 0;
+
+	if (flags & (1 << NFT_OUTPUT_FLAG_EVENTNEW)) {
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_event_opentag(NFT_OUTPUT_FLAG_EVENTNEW,
+						 type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	} else if (flags & (1 << NFT_OUTPUT_FLAG_EVENTDEL)) {
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_event_opentag(NFT_OUTPUT_FLAG_EVENTDEL,
+						 type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	switch(type) {
 	case NFT_OUTPUT_DEFAULT:
-		return nft_table_snprintf_default(buf, size, t);
+		ret = nft_table_snprintf_default(buf+offset, len, t);
+		break;
 	case NFT_OUTPUT_XML:
-		return nft_table_snprintf_xml(buf, size, t);
+		ret = nft_table_snprintf_xml(buf+offset, len, t);
+		break;
 	case NFT_OUTPUT_JSON:
-		return nft_table_snprintf_json(buf, size, t);
-	default:
+		ret = nft_table_snprintf_json(buf+offset, len, t);
 		break;
+	default:
+		return -1;
 	}
-	return -1;
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if ((flags & (1 << NFT_OUTPUT_FLAG_EVENTNEW)) ||
+	    (flags & (1 << NFT_OUTPUT_FLAG_EVENTDEL))) {
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_event_closetag(type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
 }
 EXPORT_SYMBOL(nft_table_snprintf);
 
diff --git a/src/utils.c b/src/utils.c
index 18917f5..870157a 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -212,6 +212,51 @@ int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags,
 	return ret;
 }
 
+const char *nft_event_opentag(uint32_t event, uint32_t format)
+{
+	switch (format) {
+	case NFT_OUTPUT_XML:
+		switch (event) {
+		case NFT_OUTPUT_FLAG_EVENTNEW:
+			return "<event><type>new</type>";
+		case NFT_OUTPUT_FLAG_EVENTDEL:
+			return "<event><type>destroy</type>";
+		default:
+			return "[unknown]";
+		}
+	case NFT_OUTPUT_JSON:
+		switch (event) {
+		case NFT_OUTPUT_FLAG_EVENTNEW:
+			return "{event:{type:\"new\",{\"";
+		case NFT_OUTPUT_FLAG_EVENTDEL:
+			return "{event:{type:\"destroy\",{\"";
+		default:
+			return "[unknown]";
+		}
+	default:
+		switch (event) {
+		case NFT_OUTPUT_FLAG_EVENTNEW:
+			return "[NEW] ";
+		case NFT_OUTPUT_FLAG_EVENTDEL:
+			return "[DEL] ";
+		default:
+			return "[unknown]";
+		}
+	}
+}
+
+const char *nft_event_closetag(uint32_t format)
+{
+	switch (format) {
+	case NFT_OUTPUT_XML:
+		return "</event>";
+	case NFT_OUTPUT_JSON:
+		return "}}}";
+	default:
+		return "";
+	}
+}
+
 void __nft_assert_fail(uint16_t attr, const char *filename, int line)
 {
 	fprintf(stderr, "libnftnl: attribute %d assertion failed in %s:%d\n",

