From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH 1/4 v8] src: add command tag in json/xml export support
Date: Mon,  9 Feb 2015 21:09:53 +0100
Message-ID: <1423512596-29777-2-git-send-email-alvaroneay@gmail.com>
References: <1423512596-29777-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:59937 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbbBIUJl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2015 15:09:41 -0500
Received: by mail-we0-f170.google.com with SMTP id q59so20490100wes.1
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Feb 2015 12:09:39 -0800 (PST)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id ub1sm17729984wjc.43.2015.02.09.12.09.38
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Feb 2015 12:09:39 -0800 (PST)
In-Reply-To: <1423512596-29777-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, we can't do incremental updates via json/xml.

This patch enriches the existing output to indicate the kind of
te that you want to perform.

So, if we have a ruleset like:

table ip filter {
	chain input {
		type filter hook input priority 0;
	}
}

The new output looks like:

{"nftables":[{"add":[{"table":{"name":"filter",...}}]}]}
              ^^^^^

Where we explicitly indicate that we want to add a table.

We support all the actions that we can do with nft, they are:

 - Add, delete and flush tables and chains.
 - Add, delete, replace and insert rules.
 - Add and delete sets.
 - Add and delete set elements.
 - Flush ruleset.

You only need to add the command tag:

	{"nftables":[{"delete":[{...}, {...},...}]}]}
		       ^^^^^^^^

The possible command tags that you can use are "add", "delete", "insert",
"replace" and "flush".

- Flush table or chain, eg.:

	{"nftables":[{"flush":[{"table":{"name":...}}]}]}

- Delete table, chain, set or rule, eg.:

	{"nftables":[{"delete":[{"chain":{"name":...}]}]}

- Replace a rule (you have to  specify the handle):

	{"nftables":[{"replace":[{"rule":{...}}]}]}

- Insert a rule:

	{"nftables":[{"insert":[{"rule":{...}}]}]}

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v8]
 * the function nft_flag2cmd to return enum nft_cmd_type.
 * the function nft_buf_open_array to make a correct consolidation to
   json and xml
 * nft_cmd2tag controls that the is not lead to a out of bound the entry
   parameter

 include/buffer.h          |    7 ++++
 include/libnftnl/common.h |   10 ++++++
 src/buffer.c              |   24 +++++++++++++
 src/chain.c               |   21 +++++++----
 src/common.c              |   85 +++++++++++++++++++++------------------------
 src/gen.c                 |   21 +++++++----
 src/internal.h            |   20 +++++++----
 src/rule.c                |   21 +++++++----
 src/ruleset.c             |   48 ++++++++++++++++++-------
 src/set.c                 |   21 +++++++----
 src/set_elem.c            |   22 ++++++++----
 src/table.c               |   21 +++++++----
 src/utils.c               |   35 ++++++++++++++++---
 13 files changed, 252 insertions(+), 104 deletions(-)

diff --git a/include/buffer.h b/include/buffer.h
index 2b497f2..badffe6 100644
--- a/include/buffer.h
+++ b/include/buffer.h
@@ -24,7 +24,9 @@ int nft_buf_done(struct nft_buf *b);
 union nft_data_reg;
 
 int nft_buf_open(struct nft_buf *b, int type, const char *tag);
+int nft_buf_open_array(struct nft_buf *b, int type, const char *tag);
 int nft_buf_close(struct nft_buf *b, int type, const char *tag);
+int nft_buf_close_array(struct nft_buf *b, int type, const char *tag);
 
 int nft_buf_u32(struct nft_buf *b, int type, uint32_t value, const char *tag);
 int nft_buf_s32(struct nft_buf *b, int type, uint32_t value, const char *tag);
@@ -76,5 +78,10 @@ int nft_buf_reg(struct nft_buf *b, int type, union nft_data_reg *reg,
 #define UNIT			"unit"
 #define USE			"use"
 #define XOR			"xor"
+#define ADD			"add"
+#define INSERT			"insert"
+#define DELETE			"delete"
+#define REPLACE			"replace"
+#define FLUSH			"flush"
 
 #endif
diff --git a/include/libnftnl/common.h b/include/libnftnl/common.h
index fa3ab60..f8f1304 100644
--- a/include/libnftnl/common.h
+++ b/include/libnftnl/common.h
@@ -21,6 +21,16 @@ enum nft_output_flags {
 	NFT_OF_EVENT_ANY	= (NFT_OF_EVENT_NEW | NFT_OF_EVENT_DEL),
 };
 
+enum nft_cmd_type {
+	NFT_CMD_UNSPEC		= 0,
+	NFT_CMD_ADD,
+	NFT_CMD_INSERT,
+	NFT_CMD_DELETE,
+	NFT_CMD_REPLACE,
+	NFT_CMD_FLUSH,
+	NFT_CMD_MAX,
+};
+
 enum nft_parse_type {
 	NFT_PARSE_NONE		= 0,
 	NFT_PARSE_XML,
diff --git a/src/buffer.c b/src/buffer.c
index 4cedb9e..149aec6 100644
--- a/src/buffer.c
+++ b/src/buffer.c
@@ -71,6 +71,18 @@ int nft_buf_open(struct nft_buf *b, int type, const char *tag)
 	}
 }
 
+int nft_buf_open_array(struct nft_buf *b, int type, const char *tag)
+{
+	switch (type) {
+	case NFT_OUTPUT_JSON:
+		return nft_buf_put(b, "{\"%s\":[", tag);
+	case NFT_OUTPUT_XML:
+		return nft_buf_put(b, "<%s>", tag);
+	default:
+		return 0;
+	}
+}
+
 int nft_buf_close(struct nft_buf *b, int type, const char *tag)
 {
 	switch (type) {
@@ -90,6 +102,18 @@ int nft_buf_close(struct nft_buf *b, int type, const char *tag)
 	}
 }
 
+int nft_buf_close_array(struct nft_buf *b, int type, const char *tag)
+{
+	switch (type) {
+	case NFT_OUTPUT_JSON:
+		return nft_buf_put(b, "]}");
+	case NFT_OUTPUT_XML:
+		return nft_buf_put(b, "</%s>", tag);
+	default:
+		return 0;
+	}
+}
+
 int nft_buf_u32(struct nft_buf *b, int type, uint32_t value, const char *tag)
 {
 	switch (type) {
diff --git a/src/chain.c b/src/chain.c
index 26ad14d..84851e0 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -847,12 +847,12 @@ static int nft_chain_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *c,
-		       uint32_t type, uint32_t flags)
+static int nft_chain_cmd_snprintf(char *buf, size_t size, struct nft_chain *c,
+				  uint32_t cmd, uint32_t type, uint32_t flags)
 {
 	int ret, len = size, offset = 0;
 
-	ret = nft_event_header_snprintf(buf+offset, len, type, flags);
+	ret = nft_cmd_header_snprintf(buf + offset, len, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	switch (type) {
@@ -869,15 +869,23 @@ int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *c,
 
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = nft_event_footer_snprintf(buf+offset, len, type, flags);
+	ret = nft_cmd_footer_snprintf(buf + offset, len, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
 }
+
+int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *c,
+		       uint32_t type, uint32_t flags)
+{
+	return nft_chain_cmd_snprintf(buf, size, c, nft_flag2cmd(flags), type,
+				      flags);
+}
 EXPORT_SYMBOL(nft_chain_snprintf);
 
 static inline int nft_chain_do_snprintf(char *buf, size_t size, void *c,
-					uint32_t type, uint32_t flags)
+					uint32_t cmd, uint32_t type,
+					uint32_t flags)
 {
 	return nft_chain_snprintf(buf, size, c, type, flags);
 }
@@ -885,7 +893,8 @@ static inline int nft_chain_do_snprintf(char *buf, size_t size, void *c,
 int nft_chain_fprintf(FILE *fp, struct nft_chain *c, uint32_t type,
 		      uint32_t flags)
 {
-	return nft_fprintf(fp, c, type, flags, nft_chain_do_snprintf);
+	return nft_fprintf(fp, c, NFT_CMD_UNSPEC, type, flags,
+			   nft_chain_do_snprintf);
 }
 EXPORT_SYMBOL(nft_chain_fprintf);
 
diff --git a/src/common.c b/src/common.c
index a6f2508..139be55 100644
--- a/src/common.c
+++ b/src/common.c
@@ -16,6 +16,7 @@
 #include <libmnl/libmnl.h>
 #include <libnftnl/common.h>
 #include <libnftnl/set.h>
+#include <buffer.h>
 
 #include <errno.h>
 #include "internal.h"
@@ -70,86 +71,80 @@ int nft_parse_perror(const char *msg, struct nft_parse_err *err)
 }
 EXPORT_SYMBOL(nft_parse_perror);
 
-int nft_event_header_snprintf(char *buf, size_t size, uint32_t type,
-			      uint32_t flags)
+int nft_cmd_header_snprintf(char *buf, size_t size, uint32_t cmd, uint32_t type,
+			    uint32_t flags)
 {
-	int ret = 0;
+	NFT_BUF_INIT(b, buf, size);
 
-	if (!(flags & NFT_OF_EVENT_ANY))
+	if (cmd == NFT_CMD_UNSPEC)
 		return 0;
 
 	switch (type) {
 	case NFT_OUTPUT_XML:
-		if (flags & NFT_OF_EVENT_NEW) {
-			ret = snprintf(buf, size, "<event><type>new</type>");
-		} else if (flags & NFT_OF_EVENT_DEL) {
-			ret = snprintf(buf, size,
-				       "<event><type>delete</type>");
-		} else {
-			ret = snprintf(buf, size,
-				       "<event><type>unknown</type>");
-		}
-		break;
 	case NFT_OUTPUT_JSON:
-		if (flags & NFT_OF_EVENT_NEW) {
-			ret = snprintf(buf, size, "{event:{type:\"new\",{\"");
-		} else if (flags & NFT_OF_EVENT_DEL) {
-			ret = snprintf(buf, size,
-				       "{event:{type:\"delete\",{\"");
-		} else {
-			ret = snprintf(buf, size,
-				       "{event:{type:\"unknown\",{\"");
-		}
+		nft_buf_open_array(&b, type, nft_cmd2tag(cmd));
 		break;
 	default:
-		if (flags & NFT_OF_EVENT_NEW) {
-			ret = snprintf(buf, size, "%9s", "[NEW] ");
-		} else if (flags & NFT_OF_EVENT_DEL) {
-			ret = snprintf(buf, size, "%9s", "[DELETE] ");
-		} else {
-			ret = snprintf(buf, size, "%9s", "[unknown] ");
+		switch (cmd) {
+		case NFT_CMD_ADD:
+			return snprintf(buf, size, "%9s", "[ADD] ");
+		case NFT_CMD_DELETE:
+			return snprintf(buf, size, "%9s", "[DELETE] ");
+		default:
+			return snprintf(buf, size, "%9s", "[unknown] ");
 		}
 		break;
 	}
-	return ret;
+	return nft_buf_done(&b);
 }
 
-static int nft_event_header_fprintf_cb(char *buf, size_t size, void *unused,
-				       uint32_t type, uint32_t flags)
+
+
+static int nft_cmd_header_fprintf_cb(char *buf, size_t size, void *obj,
+				     uint32_t cmd, uint32_t type,
+				     uint32_t flags)
 {
-	return nft_event_header_snprintf(buf, size, type, flags);
+	return nft_cmd_header_snprintf(buf, size, cmd, type, flags);
 }
 
-int nft_event_header_fprintf(FILE *fp, uint32_t type, uint32_t flags)
+int nft_cmd_header_fprintf(FILE *fp, uint32_t cmd, uint32_t type,
+			   uint32_t flags)
 {
-	return nft_fprintf(fp, NULL, type, flags, nft_event_header_fprintf_cb);
+	return nft_fprintf(fp, NULL, cmd, type, flags,
+			   nft_cmd_header_fprintf_cb);
 }
 
-int nft_event_footer_snprintf(char *buf, size_t size, uint32_t type,
-			      uint32_t flags)
+int nft_cmd_footer_snprintf(char *buf, size_t size, uint32_t cmd, uint32_t type,
+			    uint32_t flags)
 {
-	if (!(flags & NFT_OF_EVENT_ANY))
+	NFT_BUF_INIT(b, buf, size);
+
+	if (cmd == NFT_CMD_UNSPEC)
 		return 0;
 
 	switch (type) {
 	case NFT_OUTPUT_XML:
-		return snprintf(buf, size, "</event>");
 	case NFT_OUTPUT_JSON:
-		return snprintf(buf, size, "}}}");
+		nft_buf_close_array(&b, type, nft_cmd2tag(cmd));
+		break;
 	default:
 		return 0;
 	}
+	return nft_buf_done(&b);
 }
 
-static int nft_event_footer_fprintf_cb(char *buf, size_t size, void *unused,
-				       uint32_t type, uint32_t flags)
+static int nft_cmd_footer_fprintf_cb(char *buf, size_t size, void *obj,
+				     uint32_t cmd, uint32_t type,
+				     uint32_t flags)
 {
-	return nft_event_footer_snprintf(buf, size, type, flags);
+	return nft_cmd_footer_snprintf(buf, size, cmd, type, flags);
 }
 
-int nft_event_footer_fprintf(FILE *fp, uint32_t type, uint32_t flags)
+int nft_cmd_footer_fprintf(FILE *fp, uint32_t cmd, uint32_t type,
+			   uint32_t flags)
 {
-	return nft_fprintf(fp, NULL, type, flags, nft_event_footer_fprintf_cb);
+	return nft_fprintf(fp, NULL, cmd, type, flags,
+			   nft_cmd_footer_fprintf_cb);
 }
 
 static void nft_batch_build_hdr(char *buf, uint16_t type, uint32_t seq)
diff --git a/src/gen.c b/src/gen.c
index 21d3a49..10a647a 100644
--- a/src/gen.c
+++ b/src/gen.c
@@ -161,12 +161,12 @@ static int nft_gen_snprintf_default(char *buf, size_t size, struct nft_gen *gen)
 	return snprintf(buf, size, "ruleset generation ID %u", gen->id);
 }
 
-int nft_gen_snprintf(char *buf, size_t size, struct nft_gen *gen,
-		       uint32_t type, uint32_t flags)
+static int nft_gen_cmd_snprintf(char *buf, size_t size, struct nft_gen *gen,
+				uint32_t cmd, uint32_t type, uint32_t flags)
 {
 	int ret, len = size, offset = 0;
 
-	ret = nft_event_header_snprintf(buf + offset, len, type, flags);
+	ret = nft_cmd_header_snprintf(buf + offset, len, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	switch(type) {
@@ -178,15 +178,23 @@ int nft_gen_snprintf(char *buf, size_t size, struct nft_gen *gen,
 	}
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = nft_event_footer_snprintf(buf + offset, len, type, flags);
+	ret = nft_cmd_footer_snprintf(buf + offset, len, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
 }
+
+int nft_gen_snprintf(char *buf, size_t size, struct nft_gen *gen, uint32_t type,
+		     uint32_t flags)
+{;
+	return nft_gen_cmd_snprintf(buf, size, gen, nft_flag2cmd(flags), type,
+				    flags);
+}
 EXPORT_SYMBOL(nft_gen_snprintf);
 
 static inline int nft_gen_do_snprintf(char *buf, size_t size, void *gen,
-				      uint32_t type, uint32_t flags)
+				      uint32_t cmd, uint32_t type,
+				      uint32_t flags)
 {
 	return nft_gen_snprintf(buf, size, gen, type, flags);
 }
@@ -194,6 +202,7 @@ static inline int nft_gen_do_snprintf(char *buf, size_t size, void *gen,
 int nft_gen_fprintf(FILE *fp, struct nft_gen *gen, uint32_t type,
 		    uint32_t flags)
 {
-	return nft_fprintf(fp, gen, type, flags, nft_gen_do_snprintf);
+	return nft_fprintf(fp, gen, NFT_CMD_UNSPEC, type, flags,
+			   nft_gen_do_snprintf);
 }
 EXPORT_SYMBOL(nft_gen_fprintf);
diff --git a/src/internal.h b/src/internal.h
index db9af11..431af11 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -147,15 +147,21 @@ int nft_strtoi(const char *string, int base, void *number, enum nft_type type);
 const char *nft_verdict2str(uint32_t verdict);
 int nft_str2verdict(const char *verdict, int *verdict_num);
 int nft_get_value(enum nft_type type, void *val, void *out);
+enum nft_cmd_type nft_flag2cmd(uint32_t flags);
+const char *nft_cmd2tag(enum nft_cmd_type cmd);
 
 #include <stdio.h>
-int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags, int (*snprintf_cb)(char *buf, size_t bufsiz, void *obj, uint32_t type, uint32_t flags));
-int nft_event_header_snprintf(char *buf, size_t bufsize,
-			      uint32_t format, uint32_t flags);
-int nft_event_header_fprintf(FILE *fp, uint32_t format, uint32_t flags);
-int nft_event_footer_snprintf(char *buf, size_t bufsize,
-			      uint32_t format, uint32_t flags);
-int nft_event_footer_fprintf(FILE *fp, uint32_t format, uint32_t flags);
+int nft_fprintf(FILE *fp, void *obj, uint32_t cmd, uint32_t type,
+		uint32_t flags, int (*snprintf_cb)(char *buf, size_t bufsiz,
+		void *obj, uint32_t cmd, uint32_t type, uint32_t flags));
+int nft_cmd_header_snprintf(char *buf, size_t bufsize, uint32_t cmd,
+			    uint32_t format, uint32_t flags);
+int nft_cmd_header_fprintf(FILE *fp, uint32_t cmd, uint32_t format,
+			   uint32_t flags);
+int nft_cmd_footer_snprintf(char *buf, size_t bufsize, uint32_t cmd,
+			    uint32_t format, uint32_t flags);
+int nft_cmd_footer_fprintf(FILE *fp, uint32_t cmd, uint32_t format,
+			   uint32_t flags);
 
 struct expr_ops;
 
diff --git a/src/rule.c b/src/rule.c
index ac5136c..7f4d049 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -963,15 +963,15 @@ static int nft_rule_snprintf_default(char *buf, size_t size, struct nft_rule *r,
 	return offset;
 }
 
-int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *r,
-		       uint32_t type, uint32_t flags)
+static int nft_rule_cmd_snprintf(char *buf, size_t size, struct nft_rule *r,
+				 uint32_t cmd, uint32_t type, uint32_t flags)
 {
 	int ret, len = size, offset = 0;
 	uint32_t inner_flags = flags;
 
 	inner_flags &= ~NFT_OF_EVENT_ANY;
 
-	ret = nft_event_header_snprintf(buf+offset, len, type, flags);
+	ret = nft_cmd_header_snprintf(buf + offset, len, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	switch(type) {
@@ -993,15 +993,23 @@ int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *r,
 
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = nft_event_footer_snprintf(buf+offset, len, type, flags);
+	ret = nft_cmd_footer_snprintf(buf + offset, len, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
 }
+
+int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *r,
+		      uint32_t type, uint32_t flags)
+{
+	return nft_rule_cmd_snprintf(buf, size, r, nft_flag2cmd(flags), type,
+				     flags);
+}
 EXPORT_SYMBOL(nft_rule_snprintf);
 
 static inline int nft_rule_do_snprintf(char *buf, size_t size, void *r,
-				       uint32_t type, uint32_t flags)
+				       uint32_t cmd, uint32_t type,
+				       uint32_t flags)
 {
 	return nft_rule_snprintf(buf, size, r, type, flags);
 }
@@ -1009,7 +1017,8 @@ static inline int nft_rule_do_snprintf(char *buf, size_t size, void *r,
 int nft_rule_fprintf(FILE *fp, struct nft_rule *r, uint32_t type,
 		     uint32_t flags)
 {
-	return nft_fprintf(fp, r, type, flags, nft_rule_do_snprintf);
+	return nft_fprintf(fp, r, NFT_CMD_UNSPEC, type, flags,
+			   nft_rule_do_snprintf);
 }
 EXPORT_SYMBOL(nft_rule_fprintf);
 
diff --git a/src/ruleset.c b/src/ruleset.c
index c29c307..d05f907 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -784,7 +784,7 @@ nft_ruleset_snprintf_rule(char *buf, size_t size,
 
 static int
 nft_ruleset_do_snprintf(char *buf, size_t size, const struct nft_ruleset *rs,
-			uint32_t type, uint32_t flags)
+			uint32_t cmd, uint32_t type, uint32_t flags)
 {
 	int ret, len = size, offset = 0;
 	void *prev = NULL;
@@ -793,10 +793,10 @@ nft_ruleset_do_snprintf(char *buf, size_t size, const struct nft_ruleset *rs,
 	/* dont pass events flags to child calls of _snprintf() */
 	inner_flags &= ~NFT_OF_EVENT_ANY;
 
-	ret = nft_event_header_snprintf(buf+offset, len, type, flags);
+	ret = snprintf(buf + offset, len, "%s", nft_ruleset_o_opentag(type));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = snprintf(buf+offset, len, "%s", nft_ruleset_o_opentag(type));
+	ret = nft_cmd_header_snprintf(buf + offset, len, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_TABLELIST) &&
@@ -848,15 +848,30 @@ nft_ruleset_do_snprintf(char *buf, size_t size, const struct nft_ruleset *rs,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	ret = snprintf(buf+offset, len, "%s", nft_ruleset_o_closetag(type));
+	ret = nft_cmd_footer_snprintf(buf + offset, len, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = nft_event_footer_snprintf(buf+offset, len, type, flags);
+	ret = snprintf(buf + offset, len, "%s", nft_ruleset_o_closetag(type));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
 }
 
+static int nft_ruleset_cmd_snprintf(char *buf, size_t size,
+				    const struct nft_ruleset *r, uint32_t cmd,
+				    uint32_t type, uint32_t flags)
+{
+	switch (type) {
+	case NFT_OUTPUT_DEFAULT:
+	case NFT_OUTPUT_XML:
+	case NFT_OUTPUT_JSON:
+		return nft_ruleset_do_snprintf(buf, size, r, cmd, type, flags);
+	default:
+		errno = EOPNOTSUPP;
+		return -1;
+	}
+}
+
 int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_ruleset *r,
 			 uint32_t type, uint32_t flags)
 {
@@ -864,7 +879,9 @@ int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_ruleset *r,
 	case NFT_OUTPUT_DEFAULT:
 	case NFT_OUTPUT_XML:
 	case NFT_OUTPUT_JSON:
-		return nft_ruleset_do_snprintf(buf, size, r, type, flags);
+		return nft_ruleset_cmd_snprintf(buf, size, r,
+						nft_flag2cmd(flags), type,
+						flags);
 	default:
 		errno = EOPNOTSUPP;
 		return -1;
@@ -1017,8 +1034,8 @@ err:
 		return -1;			\
 	len += ret;
 
-int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type,
-			uint32_t flags)
+static int nft_ruleset_cmd_fprintf(FILE *fp, const struct nft_ruleset *rs,
+				   uint32_t cmd, uint32_t type, uint32_t flags)
 {
 	int len = 0, ret = 0;
 	void *prev = NULL;
@@ -1027,10 +1044,10 @@ int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type,
 	/* dont pass events flags to child calls of _snprintf() */
 	inner_flags &= ~NFT_OF_EVENT_ANY;
 
-	ret = nft_event_header_fprintf(fp, type, flags);
+	ret = fprintf(fp, "%s", nft_ruleset_o_opentag(type));
 	NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 
-	ret = fprintf(fp, "%s", nft_ruleset_o_opentag(type));
+	ret = nft_cmd_header_fprintf(fp, cmd, type, flags);
 	NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 
 	if ((nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_TABLELIST)) &&
@@ -1075,12 +1092,19 @@ int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type,
 		NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 	}
 
-	ret = fprintf(fp, "%s", nft_ruleset_o_closetag(type));
+	ret = nft_cmd_footer_fprintf(fp, cmd, type, flags);
 	NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 
-	ret = nft_event_footer_fprintf(fp, type, flags);
+	ret = fprintf(fp, "%s", nft_ruleset_o_closetag(type));
 	NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
 
 	return len;
 }
+
+int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type,
+			uint32_t flags)
+{
+	return nft_ruleset_cmd_fprintf(fp, rs, nft_flag2cmd(flags), type,
+				       flags);
+}
 EXPORT_SYMBOL(nft_ruleset_fprintf);
diff --git a/src/set.c b/src/set.c
index 4fd786a..1c56e68 100644
--- a/src/set.c
+++ b/src/set.c
@@ -889,8 +889,8 @@ static int nft_set_snprintf_xml(char *buf, size_t size, struct nft_set *s,
 	return offset;
 }
 
-int nft_set_snprintf(char *buf, size_t size, struct nft_set *s,
-		     uint32_t type, uint32_t flags)
+static int nft_set_cmd_snprintf(char *buf, size_t size, struct nft_set *s,
+				uint32_t cmd, uint32_t type, uint32_t flags)
 {
 	int ret, len = size, offset = 0;
 	uint32_t inner_flags = flags;
@@ -898,7 +898,7 @@ int nft_set_snprintf(char *buf, size_t size, struct nft_set *s,
 	/* prevent set_elems to print as events */
 	inner_flags &= ~NFT_OF_EVENT_ANY;
 
-	ret = nft_event_header_snprintf(buf+offset, len, type, flags);
+	ret = nft_cmd_header_snprintf(buf + offset, len, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	switch(type) {
@@ -919,15 +919,23 @@ int nft_set_snprintf(char *buf, size_t size, struct nft_set *s,
 
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = nft_event_footer_snprintf(buf+offset, len, type, flags);
+	ret = nft_cmd_footer_snprintf(buf + offset, len, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
 }
+
+int nft_set_snprintf(char *buf, size_t size, struct nft_set *s,
+		     uint32_t type, uint32_t flags)
+{
+	return nft_set_cmd_snprintf(buf, size, s, nft_flag2cmd(flags), type,
+				    flags);
+}
 EXPORT_SYMBOL(nft_set_snprintf);
 
 static inline int nft_set_do_snprintf(char *buf, size_t size, void *s,
-				      uint32_t type, uint32_t flags)
+				      uint32_t cmd, uint32_t type,
+				      uint32_t flags)
 {
 	return nft_set_snprintf(buf, size, s, type, flags);
 }
@@ -935,7 +943,8 @@ static inline int nft_set_do_snprintf(char *buf, size_t size, void *s,
 int nft_set_fprintf(FILE *fp, struct nft_set *s, uint32_t type,
 		    uint32_t flags)
 {
-	return nft_fprintf(fp, s, type, flags, nft_set_do_snprintf);
+	return nft_fprintf(fp, s, NFT_CMD_UNSPEC, type, flags,
+			   nft_set_do_snprintf);
 }
 EXPORT_SYMBOL(nft_set_fprintf);
 
diff --git a/src/set_elem.c b/src/set_elem.c
index 4f52b1a..5794f3a 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -614,12 +614,13 @@ static int nft_set_elem_snprintf_xml(char *buf, size_t size,
 	return offset;
 }
 
-int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem *e,
-			   uint32_t type, uint32_t flags)
+static int nft_set_elem_cmd_snprintf(char *buf, size_t size,
+				     struct nft_set_elem *e, uint32_t cmd,
+				     uint32_t type, uint32_t flags)
 {
 	int ret, len = size, offset = 0;
 
-	ret = nft_event_header_snprintf(buf+offset, len, type, flags);
+	ret = nft_cmd_header_snprintf(buf + offset, len, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	switch(type) {
@@ -638,15 +639,23 @@ int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem *e,
 
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = nft_event_footer_snprintf(buf+offset, len, type, flags);
+	ret = nft_cmd_footer_snprintf(buf + offset, len, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
 }
+
+int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem *e,
+			      uint32_t type, uint32_t flags)
+{
+	return nft_set_elem_cmd_snprintf(buf, size, e, nft_flag2cmd(flags),
+					 type, flags);
+}
 EXPORT_SYMBOL(nft_set_elem_snprintf);
 
 static inline int nft_set_elem_do_snprintf(char *buf, size_t size, void *e,
-					   uint32_t type, uint32_t flags)
+					   uint32_t cmd, uint32_t type,
+					   uint32_t flags)
 {
 	return nft_set_elem_snprintf(buf, size, e, type, flags);
 }
@@ -654,7 +663,8 @@ static inline int nft_set_elem_do_snprintf(char *buf, size_t size, void *e,
 int nft_set_elem_fprintf(FILE *fp, struct nft_set_elem *se, uint32_t type,
 			 uint32_t flags)
 {
-	return nft_fprintf(fp, se, type, flags, nft_set_elem_do_snprintf);
+	return nft_fprintf(fp, se, NFT_CMD_UNSPEC, type, flags,
+			   nft_set_elem_do_snprintf);
 }
 EXPORT_SYMBOL(nft_set_elem_fprintf);
 
diff --git a/src/table.c b/src/table.c
index e947394..ab0a8ea 100644
--- a/src/table.c
+++ b/src/table.c
@@ -419,12 +419,12 @@ static int nft_table_snprintf_default(char *buf, size_t size, struct nft_table *
 			t->table_flags, t->use);
 }
 
-int nft_table_snprintf(char *buf, size_t size, struct nft_table *t,
-		       uint32_t type, uint32_t flags)
+static int nft_table_cmd_snprintf(char *buf, size_t size, struct nft_table *t,
+				  uint32_t cmd, uint32_t type, uint32_t flags)
 {
 	int ret, len = size, offset = 0;
 
-	ret = nft_event_header_snprintf(buf+offset, len, type, flags);
+	ret = nft_cmd_header_snprintf(buf + offset, len, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	switch (type) {
@@ -440,15 +440,23 @@ int nft_table_snprintf(char *buf, size_t size, struct nft_table *t,
 	}
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = nft_event_footer_snprintf(buf+offset, len, type, flags);
+	ret = nft_cmd_footer_snprintf(buf + offset, len, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
 }
+
+int nft_table_snprintf(char *buf, size_t size, struct nft_table *t,
+		       uint32_t type, uint32_t flags)
+{
+	return nft_table_cmd_snprintf(buf, size, t, nft_flag2cmd(flags), type,
+				      flags);
+}
 EXPORT_SYMBOL(nft_table_snprintf);
 
 static inline int nft_table_do_snprintf(char *buf, size_t size, void *t,
-					uint32_t type, uint32_t flags)
+					uint32_t cmd, uint32_t type,
+					uint32_t flags)
 {
 	return nft_table_snprintf(buf, size, t, type, flags);
 }
@@ -456,7 +464,8 @@ static inline int nft_table_do_snprintf(char *buf, size_t size, void *t,
 int nft_table_fprintf(FILE *fp, struct nft_table *t, uint32_t type,
 		      uint32_t flags)
 {
-	return nft_fprintf(fp, t, type, flags, nft_table_do_snprintf);
+	return nft_fprintf(fp, t, NFT_CMD_UNSPEC, type, flags,
+			   nft_table_do_snprintf);
 }
 EXPORT_SYMBOL(nft_table_fprintf);
 
diff --git a/src/utils.c b/src/utils.c
index 9013b68..7a6039b 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -16,6 +16,7 @@
 #include <arpa/inet.h>
 #include <errno.h>
 #include <inttypes.h>
+#include <buffer.h>
 
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
@@ -28,6 +29,14 @@ static const char *const nft_family_str[NFPROTO_NUMPROTO] = {
 	[NFPROTO_IPV6]		= "ip6",
 };
 
+const char *cmd2tag[NFT_CMD_MAX] = {
+	[NFT_CMD_ADD]			= ADD,
+	[NFT_CMD_INSERT]		= INSERT,
+	[NFT_CMD_DELETE]		= DELETE,
+	[NFT_CMD_REPLACE]		= REPLACE,
+	[NFT_CMD_FLUSH]			= FLUSH,
+};
+
 const char *nft_family2str(uint32_t family)
 {
 	if (nft_family_str[family] == NULL)
@@ -177,16 +186,34 @@ int nft_str2verdict(const char *verdict, int *verdict_num)
 	return -1;
 }
 
-int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags,
+enum nft_cmd_type nft_flag2cmd(uint32_t flags)
+{
+	if (flags & NFT_OF_EVENT_NEW)
+		return NFT_CMD_ADD;
+	else if (flags & NFT_OF_EVENT_DEL)
+		return NFT_CMD_DELETE;
+
+	return NFT_CMD_UNSPEC;
+}
+
+const char *nft_cmd2tag(enum nft_cmd_type cmd)
+{
+	if (cmd >= NFT_CMD_MAX)
+		return "unknown";
+
+	return cmd2tag[cmd];
+}
+
+int nft_fprintf(FILE *fp, void *obj, uint32_t cmd, uint32_t type, uint32_t flags,
 		int (*snprintf_cb)(char *buf, size_t bufsiz, void *obj,
-				   uint32_t type, uint32_t flags))
+				   uint32_t cmd, uint32_t type, uint32_t flags))
 {
 	char _buf[NFT_SNPRINTF_BUFSIZ];
 	char *buf = _buf;
 	size_t bufsiz = sizeof(_buf);
 	int ret;
 
-	ret = snprintf_cb(buf, bufsiz, obj, type, flags);
+	ret = snprintf_cb(buf, bufsiz, obj, cmd, type, flags);
 	if (ret <= 0)
 		goto out;
 
@@ -197,7 +224,7 @@ int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags,
 		if (buf == NULL)
 			return -1;
 
-		ret = snprintf_cb(buf, bufsiz, obj, type, flags);
+		ret = snprintf_cb(buf, bufsiz, obj, cmd, type, flags);
 		if (ret <= 0)
 			goto out;
 	}
-- 
1.7.10.4

