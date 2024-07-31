Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20B316D333
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2024 22:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722464833; cv=none; b=BBkyTXxNT9+X6uCV7AhYLfJF53WZotcvnn03zaa+Bqj/TTk0FlWSna4t7OLdFOulTkCMsSvLbm3UPi1iB//bGcZW8MMtQgVJJehb00bDvSxIFZu8Syes/AWPWsdvP+aLTj+0ow7M5naA9IO+nDLUq7lbKw7/KwvZ8TRN4xvZqOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722464833; c=relaxed/simple;
	bh=H7IXfE+dIkWNgFxRDkpbw82A4FkJSh9aJ+FvQh/R8WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIPja4IjIg9CMLT8N/w9doxlRuV+zRxE5l+cAKXM7rHiJcPLpPyU1SRn1mnQQXUeB1laFd0Yo/gnUJIkpSi4IaFYZlAPVDBvGgadDLo/ZOFcRwUefyQlkuCydwXhaWMlb7g+2Pm96zcnYGkbadvESjpW1Bi7DUHpv0XdhT2z3b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ANGLEUxc; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ANGLEUxc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4gLRHQPZP7p1smcB+HX//PzsxhJJSCWT/YJN8tkJ6ts=; b=ANGLEUxcLX1Wta+dtFZ/g202Zs
	UcGIhklRcpeX0kOoSq46TwDbXXxqt7JffOHOcZm2VlvC59P3tp0oBWtFWb9EynM1ZIwP5oeEEhFxI
	TuxlQfsM3DnQyU4Te5BXKNUwOgI60eSiBjIQr2x9BqDTW/p//t7dWk6JSe/Sxx8zxWV5l72109HBP
	hibBoKk2AtxypMbQwRTE+sCq97Wak44/pKh5VOSUC8ub2BA8KMeHUKhGo8zR+tRz1ZfpLrJ9jPktj
	c+RCbWmBsTi442zlAzO8fRjKyAuB5bMSpRHxgD/fF9+qClkkRR3JOO0s8iC3RoTod4cc6OyqZwe/o
	IuqhIENQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sZHml-000000003iH-3gWf;
	Thu, 01 Aug 2024 00:27:08 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
Subject: [iptables RFC PATCH 8/8] nft: Support compat extensions in rule userdata
Date: Thu,  1 Aug 2024 00:27:03 +0200
Message-ID: <20240731222703.22741-9-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240731222703.22741-1-phil@nwl.cc>
References: <20240731222703.22741-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a mechanism providing forward compatibility for the current and
future versions of iptables-nft (and all other nft-variants) by
annotating nftnl rules with the extensions they were created for.

Upon nftnl rule parsing failure, warn about the situation and perform a
second attempt loading the respective compat extensions instead of the
native expressions which replace them. The foundational assumption is
that libxtables extensions are stable and thus the VM code created on
their behalf does not need to be.

Since nftnl rule userdata attributes are restricted to 255 bytes, the
implementation focusses on low memory consumption. Therefore, extensions
which remain in the rule as compat expressions are not also added to
userdata. In turn, extensions in userdata are annotated by start and end
expression number they are replacing. Also, the actual payload is
zipped using zlib.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 configure.ac             |   9 ++
 iptables/Makefile.am     |   1 +
 iptables/nft-compat.c    | 217 +++++++++++++++++++++++++++++++++++++++
 iptables/nft-compat.h    |  54 ++++++++++
 iptables/nft-ruleparse.c |  21 ++++
 iptables/nft.c           |  39 +++++--
 6 files changed, 331 insertions(+), 10 deletions(-)
 create mode 100644 iptables/nft-compat.c
 create mode 100644 iptables/nft-compat.h

diff --git a/configure.ac b/configure.ac
index 2293702b17a47..a18df531953d6 100644
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
@@ -270,6 +278,7 @@ echo "
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
index 0000000000000..2e37dee6cdc43
--- /dev/null
+++ b/iptables/nft-compat.c
@@ -0,0 +1,217 @@
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
+int nftnl_rule_expr_count(const struct nftnl_rule *r)
+{
+	struct nftnl_expr_iter *iter = nftnl_expr_iter_create(r);
+	int cnt = 0;
+
+	if (!iter)
+		return -1;
+
+	while (nftnl_expr_iter_next(iter))
+		cnt++;
+
+	nftnl_expr_iter_destroy(iter);
+	return cnt;
+}
+
+static struct rule_udata_ext *
+__rule_get_udata_ext(const void *data, uint32_t data_len, uint32_t *outlen)
+{
+	const struct nftnl_udata *tb[UDATA_TYPE_MAX + 1] = {};
+
+	if (nftnl_udata_parse(data, data_len, parse_udata_cb, tb) < 0)
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
+struct rule_udata_ext *
+rule_get_udata_ext(const struct nftnl_rule *r, uint32_t *outlen)
+{
+	struct nftnl_udata_buf *udata;
+	uint32_t udatalen;
+
+	udata = (void *)nftnl_rule_get_data(r, NFTNL_RULE_USERDATA, &udatalen);
+	if (!udata)
+		return NULL;
+
+	return __rule_get_udata_ext(udata, udatalen, outlen);
+}
+
+static void
+pack_rule_udata_ext_data(struct rule_udata_ext *rue,
+			 const void *data, size_t datalen)
+{
+	size_t datalen_out = datalen;
+#ifdef HAVE_ZLIB
+	compress(rue->data, &datalen_out, data, datalen);
+	rue->zip = true;
+#else
+	memcpy(rue->data, data, datalen);
+#endif
+	rue->size = datalen_out;
+}
+
+void rule_add_udata_ext(struct nftnl_rule *r,
+			uint16_t start_idx, uint16_t end_idx,
+			uint8_t type, uint16_t size, const void *data)
+{
+	struct rule_udata_ext *ext = NULL;
+	uint32_t extlen = 0, newextlen;
+	char *newext;
+	void *udata;
+
+	ext = rule_get_udata_ext(r, &extlen);
+	if (!ext)
+		extlen = 0;
+
+	udata = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
+	if (!udata)
+		xtables_error(OTHER_PROBLEM, "can't alloc memory!");
+
+	newextlen = sizeof(*ext) + size;
+	newext = xtables_malloc(extlen + newextlen);
+	if (extlen)
+		memcpy(newext, ext, extlen);
+	memset(newext + extlen, 0, newextlen);
+
+	ext = (struct rule_udata_ext *)(newext + extlen);
+	ext->start_idx = start_idx;
+	ext->end_idx = end_idx;
+	ext->type = type;
+	ext->orig_size = size;
+	pack_rule_udata_ext_data(ext, data, size);
+	newextlen = sizeof(*ext) + ext->size;
+
+	if (!nftnl_udata_put(udata, UDATA_TYPE_COMPAT_EXT,
+			     extlen + newextlen, newext) ||
+	    nftnl_rule_set_data(r, NFTNL_RULE_USERDATA,
+				nftnl_udata_buf_data(udata),
+				nftnl_udata_buf_len(udata)))
+		xtables_error(OTHER_PROBLEM, "can't alloc memory!");
+
+	free(newext);
+	nftnl_udata_buf_free(udata);
+}
+
+static struct nftnl_expr *
+__nftnl_expr_from_udata_ext(struct rule_udata_ext *rue, const void *data)
+{
+	struct nftnl_expr *expr = NULL;
+
+	switch (rue->type) {
+	case RUE_TYPE_MATCH:
+		expr = nftnl_expr_alloc("match");
+		__add_match(expr, data);
+		break;
+	case RUE_TYPE_TARGET:
+		expr = nftnl_expr_alloc("target");
+		__add_target(expr, data);
+		break;
+	default:
+		fprintf(stderr,
+			"Warning: Unexpected udata extension type %d\n",
+			rue->type);
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
+	if (rue->zip)
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
index 0000000000000..e91e2299bd2ae
--- /dev/null
+++ b/iptables/nft-compat.h
@@ -0,0 +1,54 @@
+#ifndef _NFT_COMPAT_H_
+#define _NFT_COMPAT_H_
+
+#include <libnftnl/rule.h>
+
+#include <linux/netfilter/x_tables.h>
+
+int nftnl_rule_expr_count(const struct nftnl_rule *r);
+
+enum rule_udata_ext_type {
+	RUE_TYPE_MATCH = 0,
+	RUE_TYPE_TARGET = 1,
+};
+
+struct rule_udata_ext {
+	uint8_t start_idx;
+	uint8_t end_idx;
+	uint8_t type;
+	uint8_t zip:1;
+	uint16_t orig_size;
+	uint16_t size;
+	unsigned char data[];
+};
+
+struct rule_udata_ext *
+rule_get_udata_ext(const struct nftnl_rule *r, uint32_t *outlen);
+
+void rule_add_udata_ext(struct nftnl_rule *r,
+			uint16_t start_idx, uint16_t end_idx,
+			uint8_t type, uint16_t size, const void *data);
+static inline void
+rule_add_udata_match(struct nftnl_rule *r,
+		     uint16_t start_idx, uint16_t end_idx,
+		     const struct xt_entry_match *m)
+{
+	rule_add_udata_ext(r, start_idx, end_idx,
+			   RUE_TYPE_MATCH, m->u.match_size, m);
+}
+
+static inline void
+rule_add_udata_target(struct nftnl_rule *r,
+		      uint16_t start_idx, uint16_t end_idx,
+		      const struct xt_entry_target *t)
+{
+	rule_add_udata_ext(r, start_idx, end_idx,
+			   RUE_TYPE_TARGET, t->u.target_size, t);
+}
+
+struct nft_xt_ctx;
+
+bool rule_has_udata_ext(const struct nftnl_rule *r);
+bool rule_parse_udata_ext(struct nft_xt_ctx *ctx, const struct nftnl_rule *r);
+
+#endif /* _NFT_COMPAT_H_ */
diff --git a/iptables/nft-ruleparse.c b/iptables/nft-ruleparse.c
index 757d3c29fc816..b58e16fff45cd 100644
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
 
@@ -948,6 +950,25 @@ bool nft_rule_to_iptables_command_state(struct nft_handle *h,
 			ret = false;
 		expr = nftnl_expr_iter_next(ctx.iter);
 	}
+#ifdef DEBUG_COMPAT_EXT
+	if (rule_has_udata_ext(r))
+		ret = false;
+#endif
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
 
diff --git a/iptables/nft.c b/iptables/nft.c
index 64ac35f2edcf3..de20d9714695f 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -9,6 +9,7 @@
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
+#include "config.h"
 #include <unistd.h>
 #include <fcntl.h>
 #include <sys/types.h>
@@ -60,6 +61,7 @@
 #include "nft-cache.h"
 #include "nft-shared.h"
 #include "nft-bridge.h" /* EBT_NOPROTO */
+#include "nft-compat.h"
 
 static void *nft_fn;
 
@@ -1049,6 +1051,7 @@ void __add_match(struct nftnl_expr *e, const struct xt_entry_match *m)
 static int add_nft_limit(struct nftnl_rule *r, struct xt_entry_match *m)
 {
 	struct xt_rateinfo *rinfo = (void *)m->data;
+	int i, ecnt = nftnl_rule_expr_count(r);
 	static const uint32_t mult[] = {
 		XT_LIMIT_SCALE*24*60*60,	/* day */
 		XT_LIMIT_SCALE*60*60,		/* hour */
@@ -1056,7 +1059,8 @@ static int add_nft_limit(struct nftnl_rule *r, struct xt_entry_match *m)
 		XT_LIMIT_SCALE,			/* sec */
 	};
 	struct nftnl_expr *expr;
-	int i;
+
+	rule_add_udata_match(r, ecnt, ecnt + 1, m);
 
 	expr = nftnl_expr_alloc("limit");
 	if (!expr)
@@ -1371,6 +1375,7 @@ static bool udp_all_zero(const struct xt_udp *u)
 static int add_nft_udp(struct nft_handle *h, struct nftnl_rule *r,
 		       struct xt_entry_match *m)
 {
+	int ret, ecnt = nftnl_rule_expr_count(r);
 	struct xt_udp *udp = (void *)m->data;
 
 	if (udp->invflags > XT_UDP_INV_MASK ||
@@ -1385,8 +1390,12 @@ static int add_nft_udp(struct nft_handle *h, struct nftnl_rule *r,
 	if (nftnl_rule_get_u32(r, NFTNL_RULE_COMPAT_PROTO) != IPPROTO_UDP)
 		xtables_error(PARAMETER_PROBLEM, "UDP match requires '-p udp'");
 
-	return add_nft_tcpudp(h, r, udp->spts, udp->invflags & XT_UDP_INV_SRCPT,
-			      udp->dpts, udp->invflags & XT_UDP_INV_DSTPT);
+	ret = add_nft_tcpudp(h, r, udp->spts, udp->invflags & XT_UDP_INV_SRCPT,
+			     udp->dpts, udp->invflags & XT_UDP_INV_DSTPT);
+
+	rule_add_udata_match(r, ecnt, nftnl_rule_expr_count(r), m);
+
+	return ret;
 }
 
 static int add_nft_tcpflags(struct nft_handle *h, struct nftnl_rule *r,
@@ -1423,6 +1432,7 @@ static int add_nft_tcp(struct nft_handle *h, struct nftnl_rule *r,
 		       struct xt_entry_match *m)
 {
 	static const uint8_t supported = XT_TCP_INV_SRCPT | XT_TCP_INV_DSTPT | XT_TCP_INV_FLAGS;
+	int ret, ecnt = nftnl_rule_expr_count(r);
 	struct xt_tcp *tcp = (void *)m->data;
 
 	if (tcp->invflags & ~supported || tcp->option ||
@@ -1438,23 +1448,27 @@ static int add_nft_tcp(struct nft_handle *h, struct nftnl_rule *r,
 		xtables_error(PARAMETER_PROBLEM, "TCP match requires '-p tcp'");
 
 	if (tcp->flg_mask) {
-		int ret = add_nft_tcpflags(h, r, tcp->flg_cmp, tcp->flg_mask,
-					   tcp->invflags & XT_TCP_INV_FLAGS);
+		ret = add_nft_tcpflags(h, r, tcp->flg_cmp, tcp->flg_mask,
+				       tcp->invflags & XT_TCP_INV_FLAGS);
 
 		if (ret < 0)
 			return ret;
 	}
 
-	return add_nft_tcpudp(h, r, tcp->spts, tcp->invflags & XT_TCP_INV_SRCPT,
-			      tcp->dpts, tcp->invflags & XT_TCP_INV_DSTPT);
+	ret = add_nft_tcpudp(h, r, tcp->spts, tcp->invflags & XT_TCP_INV_SRCPT,
+			     tcp->dpts, tcp->invflags & XT_TCP_INV_DSTPT);
+
+	rule_add_udata_match(r, ecnt, nftnl_rule_expr_count(r), m);
+
+	return ret;
 }
 
 static int add_nft_mark(struct nft_handle *h, struct nftnl_rule *r,
 			struct xt_entry_match *m)
 {
 	struct xt_mark_mtinfo1 *mark = (void *)m->data;
+	int op, ecnt = nftnl_rule_expr_count(r);
 	uint8_t reg;
-	int op;
 
 	add_meta(h, r, NFT_META_MARK, &reg);
 	if (mark->mask != 0xffffffff)
@@ -1467,6 +1481,8 @@ static int add_nft_mark(struct nft_handle *h, struct nftnl_rule *r,
 
 	add_cmp_u32(r, mark->mark, op, reg);
 
+	rule_add_udata_match(r, ecnt, nftnl_rule_expr_count(r), m);
+
 	return 0;
 }
 
@@ -1517,10 +1533,13 @@ void __add_target(struct nftnl_expr *e, const struct xt_entry_target *t)
 	nftnl_expr_set(e, NFTNL_EXPR_TG_INFO, info, t->u.target_size - sizeof(*t));
 }
 
-static int add_meta_nftrace(struct nftnl_rule *r)
+static int add_meta_nftrace(struct nftnl_rule *r, struct xt_entry_target *t)
 {
+	int ecnt = nftnl_rule_expr_count(r);
 	struct nftnl_expr *expr;
 
+	rule_add_udata_target(r, ecnt, ecnt + 2, t);
+
 	expr = nftnl_expr_alloc("immediate");
 	if (expr == NULL)
 		return -ENOMEM;
@@ -1544,7 +1563,7 @@ int add_target(struct nftnl_rule *r, struct xt_entry_target *t)
 	struct nftnl_expr *expr;
 
 	if (strcmp(t->u.user.name, "TRACE") == 0)
-		return add_meta_nftrace(r);
+		return add_meta_nftrace(r, t);
 
 	expr = nftnl_expr_alloc("target");
 	if (expr == NULL)
-- 
2.43.0

