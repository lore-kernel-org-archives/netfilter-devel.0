Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F87DC31E57
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 10:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14AF02084D
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 10:32:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="NN1u1zHf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbfFQKcq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 06:32:46 -0400
Received: from mx1.riseup.net ([198.252.153.129]:39676 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbfFQKcq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 06:32:46 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id B52011A1EBF
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 03:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1560767565; bh=hMG4xn9Jz+JnFRfTpK11KLs89qRSVrNqV2moq4nuzAI=;
        h=From:To:Cc:Subject:Date:From;
        b=NN1u1zHfOzHQUfowVmx+zIUfrzBTl24MvXPr6XezajoWqtYD6HCcgwIl11X4PpqfC
         w5qhHWfjaTtqyoSoexMYtCtgIt+XMiFxjUCMrJkfUj4lfp/oiulVC2glEzw48Mu37d
         qniwCILna7xptK3ONIxDxPh7zChX6kdYyRKRb6kI=
X-Riseup-User-ID: 912642A93613ED4AB070DB832FBFBD91DC421DF78A0E25E56E23AEC19117A27B
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id E66D4223EE6;
        Mon, 17 Jun 2019 03:32:44 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH libnftnl WIP] expr: add synproxy support
Date:   Mon, 17 Jun 2019 12:32:33 +0200
Message-Id: <20190617103234.1357-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/libnftnl/expr.h             |   6 +
 include/linux/netfilter/nf_tables.h |  16 +++
 src/Makefile.am                     |   1 +
 src/expr/synproxy.c                 | 170 ++++++++++++++++++++++++++++
 src/expr_ops.c                      |   2 +
 5 files changed, 195 insertions(+)
 create mode 100644 src/expr/synproxy.c

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index b2f8d75..3e0f5b0 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -291,6 +291,12 @@ enum {
 	NFTNL_EXPR_XFRM_SPNUM,
 };
 
+enum {
+	NFTNL_EXPR_SYNPROXY_MSS	= NFTNL_EXPR_BASE,
+	NFTNL_EXPR_SYNPROXY_WSCALE,
+	NFTNL_EXPR_SYNPROXY_FLAGS,
+};
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index fd38cdc..12dc74b 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -951,6 +951,22 @@ enum nft_osf_attributes {
 };
 #define NFTA_OSF_MAX (__NFTA_OSF_MAX - 1)
 
+/**
+ * enum nft_synproxy_attributes - nf_tables synproxy expression
+ * netlink attributes
+ *
+ * @NFTA_SYNPROXY_MSS: mss value sent to the backend (NLA_U16)
+ * @NFTA_SYNPROXY_WSCALE: wscale value sent to the backend (NLA_U8)
+ * @NFTA_SYNPROXY_FLAGS: flags (NLA_U32)
+ */
+enum nft_synproxy_attributes {
+        NFTA_SYNPROXY_MSS,
+        NFTA_SYNPROXY_WSCALE,
+        NFTA_SYNPROXY_FLAGS,
+        __NFTA_SYNPROXY_MAX,
+};
+#define NFTA_SYNPROXY_MAX (__NFTA_SYNPROXY_MAX - 1)
+
 /**
  * enum nft_ct_keys - nf_tables ct expression keys
  *
diff --git a/src/Makefile.am b/src/Makefile.am
index 2d5873f..d100a9e 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -58,6 +58,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/socket.c	\
 		      expr/osf.c	\
 		      expr/xfrm.c	\
+		      expr/synproxy.c	\
 		      obj/counter.c	\
 		      obj/ct_helper.c	\
 		      obj/quota.c	\
diff --git a/src/expr/synproxy.c b/src/expr/synproxy.c
new file mode 100644
index 0000000..245f4fb
--- /dev/null
+++ b/src/expr/synproxy.c
@@ -0,0 +1,170 @@
+#include <stdio.h>
+#include <stdint.h>
+#include <string.h>
+#include <arpa/inet.h>
+#include <errno.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include "internal.h"
+#include <libmnl/libmnl.h>
+#include <libnftnl/expr.h>
+#include <libnftnl/rule.h>
+
+struct nftnl_expr_synproxy {
+	uint16_t	mss;
+	uint8_t		wscale;
+	uint32_t	flags;
+};
+
+static int nftnl_expr_synproxy_set(struct nftnl_expr *e, uint16_t type,
+				   const void *data, uint32_t data_len)
+{
+	struct nftnl_expr_synproxy *synproxy = nftnl_expr_data(e);
+
+	switch(type) {
+	case NFTNL_EXPR_SYNPROXY_MSS:
+		memcpy(&synproxy->mss, data, sizeof(synproxy->mss));
+		break;
+	case NFTNL_EXPR_SYNPROXY_WSCALE:
+		memcpy(&synproxy->wscale, data, sizeof(synproxy->wscale));
+		break;
+	case NFTNL_EXPR_SYNPROXY_FLAGS:
+		memcpy(&synproxy->flags, data, sizeof(synproxy->flags));
+		break;
+	}
+	return 0;
+}
+
+static const void *
+nftnl_expr_synproxy_get(const struct nftnl_expr *e, uint16_t type,
+			uint32_t *data_len)
+{
+	struct nftnl_expr_synproxy *synproxy = nftnl_expr_data(e);
+
+	switch(type) {
+	case NFTNL_EXPR_SYNPROXY_MSS:
+		*data_len = sizeof(synproxy->mss);
+		return &synproxy->mss;
+	case NFTNL_EXPR_SYNPROXY_WSCALE:
+		*data_len = sizeof(synproxy->wscale);
+		return &synproxy->wscale;
+	case NFTNL_EXPR_SYNPROXY_FLAGS:
+		*data_len = sizeof(synproxy->flags);
+		return &synproxy->flags;
+	}
+	return NULL;
+}
+
+static int nftnl_expr_synproxy_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_SYNPROXY_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NFTNL_EXPR_SYNPROXY_MSS:
+		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
+			abi_breakage();
+		break;
+
+	case NFTNL_EXPR_SYNPROXY_WSCALE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
+			abi_breakage();
+		break;
+
+	case NFTNL_EXPR_SYNPROXY_FLAGS:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void
+nftnl_expr_synproxy_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
+{
+	struct nftnl_expr_synproxy *synproxy = nftnl_expr_data(e);
+
+	if (e->flags & (1 << NFTNL_EXPR_SYNPROXY_MSS))
+		mnl_attr_put_u16(nlh, NFTNL_EXPR_SYNPROXY_MSS,
+				 htons(synproxy->mss));
+	if (e->flags & (1 << NFTNL_EXPR_SYNPROXY_WSCALE))
+		mnl_attr_put_u8(nlh, NFTNL_EXPR_SYNPROXY_WSCALE,
+				synproxy->wscale);
+	if (e->flags & (1 << NFTNL_EXPR_SYNPROXY_FLAGS))
+		mnl_attr_put_u32(nlh, NFTNL_EXPR_SYNPROXY_FLAGS,
+				 htonl(synproxy->flags));
+}
+
+static int
+nftnl_expr_synproxy_parse(struct nftnl_expr *e, struct nlattr *attr)
+{
+	struct nftnl_expr_synproxy *synproxy = nftnl_expr_data(e);
+	struct nlattr *tb[NFTA_SYNPROXY_MAX + 1] = {};
+
+	if (mnl_attr_parse_nested(attr, nftnl_expr_synproxy_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_SYNPROXY_MSS]) {
+		synproxy->mss = ntohs(mnl_attr_get_u16(tb[NFTA_SYNPROXY_MSS]));
+		e->flags |= (1 << NFTNL_EXPR_SYNPROXY_MSS);
+	}
+
+	if (tb[NFTA_SYNPROXY_WSCALE]) {
+		synproxy->wscale = mnl_attr_get_u8(tb[NFTA_SYNPROXY_WSCALE]);
+		e->flags |= (1 << NFTNL_EXPR_SYNPROXY_WSCALE);
+	}
+
+	if (tb[NFTA_SYNPROXY_FLAGS]) {
+		synproxy->flags = ntohl(mnl_attr_get_u32(tb[NFTA_SYNPROXY_FLAGS]));
+		e->flags |= (1 << NFTNL_EXPR_SYNPROXY_FLAGS);
+	}
+
+	return 0;
+}
+
+static int nftnl_expr_synproxy_snprintf_default(char *buf, size_t size,
+						const struct nftnl_expr *e)
+{
+	struct nftnl_expr_synproxy *synproxy = nftnl_expr_data(e);
+	int ret, offset = 0, len = size;
+
+	if (e->flags & (1 << NFTNL_EXPR_SYNPROXY_MSS) &&
+	    e->flags & (1 << NFTNL_EXPR_SYNPROXY_WSCALE)) {
+		ret = snprintf(buf, len, "mss %u wscale %u ", synproxy->mss,
+			       synproxy->wscale);
+		SNPRINTF_BUFFER_SIZE(ret, len, offset);
+	}
+
+	return offset;
+}
+
+static int
+nftnl_expr_synproxy_snprintf(char *buf, size_t len, uint32_t type,
+			     uint32_t flags, const struct nftnl_expr *e)
+{
+	switch(type) {
+	case NFTNL_OUTPUT_DEFAULT:
+		return nftnl_expr_synproxy_snprintf_default(buf, len, e);
+	case NFTNL_OUTPUT_XML:
+	case NFTNL_OUTPUT_JSON:
+	default:
+		break;
+	}
+	return -1;
+}
+
+struct expr_ops expr_ops_synproxy = {
+	.name		= "synproxy",
+	.alloc_len	= sizeof(struct nftnl_expr_synproxy),
+	.max_attr	= NFTA_SYNPROXY_MAX,
+	.set		= nftnl_expr_synproxy_set,
+	.get		= nftnl_expr_synproxy_get,
+	.parse		= nftnl_expr_synproxy_parse,
+	.build		= nftnl_expr_synproxy_build,
+	.snprintf	= nftnl_expr_synproxy_snprintf,
+};
diff --git a/src/expr_ops.c b/src/expr_ops.c
index 051140f..9655e2f 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -40,6 +40,7 @@ extern struct expr_ops expr_ops_socket;
 extern struct expr_ops expr_ops_tunnel;
 extern struct expr_ops expr_ops_osf;
 extern struct expr_ops expr_ops_xfrm;
+extern struct expr_ops expr_ops_synproxy;
 
 static struct expr_ops expr_ops_notrack = {
 	.name	= "notrack",
@@ -83,6 +84,7 @@ static struct expr_ops *expr_ops[] = {
 	&expr_ops_tunnel,
 	&expr_ops_osf,
 	&expr_ops_xfrm,
+	&expr_ops_synproxy,
 	NULL,
 };
 
-- 
2.20.1

