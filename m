Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B556025B31B
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2025 15:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758641258; cv=none; b=jxHvx0NTCsccxZ2SZpIpJGmY+qxM2zn/fotvkw9tN50Doq0KPRLCS2mHOaogu/y9QpRg15XEeLBc0lZtHxTmgomFfN57g21UO2jcgZKFz7w1pXLoWSksNLJwg7PRxbJzF7ojA1u4FIp5lPgq0u3SGZ2Nh78VRvoCZXJf9cVnacU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758641258; c=relaxed/simple;
	bh=q0glxzuom7JBQDySrfKqyZIoc3CaW633TdPnEzySIzs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NzKrvNnQW7jQ7Oz+H3vHVBH1JHY3jaTvD6LVneVN50fmLt5dRbuZlZwpABqo3oB4moCgX7sBAl1EZubi9kmqiGwsKr0oleuz4nIEKdsQN8jtMVGodaneWeXgQkbGutlu/pkNDz/UWIGxEvcUCgNNOqI6XL2uXUsCvldlRDt3Zno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KMlcExvs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SlSsDhJO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KMlcExvs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SlSsDhJO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KMlcExvs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SlSsDhJO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KMlcExvs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SlSsDhJO"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 05A1B21DD3;
	Tue, 23 Sep 2025 15:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758641255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=geAS4gt6Bpw1pl/BS+vV4waFRF4pN0MZLEzgqlASXp4=;
	b=KMlcExvsWb3Yg64z6kzzfF/92ECIN2fErDueLT9FW43EBqCY1icbm9FmDRZxAND9Bz7ApL
	7qJGbGJDp1JdwtFsiqI2HmAGsU+u8X0TWT5qz86kC0CeKcoKPYXePXXTnxi3X2Xupq4qi0
	lKQRktg7eGC8B+SWj8kEuDhZwdnGR0k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758641255;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=geAS4gt6Bpw1pl/BS+vV4waFRF4pN0MZLEzgqlASXp4=;
	b=SlSsDhJOGWrkDl3EWBMldj7E2GERomMlnHAmECuGdM3sXEF3nTGS6aDsgrpjp9BbRnz6mc
	AkN4NaeM1QDeK/Ag==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758641255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=geAS4gt6Bpw1pl/BS+vV4waFRF4pN0MZLEzgqlASXp4=;
	b=KMlcExvsWb3Yg64z6kzzfF/92ECIN2fErDueLT9FW43EBqCY1icbm9FmDRZxAND9Bz7ApL
	7qJGbGJDp1JdwtFsiqI2HmAGsU+u8X0TWT5qz86kC0CeKcoKPYXePXXTnxi3X2Xupq4qi0
	lKQRktg7eGC8B+SWj8kEuDhZwdnGR0k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758641255;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=geAS4gt6Bpw1pl/BS+vV4waFRF4pN0MZLEzgqlASXp4=;
	b=SlSsDhJOGWrkDl3EWBMldj7E2GERomMlnHAmECuGdM3sXEF3nTGS6aDsgrpjp9BbRnz6mc
	AkN4NaeM1QDeK/Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B0D721388C;
	Tue, 23 Sep 2025 15:27:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0gxpKGa80mjiWQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 23 Sep 2025 15:27:34 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH RFC libnftnl] expr: add support to math expression
Date: Tue, 23 Sep 2025 17:27:10 +0200
Message-ID: <20250923152710.3652-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -2.80

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 include/libnftnl/expr.h             |   9 ++
 include/linux/netfilter/nf_tables.h |  34 +++++
 src/Makefile.am                     |   1 +
 src/expr/math.c                     | 207 ++++++++++++++++++++++++++++
 src/expr_ops.c                      |   2 +
 5 files changed, 253 insertions(+)
 create mode 100644 src/expr/math.c

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 1c07b54..b0c36b9 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -363,6 +363,15 @@ enum {
 	__NFTNL_EXPR_INNER_MAX
 };
 
+enum {
+	NFTNL_EXPR_MATH_SREG	= NFTNL_EXPR_BASE,
+	NFTNL_EXPR_MATH_DREG,
+	NFTNL_EXPR_MATH_OP,
+	NFTNL_EXPR_MATH_LEN,
+	NFTNL_EXPR_MATH_BYTEORDER,
+	__NFTNL_EXPR_MATH_MAX
+};
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 2beb30b..40bca48 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -2011,4 +2011,38 @@ enum nft_tunnel_attributes {
 };
 #define NFTA_TUNNEL_MAX	(__NFTA_TUNNEL_MAX - 1)
 
+/**
+ * enum nft_math_attributes - nftables math expression netlink attributes
+ *
+ * @NFTA_MATH_SREG: source register (NLA_U32: nft_registers)
+ * @NFTA_MATH_DREG: destination register (NLA_U32: nft_registers)
+ * @NFTA_MATH_OP: operation to be performed (NLA_U8)
+ * @NFTA_MATH_LEN: value length in bits (NLA_U8)
+ * @NFTA_MATH_BYTEORDER: byteorder of the value passed to the SREG (NLA_U8)
+ */
+enum nft_math_attributes {
+	NFTA_MATH_UNSPEC,
+	NFTA_MATH_SREG,
+	NFTA_MATH_DREG,
+	NFTA_MATH_OP,
+	NFTA_MATH_LEN,
+	NFTA_MATH_BYTEORDER,
+	__NFTA_MATH_MAX,
+};
+#define NFTA_MATH_MAX (__NFTA_MATH_MAX - 1)
+
+enum nft_math_op {
+	NFT_MATH_OP_INC,
+	NFT_MATH_OP_DEC,
+	__NFT_MATH_OP_MAX,
+};
+#define NFT_MATH_OP_MAX (__NFT_MATH_OP_MAX - 1)
+
+enum nft_math_byteorder {
+	NFT_MATH_BYTEORDER_HOST,
+	NFT_MATH_BYTEORDER_BIG,
+	__NFT_MATH_BYTEORDER_MAX,
+};
+#define NFT_MATH_BYTEORDER_MAX (__NFT_MATH_BYTEORDER_MAX - 1)
+
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/src/Makefile.am b/src/Makefile.am
index 1c38d00..90eafc4 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -62,6 +62,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/synproxy.c	\
 		      expr/osf.c	\
 		      expr/xfrm.c	\
+		      expr/math.c	\
 		      obj/counter.c	\
 		      obj/ct_helper.c	\
 		      obj/quota.c	\
diff --git a/src/expr/math.c b/src/expr/math.c
new file mode 100644
index 0000000..253bec1
--- /dev/null
+++ b/src/expr/math.c
@@ -0,0 +1,207 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * (C) 2025 by Fernando Fernandez Mancera <fmancera@suse.de>
+ */
+
+#include <arpa/inet.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include "internal.h"
+#include <libmnl/libmnl.h>
+#include <libnftnl/expr.h>
+#include <libnftnl/rule.h>
+
+struct nftnl_expr_math {
+	enum nft_registers sreg;
+	enum nft_registers dreg;
+	enum nft_math_op   op;
+	uint8_t		   len;
+	uint8_t		   byteorder;
+};
+
+static int nftnl_expr_math_set(struct nftnl_expr *e, uint16_t type,
+			       const void *data, uint32_t data_len)
+{
+	struct nftnl_expr_math *math = nftnl_expr_data(e);
+
+	switch(type) {
+	case NFTNL_EXPR_MATH_SREG:
+		memcpy(&math->sreg, data, data_len);
+		break;
+	case NFTNL_EXPR_MATH_DREG:
+		memcpy(&math->dreg, data, data_len);
+		break;
+	case NFTNL_EXPR_MATH_OP:
+		memcpy(&math->op, data, data_len);
+		break;
+	case NFTNL_EXPR_MATH_LEN:
+		memcpy(&math->len, data, data_len);
+		break;
+	case NFTNL_EXPR_MATH_BYTEORDER:
+		memcpy(&math->byteorder, data, data_len);
+		break;
+	}
+	return 0;
+}
+
+static const void *
+nftnl_expr_math_get(const struct nftnl_expr *e, uint16_t type,
+		    uint32_t *data_len)
+{
+	struct nftnl_expr_math *math = nftnl_expr_data(e);
+
+	switch(type) {
+	case NFTNL_EXPR_MATH_SREG:
+		*data_len = sizeof(math->sreg);
+		return &math->sreg;
+	case NFTNL_EXPR_MATH_DREG:
+		*data_len = sizeof(math->dreg);
+		return &math->dreg;
+	case NFTNL_EXPR_MATH_OP:
+		*data_len = sizeof(math->op);
+		return &math->op;
+	case NFTNL_EXPR_MATH_LEN:
+		*data_len = sizeof(math->len);
+		return &math->len;
+	case NFTNL_EXPR_MATH_BYTEORDER:
+		*data_len = sizeof(math->byteorder);
+		return &math->byteorder;
+	}
+	return NULL;
+}
+
+static void
+nftnl_expr_math_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
+{
+	struct nftnl_expr_math *math = nftnl_expr_data(e);
+
+	if ((e->flags & (1 << NFTNL_EXPR_MATH_SREG)) &&
+	    (e->flags & (1 << NFTNL_EXPR_MATH_DREG)) &&
+	    (e->flags & (1 << NFTNL_EXPR_MATH_LEN)) &&
+	    (e->flags & (1 << NFTNL_EXPR_MATH_OP)) &&
+	    (e->flags & (1 << NFTNL_EXPR_MATH_BYTEORDER))) {
+		mnl_attr_put_u32(nlh, NFTA_MATH_SREG, htonl(math->sreg));
+		mnl_attr_put_u32(nlh, NFTA_MATH_DREG, htonl(math->dreg));
+		mnl_attr_put_u8(nlh, NFTA_MATH_LEN, math->len);
+		mnl_attr_put_u8(nlh, NFTA_MATH_OP, math->op);
+		mnl_attr_put_u8(nlh, NFTA_MATH_BYTEORDER, math->byteorder);
+	}
+}
+
+static int nftnl_expr_math_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_MATH_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NFTNL_EXPR_MATH_SREG:
+	case NFTNL_EXPR_MATH_DREG:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	case NFTNL_EXPR_MATH_OP:
+	case NFTNL_EXPR_MATH_BYTEORDER:
+	case NFTNL_EXPR_MATH_LEN:
+		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static int
+nftnl_expr_math_parse(struct nftnl_expr *e, struct nlattr *attr)
+{
+	struct nftnl_expr_math *math = nftnl_expr_data(e);
+	struct nlattr *tb[NFTA_MATH_MAX + 1] = {};
+
+	if (mnl_attr_parse_nested(attr, nftnl_expr_math_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_MATH_SREG]) {
+		math->sreg = ntohl(mnl_attr_get_u32(tb[NFTA_MATH_SREG]));
+		e->flags |= (1 << NFTNL_EXPR_MATH_SREG);
+	}
+
+	if (tb[NFTA_MATH_DREG]) {
+		math->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_MATH_DREG]));
+		e->flags |= (1 << NFTNL_EXPR_MATH_DREG);
+	}
+
+	if (tb[NFTA_MATH_LEN]) {
+		math->len = mnl_attr_get_u8(tb[NFTA_MATH_LEN]);
+		e->flags |= (1 << NFTNL_EXPR_MATH_LEN);
+	}
+
+	if (tb[NFTA_MATH_OP]) {
+		math->op = mnl_attr_get_u8(tb[NFTA_MATH_OP]);
+		e->flags |= (1 << NFTNL_EXPR_MATH_OP);
+	}
+
+	if (tb[NFTA_MATH_BYTEORDER]) {
+		math->byteorder = mnl_attr_get_u8(tb[NFTA_MATH_BYTEORDER]);
+		e->flags |= (1 << NFTNL_EXPR_MATH_BYTEORDER);
+	}
+
+	return 0;
+}
+
+static const char *byteorder2str(enum nft_math_byteorder byteorder)
+{
+	switch (byteorder) {
+	case NFT_MATH_BYTEORDER_HOST:
+		return "host";
+	case NFT_MATH_BYTEORDER_BIG:
+		return "big";
+	default:
+		return "unknown";
+	}
+}
+
+static const char op2char(enum nft_math_op op)
+{
+	switch (op) {
+	case NFT_MATH_OP_INC:
+		return '+';
+	case NFT_MATH_OP_DEC:
+		return '-';
+	default:
+		return '?';
+	}
+}
+
+static int
+nftnl_expr_math_snprintf(char *buf, size_t len,
+			 uint32_t flags, const struct nftnl_expr *e)
+{
+	struct nftnl_expr_math *math = nftnl_expr_data(e);
+
+	return snprintf(buf, len, "math %u bits %s reg %u %c 1 => %u",
+			math->len, byteorder2str(math->byteorder),
+			math->sreg, op2char(math->op), math->dreg);
+}
+
+static struct attr_policy math_attr_policy[__NFTNL_EXPR_MATH_MAX] = {
+	[NFTNL_EXPR_MATH_SREG]		= { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_MATH_DREG]		= { .maxlen = sizeof(uint32_t) },
+	[NFTNL_EXPR_MATH_LEN]		= { .maxlen = sizeof(uint8_t) },
+	[NFTNL_EXPR_MATH_OP]		= { .maxlen = sizeof(uint8_t) },
+	[NFTNL_EXPR_MATH_BYTEORDER]	= { .maxlen = sizeof(uint8_t) },
+};
+
+struct expr_ops expr_ops_math = {
+	.name		= "math",
+	.alloc_len	= sizeof(struct nftnl_expr_math),
+	.nftnl_max_attr	= __NFTNL_EXPR_MATH_MAX - 1,
+	.attr_policy	= math_attr_policy,
+	.set		= nftnl_expr_math_set,
+	.get		= nftnl_expr_math_get,
+	.parse		= nftnl_expr_math_parse,
+	.build		= nftnl_expr_math_build,
+	.output		= nftnl_expr_math_snprintf,
+};
diff --git a/src/expr_ops.c b/src/expr_ops.c
index b85f472..b654fa0 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -43,6 +43,7 @@ extern struct expr_ops expr_ops_synproxy;
 extern struct expr_ops expr_ops_tunnel;
 extern struct expr_ops expr_ops_osf;
 extern struct expr_ops expr_ops_xfrm;
+extern struct expr_ops expr_ops_math;
 
 static struct expr_ops expr_ops_notrack = {
 	.name	= "notrack",
@@ -89,6 +90,7 @@ static struct expr_ops *expr_ops[] = {
 	&expr_ops_tunnel,
 	&expr_ops_osf,
 	&expr_ops_xfrm,
+	&expr_ops_math,
 	NULL,
 };
 
-- 
2.51.0

