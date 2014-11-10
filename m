From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 2/3 v2] src: consolidate XML/JSON exportation
Date: Mon, 10 Nov 2014 14:26:18 +0100
Message-ID: <1415625979-29079-2-git-send-email-pablo@netfilter.org>
References: <1415625979-29079-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com, alvaroneay@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53251 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbaKJNYh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 08:24:37 -0500
In-Reply-To: <1415625979-29079-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add new buffer class to consolidate the existing code to export objects
in XML/JSON and use it. We save ~700 LOC with this change.

The rule and set objects are not yet consolidated. It seems this would
require some specific glue code per representation type since lists are
arranged differently.

This also consolidates the tag names, so we make sure the same are used
from XML and JSON by placing them in include/buffer.h.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/Makefile.am           |    3 +-
 include/buffer.h              |   80 +++++++++++++++++++
 src/Makefile.am               |    1 +
 src/buffer.c                  |  160 +++++++++++++++++++++++++++++++++++++
 src/chain.c                   |  174 ++++++++---------------------------------
 src/expr/bitwise.c            |  112 ++++----------------------
 src/expr/byteorder.c          |  101 +++++++-----------------
 src/expr/cmp.c                |   65 +++++----------
 src/expr/counter.c            |   48 +++---------
 src/expr/ct.c                 |   73 ++++-------------
 src/expr/exthdr.c             |   75 ++++--------------
 src/expr/immediate.c          |   71 ++++-------------
 src/expr/limit.c              |   50 +++---------
 src/expr/log.c                |   98 +++++------------------
 src/expr/lookup.c             |   56 +++----------
 src/expr/masq.c               |   33 ++------
 src/expr/match.c              |   35 +++------
 src/expr/meta.c               |   64 +++------------
 src/expr/nat.c                |  102 ++++++------------------
 src/expr/payload.c            |   69 ++++------------
 src/expr/queue.c              |   65 +++------------
 src/expr/redir.c              |   64 +++------------
 src/expr/reject.c             |   51 +++---------
 src/expr/target.c             |   35 +++------
 src/table.c                   |   86 ++++----------------
 tests/jsonfiles/11-chain.json |    2 +-
 tests/jsonfiles/12-chain.json |    2 +-
 tests/jsonfiles/13-chain.json |    2 +-
 tests/xmlfiles/10-chain.xml   |    2 +-
 tests/xmlfiles/11-chain.xml   |    2 +-
 tests/xmlfiles/12-chain.xml   |    2 +-
 31 files changed, 573 insertions(+), 1210 deletions(-)
 create mode 100644 include/buffer.h
 create mode 100644 src/buffer.c

diff --git a/include/Makefile.am b/include/Makefile.am
index 5976bbd..102d5ab 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -1,3 +1,4 @@
 SUBDIRS = libnftnl linux
 
-noinst_HEADERS = linux_list.h
+noinst_HEADERS = linux_list.h	\
+		 buffer.h
diff --git a/include/buffer.h b/include/buffer.h
new file mode 100644
index 0000000..2b497f2
--- /dev/null
+++ b/include/buffer.h
@@ -0,0 +1,80 @@
+#ifndef _NFT_BUFFER_H_
+#define _NFT_BUFFER_H_
+
+#include <stdint.h>
+#include <stdbool.h>
+
+struct nft_buf {
+	char		*buf;
+	size_t		size;
+	size_t		len;
+	uint32_t	off;
+	bool		fail;
+};
+
+#define NFT_BUF_INIT(__b, __buf, __len)			\
+	struct nft_buf __b = {				\
+		.buf	= __buf,			\
+		.len	= __len,			\
+	};
+
+int nft_buf_update(struct nft_buf *b, int ret);
+int nft_buf_done(struct nft_buf *b);
+
+union nft_data_reg;
+
+int nft_buf_open(struct nft_buf *b, int type, const char *tag);
+int nft_buf_close(struct nft_buf *b, int type, const char *tag);
+
+int nft_buf_u32(struct nft_buf *b, int type, uint32_t value, const char *tag);
+int nft_buf_s32(struct nft_buf *b, int type, uint32_t value, const char *tag);
+int nft_buf_u64(struct nft_buf *b, int type, uint64_t value, const char *tag);
+int nft_buf_str(struct nft_buf *b, int type, const char *str, const char *tag);
+int nft_buf_reg(struct nft_buf *b, int type, union nft_data_reg *reg,
+		int reg_type, const char *tag);
+
+#define BASE			"base"
+#define BYTES			"bytes"
+#define CHAIN			"chain"
+#define CODE			"code"
+#define DATA			"data"
+#define DIR			"dir"
+#define DREG			"dreg"
+#define EXTHDR_TYPE		"exthdr_type"
+#define FAMILY			"family"
+#define FLAGS			"flags"
+#define GROUP			"group"
+#define HANDLE			"handle"
+#define HOOKNUM			"hooknum"
+#define KEY			"key"
+#define LEN			"len"
+#define LEVEL			"level"
+#define MASK			"mask"
+#define NAT_TYPE		"nat_type"
+#define NAME			"name"
+#define NUM			"num"
+#define OFFSET			"offset"
+#define OP			"op"
+#define PACKETS			"packets"
+#define PKTS			"pkts"
+#define POLICY			"policy"
+#define PREFIX			"prefix"
+#define PRIO			"prio"
+#define QTHRESH			"qthreshold"
+#define RATE			"rate"
+#define SET			"set"
+#define SIZE			"size"
+#define SNAPLEN			"snaplen"
+#define SREG_ADDR_MAX		"sreg_addr_max"
+#define SREG_ADDR_MIN		"sreg_addr_min"
+#define SREG_PROTO_MAX		"sreg_proto_max"
+#define SREG_PROTO_MIN		"sreg_proto_min"
+#define SREG			"sreg"
+#define TABLE			"table"
+#define TOTAL			"total"
+#define TYPE			"type"
+#define UNIT			"unit"
+#define USE			"use"
+#define XOR			"xor"
+
+#endif
diff --git a/src/Makefile.am b/src/Makefile.am
index 941e69e..c77c3cc 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -6,6 +6,7 @@ libnftnl_la_LDFLAGS = -Wl,--version-script=$(srcdir)/libnftnl.map	\
 		      -version-info $(LIBVERSION)
 
 libnftnl_la_SOURCES = utils.c		\
+		      buffer.c		\
 		      common.c		\
 		      gen.c		\
 		      table.c		\
diff --git a/src/buffer.c b/src/buffer.c
new file mode 100644
index 0000000..4fac110
--- /dev/null
+++ b/src/buffer.c
@@ -0,0 +1,160 @@
+/*
+ * (C) 2012-2014 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <stdio.h>
+#include <stdint.h>
+#include <inttypes.h>
+#include <string.h>
+#include <buffer.h>
+#include <libnftnl/common.h>
+#include "internal.h"
+
+int nft_buf_update(struct nft_buf *b, int ret)
+{
+	if (ret < 0) {
+		b->fail = true;
+	} else {
+		b->off += ret;
+		if (ret > b->len)
+			ret = b->len;
+		b->size += ret;
+		b->len -= ret;
+	}
+
+	return ret;
+}
+
+int nft_buf_done(struct nft_buf *b)
+{
+	if (b->fail)
+		return -1;
+
+	/* Remove trailing comma in json */
+	if (b->size > 0 && b->buf[b->size - 1] == ',') {
+		b->off--;
+		b->size--;
+		b->len++;
+	}
+
+	return b->off;
+}
+
+static int nft_buf_put(struct nft_buf *b, const char *fmt, ...)
+{
+	int ret;
+	va_list ap;
+
+	va_start(ap, fmt);
+	ret = vsnprintf(b->buf + b->off, b->len, fmt, ap);
+	ret = nft_buf_update(b, ret);
+	va_end(ap);
+
+	return ret;
+}
+
+int nft_buf_open(struct nft_buf *b, int type, const char *tag)
+{
+	switch (type) {
+	case NFT_OUTPUT_XML:
+		return nft_buf_put(b, "<%s>", tag);
+	case NFT_OUTPUT_JSON:
+		return nft_buf_put(b, "{\"%s\":{", tag);
+	default:
+		return 0;
+	}
+}
+
+int nft_buf_close(struct nft_buf *b, int type, const char *tag)
+{
+	switch (type) {
+	case NFT_OUTPUT_XML:
+		return nft_buf_put(b, "</%s>");
+	case NFT_OUTPUT_JSON:
+		/* Remove trailing comma in json */
+		if (b->size > 0 && b->buf[b->size - 1] == ',') {
+			b->off--;
+			b->size--;
+			b->len++;
+		}
+
+		return nft_buf_put(b, "}}");
+	default:
+		return 0;
+	}
+}
+
+int nft_buf_u32(struct nft_buf *b, int type, uint32_t value, const char *tag)
+{
+	switch (type) {
+	case NFT_OUTPUT_XML:
+		return nft_buf_put(b, "<%s>%u</%s>", tag, value, tag);
+	case NFT_OUTPUT_JSON:
+		return nft_buf_put(b, "\"%s\":%u,", tag, value);
+	default:
+		return 0;
+	}
+}
+
+int nft_buf_s32(struct nft_buf *b, int type, uint32_t value, const char *tag)
+{
+	switch (type) {
+	case NFT_OUTPUT_XML:
+		return nft_buf_put(b, "<%s>%d</%s>", tag, value, tag);
+	case NFT_OUTPUT_JSON:
+		return nft_buf_put(b, "\"%s\":%d,", tag, value);
+	default:
+		return 0;
+	}
+}
+
+int nft_buf_u64(struct nft_buf *b, int type, uint64_t value, const char *tag)
+{
+	switch (type) {
+	case NFT_OUTPUT_XML:
+		return nft_buf_put(b, "<%s>%"PRIu64"</%s>", tag, value, tag);
+	case NFT_OUTPUT_JSON:
+		return nft_buf_put(b, "\"%s\":%"PRIu64",", tag, value);
+	default:
+		return 0;
+	}
+}
+
+int nft_buf_str(struct nft_buf *b, int type, const char *str, const char *tag)
+{
+	switch (type) {
+	case NFT_OUTPUT_XML:
+		return nft_buf_put(b, "<%s>%s</%s>", tag, str, tag);
+	case NFT_OUTPUT_JSON:
+		return nft_buf_put(b, "\"%s\":\"%s\",", tag, str);
+	default:
+		return 0;
+	}
+}
+
+int nft_buf_reg(struct nft_buf *b, int type, union nft_data_reg *reg,
+		int reg_type, const char *tag)
+{
+	int ret;
+
+	switch (type) {
+	case NFT_OUTPUT_XML:
+		ret = nft_buf_put(b, "<%s>", tag);
+		ret = nft_data_reg_snprintf(b->buf + b->off, b->len, reg,
+                                    NFT_OUTPUT_XML, 0, reg_type);
+		nft_buf_update(b, ret);
+		return nft_buf_put(b, "</%s>", tag);
+	case NFT_OUTPUT_JSON:
+		nft_buf_put(b, "\"%s\":{", tag);
+		ret = nft_data_reg_snprintf(b->buf + b->off, b->len, reg,
+					    NFT_OUTPUT_JSON, 0, reg_type);
+		nft_buf_update(b, ret);
+		return nft_buf_put(b, "},");
+	}
+	return 0;
+}
diff --git a/src/chain.c b/src/chain.c
index a056bab..b67385e 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -27,6 +27,7 @@
 #include <linux/netfilter_arp.h>
 
 #include <libnftnl/chain.h>
+#include <buffer.h>
 
 struct nft_chain {
 	struct list_head head;
@@ -787,150 +788,41 @@ int nft_chain_parse_file(struct nft_chain *c, enum nft_parse_type type,
 }
 EXPORT_SYMBOL(nft_chain_parse_file);
 
-static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_chain *c)
+static int nft_chain_export(char *buf, size_t size, struct nft_chain *c,
+			    int type)
 {
-	int ret, len = size, offset = 0;
-
-	ret = snprintf(buf, len, "{\"chain\":{");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	ret = 0;
-
-	if (c->flags & (1 << NFT_CHAIN_ATTR_NAME)) {
-		ret = snprintf(buf + offset, len, "\"name\":\"%s\",", c->name);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (c->flags & (1 << NFT_CHAIN_ATTR_HANDLE)) {
-		ret = snprintf(buf + offset, len, "\"handle\":%"PRIu64",",
-			       c->handle);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (c->flags & (1 << NFT_CHAIN_ATTR_BYTES)) {
-		ret = snprintf(buf + offset, len, "\"bytes\":%"PRIu64",",
-			       c->bytes);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (c->flags & (1 << NFT_CHAIN_ATTR_PACKETS)) {
-		ret = snprintf(buf + offset, len, "\"packets\":%"PRIu64",",
-			       c->packets);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (c->flags & (1 << NFT_CHAIN_ATTR_FAMILY)) {
-		ret = snprintf(buf + offset, len, "\"family\":\"%s\",",
-			       nft_family2str(c->family));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (c->flags & (1 << NFT_CHAIN_ATTR_FAMILY)) {
-		ret = snprintf(buf + offset, len, "\"table\":\"%s\",",
-			       c->table);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (c->flags & (1 << NFT_CHAIN_ATTR_USE)) {
-		ret = snprintf(buf + offset, len, "\"use\":%d,", c->use);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (c->flags & (1 << NFT_CHAIN_ATTR_HOOKNUM)) {
-		if (c->flags & (1 << NFT_CHAIN_ATTR_TYPE)) {
-			ret = snprintf(buf + offset, len, "\"type\":\"%s\",",
-				       c->type);
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-		}
+	NFT_BUF_INIT(b, buf, size);
 
-		ret = snprintf(buf + offset, len, "\"hooknum\":\"%s\",",
-			       nft_hooknum2str(c->family, c->hooknum));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		if (c->flags & (1 << NFT_CHAIN_ATTR_PRIO)) {
-			ret = snprintf(buf + offset, len, "\"prio\":%d,",
-				       c->prio);
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-		}
-		if (c->flags & (1 << NFT_CHAIN_ATTR_POLICY)) {
-			ret = snprintf(buf + offset, len, "\"policy\":\"%s\",",
-				       nft_verdict2str(c->policy));
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-		}
-	}
-
-	/* If ret is not 0, some values are printed. So, It's necessary to
-	 * delete the last comma character
-	 */
-	if (ret > 0)
-		offset--;
-
-	ret = snprintf(buf + offset, len, "}}");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	return offset;
-}
-
-static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
-{
-	int ret, len = size, offset = 0;
-
-	ret = snprintf(buf, len, "<chain>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	if (c->flags & (1 << NFT_CHAIN_ATTR_NAME)) {
-		ret = snprintf(buf + offset, len, "<name>%s</name>", c->name);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (c->flags & (1 << NFT_CHAIN_ATTR_HANDLE)) {
-		ret = snprintf(buf + offset, len, "<handle>%"PRIu64"</handle>",
-			       c->handle);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (c->flags & (1 << NFT_CHAIN_ATTR_BYTES)) {
-		ret = snprintf(buf + offset, len, "<bytes>%"PRIu64"</bytes>",
-			       c->bytes);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (c->flags & (1 << NFT_CHAIN_ATTR_PACKETS)) {
-		ret = snprintf(buf + offset, len, "<packets>%"PRIu64"</packets>",
-			       c->packets);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (c->flags & (1 << NFT_CHAIN_ATTR_TABLE)) {
-		ret = snprintf(buf + offset, len, "<table>%s</table>",
-			       c->table);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (c->flags & (1 << NFT_CHAIN_ATTR_USE)) {
-		ret = snprintf(buf + offset, len, "<use>%u</use>", c->use);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
+	nft_buf_open(&b, type, CHAIN);
+	if (c->flags & (1 << NFT_CHAIN_ATTR_NAME))
+		nft_buf_str(&b, type, c->name, NAME);
+	if (c->flags & (1 << NFT_CHAIN_ATTR_HANDLE))
+		nft_buf_u64(&b, type, c->handle, HANDLE);
+	if (c->flags & (1 << NFT_CHAIN_ATTR_BYTES))
+		nft_buf_u64(&b, type, c->bytes, BYTES);
+	if (c->flags & (1 << NFT_CHAIN_ATTR_PACKETS))
+		nft_buf_u64(&b, type, c->packets, PACKETS);
+	if (c->flags & (1 << NFT_CHAIN_ATTR_TABLE))
+		nft_buf_str(&b, type, c->table, TABLE);
+	if (c->flags & (1 << NFT_CHAIN_ATTR_FAMILY))
+		nft_buf_str(&b, type, nft_family2str(c->family), FAMILY);
+	if (c->flags & (1 << NFT_CHAIN_ATTR_USE))
+		nft_buf_u32(&b, type, c->use, USE);
 	if (c->flags & (1 << NFT_CHAIN_ATTR_HOOKNUM)) {
-		if (c->flags & (1 << NFT_CHAIN_ATTR_TYPE)) {
-			ret = snprintf(buf + offset, len, "<type>%s</type>",
-				       c->type);
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-		}
-
-		ret = snprintf(buf + offset, len, "<hooknum>%s</hooknum>",
-			       nft_hooknum2str(c->family, c->hooknum));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		if (c->flags & (1 << NFT_CHAIN_ATTR_PRIO)) {
-			ret = snprintf(buf + offset, len, "<prio>%d</prio>",
-				       c->prio);
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-		}
-		if (c->flags & (1 << NFT_CHAIN_ATTR_POLICY)) {
-			ret = snprintf(buf + offset, len, "<policy>%s</policy>",
-				       nft_verdict2str(c->policy));
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-		}
-	}
-	if (c->flags & (1 << NFT_CHAIN_ATTR_FAMILY)) {
-		ret = snprintf(buf + offset, len, "<family>%s</family>",
-			       nft_family2str(c->family));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		if (c->flags & (1 << NFT_CHAIN_ATTR_TYPE))
+			nft_buf_str(&b, type, c->type, TYPE);
+		if (c->flags & (1 << NFT_CHAIN_ATTR_HOOKNUM))
+			nft_buf_str(&b, type, nft_hooknum2str(c->family,
+					 c->hooknum), HOOKNUM);
+		if (c->flags & (1 << NFT_CHAIN_ATTR_PRIO))
+			nft_buf_s32(&b, type, c->prio, PRIO);
+		if (c->flags & (1 << NFT_CHAIN_ATTR_POLICY))
+			nft_buf_str(&b, type, nft_verdict2str(c->policy), POLICY);
 	}
 
-	ret = snprintf(buf + offset, len, "</chain>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	nft_buf_close(&b, type, CHAIN);
 
-	return offset;
+	return nft_buf_done(&b);
 }
 
 static int nft_chain_snprintf_default(char *buf, size_t size,
@@ -963,15 +855,13 @@ int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *c,
 	ret = nft_event_header_snprintf(buf+offset, len, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	switch(type) {
+	switch (type) {
 	case NFT_OUTPUT_DEFAULT:
 		ret = nft_chain_snprintf_default(buf+offset, len, c);
 		break;
 	case NFT_OUTPUT_XML:
-		ret = nft_chain_snprintf_xml(buf+offset, len, c);
-		break;
 	case NFT_OUTPUT_JSON:
-		ret = nft_chain_snprintf_json(buf+offset, len, c);
+		ret = nft_chain_export(buf+offset, len, c, type);
 		break;
 	default:
 		return -1;
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index b575c7a..a299cd4 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -22,6 +22,7 @@
 #include <libnftnl/rule.h>
 #include "data_reg.h"
 #include "expr_ops.h"
+#include <buffer.h>
 
 struct nft_expr_bitwise {
 	enum nft_registers	sreg;
@@ -252,102 +253,24 @@ nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 #endif
 }
 
-static int nft_rule_expr_bitwise_snprintf_json(char *buf, size_t size,
-					       struct nft_rule_expr *e)
-{
-	int len = size, offset = 0, ret;
-	struct nft_expr_bitwise *bitwise = nft_expr_data(e);
-
-	if (e->flags & (1 << NFT_EXPR_BITWISE_SREG)) {
-		ret = snprintf(buf + offset, len, "\"sreg\":%u,",
-			       bitwise->sreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_BITWISE_DREG)) {
-		ret = snprintf(buf + offset, len, "\"dreg\":%u,",
-			       bitwise->dreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_BITWISE_LEN)) {
-		ret = snprintf(buf + offset, len, "\"len\":%u,",
-			       bitwise->len);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_BITWISE_MASK)) {
-		ret = snprintf(buf + offset, len, "\"mask\":{");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		ret = nft_data_reg_snprintf(buf+offset, len, &bitwise->mask,
-					    NFT_OUTPUT_JSON, 0, DATA_VALUE);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		ret = snprintf(buf + offset, len, "},");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	}
-	if (e->flags & (1 << NFT_EXPR_BITWISE_XOR)) {
-		ret = snprintf(buf+offset, len, "\"xor\":{");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		ret = nft_data_reg_snprintf(buf+offset, len, &bitwise->xor,
-					    NFT_OUTPUT_JSON, 0, DATA_VALUE);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		ret = snprintf(buf+offset, len, "},");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (offset > 0)
-		offset--;
-
-	return offset;
-}
-
-static int nft_rule_expr_bitwise_snprintf_xml(char *buf, size_t size,
-					      struct nft_rule_expr *e)
+static int nft_rule_expr_bitwise_export(char *buf, size_t size,
+					struct nft_rule_expr *e, int type)
 {
 	struct nft_expr_bitwise *bitwise = nft_expr_data(e);
-	int len = size, offset = 0, ret;
-
-	if (e->flags & (1 << NFT_EXPR_BITWISE_SREG)) {
-		ret = snprintf(buf + offset, len, "<sreg>%u</sreg>",
-			       bitwise->sreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_BITWISE_DREG)) {
-		ret = snprintf(buf + offset, len, "<dreg>%u</dreg>",
-			       bitwise->dreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_BITWISE_LEN)) {
-		ret = snprintf(buf + offset, len, "<len>%u</len>",
-			       bitwise->len);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_BITWISE_MASK)) {
-		ret = snprintf(buf + offset, len, "<mask>");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	NFT_BUF_INIT(b, buf, size);
 
-		ret = nft_data_reg_snprintf(buf + offset, len, &bitwise->mask,
-					    NFT_OUTPUT_XML, 0, DATA_VALUE);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		ret = snprintf(buf + offset, len, "</mask>");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_BITWISE_XOR)) {
-		ret = snprintf(buf + offset, len, "<xor>");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		ret = nft_data_reg_snprintf(buf + offset, len, &bitwise->xor,
-					    NFT_OUTPUT_XML, 0, DATA_VALUE);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		ret = snprintf(buf + offset, len, "</xor>");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
+	if (e->flags & (1 << NFT_EXPR_BITWISE_SREG))
+		nft_buf_u32(&b, type, bitwise->sreg, SREG);
+	if (e->flags & (1 << NFT_EXPR_BITWISE_DREG))
+		nft_buf_u32(&b, type, bitwise->dreg, DREG);
+	if (e->flags & (1 << NFT_EXPR_BITWISE_LEN))
+		nft_buf_u32(&b, type, bitwise->len, LEN);
+	if (e->flags & (1 << NFT_EXPR_BITWISE_MASK))
+		nft_buf_reg(&b, type, &bitwise->mask, DATA_VALUE, MASK);
+	if (e->flags & (1 << NFT_EXPR_BITWISE_XOR))
+		nft_buf_reg(&b, type, &bitwise->xor, DATA_VALUE, XOR);
 
-	return offset;
+	return nft_buf_done(&b);
 }
 
 static int nft_rule_expr_bitwise_snprintf_default(char *buf, size_t size,
@@ -378,13 +301,12 @@ static int
 nft_rule_expr_bitwise_snprintf(char *buf, size_t size, uint32_t type,
 			       uint32_t flags, struct nft_rule_expr *e)
 {
-	switch(type) {
+	switch (type) {
 	case NFT_OUTPUT_DEFAULT:
 		return nft_rule_expr_bitwise_snprintf_default(buf, size, e);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_bitwise_snprintf_xml(buf, size, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_bitwise_snprintf_json(buf, size, e);
+		return nft_rule_expr_bitwise_export(buf, size, e, type);
 	default:
 		break;
 	}
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index ad28bc4..77680d2 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -22,6 +22,7 @@
 #include <libnftnl/rule.h>
 #include "data_reg.h"
 #include "expr_ops.h"
+#include <buffer.h>
 
 struct nft_expr_byteorder {
 	enum nft_registers	sreg;
@@ -179,6 +180,14 @@ static char *expr_byteorder_str[] = {
 	[NFT_BYTEORDER_NTOH] = "ntoh",
 };
 
+static const char *bo2str(uint32_t type)
+{
+	if (type > NFT_BYTEORDER_HTON)
+		return "unknown";
+
+	return expr_byteorder_str[type];
+}
+
 static inline int nft_str2ntoh(const char *op)
 {
 	if (strcmp(op, "ntoh") == 0)
@@ -270,77 +279,24 @@ nft_rule_expr_byteorder_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 #endif
 }
 
-static int nft_rule_expr_byteorder_snprintf_json(char *buf, size_t size,
-						 struct nft_rule_expr *e)
-{
-	struct nft_expr_byteorder *byteorder = nft_expr_data(e);
-	int len = size, offset = 0, ret;
-
-	if (e->flags & (1 << NFT_EXPR_BYTEORDER_SREG)) {
-		ret = snprintf(buf + offset, len, "\"sreg\":%u,",
-			       byteorder->sreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_BYTEORDER_DREG)) {
-		ret = snprintf(buf + offset, len, "\"dreg\":%u,",
-			       byteorder->dreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_BYTEORDER_OP)) {
-		ret = snprintf(buf + offset, len, "\"op\":\"%s\",",
-			       expr_byteorder_str[byteorder->op]);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_BYTEORDER_LEN)) {
-		ret = snprintf(buf + offset, len, "\"len\":%u,",
-			       byteorder->len);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_BYTEORDER_SIZE)) {
-		ret = snprintf(buf + offset, len, "\"size\":%u,",
-			       byteorder->size);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (offset > 0)
-		offset--;
-
-	return offset;
-}
-
-static int nft_rule_expr_byteorder_snprintf_xml(char *buf, size_t size,
-						struct nft_rule_expr *e)
+static int nft_rule_expr_byteorder_export(char *buf, size_t size,
+					  struct nft_rule_expr *e, int type)
 {
 	struct nft_expr_byteorder *byteorder = nft_expr_data(e);
-	int len = size, offset = 0, ret;
-
-	if (e->flags & (1 << NFT_EXPR_BYTEORDER_SREG)) {
-		ret = snprintf(buf + offset, len, "<sreg>%u</sreg>",
-			       byteorder->sreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_BYTEORDER_DREG)) {
-		ret = snprintf(buf + offset, len, "<dreg>%u</dreg>",
-			       byteorder->dreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_BYTEORDER_OP)) {
-		ret = snprintf(buf + offset, len, "<op>%s</op>",
-			       expr_byteorder_str[byteorder->op]);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_BYTEORDER_LEN)) {
-		ret = snprintf(buf + offset, len, "<len>%u</len>",
-			       byteorder->len);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_BYTEORDER_SIZE)) {
-		ret = snprintf(buf + offset, len, "<size>%u</size>",
-			       byteorder->size);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	return offset;
+	NFT_BUF_INIT(b, buf, size);
+
+	if (e->flags & (1 << NFT_EXPR_BYTEORDER_SREG))
+		nft_buf_u32(&b, type, byteorder->sreg, SREG);
+	if (e->flags & (1 << NFT_EXPR_BYTEORDER_DREG))
+		nft_buf_u32(&b, type, byteorder->dreg, DREG);
+	if (e->flags & (1 << NFT_EXPR_BYTEORDER_OP))
+		nft_buf_str(&b, type, bo2str(byteorder->op), OP);
+	if (e->flags & (1 << NFT_EXPR_BYTEORDER_LEN))
+		nft_buf_u32(&b, type, byteorder->len, LEN);
+	if (e->flags & (1 << NFT_EXPR_BYTEORDER_SIZE))
+		nft_buf_u32(&b, type, byteorder->size, SIZE);
+
+	return nft_buf_done(&b);
 }
 
 static int nft_rule_expr_byteorder_snprintf_default(char *buf, size_t size,
@@ -350,7 +306,7 @@ static int nft_rule_expr_byteorder_snprintf_default(char *buf, size_t size,
 	int len = size, offset = 0, ret;
 
 	ret = snprintf(buf, len, "reg %u = %s(reg %u, %u, %u) ",
-		       byteorder->dreg, expr_byteorder_str[byteorder->op],
+		       byteorder->dreg, bo2str(byteorder->op),
 		       byteorder->sreg, byteorder->size, byteorder->len);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
@@ -361,13 +317,12 @@ static int
 nft_rule_expr_byteorder_snprintf(char *buf, size_t size, uint32_t type,
 				 uint32_t flags, struct nft_rule_expr *e)
 {
-	switch(type) {
+	switch (type) {
 	case NFT_OUTPUT_DEFAULT:
 		return nft_rule_expr_byteorder_snprintf_default(buf, size, e);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_byteorder_snprintf_xml(buf, size, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_byteorder_snprintf_json(buf, size, e);
+		return nft_rule_expr_byteorder_export(buf, size, e, type);
 	default:
 		break;
 	}
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 6ecab7d..b186df0 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -23,6 +23,7 @@
 #include <libnftnl/rule.h>
 #include "expr_ops.h"
 #include "data_reg.h"
+#include <buffer.h>
 
 struct nft_expr_cmp {
 	union nft_data_reg	data;
@@ -150,6 +151,14 @@ static char *expr_cmp_str[] = {
 	[NFT_CMP_GTE]	= "gte",
 };
 
+static const char *cmp2str(uint32_t op)
+{
+	if (op > NFT_CMP_GTE)
+		return "unknown";
+
+	return expr_cmp_str[op];
+}
+
 static inline int nft_str2cmp(const char *op)
 {
 	if (strcmp(op, "eq") == 0)
@@ -238,51 +247,20 @@ static int nft_rule_expr_cmp_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 #endif
 }
 
-static int nft_rule_expr_cmp_snprintf_json(char *buf, size_t size,
-					   struct nft_rule_expr *e)
+static int nft_rule_expr_cmp_export(char *buf, size_t size,
+				    struct nft_rule_expr *e, int type)
 {
 	struct nft_expr_cmp *cmp = nft_expr_data(e);
-	int len = size, offset = 0, ret;
+	NFT_BUF_INIT(b, buf, size);
 
-	if (e->flags & (1 << NFT_EXPR_CMP_SREG)) {
-		ret = snprintf(buf + offset, len, "\"sreg\":%u,", cmp->sreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_CMP_OP)) {
-		ret = snprintf(buf + offset, len, "\"op\":\"%s\",",
-			       expr_cmp_str[cmp->op]);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	ret = nft_data_reg_snprintf(buf + offset, len, &cmp->data,
-				    NFT_OUTPUT_JSON, 0, DATA_VALUE);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	return offset;
-}
-
-static int nft_rule_expr_cmp_snprintf_xml(char *buf, size_t size,
-					  struct nft_rule_expr *e)
-{
-	struct nft_expr_cmp *cmp = nft_expr_data(e);
-	int len = size, offset = 0, ret;
-
-	if (e->flags & (1 << NFT_EXPR_CMP_SREG)) {
-		ret = snprintf(buf, len, "<sreg>%u</sreg>",
-			       cmp->sreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (e->flags & (1 << NFT_EXPR_CMP_SREG)) {
-		ret = snprintf(buf + offset, len, "<op>%s</op>",
-			       expr_cmp_str[cmp->op]);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	ret = nft_data_reg_snprintf(buf + offset, len, &cmp->data,
-				    NFT_OUTPUT_XML, 0, DATA_VALUE);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFT_EXPR_CMP_SREG))
+		nft_buf_u32(&b, type, cmp->sreg, SREG);
+	if (e->flags & (1 << NFT_EXPR_CMP_OP))
+		nft_buf_str(&b, type, cmp2str(cmp->op), OP);
+	if (e->flags & (1 << NFT_EXPR_CMP_DATA))
+		nft_buf_reg(&b, type, &cmp->data, DATA_VALUE, DATA);
 
-	return offset;
+	return nft_buf_done(&b);
 }
 
 static int nft_rule_expr_cmp_snprintf_default(char *buf, size_t size,
@@ -306,13 +284,12 @@ static int
 nft_rule_expr_cmp_snprintf(char *buf, size_t size, uint32_t type,
 			   uint32_t flags, struct nft_rule_expr *e)
 {
-	switch(type) {
+	switch (type) {
 	case NFT_OUTPUT_DEFAULT:
 		return nft_rule_expr_cmp_snprintf_default(buf, size, e);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_cmp_snprintf_xml(buf, size, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_cmp_snprintf_json(buf, size, e);
+		return nft_rule_expr_cmp_export(buf, size, e, type);
 	default:
 		break;
 	}
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 82d1939..e9abc5b 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -22,6 +22,7 @@
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
 #include "expr_ops.h"
+#include <buffer.h>
 
 struct nft_expr_counter {
 	uint64_t	pkts;
@@ -159,45 +160,19 @@ nft_rule_expr_counter_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 	return -1;
 #endif
 }
-static int nft_rule_expr_counter_snprintf_json(char *buf, size_t len,
-					       struct nft_rule_expr *e)
-{
-	int ret, size = len, offset = 0;
-	struct nft_expr_counter *ctr = nft_expr_data(e);
 
-	if (e->flags & (1 << NFT_EXPR_CTR_PACKETS)) {
-		ret = snprintf(buf, len,"\"pkts\":%"PRIu64",", ctr->pkts);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_CTR_BYTES)) {
-		ret = snprintf(buf + offset, len, "\"bytes\":%"PRIu64",", ctr->bytes);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	/* Remove the last comma characther */
-	if (offset > 0)
-		offset--;
-
-	return offset;
-}
-
-static int nft_rule_expr_counter_snprintf_xml(char *buf, size_t len,
-					      struct nft_rule_expr *e)
+static int nft_rule_expr_counter_export(char *buf, size_t size,
+					struct nft_rule_expr *e, int type)
 {
-	int ret, size = len, offset = 0;
 	struct nft_expr_counter *ctr = nft_expr_data(e);
+	NFT_BUF_INIT(b, buf, size);
 
-	if (e->flags & (1 << NFT_EXPR_CTR_PACKETS)) {
-		ret = snprintf(buf, len, "<pkts>%"PRIu64"</pkts>", ctr->pkts);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_CTR_BYTES)) {
-		ret = snprintf(buf + offset, len, "<bytes>%"PRIu64"</bytes>",
-			       ctr->bytes);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
+	if (e->flags & (1 << NFT_EXPR_CTR_PACKETS))
+		nft_buf_u64(&b, type, ctr->pkts, PKTS);
+	if (e->flags & (1 << NFT_EXPR_CTR_BYTES))
+		nft_buf_u64(&b, type, ctr->bytes, BYTES);
 
-	return offset;
+	return nft_buf_done(&b);
 }
 
 static int nft_rule_expr_counter_snprintf_default(char *buf, size_t len,
@@ -213,13 +188,12 @@ static int nft_rule_expr_counter_snprintf(char *buf, size_t len, uint32_t type,
 					  uint32_t flags,
 					  struct nft_rule_expr *e)
 {
-	switch(type) {
+	switch (type) {
 	case NFT_OUTPUT_DEFAULT:
 		return nft_rule_expr_counter_snprintf_default(buf, len, e);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_counter_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_counter_snprintf_json(buf, len, e);
+		return nft_rule_expr_counter_export(buf, len, e, type);
 	default:
 		break;
 	}
diff --git a/src/expr/ct.c b/src/expr/ct.c
index d443c1e..12d96d5 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -21,6 +21,7 @@
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
 #include "expr_ops.h"
+#include <buffer.h>
 
 struct nft_expr_ct {
 	enum nft_ct_keys        key;
@@ -310,66 +311,21 @@ err:
 }
 
 static int
-nft_expr_ct_snprintf_json(char *buf, size_t size, struct nft_rule_expr *e)
+nft_expr_ct_export(char *buf, size_t size, struct nft_rule_expr *e, int type)
 {
-	int ret, len = size, offset = 0;
-	struct nft_expr_ct *ct = nft_expr_data(e);
-
-	if (e->flags & (1 << NFT_EXPR_CT_DREG)) {
-		ret = snprintf(buf+offset, len, "\"dreg\":%u,", ct->dreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (e->flags & (1 << NFT_EXPR_CT_SREG)) {
-		ret = snprintf(buf+offset, len, "\"sreg:\":%u,", ct->sreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (e->flags & (1 << NFT_EXPR_CT_KEY)) {
-		ret = snprintf(buf+offset, len, "\"key\":\"%s\",",
-						ctkey2str(ct->key));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (nft_rule_expr_is_set(e, NFT_EXPR_CT_DIR)) {
-		ret = snprintf(buf+offset, len, "\"dir\":\"%s\",",
-			       ctdir2str(ct->dir));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	/* Remove the last separator characther  */
-	if (offset > 0)
-		offset--;
-
-	return offset;
-}
-
-static int
-nft_expr_ct_snprintf_xml(char *buf, size_t size, struct nft_rule_expr *e)
-{
-	int ret, len = size, offset = 0;
 	struct nft_expr_ct *ct = nft_expr_data(e);
+	NFT_BUF_INIT(b, buf, size);
 
-	if (e->flags & (1 << NFT_EXPR_CT_DREG)) {
-		ret = snprintf(buf + offset, len, "<dreg>%u</dreg>", ct->dreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_CT_SREG)) {
-		ret = snprintf(buf + offset, len, "<sreg>%u</sreg>", ct->sreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_CT_KEY)) {
-		ret = snprintf(buf + offset, len, "<key>%s</key>",
-			       ctkey2str(ct->key));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (nft_rule_expr_is_set(e, NFT_EXPR_CT_DIR)) {
-		ret = snprintf(buf + offset, len, "<dir>%s</dir>",
-			       ctdir2str(ct->dir));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
+	if (e->flags & (1 << NFT_EXPR_CT_SREG))
+		nft_buf_u32(&b, type, ct->sreg, SREG);
+	if (e->flags & (1 << NFT_EXPR_CT_DREG))
+		nft_buf_u32(&b, type, ct->dreg, DREG);
+	if (e->flags & (1 << NFT_EXPR_CT_KEY))
+		nft_buf_str(&b, type, ctkey2str(ct->key), KEY);
+	if (e->flags & (1 << NFT_EXPR_CT_DIR))
+		nft_buf_str(&b, type, ctdir2str(ct->dir), DIR);
 
-	return offset;
+	return nft_buf_done(&b);
 }
 
 static int
@@ -403,13 +359,12 @@ static int
 nft_rule_expr_ct_snprintf(char *buf, size_t len, uint32_t type,
 			    uint32_t flags, struct nft_rule_expr *e)
 {
-	switch(type) {
+	switch (type) {
 	case NFT_OUTPUT_DEFAULT:
 		return nft_expr_ct_snprintf_default(buf, len, e);
 	case NFT_OUTPUT_XML:
-		return nft_expr_ct_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return nft_expr_ct_snprintf_json(buf, len, e);
+		return nft_expr_ct_export(buf, len, e, type);
 	default:
 		break;
 	}
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 369727c..2135148 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -25,6 +25,7 @@
 #include <libnftnl/rule.h>
 
 #include "expr_ops.h"
+#include <buffer.h>
 
 #ifndef IPPROTO_MH
 #define IPPROTO_MH 135
@@ -154,7 +155,7 @@ nft_rule_expr_exthdr_parse(struct nft_rule_expr *e, struct nlattr *attr)
 	return 0;
 }
 
-static const char *exthdr_type2str(uint32_t type)
+static const char *type2str(uint32_t type)
 {
 	switch (type) {
 	case IPPROTO_HOPOPTS:
@@ -262,65 +263,22 @@ nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 #endif
 }
 
-static int nft_rule_expr_exthdr_snprintf_json(char *buf, size_t len,
-					      struct nft_rule_expr *e)
+static int nft_rule_expr_exthdr_export(char *buf, size_t len,
+				       struct nft_rule_expr *e, int type)
 {
 	struct nft_expr_exthdr *exthdr = nft_expr_data(e);
-	int ret, size = len, offset = 0;
+	NFT_BUF_INIT(b, buf, len);
 
-	if (e->flags & (1 << NFT_EXPR_EXTHDR_DREG)) {
-		ret = snprintf(buf, len, "\"dreg\":%u,", exthdr->dreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_EXTHDR_TYPE)) {
-		ret = snprintf(buf + offset, len, "\"exthdr_type\":\"%s\",",
-			       exthdr_type2str(exthdr->type));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_EXTHDR_OFFSET)) {
-		ret = snprintf(buf + offset, len, "\"offset\":%u,",
-			       exthdr->offset);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_EXTHDR_LEN)) {
-		ret = snprintf(buf + offset, len, "\"len\":%u,",
-			       exthdr->len);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	/* Remove the last comma characther */
-	if (offset > 0)
-		offset--;
-
-	return offset;
-}
-
-static int nft_rule_expr_exthdr_snprintf_xml(char *buf, size_t len,
-					     struct nft_rule_expr *e)
-{
-	struct nft_expr_exthdr *exthdr = nft_expr_data(e);
-	int ret, size = len, offset = 0;
-
-	if (e->flags & (1 << NFT_EXPR_EXTHDR_DREG)) {
-		ret = snprintf(buf, len, "<dreg>%u</dreg>", exthdr->dreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_EXTHDR_TYPE)) {
-		ret = snprintf(buf + offset, len,
-			       "<exthdr_type>%s</exthdr_type>",
-			       exthdr_type2str(exthdr->type));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_EXTHDR_OFFSET)) {
-		ret = snprintf(buf + offset, len, "<offset>%u</offset>",
-			       exthdr->offset);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_EXTHDR_LEN)) {
-		ret = snprintf(buf + offset, len, "<len>%u</len>", exthdr->len);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
+	if (e->flags & (1 << NFT_EXPR_EXTHDR_DREG))
+		nft_buf_u32(&b, type, exthdr->dreg, DREG);
+	if (e->flags & (1 << NFT_EXPR_EXTHDR_TYPE))
+		nft_buf_str(&b, type, type2str(exthdr->type), EXTHDR_TYPE);
+	if (e->flags & (1 << NFT_EXPR_EXTHDR_OFFSET))
+		nft_buf_u32(&b, type, exthdr->offset, OFFSET);
+	if (e->flags & (1 << NFT_EXPR_EXTHDR_LEN))
+		nft_buf_u32(&b, type, exthdr->len, LEN);
 
-	return offset;
+	return nft_buf_done(&b);
 }
 
 static int nft_rule_expr_exthdr_snprintf_default(char *buf, size_t len,
@@ -337,13 +295,12 @@ static int
 nft_rule_expr_exthdr_snprintf(char *buf, size_t len, uint32_t type,
 			       uint32_t flags, struct nft_rule_expr *e)
 {
-	switch(type) {
+	switch (type) {
 	case NFT_OUTPUT_DEFAULT:
 		return nft_rule_expr_exthdr_snprintf_default(buf, len, e);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_exthdr_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_exthdr_snprintf_json(buf, len, e);
+		return nft_rule_expr_exthdr_export(buf, len, e, type);
 	default:
 		break;
 	}
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 5f54129..be70445 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -21,6 +21,7 @@
 #include <libnftnl/rule.h>
 #include "expr_ops.h"
 #include "data_reg.h"
+#include <buffer.h>
 
 struct nft_expr_immediate {
 	union nft_data_reg	data;
@@ -248,63 +249,22 @@ nft_rule_expr_immediate_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 }
 
 static int
-nft_rule_expr_immediate_snprintf_json(char *buf, size_t len,
-				     struct nft_rule_expr *e, uint32_t flags)
+nft_rule_expr_immediate_export(char *buf, size_t size, struct nft_rule_expr *e,
+			       int type)
 {
-	int size = len, offset = 0, ret;
 	struct nft_expr_immediate *imm = nft_expr_data(e);
+	NFT_BUF_INIT(b, buf, size);
 
-	if (e->flags & (1 << NFT_EXPR_IMM_DREG)) {
-		ret = snprintf(buf, len, "\"dreg\":%u,", imm->dreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_IMM_DATA)) {
-		ret = nft_data_reg_snprintf(buf + offset, len, &imm->data,
-					    NFT_OUTPUT_JSON, flags, DATA_VALUE);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	} else if (e->flags & (1 << NFT_EXPR_IMM_VERDICT)) {
-		ret = nft_data_reg_snprintf(buf + offset, len, &imm->data,
-					  NFT_OUTPUT_JSON, flags, DATA_VERDICT);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	} else if (e->flags & (1 << NFT_EXPR_IMM_CHAIN)) {
-		ret = nft_data_reg_snprintf(buf + offset, len, &imm->data,
-					    NFT_OUTPUT_JSON, flags, DATA_CHAIN);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	return offset;
-}
-
-static int
-nft_rule_expr_immediate_snprintf_xml(char *buf, size_t len,
-				     struct nft_rule_expr *e, uint32_t flags)
-{
-	int size = len, offset = 0, ret;
-	struct nft_expr_immediate *imm = nft_expr_data(e);
-
-	if (e->flags & (1 << NFT_EXPR_IMM_DREG)) {
-		ret = snprintf(buf, len, "<dreg>%u</dreg>", imm->dreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_IMM_DATA)) {
-		ret = nft_data_reg_snprintf(buf + offset, len, &imm->data,
-					    NFT_OUTPUT_XML, flags, DATA_VALUE);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	} else if (e->flags & (1 << NFT_EXPR_IMM_VERDICT)) {
-		ret = nft_data_reg_snprintf(buf + offset, len, &imm->data,
-					  NFT_OUTPUT_XML, flags, DATA_VERDICT);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	} else if (e->flags & (1 << NFT_EXPR_IMM_CHAIN)) {
-		ret = nft_data_reg_snprintf(buf + offset, len, &imm->data,
-					    NFT_OUTPUT_XML, flags, DATA_CHAIN);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	return offset;
+	if (e->flags & (1 << NFT_EXPR_IMM_DREG))
+		nft_buf_u32(&b, type, imm->dreg, DREG);
+	if (e->flags & (1 << NFT_EXPR_IMM_DATA))
+		nft_buf_reg(&b, type, &imm->data, DATA_VALUE, DATA);
+	if (e->flags & (1 << NFT_EXPR_IMM_VERDICT))
+		nft_buf_reg(&b, type, &imm->data, DATA_VERDICT, DATA);
+	if (e->flags & (1 << NFT_EXPR_IMM_CHAIN))
+		nft_buf_reg(&b, type, &imm->data, DATA_CHAIN, DATA);
+
+	return nft_buf_done(&b);
 }
 
 static int
@@ -344,9 +304,8 @@ nft_rule_expr_immediate_snprintf(char *buf, size_t len, uint32_t type,
 	case NFT_OUTPUT_DEFAULT:
 		return nft_rule_expr_immediate_snprintf_default(buf, len, e, flags);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_immediate_snprintf_xml(buf, len, e, flags);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_immediate_snprintf_json(buf, len, e, flags);
+		return nft_rule_expr_immediate_export(buf, len, e, type);
 	default:
 		break;
 	}
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 68cfa37..375e6e0 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -22,6 +22,7 @@
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
 #include "expr_ops.h"
+#include <buffer.h>
 
 struct nft_expr_limit {
 	uint64_t		rate;
@@ -169,48 +170,18 @@ static const char *get_unit(uint64_t u)
 	return "error";
 }
 
-static int nft_rule_expr_limit_snprintf_xml(char *buf, size_t len,
-					    struct nft_rule_expr *e)
+static int nft_rule_expr_limit_export(char *buf, size_t size,
+				      struct nft_rule_expr *e, int type)
 {
 	struct nft_expr_limit *limit = nft_expr_data(e);
-	int ret, size = len, offset = 0;
+	NFT_BUF_INIT(b, buf, size);
 
-	if (e->flags & (1 << NFT_EXPR_LIMIT_RATE)) {
-		ret = snprintf(buf + offset, len, "<rate>%"PRIu64"</rate>",
-			       limit->rate);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_LIMIT_UNIT)) {
-		ret = snprintf(buf + offset, len, "<unit>%"PRIu64"</unit>",
-			       limit->unit);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	return offset;
-}
-
-static int nft_rule_expr_limit_snprintf_json(char *buf, size_t len,
-					    struct nft_rule_expr *e)
-{
-	struct nft_expr_limit *limit = nft_expr_data(e);
-	int ret, size = len, offset = 0;
-
-	if (e->flags & (1 << NFT_EXPR_LIMIT_RATE)) {
-		ret = snprintf(buf + offset, len, "\"rate\":%"PRIu64",",
-			       limit->rate);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_LIMIT_UNIT)) {
-		ret = snprintf(buf + offset, len, "\"unit\":%"PRIu64",",
-			       limit->unit);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	/* Remove the last comma characther */
-	if (offset > 0)
-		offset--;
+	if (e->flags & (1 << NFT_EXPR_LIMIT_RATE))
+		nft_buf_u64(&b, type, limit->rate, RATE);
+	if (e->flags & (1 << NFT_EXPR_LIMIT_UNIT))
+		nft_buf_u64(&b, type, limit->unit, UNIT);
 
-	return offset;
+	return nft_buf_done(&b);
 }
 
 static int nft_rule_expr_limit_snprintf_default(char *buf, size_t len,
@@ -231,9 +202,8 @@ nft_rule_expr_limit_snprintf(char *buf, size_t len, uint32_t type,
 	case NFT_OUTPUT_DEFAULT:
 		return nft_rule_expr_limit_snprintf_default(buf, len, e);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_limit_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_limit_snprintf_json(buf, len, e);
+		return nft_rule_expr_limit_export(buf, len, e, type);
 	default:
 		break;
 	}
diff --git a/src/expr/log.c b/src/expr/log.c
index 98481c9..0a324c4 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -21,6 +21,7 @@
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
 #include "expr_ops.h"
+#include <buffer.h>
 
 struct nft_expr_log {
 	uint32_t		snaplen;
@@ -288,90 +289,28 @@ static int nft_rule_expr_log_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int nft_rule_expr_log_snprintf_xml(char *buf, size_t size,
-					  struct nft_rule_expr *e)
+static int nft_rule_expr_log_export(char *buf, size_t size,
+				    struct nft_rule_expr *e, int type)
 {
-	int ret, len = size, offset = 0;
 	struct nft_expr_log *log = nft_expr_data(e);
+	NFT_BUF_INIT(b, buf, size);
 
-	if (e->flags & (1 << NFT_EXPR_LOG_PREFIX)) {
-		ret = snprintf(buf + offset, len, "<prefix>%s</prefix>",
-			       log->prefix);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_LOG_GROUP)) {
-		ret = snprintf(buf + offset, len, "<group>%u</group>",
-			       log->group);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_LOG_SNAPLEN)) {
-		ret = snprintf(buf + offset, len, "<snaplen>%u</snaplen>",
-			       log->snaplen);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_LOG_QTHRESHOLD)) {
-		ret = snprintf(buf + offset, len, "<qthreshold>%u</qthreshold>",
-			       log->qthreshold);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_LOG_LEVEL)) {
-		ret = snprintf(buf + offset, len, "<level>%u</level>",
-			       log->level);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_LOG_FLAGS)) {
-		ret = snprintf(buf + offset, len, "<flags>%u</flags>",
-			       log->flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	return offset;
-}
-
-static int nft_rule_expr_log_snprintf_json(char *buf, size_t len,
-					   struct nft_rule_expr *e)
-{
-	int ret, size = len, offset = 0;
-	struct nft_expr_log *log = nft_expr_data(e);
-
-	if (e->flags & (1 << NFT_EXPR_LOG_PREFIX)) {
-		ret = snprintf(buf + offset, len, "\"prefix\":\"%s\",",
-			       log->prefix);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_LOG_GROUP)) {
-		ret = snprintf(buf + offset, len, "\"group\":%u,",
-			       log->group);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_LOG_SNAPLEN)) {
-		ret = snprintf(buf + offset, len, "\"snaplen\":%u,",
-			       log->snaplen);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_LOG_QTHRESHOLD)) {
-		ret = snprintf(buf + offset, len, "\"qthreshold\":%u,",
-			       log->qthreshold);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_LOG_LEVEL)) {
-		ret = snprintf(buf + offset, len, "\"level\":%u,",
-			       log->level);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_LOG_FLAGS)) {
-		ret = snprintf(buf + offset, len, "\"flags\":%u,",
-			       log->flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	/* Remove the last comma characther */
-	if (offset > 0)
-		offset--;
+	if (e->flags & (1 << NFT_EXPR_LOG_PREFIX))
+		nft_buf_str(&b, type, log->prefix, PREFIX);
+	if (e->flags & (1 << NFT_EXPR_LOG_GROUP))
+		nft_buf_u32(&b, type, log->group, GROUP);
+	if (e->flags & (1 << NFT_EXPR_LOG_SNAPLEN))
+		nft_buf_u32(&b, type, log->snaplen, SNAPLEN);
+	if (e->flags & (1 << NFT_EXPR_LOG_QTHRESHOLD))
+		nft_buf_u32(&b, type, log->qthreshold, QTHRESH);
+	if (e->flags & (1 << NFT_EXPR_LOG_LEVEL))
+		nft_buf_u32(&b, type, log->level, LEVEL);
+	if (e->flags & (1 << NFT_EXPR_LOG_FLAGS))
+		nft_buf_u32(&b, type, log->level, FLAGS);
 
-	return offset;
+	return nft_buf_done(&b);
 }
 
-
 static int
 nft_rule_expr_log_snprintf(char *buf, size_t len, uint32_t type,
 			    uint32_t flags, struct nft_rule_expr *e)
@@ -380,9 +319,8 @@ nft_rule_expr_log_snprintf(char *buf, size_t len, uint32_t type,
 	case NFT_OUTPUT_DEFAULT:
 		return nft_rule_expr_log_snprintf_default(buf, len, e);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_log_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_log_snprintf_json(buf, len, e);
+		return nft_rule_expr_log_export(buf, len, e, type);
 	default:
 		break;
 	}
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 625bc58..29daa30 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -22,6 +22,7 @@
 #include <libnftnl/expr.h>
 #include "data_reg.h"
 #include "expr_ops.h"
+#include <buffer.h>
 
 #ifndef IFNAMSIZ
 #define IFNAMSIZ	16
@@ -208,52 +209,20 @@ nft_rule_expr_lookup_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 }
 
 static int
-nft_rule_expr_lookup_snprintf_json(char *buf, size_t size,
-				   struct nft_rule_expr *e)
+nft_rule_expr_lookup_export(char *buf, size_t size,
+			    struct nft_rule_expr *e, int type)
 {
-	int len = size, offset = 0, ret;
-	struct nft_expr_lookup *l = nft_expr_data(e);
-
-	if (e->flags & (1 << NFT_EXPR_LOOKUP_SET)) {
-		ret = snprintf(buf, len, "\"set\":\"%s\",", l->set_name);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_LOOKUP_SREG)) {
-		ret = snprintf(buf + offset, len, "\"sreg\":%u,", l->sreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_LOOKUP_DREG)) {
-		ret = snprintf(buf + offset, len, "\"dreg\":%u,", l->dreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	/* Remove the last comma characther */
-	if (offset > 0)
-		offset--;
-
-	return offset;
-}
-
-static int
-nft_rule_expr_lookup_snprintf_xml(char *buf, size_t size,
-				  struct nft_rule_expr *e)
-{
-	int len = size, offset = 0, ret;
 	struct nft_expr_lookup *l = nft_expr_data(e);
+	NFT_BUF_INIT(b, buf, size);
 
-	if (e->flags & (1 << NFT_EXPR_LOOKUP_SET)) {
-		ret = snprintf(buf, len, "<set>%s</set>", l->set_name);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_LOOKUP_SREG)) {
-		ret = snprintf(buf + offset, len, "<sreg>%u</sreg>", l->sreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_LOOKUP_DREG)) {
-		ret = snprintf(buf + offset, len, "<dreg>%u</dreg>", l->dreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
+	if (e->flags & (1 << NFT_EXPR_LOOKUP_SET))
+		nft_buf_str(&b, type, l->set_name, SET);
+	if (e->flags & (1 << NFT_EXPR_LOOKUP_SREG))
+		nft_buf_u32(&b, type, l->sreg, SREG);
+	if (e->flags & (1 << NFT_EXPR_LOOKUP_DREG))
+		nft_buf_u32(&b, type, l->dreg, DREG);
 
-	return offset;
+	return nft_buf_done(&b);
 }
 
 static int
@@ -284,9 +253,8 @@ nft_rule_expr_lookup_snprintf(char *buf, size_t size, uint32_t type,
 	case NFT_OUTPUT_DEFAULT:
 		return nft_rule_expr_lookup_snprintf_default(buf, size, e);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_lookup_snprintf_xml(buf, size, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_lookup_snprintf_json(buf, size, e);
+		return nft_rule_expr_lookup_export(buf, size, e, type);
 	default:
 		break;
 	}
diff --git a/src/expr/masq.c b/src/expr/masq.c
index b39a43a..869fd45 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -20,6 +20,7 @@
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
 #include "expr_ops.h"
+#include <buffer.h>
 
 struct nft_expr_masq {
 	uint32_t	flags;
@@ -135,33 +136,16 @@ nft_rule_expr_masq_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 	return -1;
 #endif
 }
-static int nft_rule_expr_masq_snprintf_json(char *buf, size_t len,
-					    struct nft_rule_expr *e)
+static int nft_rule_expr_masq_export(char *buf, size_t size,
+				     struct nft_rule_expr *e, int type)
 {
-	int ret, size = len, offset = 0;
 	struct nft_expr_masq *masq = nft_expr_data(e);
+	NFT_BUF_INIT(b, buf, size);
 
-	if (e->flags & (1 << NFT_EXPR_MASQ_FLAGS)) {
-		ret = snprintf(buf + offset, len, "\"flags\":%u", masq->flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	return offset;
-}
-
-static int nft_rule_expr_masq_snprintf_xml(char *buf, size_t len,
-					   struct nft_rule_expr *e)
-{
-	int ret, size = len, offset = 0;
-	struct nft_expr_masq *masq = nft_expr_data(e);
-
-	if (e->flags & (1 << NFT_EXPR_MASQ_FLAGS)) {
-		ret = snprintf(buf + offset, len, "<flags>%u</flags>",
-			       masq->flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
+	if (e->flags & (1 << NFT_EXPR_MASQ_FLAGS))
+		nft_buf_u32(&b, type, masq->flags, FLAGS);
 
-	return offset;
+	return nft_buf_done(&b);
 }
 
 static int nft_rule_expr_masq_snprintf_default(char *buf, size_t len,
@@ -182,9 +166,8 @@ static int nft_rule_expr_masq_snprintf(char *buf, size_t len, uint32_t type,
 	case NFT_OUTPUT_DEFAULT:
 		return nft_rule_expr_masq_snprintf_default(buf, len, e);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_masq_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_masq_snprintf_json(buf, len, e);
+		return nft_rule_expr_masq_export(buf, len, e, type);
 	default:
 		break;
 	}
diff --git a/src/expr/match.c b/src/expr/match.c
index dc66585..26a368f 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -25,6 +25,7 @@
 #include <libnftnl/rule.h>
 
 #include "expr_ops.h"
+#include <buffer.h>
 
 /* From include/linux/netfilter/x_tables.h */
 #define XT_EXTENSION_MAXNAMELEN 29
@@ -204,33 +205,16 @@ static int nft_rule_expr_match_xml_parse(struct nft_rule_expr *e, mxml_node_t *t
 #endif
 }
 
-static int nft_rule_expr_match_snprintf_json(char *buf, size_t len,
-					     struct nft_rule_expr *e)
+static int nft_rule_expr_match_export(char *buf, size_t size,
+				      struct nft_rule_expr *e, int type)
 {
 	struct nft_expr_match *mt = nft_expr_data(e);
-	int ret, size = len, offset = 0;
+	NFT_BUF_INIT(b, buf, size);
 
-	if (e->flags & (1 << NFT_EXPR_MT_NAME)) {
-		ret = snprintf(buf, len, "\"name\":\"%s\"", mt->name);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	return offset;
-}
-
-static int nft_rule_expr_match_snprintf_xml(char *buf, size_t len,
-					    struct nft_rule_expr *e)
-{
-	struct nft_expr_match *mt = nft_expr_data(e);
-	int ret, size=len;
-	int offset = 0;
-
-	if (e->flags & (1 << NFT_EXPR_MT_NAME)) {
-		ret = snprintf(buf, len, "<name>%s</name>", mt->name);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
+	if (e->flags & (1 << NFT_EXPR_MT_NAME))
+		nft_buf_str(&b, type, mt->name, NAME);
 
-	return offset;
+	return nft_buf_done(&b);
 }
 
 static int
@@ -239,14 +223,13 @@ nft_rule_expr_match_snprintf(char *buf, size_t len, uint32_t type,
 {
 	struct nft_expr_match *match = nft_expr_data(e);
 
-	switch(type) {
+	switch (type) {
 	case NFT_OUTPUT_DEFAULT:
 		return snprintf(buf, len, "name %s rev %u ",
 				match->name, match->rev);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_match_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_match_snprintf_json(buf, len, e);
+		return nft_rule_expr_match_export(buf, len, e, type);
 	default:
 		break;
 	}
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 5b5159f..51e9924 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -21,6 +21,7 @@
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
 #include "expr_ops.h"
+#include <buffer.h>
 
 #ifndef NFT_META_MAX
 #define NFT_META_MAX (NFT_META_OIFGROUP + 1)
@@ -263,71 +264,32 @@ nft_rule_expr_meta_snprintf_default(char *buf, size_t len,
 	return 0;
 }
 
-static int
-nft_rule_expr_meta_snprintf_xml(char *buf, size_t size,
-				struct nft_rule_expr *e)
-{
-	int ret, len = size, offset = 0;
-	struct nft_expr_meta *meta = nft_expr_data(e);
-
-	if (e->flags & (1 << NFT_EXPR_META_DREG)) {
-		ret = snprintf(buf, len, "<dreg>%u</dreg>", meta->dreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_META_KEY)) {
-		ret = snprintf(buf + offset, len, "<key>%s</key>",
-			       meta_key2str(meta->key));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_META_SREG)) {
-		ret = snprintf(buf + offset, len, "<sreg>%u</sreg>",
-			       meta->sreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	return offset;
-}
-
-static int
-nft_rule_expr_meta_snprintf_json(char *buf, size_t size,
-				 struct nft_rule_expr *e)
+static int nft_rule_expr_meta_export(char *buf, size_t size,
+				     struct nft_rule_expr *e, int type)
 {
-	int ret, len = size, offset = 0;
 	struct nft_expr_meta *meta = nft_expr_data(e);
+	NFT_BUF_INIT(b, buf, size);
 
-	if (e->flags & (1 << NFT_EXPR_META_DREG)) {
-		ret = snprintf(buf + offset, len, "\"dreg\":%u,",
-			       meta->dreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_META_KEY)) {
-		ret = snprintf(buf + offset, len, "\"key\":\"%s\",",
-			       meta_key2str(meta->key));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_META_SREG)) {
-		ret = snprintf(buf + offset, len, "\"sreg\":%u,",
-			       meta->sreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	/* Remove the last comma separator */
-	if (offset > 0)
-		offset--;
+	if (e->flags & (1 << NFT_EXPR_META_DREG))
+		nft_buf_u32(&b, type, meta->dreg, DREG);
+	if (e->flags & (1 << NFT_EXPR_META_KEY))
+		nft_buf_str(&b, type, meta_key2str(meta->key), KEY);
+	if (e->flags & (1 << NFT_EXPR_META_SREG))
+		nft_buf_u32(&b, type, meta->sreg, SREG);
 
-	return offset;
+	return nft_buf_done(&b);
 }
 
 static int
 nft_rule_expr_meta_snprintf(char *buf, size_t len, uint32_t type,
 			    uint32_t flags, struct nft_rule_expr *e)
 {
-	switch(type) {
+	switch (type) {
 	case NFT_OUTPUT_DEFAULT:
 		return nft_rule_expr_meta_snprintf_default(buf, len, e);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_meta_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_meta_snprintf_json(buf, len, e);
+		return nft_rule_expr_meta_export(buf, len, e, type);
 	default:
 		break;
 	}
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 60623a6..c9e05af 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -1,4 +1,5 @@
 /*
+ * (C) 2012-2014 Pablo Neira Ayuso <pablo@netfilter.org>
  * (C) 2012 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
@@ -23,6 +24,7 @@
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
 #include "expr_ops.h"
+#include <buffer.h>
 
 struct nft_expr_nat {
 	enum nft_registers sreg_addr_min;
@@ -196,7 +198,7 @@ nft_rule_expr_nat_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
 		mnl_attr_put_u32(nlh, NFTA_NAT_FLAGS, htonl(nat->flags));
 }
 
-static inline const char *nft_nat2str(uint16_t nat)
+static inline const char *nat2str(uint16_t nat)
 {
 	switch (nat) {
 	case NFT_NAT_SNAT:
@@ -329,85 +331,28 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 #endif
 }
 
-static int
-nft_rule_expr_nat_snprintf_json(char *buf, size_t size,
-				struct nft_rule_expr *e)
+static int nft_rule_expr_nat_export(char *buf, size_t size,
+				    struct nft_rule_expr *e, int type)
 {
 	struct nft_expr_nat *nat = nft_expr_data(e);
-	int len = size, offset = 0, ret = 0;
-
-	ret = snprintf(buf, len, "\"nat_type\":\"%s\",",
-		       nft_nat2str(nat->type));
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	ret = snprintf(buf+offset, len, "\"family\":\"%s\",",
-		       nft_family2str(nat->family));
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	if (e->flags & (1 << NFT_EXPR_NAT_REG_ADDR_MIN)) {
-		ret = snprintf(buf+offset, len, "\"sreg_addr_min\":%u,"
-						"\"sreg_addr_max\":%u,",
-			       nat->sreg_addr_min, nat->sreg_addr_max);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (e->flags & (1 << NFT_EXPR_NAT_REG_PROTO_MIN)) {
-		ret = snprintf(buf+offset, len, "\"sreg_proto_min\":%u,"
-						"\"sreg_proto_max\":%u,",
-		       nat->sreg_proto_min, nat->sreg_proto_max);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (e->flags & (1 << NFT_EXPR_NAT_FLAGS)) {
-		ret = snprintf(buf+offset, len, "\"flags\":%u,", nat->flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	/* Remove the last comma separator */
-	if (offset > 0)
-		offset--;
-
-	return offset;
-}
+	NFT_BUF_INIT(b, buf, size);
 
+	if (e->flags & (1 << NFT_EXPR_NAT_TYPE))
+		nft_buf_str(&b, type, nat2str(nat->type), NAT_TYPE);
+	if (e->flags & (1 << NFT_EXPR_NAT_FAMILY))
+		nft_buf_str(&b, type, nft_family2str(nat->family), FAMILY);
+	if (e->flags & (1 << NFT_EXPR_NAT_REG_ADDR_MIN))
+		nft_buf_u32(&b, type, nat->sreg_addr_min, SREG_ADDR_MIN);
+	if (e->flags & (1 << NFT_EXPR_NAT_REG_ADDR_MAX))
+		nft_buf_u32(&b, type, nat->sreg_addr_max, SREG_ADDR_MAX);
+	if (e->flags & (1 << NFT_EXPR_NAT_REG_PROTO_MIN))
+		nft_buf_u32(&b, type, nat->sreg_proto_min, SREG_PROTO_MIN);
+	if (e->flags & (1 << NFT_EXPR_NAT_REG_PROTO_MAX))
+		nft_buf_u32(&b, type, nat->sreg_proto_max, SREG_PROTO_MAX);
+	if (e->flags & (1 << NFT_EXPR_NAT_FLAGS))
+		nft_buf_u32(&b, type, nat->flags, FLAGS);
 
-static int
-nft_rule_expr_nat_snprintf_xml(char *buf, size_t size,
-				struct nft_rule_expr *e)
-{
-	struct nft_expr_nat *nat = nft_expr_data(e);
-	int len = size, offset = 0, ret = 0;
-
-	ret = snprintf(buf, len, "<type>%s</type>", nft_nat2str(nat->type));
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	ret = snprintf(buf+offset, len, "<family>%s</family>",
-		       nft_family2str(nat->family));
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	if (e->flags & (1 << NFT_EXPR_NAT_REG_ADDR_MIN)) {
-		ret = snprintf(buf+offset, len,
-				"<sreg_addr_min>%u</sreg_addr_min>"
-				"<sreg_addr_max>%u</sreg_addr_max>",
-			       nat->sreg_addr_min, nat->sreg_addr_max);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (e->flags & (1 << NFT_EXPR_NAT_REG_PROTO_MIN)) {
-		ret = snprintf(buf+offset, len,
-				"<sreg_proto_min>%u</sreg_proto_min>"
-				"<sreg_proto_max>%u</sreg_proto_max>",
-		       nat->sreg_proto_min, nat->sreg_proto_max);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (e->flags & (1 << NFT_EXPR_NAT_FLAGS)) {
-		ret = snprintf(buf+offset, len, "<flags>%u</flags>",
-			       nat->flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	return offset;
+	return nft_buf_done(&b);
 }
 
 static int
@@ -417,7 +362,7 @@ nft_rule_expr_nat_snprintf_default(char *buf, size_t size,
 	struct nft_expr_nat *nat = nft_expr_data(e);
 	int len = size, offset = 0, ret = 0;
 
-	ret = snprintf(buf, len, "%s ", nft_nat2str(nat->type));
+	ret = snprintf(buf, len, "%s ", nat2str(nat->type));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = snprintf(buf+offset, len, "%s ", nft_family2str(nat->family));
@@ -453,9 +398,8 @@ nft_rule_expr_nat_snprintf(char *buf, size_t size, uint32_t type,
 	case NFT_OUTPUT_DEFAULT:
 		return nft_rule_expr_nat_snprintf_default(buf, size, e);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_nat_snprintf_xml(buf, size, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_nat_snprintf_json(buf, size, e);
+		return nft_rule_expr_nat_export(buf, size, e, type);
 	default:
 		break;
 	}
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 717cdac..1aa20bd 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -25,6 +25,7 @@
 #include <libnftnl/rule.h>
 
 #include "expr_ops.h"
+#include <buffer.h>
 
 struct nft_expr_payload {
 	enum nft_registers	dreg;
@@ -161,34 +162,6 @@ static const char *base2str(enum nft_payload_bases base)
 	return base2str_array[base];
 }
 
-static int
-nft_rule_expr_payload_snprintf_json(char *buf, size_t len, uint32_t flags,
-				   struct nft_rule_expr *e)
-{
-	struct nft_expr_payload *payload = nft_expr_data(e);
-	int size = len, offset = 0, ret;
-
-	if (e->flags & (1 << NFT_EXPR_PAYLOAD_DREG)) {
-		ret = snprintf(buf, len, "\"dreg\":%u,", payload->dreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_PAYLOAD_OFFSET)) {
-		ret = snprintf(buf + offset, len, "\"offset\":%u,",
-			       payload->offset);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_PAYLOAD_LEN)) {
-		ret = snprintf(buf + offset, len, "\"len\":%u,", payload->len);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_PAYLOAD_BASE)) {
-		ret = snprintf(buf + offset, len, "\"base\":\"%s\"",
-			       base2str(payload->base));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	return offset;
-}
-
 static inline int nft_str2base(const char *base)
 {
 	if (strcmp(base, "link") == 0)
@@ -277,33 +250,22 @@ nft_rule_expr_payload_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 #endif
 }
 
-static int
-nft_rule_expr_payload_snprintf_xml(char *buf, size_t len, uint32_t flags,
-				   struct nft_rule_expr *e)
+static int nft_rule_expr_payload_export(char *buf, size_t size, uint32_t flags,
+					struct nft_rule_expr *e, int type)
 {
 	struct nft_expr_payload *payload = nft_expr_data(e);
-	int size = len, offset = 0, ret;
+	NFT_BUF_INIT(b, buf, size);
 
-	if (e->flags & (1 << NFT_EXPR_PAYLOAD_DREG)) {
-		ret = snprintf(buf, len, "<dreg>%u</dreg>", payload->dreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_PAYLOAD_OFFSET)) {
-		ret = snprintf(buf + offset, len, "<offset>%u</offset>",
-			       payload->offset);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_PAYLOAD_LEN)) {
-		ret = snprintf(buf + offset, len, "<len>%u</len>", payload->len);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_PAYLOAD_BASE)) {
-		ret = snprintf(buf + offset, len, "<base>%s</base>",
-			       base2str(payload->base));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
+	if (e->flags & (1 << NFT_EXPR_PAYLOAD_DREG))
+		nft_buf_u32(&b, type, payload->dreg, DREG);
+	if (e->flags & (1 << NFT_EXPR_PAYLOAD_OFFSET))
+		nft_buf_u32(&b, type, payload->offset, OFFSET);
+	if (e->flags & (1 << NFT_EXPR_PAYLOAD_LEN))
+		nft_buf_u32(&b, type, payload->len, LEN);
+	if (e->flags & (1 << NFT_EXPR_PAYLOAD_BASE))
+		nft_buf_str(&b, type, base2str(payload->base), BASE);
 
-	return offset;
+	return nft_buf_done(&b);
 }
 
 static int
@@ -312,15 +274,14 @@ nft_rule_expr_payload_snprintf(char *buf, size_t len, uint32_t type,
 {
 	struct nft_expr_payload *payload = nft_expr_data(e);
 
-	switch(type) {
+	switch (type) {
 	case NFT_OUTPUT_DEFAULT:
 		return snprintf(buf, len, "load %ub @ %s header + %u => reg %u ",
 				payload->len, base2str(payload->base),
 				payload->offset, payload->dreg);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_payload_snprintf_xml(buf, len, flags, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_payload_snprintf_json(buf, len, flags, e);
+		return nft_rule_expr_payload_export(buf, len, flags, e, type);
 	default:
 		break;
 	}
diff --git a/src/expr/queue.c b/src/expr/queue.c
index 64eb3cb..a4f0b88 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -20,6 +20,7 @@
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
 #include "expr_ops.h"
+#include <buffer.h>
 
 struct nft_expr_queue {
 	uint16_t		queuenum;
@@ -211,59 +212,20 @@ static int nft_rule_expr_queue_snprintf_default(char *buf, size_t len,
 	return offset;
 }
 
-static int nft_rule_expr_queue_snprintf_xml(char *buf, size_t len,
-					    struct nft_rule_expr *e)
+static int nft_rule_expr_queue_export(char *buf, size_t size,
+				      struct nft_rule_expr *e, int type)
 {
-	int ret, size = len, offset = 0;
-	struct nft_expr_queue *queue = nft_expr_data(e);
-
-	if (e->flags & (1 << NFT_EXPR_QUEUE_NUM)) {
-		ret = snprintf(buf + offset, len, "<num>%u</num>",
-			       queue->queuenum);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (e->flags & (1 << NFT_EXPR_QUEUE_TOTAL)) {
-		ret = snprintf(buf + offset, len, "<total>%u</total>",
-			       queue->queues_total);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_QUEUE_FLAGS)) {
-		ret = snprintf(buf + offset, len, "<flags>%u</flags>",
-			       queue->flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	return offset;
-}
-
-static int nft_rule_expr_queue_snprintf_json(char *buf, size_t len,
-					     struct nft_rule_expr *e)
-{
-	int ret, size = len, offset = 0;
 	struct nft_expr_queue *queue = nft_expr_data(e);
+	NFT_BUF_INIT(b, buf, size);
 
-	if (e->flags & (1 << NFT_EXPR_QUEUE_NUM)) {
-		ret = snprintf(buf + offset, len, "\"num\":%u,",
-			       queue->queuenum);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (e->flags & (1 << NFT_EXPR_QUEUE_TOTAL)) {
-		ret = snprintf(buf + offset, len, "\"total\":%u,",
-			       queue->queues_total);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_QUEUE_FLAGS)) {
-		ret = snprintf(buf + offset, len, "\"flags\":%u,",
-			       queue->flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	/* Remove the last comma characther */
-	if (offset > 0)
-		offset--;
+	if (e->flags & (1 << NFT_EXPR_QUEUE_NUM))
+		nft_buf_u32(&b, type, queue->queuenum, NUM);
+	if (e->flags & (1 << NFT_EXPR_QUEUE_TOTAL))
+		nft_buf_u32(&b, type, queue->queues_total, TOTAL);
+	if (e->flags & (1 << NFT_EXPR_QUEUE_FLAGS))
+		nft_buf_u32(&b, type, queue->flags, FLAGS);
 
-	return offset;
+	return nft_buf_done(&b);
 }
 
 static int
@@ -271,13 +233,12 @@ nft_rule_expr_queue_snprintf(char *buf, size_t len, uint32_t type,
 			      uint32_t flags, struct nft_rule_expr *e)
 {
 
-	switch(type) {
+	switch (type) {
 	case NFT_OUTPUT_DEFAULT:
 		return nft_rule_expr_queue_snprintf_default(buf, len, e);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_queue_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_queue_snprintf_json(buf, len, e);
+		return nft_rule_expr_queue_export(buf, len, e, type);
 	default:
 		break;
 	}
diff --git a/src/expr/redir.c b/src/expr/redir.c
index 98e8850..02cd3a6 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -20,6 +20,7 @@
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
 #include "expr_ops.h"
+#include <buffer.h>
 
 struct nft_expr_redir {
 	enum nft_registers sreg_proto_min;
@@ -184,60 +185,20 @@ nft_rule_expr_redir_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 #endif
 }
 
-static int nft_rule_expr_redir_snprintf_json(char *buf, size_t len,
-					     struct nft_rule_expr *e)
+static int nft_rule_expr_redir_export(char *buf, size_t size,
+				      struct nft_rule_expr *e, int type)
 {
-	int ret, size = len, offset = 0;
 	struct nft_expr_redir *redir = nft_expr_data(e);
+        NFT_BUF_INIT(b, buf, size);
 
-	if (nft_rule_expr_is_set(e, NFT_EXPR_REDIR_REG_PROTO_MIN)) {
-		ret = snprintf(buf + offset, len, "\"sreg_proto_min\":%u,",
-			       redir->sreg_proto_min);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (nft_rule_expr_is_set(e, NFT_EXPR_REDIR_REG_PROTO_MAX)) {
-		ret = snprintf(buf + offset, len, "\"sreg_proto_max\":%u,",
-			       redir->sreg_proto_max);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (nft_rule_expr_is_set(e, NFT_EXPR_REDIR_FLAGS)) {
-		ret = snprintf(buf + offset, len, "\"flags\":%u",
-			       redir->flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	return offset;
-}
-
-static int nft_rule_expr_redir_snprintf_xml(char *buf, size_t len,
-					    struct nft_rule_expr *e)
-{
-	int ret, size = len, offset = 0;
-	struct nft_expr_redir *redir = nft_expr_data(e);
-
-	if (nft_rule_expr_is_set(e, NFT_EXPR_REDIR_REG_PROTO_MIN)) {
-		ret = snprintf(buf + offset, len,
-			       "<sreg_proto_min>%u<sreg_proto_min>",
-			       redir->sreg_proto_min);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (nft_rule_expr_is_set(e, NFT_EXPR_REDIR_REG_PROTO_MAX)) {
-		ret = snprintf(buf + offset, len,
-			       "<sreg_proto_max>%u</sreg_proto_max>",
-			       redir->sreg_proto_max);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (nft_rule_expr_is_set(e, NFT_EXPR_REDIR_FLAGS)) {
-		ret = snprintf(buf + offset, len, "<flags>%u</flags>",
-			       redir->flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
+	if (e->flags & (1 << NFT_EXPR_REDIR_REG_PROTO_MIN))
+		nft_buf_u32(&b, type, redir->sreg_proto_min, SREG_PROTO_MIN);
+	if (e->flags & (1 << NFT_EXPR_REDIR_REG_PROTO_MAX))
+		nft_buf_u32(&b, type, redir->sreg_proto_max, SREG_PROTO_MAX);
+	if (e->flags & (1 << NFT_EXPR_REDIR_FLAGS))
+		nft_buf_u32(&b, type, redir->flags, FLAGS);
 
-	return offset;
+	return nft_buf_done(&b);
 }
 
 static int nft_rule_expr_redir_snprintf_default(char *buf, size_t len,
@@ -275,9 +236,8 @@ nft_rule_expr_redir_snprintf(char *buf, size_t len, uint32_t type,
 	case NFT_OUTPUT_DEFAULT:
 		return nft_rule_expr_redir_snprintf_default(buf, len, e);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_redir_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_redir_snprintf_json(buf, len, e);
+		return nft_rule_expr_redir_export(buf, len, e, type);
 	default:
 		break;
 	}
diff --git a/src/expr/reject.c b/src/expr/reject.c
index fb88cf5..fe18368 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -21,6 +21,7 @@
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
 #include "expr_ops.h"
+#include <buffer.h>
 
 struct nft_expr_reject {
 	uint32_t		type;
@@ -170,60 +171,30 @@ static int nft_rule_expr_reject_snprintf_default(char *buf, size_t len,
 			reject->type, reject->icmp_code);
 }
 
-static int nft_rule_expr_reject_snprintf_xml(char *buf, size_t len,
-					     struct nft_rule_expr *e)
+static int nft_rule_expr_reject_export(char *buf, size_t size,
+				       struct nft_rule_expr *e, int type)
 {
-	int ret, size = len, offset = 0;
 	struct nft_expr_reject *reject = nft_expr_data(e);
+	NFT_BUF_INIT(b, buf, size);
 
-	if (e->flags & (1 << NFT_EXPR_REJECT_TYPE)) {
-		ret = snprintf(buf+offset, len, "<type>%u</type>",
-			       reject->type);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_REJECT_CODE)) {
-		ret = snprintf(buf+offset, len, "<code>%u</code>",
-			       reject->icmp_code);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	return offset;
-}
-
-static int nft_rule_expr_reject_snprintf_json(char *buf, size_t len,
-					      struct nft_rule_expr *e)
-{
-	int ret, size = len, offset = 0;
-	struct nft_expr_reject *reject = nft_expr_data(e);
-
-	if (e->flags & (1 << NFT_EXPR_REJECT_TYPE)) {
-		ret = snprintf(buf+offset, len, "\"type\":%u,",
-			       reject->type);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (e->flags & (1 << NFT_EXPR_REJECT_CODE)) {
-		ret = snprintf(buf+offset, len, "\"code\":%u,",
-			       reject->icmp_code);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (offset > 0)
-		offset--;
+	if (e->flags & (1 << NFT_EXPR_REJECT_TYPE))
+		nft_buf_u32(&b, type, reject->type, TYPE);
+	if (e->flags & (1 << NFT_EXPR_REJECT_CODE))
+		nft_buf_u32(&b, type, reject->icmp_code, CODE);
 
-	return offset;
+	return nft_buf_done(&b);
 }
 
 static int
 nft_rule_expr_reject_snprintf(char *buf, size_t len, uint32_t type,
 			      uint32_t flags, struct nft_rule_expr *e)
 {
-	switch(type) {
+	switch (type) {
 	case NFT_OUTPUT_DEFAULT:
 		return nft_rule_expr_reject_snprintf_default(buf, len, e);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_reject_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_reject_snprintf_json(buf, len, e);
+		return nft_rule_expr_reject_export(buf, len, e, type);
 	default:
 		break;
 	}
diff --git a/src/expr/target.c b/src/expr/target.c
index bfff513..a79bc9e 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -25,6 +25,7 @@
 #include <libnftnl/rule.h>
 
 #include "expr_ops.h"
+#include <buffer.h>
 
 /* From include/linux/netfilter/x_tables.h */
 #define XT_EXTENSION_MAXNAMELEN 29
@@ -205,33 +206,16 @@ nft_rule_expr_target_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 #endif
 }
 
-static int nft_rule_exp_target_snprintf_json(char *buf, size_t len,
-					     struct nft_rule_expr *e)
+static int nft_rule_exp_target_export(char *buf, size_t size,
+				      struct nft_rule_expr *e, int type)
 {
 	struct nft_expr_target *target = nft_expr_data(e);
-	int ret, size = len, offset = 0;
+	NFT_BUF_INIT(b, buf, size);
 
-	if (e->flags & (1 << NFT_EXPR_TG_NAME)) {
-		ret = snprintf(buf, len, "\"name\":\"%s\"", target->name);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	return offset;
-}
-
-static int nft_rule_exp_target_snprintf_xml(char *buf, size_t len,
-					    struct nft_rule_expr *e)
-{
-	struct nft_expr_target *target = nft_expr_data(e);
-	int ret, size=len;
-	int offset = 0;
-
-	if (e->flags & (1 << NFT_EXPR_TG_NAME)) {
-		ret = snprintf(buf, len, "<name>%s</name>", target->name);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
+	if (e->flags & (1 << NFT_EXPR_TG_NAME))
+		nft_buf_str(&b, type, target->name, NAME);
 
-	return offset;
+	return nft_buf_done(&b);
 }
 
 static int
@@ -240,14 +224,13 @@ nft_rule_expr_target_snprintf(char *buf, size_t len, uint32_t type,
 {
 	struct nft_expr_target *target = nft_expr_data(e);
 
-	switch(type) {
+	switch (type) {
 	case NFT_OUTPUT_DEFAULT:
 		return snprintf(buf, len, "name %s rev %u ",
 				target->name, target->rev);
 	case NFT_OUTPUT_XML:
-		return nft_rule_exp_target_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_exp_target_snprintf_json(buf, len, e);
+		return nft_rule_exp_target_export(buf, len, e, type);
 	default:
 		break;
 	}
diff --git a/src/table.c b/src/table.c
index 53f6a4d..c93e6fb 100644
--- a/src/table.c
+++ b/src/table.c
@@ -24,6 +24,7 @@
 #include <linux/netfilter/nf_tables.h>
 
 #include <libnftnl/table.h>
+#include <buffer.h>
 
 struct nft_table {
 	struct list_head head;
@@ -391,75 +392,24 @@ int nft_table_parse_file(struct nft_table *t, enum nft_parse_type type,
 }
 EXPORT_SYMBOL(nft_table_parse_file);
 
-static int nft_table_snprintf_json(char *buf, size_t size, struct nft_table *t)
+static int nft_table_export(char *buf, size_t size, struct nft_table *t,
+			    int type)
 {
-	int ret, len = size, offset = 0;
-
-	ret = snprintf(buf, size, "{\"table\":{");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	ret = 0;
-
-	if (t->flags & (1 << NFT_TABLE_ATTR_NAME)) {
-		ret = snprintf(buf + offset, size, "\"name\":\"%s\",", t->name);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (t->flags & (1 << NFT_TABLE_ATTR_FAMILY)) {
-		ret = snprintf(buf + offset, size, "\"family\":\"%s\",",
-			       nft_family2str(t->family));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (t->flags & (1 << NFT_TABLE_ATTR_FLAGS)) {
-		ret = snprintf(buf + offset, size, "\"flags\":%u,",
-			       t->table_flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (t->flags & (1 << NFT_TABLE_ATTR_USE)) {
-		ret = snprintf(buf + offset, size, "\"use\":%u,", t->use);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	/* If  some values is set, ret is not 0. So, It's needed to remove the
-	 * last comma characther
-	 */
-	if (ret > 0)
-		offset--;
-
-	ret = snprintf(buf + offset, size, "}}");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	return offset;
-}
-
-static int nft_table_snprintf_xml(char *buf, size_t size, struct nft_table *t)
-{
-	int ret, len = size, offset = 0;
-
-	ret = snprintf(buf, size, "<table>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	NFT_BUF_INIT(b, buf, size);
 
-	if (t->flags & (1 << NFT_TABLE_ATTR_NAME)) {
-		ret = snprintf(buf + offset, size, "<name>%s</name>", t->name);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (t->flags & (1 << NFT_TABLE_ATTR_FAMILY)) {
-		ret = snprintf(buf + offset, size, "<family>%s</family>",
-			       nft_family2str(t->family));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (t->flags & (1 << NFT_TABLE_ATTR_FLAGS)) {
-		ret = snprintf(buf + offset, size, "<flags>%u</flags>",
-			       t->table_flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (t->flags & (1 << NFT_TABLE_ATTR_USE)) {
-		ret = snprintf(buf + offset, size, "<use>%u</use>", t->use);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
+	nft_buf_open(&b, type, TABLE);
+	if (t->flags & (1 << NFT_TABLE_ATTR_NAME))
+		nft_buf_str(&b, type, t->name, NAME);
+	if (t->flags & (1 << NFT_TABLE_ATTR_FAMILY))
+		nft_buf_str(&b, type, nft_family2str(t->family), FAMILY);
+	if (t->flags & (1 << NFT_TABLE_ATTR_FLAGS))
+		nft_buf_u32(&b, type, t->table_flags, FLAGS);
+	if (t->flags & (1 << NFT_TABLE_ATTR_USE))
+		nft_buf_u32(&b, type, t->use, USE);
 
-	ret = snprintf(buf + offset, size, "</table>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	nft_buf_close(&b, type, TABLE);
 
-	return offset;
+	return nft_buf_done(&b);
 }
 
 static int nft_table_snprintf_default(char *buf, size_t size, struct nft_table *t)
@@ -477,15 +427,13 @@ int nft_table_snprintf(char *buf, size_t size, struct nft_table *t,
 	ret = nft_event_header_snprintf(buf+offset, len, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	switch(type) {
+	switch (type) {
 	case NFT_OUTPUT_DEFAULT:
 		ret = nft_table_snprintf_default(buf+offset, len, t);
 		break;
 	case NFT_OUTPUT_XML:
-		ret = nft_table_snprintf_xml(buf+offset, len, t);
-		break;
 	case NFT_OUTPUT_JSON:
-		ret = nft_table_snprintf_json(buf+offset, len, t);
+		ret = nft_table_export(buf+offset, len, t, type);
 		break;
 	default:
 		return -1;
diff --git a/tests/jsonfiles/11-chain.json b/tests/jsonfiles/11-chain.json
index 2610b79..731ed1f 100644
--- a/tests/jsonfiles/11-chain.json
+++ b/tests/jsonfiles/11-chain.json
@@ -1 +1 @@
-{"nftables":[{"chain":{"name":"input","handle":1,"bytes":1375696,"packets":4136,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"input","prio":0,"policy":"accept"}}]}
+{"nftables":[{"chain":{"name":"input","handle":1,"bytes":1375696,"packets":4136,"table":"filter","family":"ip","use":0,"type":"filter","hooknum":"input","prio":0,"policy":"accept"}}]}
diff --git a/tests/jsonfiles/12-chain.json b/tests/jsonfiles/12-chain.json
index 3d15982..2d344eb 100644
--- a/tests/jsonfiles/12-chain.json
+++ b/tests/jsonfiles/12-chain.json
@@ -1 +1 @@
-{"nftables":[{"chain":{"name":"forward","handle":2,"bytes":0,"packets":0,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"forward","prio":0,"policy":"accept"}}]}
+{"nftables":[{"chain":{"name":"forward","handle":2,"bytes":0,"packets":0,"table":"filter","family":"ip","use":0,"type":"filter","hooknum":"forward","prio":0,"policy":"accept"}}]}
diff --git a/tests/jsonfiles/13-chain.json b/tests/jsonfiles/13-chain.json
index e3a17f0..5a6ddd1 100644
--- a/tests/jsonfiles/13-chain.json
+++ b/tests/jsonfiles/13-chain.json
@@ -1 +1 @@
-{"nftables":[{"chain":{"name":"output","handle":3,"bytes":454786,"packets":2681,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"output","prio":0,"policy":"accept"}}]}
+{"nftables":[{"chain":{"name":"output","handle":3,"bytes":454786,"packets":2681,"table":"filter","family":"ip","use":0,"type":"filter","hooknum":"output","prio":0,"policy":"accept"}}]}
diff --git a/tests/xmlfiles/10-chain.xml b/tests/xmlfiles/10-chain.xml
index 9c00eda..6ac54ab 100644
--- a/tests/xmlfiles/10-chain.xml
+++ b/tests/xmlfiles/10-chain.xml
@@ -1 +1 @@
-<nftables><chain><name>test</name><handle>0</handle><bytes>0</bytes><packets>0</packets><table>filter</table><type>filter</type><hooknum>input</hooknum><prio>0</prio><policy>accept</policy><family>ip</family></chain></nftables>
+<nftables><chain><name>test</name><handle>0</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family><type>filter</type><hooknum>input</hooknum><prio>0</prio><policy>accept</policy></chain></nftables>
diff --git a/tests/xmlfiles/11-chain.xml b/tests/xmlfiles/11-chain.xml
index 3d9978e..34d99dd 100644
--- a/tests/xmlfiles/11-chain.xml
+++ b/tests/xmlfiles/11-chain.xml
@@ -1 +1 @@
-<nftables><chain><name>test</name><handle>0</handle><bytes>59</bytes><packets>1</packets><table>filter</table><type>filter</type><hooknum>forward</hooknum><prio>0</prio><policy>drop</policy><family>ip6</family></chain></nftables>
+<nftables><chain><name>test</name><handle>0</handle><bytes>59</bytes><packets>1</packets><table>filter</table><family>ip6</family><type>filter</type><hooknum>forward</hooknum><prio>0</prio><policy>drop</policy></chain></nftables>
diff --git a/tests/xmlfiles/12-chain.xml b/tests/xmlfiles/12-chain.xml
index db0f56c..f53f252 100644
--- a/tests/xmlfiles/12-chain.xml
+++ b/tests/xmlfiles/12-chain.xml
@@ -1 +1 @@
-<nftables><chain><name>foo</name><handle>100</handle><bytes>59264154979</bytes><packets>2548796325</packets><table>nat</table><type>nat</type><hooknum>postrouting</hooknum><prio>0</prio><policy>accept</policy><family>ip</family></chain></nftables>
+<nftables><chain><name>foo</name><handle>100</handle><bytes>59264154979</bytes><packets>2548796325</packets><table>nat</table><family>ip</family><type>nat</type><hooknum>postrouting</hooknum><prio>0</prio><policy>accept</policy></chain></nftables>
-- 
1.7.10.4

