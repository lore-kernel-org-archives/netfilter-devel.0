From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [BUG] libnftables: NULL pointer dereference in
 nft_expr_ops_lookup
Date: Fri, 25 Oct 2013 17:04:36 +0200
Message-ID: <20131025150436.GA7536@localhost>
References: <20131025152735.65d354bd@griffin>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Cc: netfilter-devel@vger.kernel.org
To: Jiri Benc <jbenc@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36393 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab3JYPEp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:04:45 -0400
Content-Disposition: inline
In-Reply-To: <20131025152735.65d354bd@griffin>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jiri,

On Fri, Oct 25, 2013 at 03:27:35PM +0200, Jiri Benc wrote:
> Hi,
> 
> using both the latest (git) libnftables and nftables, I got:
> 
> [root@localhost ~]# nft add rule ip filter input tcp dport 81 reject
> Segmentation fault (core dumped)
> 
> (gdb) bt
> #0  0x00007fb7890c1364 in __strcmp_sse2 () from /lib64/libc.so.6
> #1  0x00007fb78960bfa4 in nft_expr_ops_lookup (name=name@entry=0x0) at expr_ops.c:18
> #2  0x00007fb78960bc56 in nft_rule_expr_alloc (name=name@entry=0x0) at expr.c:34
> #3  0x000000000040db29 in alloc_nft_expr (name=name@entry=0x0) at src/netlink.c:118
> #4  0x0000000000410117 in netlink_gen_reject_stmt (ctx=<optimized out>, stmt=<optimized out>)
>     at src/netlink_linearize.c:564
> #5  netlink_gen_stmt (stmt=0xb106f0, ctx=0x7fff734c4690) at src/netlink_linearize.c:651
> #6  netlink_linearize_rule (ctx=ctx@entry=0x7fff734c4730, nlr=nlr@entry=0xb10520, rule=rule@entry=0xb10760)
>     at src/netlink_linearize.c:670
> #7  0x000000000040e25b in netlink_add_rule_batch (ctx=0x7fff734c4730, h=<optimized out>, rule=0xb10760, flags=2048)
>     at src/netlink.c:320
> #8  0x00000000004056ec in nft_netlink (msgs=0x7fff734c48b0, state=0x7fff734c48c0) at src/main.c:167
> #9  nft_run (scanner=scanner@entry=0xb102c0, state=state@entry=0x7fff734c48c0, msgs=msgs@entry=0x7fff734c48b0)
>     at src/main.c:214
> #10 0x00000000004052e5 in main (argc=10, argv=<optimized out>) at src/main.c:321
> 
> 
> Looking into the code, netlink_gen_reject_stmt calls
> alloc_nft_expr(NULL), the NULL propagates to strcmp in
> nft_expr_ops_lookup.

reject support was never finished. Please, find enclosed patches for
libnftables and nft.

ICMP code support is still missing, perhaps you want to investigate
how to add it to nft. It should be a small follow up patch.

--/04w6evG8XlLl3ft
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-expr-add-reject.patch"

>From f619e81d6cc10caec8a9c5ff1b0e4a8ea081646d Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 25 Oct 2013 16:48:36 +0200
Subject: [PATCH libnftables] expr: add reject

This patch adds support for the reject expression.

Reported-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftables/expr.h |    5 ++
 src/Makefile.am            |    1 +
 src/expr/reject.c          |  213 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 219 insertions(+)
 create mode 100644 src/expr/reject.c

diff --git a/include/libnftables/expr.h b/include/libnftables/expr.h
index 232a810..64c407c 100644
--- a/include/libnftables/expr.h
+++ b/include/libnftables/expr.h
@@ -137,6 +137,11 @@ enum {
 	NFT_EXPR_LIMIT_UNIT,
 };
 
+enum {
+	NFT_EXPR_REJECT_TYPE	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_REJECT_CODE,
+};
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/src/Makefile.am b/src/Makefile.am
index 474dbf0..5f64db2 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -30,6 +30,7 @@ libnftables_la_SOURCES = utils.c		\
 			 expr/meta.c		\
 			 expr/nat.c		\
 			 expr/payload.c		\
+			 expr/reject.c		\
 			 expr/target.c		\
 			 libnftables.map	\
 			 internal.h
diff --git a/src/expr/reject.c b/src/expr/reject.c
new file mode 100644
index 0000000..460f6a0
--- /dev/null
+++ b/src/expr/reject.c
@@ -0,0 +1,213 @@
+/*
+ * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
+ */
+
+#include <stdio.h>
+#include <stdint.h>
+#include <string.h>
+#include <arpa/inet.h>
+#include <errno.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include "internal.h"
+#include <libmnl/libmnl.h>
+#include <libnftables/expr.h>
+#include <libnftables/rule.h>
+#include "expr_ops.h"
+
+struct nft_expr_reject {
+	uint32_t		type;
+	uint8_t			icmp_code;
+};
+
+static int nft_rule_expr_reject_set(struct nft_rule_expr *e, uint16_t type,
+				 const void *data, uint32_t data_len)
+{
+	struct nft_expr_reject *reject = nft_expr_data(e);
+
+	switch(type) {
+	case NFT_EXPR_REJECT_TYPE:
+		reject->type = *((uint32_t *)data);
+		break;
+	case NFT_EXPR_REJECT_CODE:
+		reject->icmp_code = *((uint8_t *)data);
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *
+nft_rule_expr_reject_get(const struct nft_rule_expr *e, uint16_t type,
+		      uint32_t *data_len)
+{
+	struct nft_expr_reject *reject = nft_expr_data(e);
+
+	switch(type) {
+	case NFT_EXPR_REJECT_TYPE:
+		*data_len = sizeof(reject->type);
+		return &reject->type;
+	case NFT_EXPR_REJECT_CODE:
+		*data_len = sizeof(reject->icmp_code);
+		return &reject->icmp_code;
+	}
+	return NULL;
+}
+
+static int nft_rule_expr_reject_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_REJECT_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NFTA_REJECT_TYPE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NFTA_REJECT_ICMP_CODE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void
+nft_rule_expr_reject_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
+{
+	struct nft_expr_reject *reject = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_REJECT_TYPE))
+		mnl_attr_put_u32(nlh, NFTA_REJECT_TYPE, htonl(reject->type));
+	if (e->flags & (1 << NFT_EXPR_REJECT_CODE))
+		mnl_attr_put_u16(nlh, NFTA_REJECT_ICMP_CODE, htonl(reject->icmp_code));
+}
+
+static int
+nft_rule_expr_reject_parse(struct nft_rule_expr *e, struct nlattr *attr)
+{
+	struct nft_expr_reject *reject = nft_expr_data(e);
+	struct nlattr *tb[NFTA_REJECT_MAX+1] = {};
+
+	if (mnl_attr_parse_nested(attr, nft_rule_expr_reject_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_REJECT_TYPE]) {
+		reject->type = ntohl(mnl_attr_get_u32(tb[NFTA_REJECT_TYPE]));
+		e->flags |= (1 << NFT_EXPR_REJECT_TYPE);
+	}
+	if (tb[NFTA_REJECT_ICMP_CODE]) {
+		reject->icmp_code = ntohl(mnl_attr_get_u8(tb[NFTA_REJECT_ICMP_CODE]));
+		e->flags |= (1 << NFT_EXPR_REJECT_CODE);
+	}
+
+	return 0;
+}
+
+static int
+nft_rule_expr_reject_json_parse(struct nft_rule_expr *e, json_t *root)
+{
+#ifdef JSON_PARSING
+	uint32_t type;
+	uint16_t code;
+
+	if (nft_jansson_parse_val(root, "type", NFT_TYPE_U32, &type) < 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_REJECT_TYPE, type);
+
+	if (nft_jansson_parse_val(root, "code", NFT_TYPE_U8, &code) < 0)
+		return -1;
+
+	nft_rule_expr_set_u8(e, NFT_EXPR_REJECT_CODE, code);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
+nft_rule_expr_reject_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
+{
+#ifdef XML_PARSING
+	struct nft_expr_reject *reject = nft_expr_data(e);
+
+	if (nft_mxml_num_parse(tree, "type", MXML_DESCEND_FIRST, BASE_DEC,
+			       &reject->type, NFT_TYPE_U32, NFT_XML_MAND) != 0)
+		return -1;
+
+	e->flags |= (1 << NFT_EXPR_REJECT_TYPE);
+
+	if (nft_mxml_num_parse(tree, "code", MXML_DESCEND_FIRST, BASE_DEC,
+			       &reject->icmp_code, NFT_TYPE_U8, NFT_XML_MAND) != 0)
+		return -1;
+
+	e->flags |= (1 << NFT_EXPR_REJECT_CODE);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
+nft_rule_expr_reject_snprintf(char *buf, size_t len, uint32_t type,
+			      uint32_t flags, struct nft_rule_expr *e)
+{
+	struct nft_expr_reject *reject = nft_expr_data(e);
+
+	switch(type) {
+	case NFT_RULE_O_DEFAULT:
+		return snprintf(buf, len, "type %u code %u  ",
+				reject->type, reject->icmp_code);
+	case NFT_RULE_O_XML:
+		return snprintf(buf, len, "<type>%u</type>"
+					  "<code>%u</code>",
+				reject->type, reject->icmp_code);
+	case NFT_RULE_O_JSON:
+		return snprintf(buf, len, "\"type\":%u,"
+					  "\"code\":%u,",
+				reject->type, reject->icmp_code);
+	default:
+		break;
+	}
+	return -1;
+}
+
+struct expr_ops expr_ops_reject = {
+	.name		= "reject",
+	.alloc_len	= sizeof(struct nft_expr_reject),
+	.max_attr	= NFTA_REJECT_MAX,
+	.set		= nft_rule_expr_reject_set,
+	.get		= nft_rule_expr_reject_get,
+	.parse		= nft_rule_expr_reject_parse,
+	.build		= nft_rule_expr_reject_build,
+	.snprintf	= nft_rule_expr_reject_snprintf,
+	.xml_parse	= nft_rule_expr_reject_xml_parse,
+	.json_parse	= nft_rule_expr_reject_json_parse,
+};
+
+static void __init expr_reject_init(void)
+{
+	nft_expr_ops_register(&expr_ops_reject);
+}
-- 
1.7.10.4


--/04w6evG8XlLl3ft
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netlink_linearize-finish-reject-support.patch"

>From 41fbf2fd89a166bb3bb8d7d11bf790aa6011fcd1 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 25 Oct 2013 17:01:58 +0200
Subject: [PATCH nft] netlink_linearize: finish reject support

This patch finishes the reject support.

Reported-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_linearize.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index c1d1a9a..96ffe68 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -692,7 +692,9 @@ static void netlink_gen_reject_stmt(struct netlink_linearize_ctx *ctx,
 {
 	struct nft_rule_expr *nle;
 
-	nle = alloc_nft_expr(NULL);
+	nle = alloc_nft_expr("reject");
+	nft_rule_expr_set_u32(nle, NFT_EXPR_REJECT_TYPE, stmt->reject.type);
+	nft_rule_expr_set_u8(nle, NFT_EXPR_REJECT_CODE, 0);
 	nft_rule_add_expr(ctx->nlr, nle);
 }
 
-- 
1.7.10.4


--/04w6evG8XlLl3ft--
