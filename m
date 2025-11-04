Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A9233BBC2
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Nov 2025 17:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762276326; cv=none; b=B+ygw7FPcYLCV2vzrYttI0LwHbDh4a6pf8N62w1170UEP2/3a0dX6qyHblmh42wm7kCc90EqmL6rdEOTH3/7NThcW0BDYcwRRa24yo2IJYv4yWPHjGgN2vQlpaEmY6QpNiFJIOIqEsg1v3j8nOzoHBq/uADjJNGzLaiUrMqcNHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762276326; c=relaxed/simple;
	bh=1Sl8ACgzEyQtMTsVk3MrtKbk+JyTwowndoSaXejdxtw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gUxoZEcDX86PDntyzOzu8OVN/+rMOKMLNBsw4Q15vz2uOcGma6CqqL1nTMDSueWwQLd5aBAYC7Y3MbKIUSJeiyREGRZgcFcxZ2ZoxR1Y4BYunOzo4FZKfS3ukRIB+9rKYV9uV7m+snzHsXeTywpwbfA9p7+QDrs888449pxFMl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=a16EulL8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=o0UFBDs+; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=a16EulL8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=o0UFBDs+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="a16EulL8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="o0UFBDs+";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="a16EulL8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="o0UFBDs+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7BBE11F387;
	Tue,  4 Nov 2025 17:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762276320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Jzi4ALIZ7XfwKQA6bbCbN/X/ZTZHwqO5rQBi0O7IgHE=;
	b=a16EulL8x2kQLSYFmHq5ohU9/LwWTmJU6Dx1ZDxawO93HqD8WYPYlM1nMAjdjb/8pxeO4d
	eEg8n03/2JJExok9JixOciyyt98QW8ZYc5j7tvLj3I+7gNjSeaTNfWd273qoyz0WKOkSNW
	NDbzHx2aL3P5lNdX6ZVnE2nIJMig5jI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762276320;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Jzi4ALIZ7XfwKQA6bbCbN/X/ZTZHwqO5rQBi0O7IgHE=;
	b=o0UFBDs+qrP92XJH3quutvxsySxOy60d5OFsdZyP++MC9Rf3rAoqoib3Rg2zyqw9GyZOJN
	9RHAvRcflrFjvFDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=a16EulL8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o0UFBDs+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762276320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Jzi4ALIZ7XfwKQA6bbCbN/X/ZTZHwqO5rQBi0O7IgHE=;
	b=a16EulL8x2kQLSYFmHq5ohU9/LwWTmJU6Dx1ZDxawO93HqD8WYPYlM1nMAjdjb/8pxeO4d
	eEg8n03/2JJExok9JixOciyyt98QW8ZYc5j7tvLj3I+7gNjSeaTNfWd273qoyz0WKOkSNW
	NDbzHx2aL3P5lNdX6ZVnE2nIJMig5jI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762276320;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Jzi4ALIZ7XfwKQA6bbCbN/X/ZTZHwqO5rQBi0O7IgHE=;
	b=o0UFBDs+qrP92XJH3quutvxsySxOy60d5OFsdZyP++MC9Rf3rAoqoib3Rg2zyqw9GyZOJN
	9RHAvRcflrFjvFDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 37535139A9;
	Tue,  4 Nov 2025 17:12:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0JB8CuAzCmkMcgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 04 Nov 2025 17:12:00 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH libnftnl] src: add connlimit stateful object support
Date: Tue,  4 Nov 2025 18:11:51 +0100
Message-ID: <20251104171151.29350-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 7BBE11F387
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -3.01

Add all the implementation needed to handle connlimit objects.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 include/libnftnl/object.h |   6 ++
 include/obj.h             |   5 ++
 src/Makefile.am           |   1 +
 src/obj/connlimit.c       | 129 ++++++++++++++++++++++++++++++++++++++
 src/object.c              |   1 +
 5 files changed, 142 insertions(+)
 create mode 100644 src/obj/connlimit.c

diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
index 490e8b4..fb81385 100644
--- a/include/libnftnl/object.h
+++ b/include/libnftnl/object.h
@@ -146,6 +146,12 @@ enum {
 	NFTNL_TUNNEL_GENEVE_DATA,
 };
 
+enum {
+	NFTNL_OBJ_CONNLIMIT_COUNT = NFTNL_OBJ_BASE,
+	NFTNL_OBJ_CONNLIMIT_FLAGS,
+	__NFTNL_OBJ_CONNLIMIT_MAX,
+};
+
 struct nftnl_tunnel_opt;
 struct nftnl_tunnel_opts;
 
diff --git a/include/obj.h b/include/obj.h
index 5d3c4ec..811680e 100644
--- a/include/obj.h
+++ b/include/obj.h
@@ -83,6 +83,10 @@ struct nftnl_obj {
 		struct nftnl_obj_secmark {
 			char		ctx[NFT_SECMARK_CTX_MAXLEN];
 		} secmark;
+		struct nftnl_obj_connlimit {
+			uint32_t	count;
+			uint32_t	flags;
+		} connlimit;
 	} data;
 };
 
@@ -108,6 +112,7 @@ extern struct obj_ops obj_ops_limit;
 extern struct obj_ops obj_ops_synproxy;
 extern struct obj_ops obj_ops_tunnel;
 extern struct obj_ops obj_ops_secmark;
+extern struct obj_ops obj_ops_connlimit;
 
 #define nftnl_obj_data(obj) (void *)&obj->data
 
diff --git a/src/Makefile.am b/src/Makefile.am
index 1c38d00..14c6dd5 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -71,4 +71,5 @@ libnftnl_la_SOURCES = utils.c		\
 		      obj/ct_timeout.c 	\
 		      obj/secmark.c	\
 		      obj/ct_expect.c 	\
+		      obj/connlimit.c	\
 		      libnftnl.map
diff --git a/src/obj/connlimit.c b/src/obj/connlimit.c
new file mode 100644
index 0000000..34c0558
--- /dev/null
+++ b/src/obj/connlimit.c
@@ -0,0 +1,129 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * (C) 2025 by Fernando Fernandez Mancera <fmancera@suse.de>
+ */
+
+#include <stdio.h>
+#include <stdint.h>
+#include <arpa/inet.h>
+
+#include <linux/netfilter/nf_tables.h>
+
+#include <internal.h>
+#include <libmnl/libmnl.h>
+#include <libnftnl/object.h>
+
+#include "obj.h"
+
+static int nftnl_obj_connlimit_set(struct nftnl_obj *e, uint16_t type,
+				   const void *data, uint32_t data_len)
+{
+	struct nftnl_obj_connlimit *connlimit = nftnl_obj_data(e);
+
+	switch(type) {
+	case NFTNL_OBJ_CONNLIMIT_COUNT:
+		memcpy(&connlimit->count, data, data_len);
+		break;
+	case NFTNL_OBJ_CONNLIMIT_FLAGS:
+		memcpy(&connlimit->flags, data, data_len);
+		break;
+	}
+	return 0;
+}
+
+static const void *nftnl_obj_connlimit_get(const struct nftnl_obj *e,
+					   uint16_t type, uint32_t *data_len)
+{
+	struct nftnl_obj_connlimit *connlimit = nftnl_obj_data(e);
+
+	switch (type) {
+	case NFTNL_OBJ_CONNLIMIT_COUNT:
+		*data_len = sizeof(connlimit->count);
+		return &connlimit->count;
+	case NFTNL_OBJ_CONNLIMIT_FLAGS:
+		*data_len = sizeof(connlimit->flags);
+		return &connlimit->flags;
+	}
+	return NULL;
+}
+
+static int nftnl_obj_connlimit_cb(const struct nlattr *attr, void *data)
+{
+	int type = mnl_attr_get_type(attr);
+	const struct nlattr **tb = data;
+
+	if (mnl_attr_type_valid(attr, NFTA_CONNLIMIT_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_CONNLIMIT_COUNT:
+	case NFTA_CONNLIMIT_FLAGS:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void nftnl_obj_connlimit_build(struct nlmsghdr *nlh,
+				      const struct nftnl_obj *e)
+{
+	struct nftnl_obj_connlimit *connlimit = nftnl_obj_data(e);
+
+	if (e->flags & (1 << NFTNL_OBJ_CONNLIMIT_COUNT))
+		mnl_attr_put_u32(nlh, NFTA_CONNLIMIT_COUNT,
+				 htonl(connlimit->count));
+	if (e->flags & (1 << NFTNL_OBJ_CONNLIMIT_FLAGS))
+		mnl_attr_put_u32(nlh, NFTA_CONNLIMIT_FLAGS,
+				 htonl(connlimit->flags));
+}
+
+static int nftnl_obj_connlimit_parse(struct nftnl_obj *e, struct nlattr *attr)
+{
+	struct nftnl_obj_connlimit *connlimit = nftnl_obj_data(e);
+	struct nlattr *tb[NFTA_CONNLIMIT_MAX + 1] = {};
+
+	if (mnl_attr_parse_nested(attr, nftnl_obj_connlimit_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_CONNLIMIT_COUNT]) {
+		connlimit->count = ntohl(mnl_attr_get_u32(tb[NFTA_CONNLIMIT_COUNT]));
+		e->flags |= (1 << NFTNL_OBJ_CONNLIMIT_COUNT);
+	}
+	if (tb[NFTA_CONNLIMIT_FLAGS]) {
+		connlimit->flags = ntohl(mnl_attr_get_u32(tb[NFTA_CONNLIMIT_FLAGS]));
+		e->flags |= (1 << NFTNL_OBJ_CONNLIMIT_FLAGS);
+	}
+
+	return 0;
+}
+
+static int nftnl_obj_connlimit_snprintf(char *buf, size_t len,
+					uint32_t flags,
+					const struct nftnl_obj *e)
+{
+	struct nftnl_obj_connlimit *connlimit = nftnl_obj_data(e);
+
+	return snprintf(buf, len, "count %u flags %x ",
+			connlimit->count, connlimit->flags);
+}
+
+static struct attr_policy obj_connlimit_attr_policy[__NFTNL_OBJ_CONNLIMIT_MAX] = {
+	[NFTNL_OBJ_CONNLIMIT_COUNT]	= { .maxlen = sizeof(uint32_t) },
+	[NFTNL_OBJ_CONNLIMIT_FLAGS]	= { .maxlen = sizeof(uint32_t) },
+};
+
+struct obj_ops obj_ops_connlimit = {
+	.name		= "connlimit",
+	.type		= NFT_OBJECT_CONNLIMIT,
+	.alloc_len	= sizeof(struct nftnl_obj_connlimit),
+	.nftnl_max_attr	= __NFTNL_OBJ_CONNLIMIT_MAX,
+	.attr_policy	= obj_connlimit_attr_policy,
+	.set		= nftnl_obj_connlimit_set,
+	.get		= nftnl_obj_connlimit_get,
+	.parse		= nftnl_obj_connlimit_parse,
+	.build		= nftnl_obj_connlimit_build,
+	.output		= nftnl_obj_connlimit_snprintf,
+};
diff --git a/src/object.c b/src/object.c
index 3d358cc..aa5b544 100644
--- a/src/object.c
+++ b/src/object.c
@@ -30,6 +30,7 @@ static struct obj_ops *obj_ops[__NFT_OBJECT_MAX] = {
 	[NFT_OBJECT_SECMARK]	= &obj_ops_secmark,
 	[NFT_OBJECT_CT_EXPECT]	= &obj_ops_ct_expect,
 	[NFT_OBJECT_SYNPROXY]	= &obj_ops_synproxy,
+	[NFT_OBJECT_CONNLIMIT]	= &obj_ops_connlimit,
 };
 
 static struct obj_ops *nftnl_obj_ops_lookup(uint32_t type)
-- 
2.51.0

