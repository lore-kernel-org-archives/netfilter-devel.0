Return-Path: <SRS0=FJFf=5X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F6BC2BA1A
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Apr 2020 18:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AF2C2063A
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Apr 2020 18:01:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s+lmS4bB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgDGSBD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Apr 2020 14:01:03 -0400
Received: from mail-oi1-f176.google.com ([209.85.167.176]:34200 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgDGSBD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Apr 2020 14:01:03 -0400
Received: by mail-oi1-f176.google.com with SMTP id d3so2322649oic.1
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Apr 2020 11:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=p4Nc0Li+/kD37w7veUXAXlgTSuUYGKPmFqGcLi8n2Fw=;
        b=s+lmS4bBB86dAUKPuLnVzD/Oqv8IiIgo12m+BhiR5DVl3F97nXgWRov2UxmtUzNEX5
         nbACIgBiDx5LzvzJvqIr8Je7bgigoheILfFbIA3z6lu6ka1nSgCl+KYtH5Dm54Gf8W5o
         9IVyXR5SjJZJq71oRz0Gm3a1CN697xTqjCaaqHVzh0AsrUPAiXRj33TJU85UYw1HGSJ5
         //d5Tivw22dYyDZPRTtrwE1jjgxLA16f3Mm0YqmBFai7DRJIcwIvcWg3Zk9+HUdLjlvq
         N85NnStabiGR01Y/n4JSrjmcHW5sxFK99FoKvUTvjTVD3mtyXL0ySWx1d6hKGRheokw4
         bPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=p4Nc0Li+/kD37w7veUXAXlgTSuUYGKPmFqGcLi8n2Fw=;
        b=PD2zp0Cm49OtFvkOwLBJ6Cl8sxEpCTHn8dBuS+vRsiG6cX2kV2HJSZR4sffG1ejO8l
         QnMk8X8mWjoPNKjbXwl3fci/otEF1bRnAJDjVOTiow3GMl7X0E3Irm6G5qNlqipfgFQJ
         Eb96vPy2MxBmu5oIFVuyevkCvy48K5mD2rjALXpFCBtFotUHpdWG/AT5DlhW2yiusnd3
         gnihIZ7Jqe/G8l1GWleub8MrQSKKIOj0NHB4oEcLHdeCgpdilDEHmF+t8oPGHVO4M9Aw
         A+GxaGLpPJvKmcgHin35Sd6rL163AerB2J0iPSo6cmFLthlUpscxAStoLkXGv1WAsqhC
         WG4Q==
X-Gm-Message-State: AGi0PubFf18lvmlRLJESA5DfHModwbvbkYJ6tHXPZbSThcCDvimMFBV7
        flJ/xYUFI7oBWYGi5JHhwIm8V5mN
X-Google-Smtp-Source: APiQypKLyBvuuj8WkcNOGy62NcLC6Tsm4r3zANjnd2AFUXlh4E09JQZD0G568LHZc9y3uoeKtwM9wg==
X-Received: by 2002:a05:6808:6cb:: with SMTP id m11mr52518oih.130.1586282461706;
        Tue, 07 Apr 2020 11:01:01 -0700 (PDT)
Received: from localhost.localdomain (CableLink-187-161-107-10.PCs.InterCable.net. [187.161.107.10])
        by smtp.gmail.com with ESMTPSA id 186sm5358619ooi.30.2020.04.07.11.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 11:01:01 -0700 (PDT)
From:   Alberto Leiva Popper <ydahhrk@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Alberto Leiva Popper <ydahhrk@gmail.com>
Subject: [libnftnl PATCH 1/2] expr: add jool support
Date:   Tue,  7 Apr 2020 13:00:50 -0500
Message-Id: <20200407180050.19095-1-ydahhrk@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jool statements are used to send packets to the Jool kernel module,
which is an IP/ICMP translator: www.jool.mx

This feature was requested in Jool's bug tracker:
https://github.com/NICMx/Jool/issues/285

Signed-off-by: Alberto Leiva Popper <ydahhrk@gmail.com>
---
 include/libnftnl/expr.h |   5 ++
 src/Makefile.am         |   1 +
 src/expr/jool.c         | 193 ++++++++++++++++++++++++++++++++++++++++
 src/expr_ops.c          |   2 +
 4 files changed, 201 insertions(+)
 create mode 100644 src/expr/jool.c

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index cfe456d..5349e15 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -299,6 +299,11 @@ enum {
 	NFTNL_EXPR_SYNPROXY_FLAGS,
 };
 
+enum {
+	NFTNL_EXPR_JOOL_TYPE	= NFTNL_EXPR_BASE,
+	NFTNL_EXPR_JOOL_INSTANCE,
+};
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/src/Makefile.am b/src/Makefile.am
index 90b1967..2c1c964 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -57,6 +57,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/hash.c	\
 		      expr/socket.c	\
 		      expr/synproxy.c	\
+		      expr/jool.c	\
 		      expr/osf.c	\
 		      expr/xfrm.c	\
 		      obj/counter.c	\
diff --git a/src/expr/jool.c b/src/expr/jool.c
new file mode 100644
index 0000000..bd680c7
--- /dev/null
+++ b/src/expr/jool.c
@@ -0,0 +1,193 @@
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
+enum nft_jool_attributes {
+	NFTA_JOOL_UNSPEC,
+	NFTA_JOOL_TYPE,
+	NFTA_JOOL_INSTANCE,
+	__NFTA_JOOL_MAX,
+};
+
+#define NFTA_JOOL_MAX (__NFTA_JOOL_MAX - 1)
+
+struct nftnl_expr_jool {
+	const char		*instance;
+	uint8_t			type;
+};
+
+#define XT_SIIT		(1 << 0)
+#define XT_NAT64	(1 << 1)
+
+static int
+nftnl_expr_jool_set(struct nftnl_expr *e, uint16_t type,
+		    const void *data, uint32_t data_len)
+{
+	struct nftnl_expr_jool *jool = nftnl_expr_data(e);
+
+	switch(type) {
+	case NFTNL_EXPR_JOOL_TYPE:
+		memcpy(&jool->type, data, sizeof(jool->type));
+		break;
+	case NFTNL_EXPR_JOOL_INSTANCE:
+		jool->instance = strdup(data);
+		if (!jool->instance)
+			return -1;
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *
+nftnl_expr_jool_get(const struct nftnl_expr *e, uint16_t type,
+		    uint32_t *data_len)
+{
+	struct nftnl_expr_jool *jool = nftnl_expr_data(e);
+
+	switch(type) {
+	case NFTNL_EXPR_JOOL_TYPE:
+		*data_len = sizeof(jool->type);
+		return &jool->type;
+	case NFTNL_EXPR_JOOL_INSTANCE:
+		*data_len = strlen(jool->instance) + 1;
+		return jool->instance;
+	}
+	return NULL;
+}
+
+static int
+nftnl_expr_jool_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_JOOL_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NFTNL_EXPR_JOOL_TYPE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
+			abi_breakage();
+		break;
+	case NFTNL_EXPR_JOOL_INSTANCE:
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void
+nftnl_expr_jool_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
+{
+	struct nftnl_expr_jool *jool = nftnl_expr_data(e);
+
+	if (e->flags & (1 << NFTNL_EXPR_JOOL_TYPE))
+		mnl_attr_put_u8(nlh, NFTA_JOOL_TYPE, jool->type);
+	if (e->flags & (1 << NFTNL_EXPR_JOOL_INSTANCE))
+		mnl_attr_put_strz(nlh, NFTA_JOOL_INSTANCE, jool->instance);
+}
+
+static int
+nftnl_expr_jool_parse(struct nftnl_expr *e, struct nlattr *attr)
+{
+	struct nftnl_expr_jool *jool = nftnl_expr_data(e);
+	struct nlattr *tb[NFTA_JOOL_MAX+1] = {};
+
+	if (mnl_attr_parse_nested(attr, nftnl_expr_jool_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_JOOL_TYPE]) {
+		jool->type = mnl_attr_get_u8(tb[NFTA_JOOL_TYPE]);
+		e->flags |= (1 << NFTNL_EXPR_JOOL_TYPE);
+	}
+	if (tb[NFTA_JOOL_INSTANCE]) {
+		jool->instance =
+			strdup(mnl_attr_get_str(tb[NFTA_JOOL_INSTANCE]));
+		if (!jool->instance)
+			return -1;
+		e->flags |= (1 << NFTNL_EXPR_JOOL_INSTANCE);
+	}
+
+	return 0;
+}
+
+static const char *jt2str(uint8_t xt)
+{
+	switch (xt) {
+	case XT_SIIT:
+		return "siit";
+	case XT_NAT64:
+		return "nat64";
+	default:
+		return "unknown";
+	}
+}
+
+static int
+nftnl_expr_jool_snprintf_default(char *buf, size_t size,
+				 const struct nftnl_expr *e)
+{
+	struct nftnl_expr_jool *jool = nftnl_expr_data(e);
+	int ret, remain = size, offset = 0;
+
+	if (nftnl_expr_is_set(e, NFTNL_EXPR_JOOL_TYPE)) {
+		ret = snprintf(buf + offset, remain, "type %s ",
+			       jt2str(jool->type));
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+	}
+
+	if (e->flags & (1 << NFTNL_EXPR_JOOL_INSTANCE)) {
+		ret = snprintf(buf, size, "instance %s ", jool->instance);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+	}
+
+	return offset;
+}
+
+static int
+nftnl_expr_jool_snprintf(char *buf, size_t len, uint32_t type,
+			 uint32_t flags, const struct nftnl_expr *e)
+{
+	switch(type) {
+	case NFTNL_OUTPUT_DEFAULT:
+		return nftnl_expr_jool_snprintf_default(buf, len, e);
+	case NFTNL_OUTPUT_XML:
+	case NFTNL_OUTPUT_JSON:
+	default:
+		break;
+	}
+	return -1;
+}
+
+static void
+nftnl_expr_jool_free(const struct nftnl_expr *e)
+{
+	struct nftnl_expr_jool *jool = nftnl_expr_data(e);
+
+	xfree(jool->instance);
+}
+
+struct expr_ops expr_ops_jool = {
+	.name		= "jool",
+	.alloc_len	= sizeof(struct nftnl_expr_jool),
+	.max_attr	= NFTA_JOOL_MAX,
+	.free		= nftnl_expr_jool_free,
+	.set		= nftnl_expr_jool_set,
+	.get		= nftnl_expr_jool_get,
+	.parse		= nftnl_expr_jool_parse,
+	.build		= nftnl_expr_jool_build,
+	.snprintf	= nftnl_expr_jool_snprintf,
+};
diff --git a/src/expr_ops.c b/src/expr_ops.c
index 3538dd6..80b9a86 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -38,6 +38,7 @@ extern struct expr_ops expr_ops_fib;
 extern struct expr_ops expr_ops_flow;
 extern struct expr_ops expr_ops_socket;
 extern struct expr_ops expr_ops_synproxy;
+extern struct expr_ops expr_ops_jool;
 extern struct expr_ops expr_ops_tunnel;
 extern struct expr_ops expr_ops_osf;
 extern struct expr_ops expr_ops_xfrm;
@@ -82,6 +83,7 @@ static struct expr_ops *expr_ops[] = {
 	&expr_ops_flow,
 	&expr_ops_socket,
 	&expr_ops_synproxy,
+	&expr_ops_jool,
 	&expr_ops_tunnel,
 	&expr_ops_osf,
 	&expr_ops_xfrm,
-- 
2.17.1

