Return-Path: <SRS0=QWtc=XC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE78C43331
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Sep 2019 16:05:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD034218AE
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Sep 2019 16:05:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="PIyOAcTr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394838AbfIGQFN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Sep 2019 12:05:13 -0400
Received: from mx1.riseup.net ([198.252.153.129]:58100 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392003AbfIGQFN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Sep 2019 12:05:13 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 9B67E1A0B32
        for <netfilter-devel@vger.kernel.org>; Sat,  7 Sep 2019 09:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1567872312; bh=5kzAPQI/35MAaqBBzk2kCgTfWB5FsKUl3laguTLPqzI=;
        h=From:To:Cc:Subject:Date:From;
        b=PIyOAcTrS0ruptTAid79ueGu3CoZcwC46vogtoNDEgZw05980pJN3rf3l/GOQsNiY
         YnABHUk44HFvqcgJlmvJJlx0ygd2cDvaNK0XR6UzalDdj1ceUYyAn6h8lT+1HjmjKt
         qaVDnVmJnMQD/BuwjAsilFuOQkyRYOnVZsfy2cKM=
X-Riseup-User-ID: 66D937E9EE09676E43987477F9D6C2550C2AD6A7D18594D8B198506F7BA859D7
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 6E8362209E6;
        Sat,  7 Sep 2019 09:05:11 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH libnftnl] src: synproxy stateful object support
Date:   Sat,  7 Sep 2019 18:05:01 +0200
Message-Id: <20190907160501.7666-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds synproxy stateful object support.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/libnftnl/object.h           |   6 ++
 include/linux/netfilter/nf_tables.h |   3 +-
 include/obj.h                       |   6 ++
 src/Makefile.am                     |   1 +
 src/obj/synproxy.c                  | 161 ++++++++++++++++++++++++++++
 src/object.c                        |   1 +
 6 files changed, 177 insertions(+), 1 deletion(-)
 create mode 100644 src/obj/synproxy.c

diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
index cce0713..c5ea88e 100644
--- a/include/libnftnl/object.h
+++ b/include/libnftnl/object.h
@@ -86,6 +86,12 @@ enum {
 	NFTNL_OBJ_LIMIT_FLAGS,
 };
 
+enum {
+	NFTNL_OBJ_SYNPROXY_MSS	= NFTNL_OBJ_BASE,
+	NFTNL_OBJ_SYNPROXY_WSCALE,
+	NFTNL_OBJ_SYNPROXY_FLAGS,
+};
+
 enum {
 	NFTNL_OBJ_TUNNEL_ID	= NFTNL_OBJ_BASE,
 	NFTNL_OBJ_TUNNEL_IPV4_SRC,
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 75e083e..2e49bc6 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1481,7 +1481,8 @@ enum nft_ct_expectation_attributes {
 #define NFT_OBJECT_CT_TIMEOUT	7
 #define NFT_OBJECT_SECMARK	8
 #define NFT_OBJECT_CT_EXPECT	9
-#define __NFT_OBJECT_MAX	10
+#define NFT_OBJECT_SYNPROXY	10
+#define __NFT_OBJECT_MAX	11
 #define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
 
 /**
diff --git a/include/obj.h b/include/obj.h
index 9394d79..10f806c 100644
--- a/include/obj.h
+++ b/include/obj.h
@@ -56,6 +56,11 @@ struct nftnl_obj {
 			uint32_t	type;
 			uint32_t	flags;
 		} limit;
+		struct nftnl_obj_synproxy {
+			uint16_t	mss;
+			uint8_t		wscale;
+			uint32_t	flags;
+		} synproxy;
 		struct nftnl_obj_tunnel {
 			uint32_t	id;
 			uint32_t	src_v4;
@@ -108,6 +113,7 @@ extern struct obj_ops obj_ops_ct_helper;
 extern struct obj_ops obj_ops_ct_timeout;
 extern struct obj_ops obj_ops_ct_expect;
 extern struct obj_ops obj_ops_limit;
+extern struct obj_ops obj_ops_synproxy;
 extern struct obj_ops obj_ops_tunnel;
 extern struct obj_ops obj_ops_secmark;
 
diff --git a/src/Makefile.am b/src/Makefile.am
index f16422c..90b1967 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -64,6 +64,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      obj/quota.c	\
 		      obj/tunnel.c	\
 		      obj/limit.c	\
+		      obj/synproxy.c	\
 		      obj/ct_timeout.c 	\
 		      obj/secmark.c	\
 		      obj/ct_expect.c 	\
diff --git a/src/obj/synproxy.c b/src/obj/synproxy.c
new file mode 100644
index 0000000..56ebc85
--- /dev/null
+++ b/src/obj/synproxy.c
@@ -0,0 +1,161 @@
+#include <stdio.h>
+#include <stdint.h>
+#include <arpa/inet.h>
+#include <errno.h>
+#include <inttypes.h>
+
+#include <linux/netfilter/nf_tables.h>
+
+#include "internal.h"
+#include <libmnl/libmnl.h>
+#include <libnftnl/object.h>
+
+#include "obj.h"
+
+static int nftnl_obj_synproxy_set(struct nftnl_obj *e, uint16_t type,
+				  const void *data, uint32_t data_len)
+{
+	struct nftnl_obj_synproxy *synproxy = nftnl_obj_data(e);
+
+	switch (type) {
+	case NFTNL_OBJ_SYNPROXY_MSS:
+		synproxy->mss = *((uint16_t *)data);
+		break;
+	case NFTNL_OBJ_SYNPROXY_WSCALE:
+		synproxy->wscale = *((uint8_t *)data);
+		break;
+	case NFTNL_OBJ_SYNPROXY_FLAGS:
+		synproxy->flags = *((uint32_t *)data);
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *nftnl_obj_synproxy_get(const struct nftnl_obj *e,
+					  uint16_t type, uint32_t *data_len)
+{
+	struct nftnl_obj_synproxy *synproxy = nftnl_obj_data(e);
+
+	switch (type) {
+	case NFTNL_OBJ_SYNPROXY_MSS:
+		*data_len = sizeof(synproxy->mss);
+		return &synproxy->mss;
+	case NFTNL_OBJ_SYNPROXY_WSCALE:
+		*data_len = sizeof(synproxy->wscale);
+		return &synproxy->wscale;
+	case NFTNL_OBJ_SYNPROXY_FLAGS:
+		*data_len = sizeof(synproxy->flags);
+		return &synproxy->flags;
+	}
+	return NULL;
+}
+
+static int nftnl_obj_synproxy_cb(const struct nlattr *attr, void *data)
+{
+	int type = mnl_attr_get_type(attr);
+	const struct nlattr **tb = data;
+
+	if (mnl_attr_type_valid(attr, NFTA_SYNPROXY_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_SYNPROXY_MSS:
+		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
+			abi_breakage();
+		break;
+	case NFTA_SYNPROXY_WSCALE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
+			abi_breakage();
+		break;
+	case NFTA_SYNPROXY_FLAGS:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void nftnl_obj_synproxy_build(struct nlmsghdr *nlh,
+				     const struct nftnl_obj *e)
+{
+	struct nftnl_obj_synproxy *synproxy = nftnl_obj_data(e);
+
+	if (e->flags & (1 << NFTNL_OBJ_SYNPROXY_MSS))
+		mnl_attr_put_u16(nlh, NFTA_SYNPROXY_MSS, htons(synproxy->mss));
+	if (e->flags & (1 << NFTNL_OBJ_SYNPROXY_WSCALE))
+		mnl_attr_put_u8(nlh, NFTA_SYNPROXY_WSCALE, synproxy->wscale);
+	if (e->flags & (1 << NFTNL_OBJ_SYNPROXY_FLAGS))
+		mnl_attr_put_u32(nlh, NFTA_SYNPROXY_FLAGS,
+				 htonl(synproxy->flags));
+}
+
+static int nftnl_obj_synproxy_parse(struct nftnl_obj *e, struct nlattr *attr)
+{
+	struct nftnl_obj_synproxy *synproxy = nftnl_obj_data(e);
+	struct nlattr *tb[NFTA_SYNPROXY_MAX + 1] = {};
+
+	if (mnl_attr_parse_nested(attr, nftnl_obj_synproxy_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_SYNPROXY_MSS]) {
+		synproxy->mss = ntohs(mnl_attr_get_u16(tb[NFTA_SYNPROXY_MSS]));
+		e->flags |= (1 << NFTNL_OBJ_SYNPROXY_MSS);
+	}
+	if (tb[NFTA_SYNPROXY_WSCALE]) {
+		synproxy->wscale = mnl_attr_get_u8(tb[NFTA_SYNPROXY_WSCALE]);
+		e->flags |= (1 << NFTNL_OBJ_SYNPROXY_WSCALE);
+	}
+	if (tb[NFTA_SYNPROXY_FLAGS]) {
+		synproxy->flags = ntohl(mnl_attr_get_u32(tb[NFTA_SYNPROXY_FLAGS]));
+		e->flags |= (1 << NFTNL_OBJ_SYNPROXY_FLAGS);
+	}
+
+	return 0;
+}
+
+static int nftnl_obj_synproxy_snprintf_default(char *buf, size_t size,
+					       const struct nftnl_obj *e)
+{
+	struct nftnl_obj_synproxy *synproxy = nftnl_obj_data(e);
+        int ret, offset = 0, len = size;
+
+        if (e->flags & (1 << NFTNL_OBJ_SYNPROXY_MSS) &&
+            e->flags & (1 << NFTNL_OBJ_SYNPROXY_WSCALE)) {
+                ret = snprintf(buf, len, "mss %u wscale %u ", synproxy->mss,
+                               synproxy->wscale);
+                SNPRINTF_BUFFER_SIZE(ret, len, offset);
+        }
+
+        return offset;
+}
+
+static int nftnl_obj_synproxy_snprintf(char *buf, size_t len, uint32_t type,
+				    uint32_t flags,
+				    const struct nftnl_obj *e)
+{
+	switch (type) {
+	case NFTNL_OUTPUT_DEFAULT:
+		return nftnl_obj_synproxy_snprintf_default(buf, len, e);
+	case NFTNL_OUTPUT_XML:
+	case NFTNL_OUTPUT_JSON:
+	default:
+		break;
+	}
+	return -1;
+}
+
+struct obj_ops obj_ops_synproxy = {
+	.name		= "synproxy",
+	.type		= NFT_OBJECT_SYNPROXY,
+	.alloc_len	= sizeof(struct nftnl_obj_synproxy),
+	.max_attr	= NFTA_SYNPROXY_MAX,
+	.set		= nftnl_obj_synproxy_set,
+	.get		= nftnl_obj_synproxy_get,
+	.parse		= nftnl_obj_synproxy_parse,
+	.build		= nftnl_obj_synproxy_build,
+	.snprintf	= nftnl_obj_synproxy_snprintf,
+};
diff --git a/src/object.c b/src/object.c
index d8c87ee..ed8e36d 100644
--- a/src/object.c
+++ b/src/object.c
@@ -34,6 +34,7 @@ static struct obj_ops *obj_ops[__NFT_OBJECT_MAX] = {
 	[NFT_OBJECT_CT_TIMEOUT] = &obj_ops_ct_timeout,
 	[NFT_OBJECT_SECMARK]	= &obj_ops_secmark,
 	[NFT_OBJECT_CT_EXPECT]	= &obj_ops_ct_expect,
+	[NFT_OBJECT_SYNPROXY]	= &obj_ops_synproxy,
 };
 
 static struct obj_ops *nftnl_obj_ops_lookup(uint32_t type)
-- 
2.20.1

