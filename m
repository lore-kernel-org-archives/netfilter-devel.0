Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E291922F1
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 11:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728474509; cv=none; b=iI2fOg8ZNAvFb3/6dfcxJABgx+yEB+b1aHmHUM/xTJaqSoE7aMKzsfsmhg77Vs7Lct8N/zbNAOsgzQa5H8a4wVunH9PGkPZabhkdhfk/Kq8fn0POnp3alcAC3R0kd6d3VlkMCmnMkpfgFjAV4YlQA6w7x2CHpnrJF1kmSLoku1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728474509; c=relaxed/simple;
	bh=Yglo4cw6b8wlu80i7xIrPGHVrx1lSdQwp8eU5n1+iLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fb+U3ZNqRXL637UtYlRztUJ8pjSV1nyfC+yRDWg2oiSmpkTtDa/bdbliFupNSdMf7Jx5AzyUIYx3WvEYADezf7bo9OhD1GFAcSGnDw4pvJ+maDhnGKLbgVw4ayfkTxk5hVAmnPMDGxtZXJtxg6wGK5Cx9s+oh7VxBJk49PKkJ+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=V4RZV+6y; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="V4RZV+6y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=AWJDo+zj40CvuAoMCnQ1XQZTcUdUGPHPmK7MdAe6lP8=; b=V4RZV+6yvl6sSsQ2E/WmZ6Obpr
	FUqqoqthE2VtWsscj29Ps/hmw5JfZ7W9LzIvpevfGG7/bhy2eaQb5d51eucy5u4qvhoXwUzrJwbyh
	uyp+KScFdni7gHjZv9ZGd7kPOSVRt7IUvLhWs0GLUG2gro3ebESmQhugYpFZJ+6B5vc4LG3hyR9s4
	inQfrzV/v2FjpvZHUmP+HgKutuM4aCWvtAPHxp7OtuMcKks7t5cjmb3PSgq+RF3u5umfDZTm5389e
	rYTGFGd9D68zspmPf0wij21ZburI4Q1sr8QOQmlLUsw8ZQIdLei1qTpsBHiD0gmH3kPX4imWuwXmb
	ugHNWqIw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1syVB4-000000008Hi-1hfn;
	Wed, 09 Oct 2024 13:48:26 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 5/8] nft-ruleparse: Fallback to compat expressions in userdata
Date: Wed,  9 Oct 2024 13:48:16 +0200
Message-ID: <20241009114819.15379-6-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241009114819.15379-1-phil@nwl.cc>
References: <20241009114819.15379-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If parsing of a rule fails (e.g. due to an unknown native expression),
check if userdata contains a UDATA_TYPE_COMPAT_EXT attribute and retry
parsing the rule preferring the contained extensions instead of native
expressions.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 configure.ac             |   9 +++
 iptables/Makefile.am     |   1 +
 iptables/nft-compat.c    | 148 +++++++++++++++++++++++++++++++++++++++
 iptables/nft-compat.h    |  29 ++++++++
 iptables/nft-ruleparse.c |  17 +++++
 5 files changed, 204 insertions(+)
 create mode 100644 iptables/nft-compat.c
 create mode 100644 iptables/nft-compat.h

diff --git a/configure.ac b/configure.ac
index a19a60c03c5b2..4cc4960598822 100644
--- a/configure.ac
+++ b/configure.ac
@@ -77,6 +77,14 @@ AC_ARG_WITH([xt-lock-name], AS_HELP_STRING([--with-xt-lock-name=PATH],
 AC_ARG_ENABLE([profiling],
 	AS_HELP_STRING([--enable-profiling], [build for use of gcov/gprof]),
 	[enable_profiling="$enableval"], [enable_profiling="no"])
+AC_ARG_WITH([zlib], [AS_HELP_STRING([--without-zlib],
+	    [Disable payload compression of rule compat expressions])],
+           [], [with_zlib=yes])
+AS_IF([test "x$with_zlib" != xno], [
+       AC_CHECK_LIB([z], [compress], ,
+		    AC_MSG_ERROR([No suitable version of zlib found]))
+       AC_DEFINE([HAVE_ZLIB], [1], [Define if you have zlib])
+])
 
 AC_MSG_CHECKING([whether $LD knows -Wl,--no-undefined])
 saved_LDFLAGS="$LDFLAGS";
@@ -289,6 +297,7 @@ echo "
   nftables support:			${enable_nftables}
   connlabel support:			${enable_connlabel}
   profiling support:			${enable_profiling}
+  compress rule compat expressions:	${with_zlib}
 
 Build parameters:
   Put plugins into executable (static):	${enable_static}
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 2007cd10260bd..4855c9a7c2911 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -57,6 +57,7 @@ xtables_nft_multi_SOURCES += nft.c nft.h \
 			     nft-ruleparse-arp.c nft-ruleparse-bridge.c \
 			     nft-ruleparse-ipv4.c nft-ruleparse-ipv6.c \
 			     nft-shared.c nft-shared.h \
+			     nft-compat.c nft-compat.h \
 			     xtables-monitor.c \
 			     xtables.c xtables-arp.c xtables-eb.c \
 			     xtables-standalone.c xtables-eb-standalone.c \
diff --git a/iptables/nft-compat.c b/iptables/nft-compat.c
new file mode 100644
index 0000000000000..1edf08851c579
--- /dev/null
+++ b/iptables/nft-compat.c
@@ -0,0 +1,148 @@
+/*
+ * (C) 2024 Red Hat GmbH
+ * Author: Phil Sutter <phil@nwl.cc>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include "config.h"
+#include "nft-compat.h"
+#include "nft-ruleparse.h"
+#include "nft.h"
+
+#include <stdlib.h>
+#include <string.h>
+#include <xtables.h>
+
+#ifdef HAVE_ZLIB
+#include <zlib.h>
+#endif
+
+#include <libnftnl/udata.h>
+
+static struct rule_udata_ext *
+rule_get_udata_ext(const struct nftnl_rule *r, uint32_t *outlen)
+{
+	const struct nftnl_udata *tb[UDATA_TYPE_MAX + 1] = {};
+	struct nftnl_udata_buf *udata;
+	uint32_t udatalen;
+
+	udata = (void *)nftnl_rule_get_data(r, NFTNL_RULE_USERDATA, &udatalen);
+	if (!udata)
+		return NULL;
+
+	if (nftnl_udata_parse(udata, udatalen, parse_udata_cb, tb) < 0)
+		return NULL;
+
+	if (!tb[UDATA_TYPE_COMPAT_EXT])
+		return NULL;
+
+	if (outlen)
+		*outlen = nftnl_udata_len(tb[UDATA_TYPE_COMPAT_EXT]);
+	return nftnl_udata_get(tb[UDATA_TYPE_COMPAT_EXT]);
+}
+
+static struct nftnl_expr *
+__nftnl_expr_from_udata_ext(struct rule_udata_ext *rue, const void *data)
+{
+	struct nftnl_expr *expr = NULL;
+
+	switch (rue->flags & RUE_FLAG_TYPE_BITS) {
+	case RUE_FLAG_MATCH_TYPE:
+		expr = nftnl_expr_alloc("match");
+		__add_match(expr, data);
+		break;
+	case RUE_FLAG_TARGET_TYPE:
+		expr = nftnl_expr_alloc("target");
+		__add_target(expr, data);
+		break;
+	default:
+		fprintf(stderr,
+			"Warning: Unexpected udata extension type %d\n",
+			rue->flags & RUE_FLAG_TYPE_BITS);
+	}
+
+	return expr;
+}
+
+static struct nftnl_expr *
+nftnl_expr_from_zipped_udata_ext(struct rule_udata_ext *rue)
+{
+#ifdef HAVE_ZLIB
+	uLongf datalen = rue->orig_size;
+	struct nftnl_expr *expr = NULL;
+	void *data;
+
+	data = xtables_malloc(datalen);
+	if (uncompress(data, &datalen, rue->data, rue->size) != Z_OK) {
+		fprintf(stderr, "Warning: Failed to uncompress rule udata extension\n");
+		goto out;
+	}
+
+	expr = __nftnl_expr_from_udata_ext(rue, data);
+out:
+	free(data);
+	return expr;
+#else
+	fprintf(stderr, "Warning: Zipped udata extensions are not supported.\n");
+	return NULL;
+#endif
+}
+
+static struct nftnl_expr *nftnl_expr_from_udata_ext(struct rule_udata_ext *rue)
+{
+	if (rue->flags & RUE_FLAG_ZIP)
+		return nftnl_expr_from_zipped_udata_ext(rue);
+	else
+		return __nftnl_expr_from_udata_ext(rue, rue->data);
+}
+
+bool rule_has_udata_ext(const struct nftnl_rule *r)
+{
+	return rule_get_udata_ext(r, NULL) != NULL;
+}
+
+#define rule_udata_ext_foreach(rue, ext, extlen)			\
+	for (rue = (void *)(ext);					\
+	     (char *)rue < (char *)(ext) + extlen;			\
+	     rue = (void *)((char *)rue + sizeof(*rue) + rue->size))
+
+bool rule_parse_udata_ext(struct nft_xt_ctx *ctx, const struct nftnl_rule *r)
+{
+	struct rule_udata_ext *rue;
+	struct nftnl_expr *expr;
+	uint32_t extlen;
+	bool ret = true;
+	int eidx = 0;
+	void *ext;
+
+	ext = rule_get_udata_ext(r, &extlen);
+	if (!ext)
+		return false;
+
+	rule_udata_ext_foreach(rue, ext, extlen) {
+		for (; eidx < rue->start_idx; eidx++) {
+			expr = nftnl_expr_iter_next(ctx->iter);
+			if (!nft_parse_rule_expr(ctx->h, expr, ctx))
+				ret = false;
+		}
+
+		expr = nftnl_expr_from_udata_ext(rue);
+		if (!nft_parse_rule_expr(ctx->h, expr, ctx))
+			ret = false;
+		nftnl_expr_free(expr);
+
+		for (; eidx < rue->end_idx; eidx++)
+			nftnl_expr_iter_next(ctx->iter);
+	}
+	expr = nftnl_expr_iter_next(ctx->iter);
+	while (expr != NULL) {
+		if (!nft_parse_rule_expr(ctx->h, expr, ctx))
+			ret = false;
+		expr = nftnl_expr_iter_next(ctx->iter);
+	}
+	return ret;
+}
+
diff --git a/iptables/nft-compat.h b/iptables/nft-compat.h
new file mode 100644
index 0000000000000..1147f08a0b6d5
--- /dev/null
+++ b/iptables/nft-compat.h
@@ -0,0 +1,29 @@
+#ifndef _NFT_COMPAT_H_
+#define _NFT_COMPAT_H_
+
+#include <libnftnl/rule.h>
+
+#include <linux/netfilter/x_tables.h>
+
+enum rule_udata_ext_flags {
+	RUE_FLAG_MATCH_TYPE	= (1 << 0),
+	RUE_FLAG_TARGET_TYPE	= (1 << 1),
+	RUE_FLAG_ZIP		= (1 << 7),
+};
+#define RUE_FLAG_TYPE_BITS	(RUE_FLAG_MATCH_TYPE | RUE_FLAG_TARGET_TYPE)
+
+struct rule_udata_ext {
+	uint8_t start_idx;
+	uint8_t end_idx;
+	uint8_t flags;
+	uint16_t orig_size;
+	uint16_t size;
+	unsigned char data[];
+};
+
+struct nft_xt_ctx;
+
+bool rule_has_udata_ext(const struct nftnl_rule *r);
+bool rule_parse_udata_ext(struct nft_xt_ctx *ctx, const struct nftnl_rule *r);
+
+#endif /* _NFT_COMPAT_H_ */
diff --git a/iptables/nft-ruleparse.c b/iptables/nft-ruleparse.c
index 757d3c29fc816..34270e46ae888 100644
--- a/iptables/nft-ruleparse.c
+++ b/iptables/nft-ruleparse.c
@@ -10,6 +10,7 @@
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
+#include "config.h"
 #include <stdbool.h>
 #include <stdlib.h>
 #include <string.h>
@@ -27,6 +28,7 @@
 
 #include <xtables.h>
 
+#include "nft-compat.h"
 #include "nft-ruleparse.h"
 #include "nft.h"
 
@@ -948,6 +950,21 @@ bool nft_rule_to_iptables_command_state(struct nft_handle *h,
 			ret = false;
 		expr = nftnl_expr_iter_next(ctx.iter);
 	}
+	if (!ret && rule_has_udata_ext(r)) {
+		fprintf(stderr,
+			"Warning: Rule parser failed, trying compat fallback\n");
+
+		h->ops->clear_cs(cs);
+		if (h->ops->init_cs)
+			h->ops->init_cs(cs);
+
+		nftnl_expr_iter_destroy(ctx.iter);
+		ctx.iter = nftnl_expr_iter_create(r);
+		if (!ctx.iter)
+			return false;
+
+		ret = rule_parse_udata_ext(&ctx, r);
+	}
 
 	nftnl_expr_iter_destroy(ctx.iter);
 
-- 
2.43.0

