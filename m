Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FC92141A9
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2024 19:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727896798; cv=none; b=VGe4jMQ2iEl/Yr0lq7O2Kh/OG5OnsiFXRoT3QfhDDXnWD5zZ6wpZMWIt8RvNt4Dmd8Mu3PbENsfR7XlVaOdtGfTG+NQne4c141i6mg4nfjk3Qv7PB4wYhsVDsDsyxeO3mr8KqCrlvDjkxnCU1LkLVotQg/4hHhx6CHbW0akfoiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727896798; c=relaxed/simple;
	bh=kpRrN1qY6GMSb0rXhCvnKpcsf3KxCYOOdizFchH5whc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqguBlZV45b428X2XhYD5ACQfW/S0qaq9aLRlKAET3U1AezQPTJ4t0A/rrEJFDpzr5sueZwOAU0y1KNWWj/r41On8wCOOaTmzOaCC14WYZQ9EjBdel1ldKF4Usj2PL/grqsFVaOffiCAfniIVxnv4EcnrRwTYjcInD1UtQEZQ4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=NC2ttCCZ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="NC2ttCCZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PocHrGFdIylDbV+P3DN+ITckVII2u9TMfQJh2YW2+2k=; b=NC2ttCCZRYayGfReRdSoRdeAt+
	+iXDBsr6AlbqB0gUemoLRkip0KaeD2FNmaLpUqIrsift+1bXpt2UKr1jc0+OpUk/ZLqVLqaYGb+jC
	Pmswi7ULrI/QyMkjFRS19DnN28VT3UxrthKNbhhNY32iZQVUGhbzE3lIZUSopp1B3KvXHS+BQychy
	bADjdlr1Gpt0+AbvUt4VALsWcuwkgLRWEy1LMGulkl6gZ4z4Jhd9JZdLZStJLGne/uHarZBopP7I+
	Hr/3/LHY/sw8qqFNSgO9bpYJKATsEsWixlGASiFUi3RyQriu30SWmkLw5UDSLxVEl74gMmMdMp0pE
	M3WTD8AQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sw4t1-000000002lY-2lSv;
	Wed, 02 Oct 2024 21:19:47 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 4/4] device: Introduce nftnl_device
Date: Wed,  2 Oct 2024 21:19:41 +0200
Message-ID: <20241002191941.8410-5-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241002191941.8410-1-phil@nwl.cc>
References: <20241002191941.8410-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A data structure used to parse NFT_MSG_(NEW|DEL)DEV messages into. Since
the kernel does not support these message types in requests yet,
implement a parser and getters only.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/libnftnl/Makefile.am        |   1 +
 include/libnftnl/device.h           |  39 +++++++
 include/linux/netfilter/nf_tables.h |   8 ++
 src/Makefile.am                     |   1 +
 src/device.c                        | 153 ++++++++++++++++++++++++++++
 src/libnftnl.map                    |  10 ++
 6 files changed, 212 insertions(+)
 create mode 100644 include/libnftnl/device.h
 create mode 100644 src/device.c

diff --git a/include/libnftnl/Makefile.am b/include/libnftnl/Makefile.am
index d846a574f4386..feaa7285f0070 100644
--- a/include/libnftnl/Makefile.am
+++ b/include/libnftnl/Makefile.am
@@ -2,6 +2,7 @@ pkginclude_HEADERS = batch.h		\
 		     table.h		\
 		     trace.h		\
 		     chain.h		\
+		     device.h		\
 		     object.h		\
 		     rule.h		\
 		     expr.h		\
diff --git a/include/libnftnl/device.h b/include/libnftnl/device.h
new file mode 100644
index 0000000000000..8c437a1fe3ccf
--- /dev/null
+++ b/include/libnftnl/device.h
@@ -0,0 +1,39 @@
+#ifndef _LIBNFTNL_DEVICE_H_
+#define _LIBNFTNL_DEVICE_H_
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+struct nftnl_device;
+
+struct nftnl_device *nftnl_device_alloc(void);
+void nftnl_device_free(const struct nftnl_device *);
+
+enum nftnl_device_attr {
+	NFTNL_DEVICE_NAME	= 0,
+	NFTNL_DEVICE_TABLE,
+	NFTNL_DEVICE_FLOWTABLE,
+	NFTNL_DEVICE_CHAIN,
+	NFTNL_DEVICE_SPEC,
+	NFTNL_DEVICE_FAMILY,
+	__NFTNL_DEVICE_MAX,
+};
+#define NFTNL_DEVICE_MAX (__NFTNL_DEVICE_MAX - 1)
+
+bool nftnl_device_is_set(const struct nftnl_device *d, uint16_t attr);
+
+const void *nftnl_device_get_data(const struct nftnl_device *d,
+				  uint16_t attr, uint32_t *data_len);
+const char *nftnl_device_get_str(const struct nftnl_device *d, uint16_t attr);
+int32_t nftnl_device_get_s32(const struct nftnl_device *d, uint16_t attr);
+
+struct nlmsghdr;
+
+int nftnl_device_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_device *d);
+
+#ifdef __cplusplus
+} /* extern "C" */
+#endif
+
+#endif /* _LIBNFTNL_DEVICE_H_ */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index c48b19333630d..2f73d367cf429 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1740,10 +1740,18 @@ enum nft_synproxy_attributes {
  * enum nft_device_attributes - nf_tables device netlink attributes
  *
  * @NFTA_DEVICE_NAME: name of this device (NLA_STRING)
+ * @NFTA_DEVICE_TABLE: table containing the flowtable or chain hooking into the device (NLA_STRING)
+ * @NFTA_DEVICE_FLOWTABLE: flowtable hooking into the device (NLA_STRING)
+ * @NFTA_DEVICE_CHAIN: chain hooking into the device (NLA_STRING)
+ * @NFTA_DEVICE_SPEC: hook spec matching the device (NLA_STRING)
  */
 enum nft_devices_attributes {
 	NFTA_DEVICE_UNSPEC,
 	NFTA_DEVICE_NAME,
+	NFTA_DEVICE_TABLE,
+	NFTA_DEVICE_FLOWTABLE,
+	NFTA_DEVICE_CHAIN,
+	NFTA_DEVICE_SPEC,
 	__NFTA_DEVICE_MAX
 };
 #define NFTA_DEVICE_MAX		(__NFTA_DEVICE_MAX - 1)
diff --git a/src/Makefile.am b/src/Makefile.am
index 3cd259c04d1c3..34dbe7ced1a2a 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -13,6 +13,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      table.c		\
 		      trace.c		\
 		      chain.c		\
+		      device.c		\
 		      object.c		\
 		      rule.c		\
 		      set.c		\
diff --git a/src/device.c b/src/device.c
new file mode 100644
index 0000000000000..79102f34752ea
--- /dev/null
+++ b/src/device.c
@@ -0,0 +1,153 @@
+/*
+ * (C) 2024 Red Hat GmbH
+ * Author: Phil Sutter <phil@nwl.cc>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include "internal.h"
+
+#include <linux/netfilter/nfnetlink.h>
+
+#include <libnftnl/device.h>
+
+struct nftnl_device {
+	const char	*name;
+	const char	*table;
+	const char	*flowtable;
+	const char	*chain;
+	const char	*spec;
+	int32_t		family;
+	uint32_t	flags;
+};
+
+EXPORT_SYMBOL(nftnl_device_alloc);
+struct nftnl_device *nftnl_device_alloc(void)
+{
+	return calloc(1, sizeof(struct nftnl_device));
+}
+
+EXPORT_SYMBOL(nftnl_device_free);
+void nftnl_device_free(const struct nftnl_device *d)
+{
+	if (d->flags & (1 << NFTNL_DEVICE_NAME))
+		xfree(d->name);
+	if (d->flags & (1 << NFTNL_DEVICE_TABLE))
+		xfree(d->table);
+	if (d->flags & (1 << NFTNL_DEVICE_FLOWTABLE))
+		xfree(d->flowtable);
+	if (d->flags & (1 << NFTNL_DEVICE_CHAIN))
+		xfree(d->chain);
+	if (d->flags & (1 << NFTNL_DEVICE_SPEC))
+		xfree(d->spec);
+	xfree(d);
+}
+
+EXPORT_SYMBOL(nftnl_device_is_set);
+bool nftnl_device_is_set(const struct nftnl_device *d, uint16_t attr)
+{
+	return d->flags & (1 << attr);
+}
+
+EXPORT_SYMBOL(nftnl_device_get_data);
+const void *nftnl_device_get_data(const struct nftnl_device *d,
+				  uint16_t attr, uint32_t *data_len)
+{
+	if (!(d->flags & (1 << attr)))
+		return NULL;
+
+	switch (attr) {
+	case NFTNL_DEVICE_NAME:
+		*data_len = strlen(d->name) + 1;
+		return d->name;
+	case NFTNL_DEVICE_TABLE:
+		*data_len = strlen(d->table) + 1;
+		return d->table;
+	case NFTNL_DEVICE_FLOWTABLE:
+		*data_len = strlen(d->flowtable) + 1;
+		return d->flowtable;
+	case NFTNL_DEVICE_CHAIN:
+		*data_len = strlen(d->chain) + 1;
+		return d->chain;
+	case NFTNL_DEVICE_SPEC:
+		*data_len = strlen(d->spec) + 1;
+		return d->spec;
+	case NFTNL_DEVICE_FAMILY:
+		*data_len = sizeof(int32_t);
+		return &d->family;
+	}
+	return NULL;
+}
+
+EXPORT_SYMBOL(nftnl_device_get_str);
+const char *nftnl_device_get_str(const struct nftnl_device *d, uint16_t attr)
+{
+	uint32_t data_len;
+
+	return nftnl_device_get_data(d, attr, &data_len);
+}
+
+EXPORT_SYMBOL(nftnl_device_get_s32);
+int32_t nftnl_device_get_s32(const struct nftnl_device *d, uint16_t attr)
+{
+	uint32_t data_len = 0;
+	const int32_t *val = nftnl_device_get_data(d, attr, &data_len);
+
+	nftnl_assert(val, attr, data_len == sizeof(int32_t));
+
+	return val ? *val : 0;
+}
+
+static int nftnl_device_parse_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_DEVICE_MAX) < 0)
+		return MNL_CB_OK;
+
+	/* all attributes are of string type */
+	if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+		abi_breakage();
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+EXPORT_SYMBOL(nftnl_device_nlmsg_parse);
+int nftnl_device_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_device *d)
+{
+	struct nlattr *tb[NFTA_DEVICE_MAX + 1] = {};
+	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
+	int ret = 0;
+
+	if (mnl_attr_parse(nlh, sizeof(*nfg), nftnl_device_parse_attr_cb, tb) < 0)
+		return -1;
+
+	if (nftnl_parse_str_attr(tb[NFTA_DEVICE_NAME], NFTNL_DEVICE_NAME,
+				 &d->name, &d->flags) < 0)
+		return -1;
+	if (nftnl_parse_str_attr(tb[NFTA_DEVICE_TABLE], NFTNL_DEVICE_TABLE,
+				 &d->table, &d->flags) < 0)
+		return -1;
+	if (nftnl_parse_str_attr(tb[NFTA_DEVICE_FLOWTABLE],
+				 NFTNL_DEVICE_FLOWTABLE,
+				 &d->flowtable, &d->flags) < 0)
+		return -1;
+	if (nftnl_parse_str_attr(tb[NFTA_DEVICE_CHAIN], NFTNL_DEVICE_CHAIN,
+				 &d->chain, &d->flags) < 0)
+		return -1;
+	if (tb[NFTA_DEVICE_SPEC]) {
+		d->spec = strdup(mnl_attr_get_ifname(tb[NFTA_DEVICE_SPEC]));
+		if (!d->spec)
+			return -1;
+		d->flags |= (1 << NFTNL_DEVICE_SPEC);
+	}
+
+	d->family = nfg->nfgen_family;
+	d->flags |= (1 << NFTNL_DEVICE_FAMILY);
+
+	return ret;
+}
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 8fffff19eb2e2..96ee683fb0611 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -383,3 +383,13 @@ LIBNFTNL_16 {
 LIBNFTNL_17 {
   nftnl_set_elem_nlmsg_build;
 } LIBNFTNL_16;
+
+LIBNFTNL_18 {
+  nftnl_device_alloc;
+  nftnl_device_free;
+  nftnl_device_is_set;
+  nftnl_device_get_data;
+  nftnl_device_get_str;
+  nftnl_device_get_s32;
+  nftnl_device_nlmsg_parse;
+} LIBNFTNL_17;
-- 
2.43.0

