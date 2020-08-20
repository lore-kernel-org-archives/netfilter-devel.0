Return-Path: <SRS0=xTVu=B6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC0CC433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Aug 2020 08:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F026A21744
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Aug 2020 08:20:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="K0IMHWzA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgHTIU3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Aug 2020 04:20:29 -0400
Received: from mx1.riseup.net ([198.252.153.129]:39082 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbgHTIUZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Aug 2020 04:20:25 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BXHdb5pTgzFmbb;
        Thu, 20 Aug 2020 01:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1597911624; bh=a7Fr6U0KDLGY7VOI7hPFG8+UBEQNkkDHO8iSpVE1NzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K0IMHWzAVpBE/eGjvKGq26XtHdQnypv74d2BwSP5x/T05LbM4+6YWRiI6MemWxjbo
         xNYER+PzS4BudKcTmaRpBoxB5ePgcRwM6aGhjj/xUhF4HrH/jmCDWu46/xiGlK/74C
         PgqzS1r4Lhr9N0ED1aFA3vZQJG3GffXshxPJC2hc=
X-Riseup-User-ID: 9489E42BF367363C3C0217E6496C0278A128BC2A6CDB9BFE580DA35D52F80CB8
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4BXHdZ6l3Dz8vXH;
        Thu, 20 Aug 2020 01:20:18 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org
Subject: [PATCH libnftnl 2/3] table: add userdata support
Date:   Thu, 20 Aug 2020 10:19:02 +0200
Message-Id: <20200820081903.36781-3-guigom@riseup.net>
In-Reply-To: <20200820081903.36781-1-guigom@riseup.net>
References: <20200820081903.36781-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 include/libnftnl/table.h            |  1 +
 include/libnftnl/udata.h            |  6 ++++++
 include/linux/netfilter/nf_tables.h |  1 +
 src/table.c                         | 33 +++++++++++++++++++++++++++++
 4 files changed, 41 insertions(+)

diff --git a/include/libnftnl/table.h b/include/libnftnl/table.h
index 5faec81..a37fba2 100644
--- a/include/libnftnl/table.h
+++ b/include/libnftnl/table.h
@@ -23,6 +23,7 @@ enum nftnl_table_attr {
 	NFTNL_TABLE_FLAGS,
 	NFTNL_TABLE_USE,
 	NFTNL_TABLE_HANDLE,
+	NFTNL_TABLE_USERDATA,
 	__NFTNL_TABLE_MAX
 };
 #define NFTNL_TABLE_MAX (__NFTNL_TABLE_MAX - 1)
diff --git a/include/libnftnl/udata.h b/include/libnftnl/udata.h
index efa3f76..ba6b3ab 100644
--- a/include/libnftnl/udata.h
+++ b/include/libnftnl/udata.h
@@ -9,6 +9,12 @@
 extern "C" {
 #endif
 
+enum nftnl_udata_table_types {
+	NFTNL_UDATA_TABLE_COMMENT,
+	__NFTNL_UDATA_TABLE_MAX
+};
+#define NFTNL_UDATA_TABLE_MAX (__NFTNL_UDATA_TABLE_MAX - 1)
+
 enum nftnl_udata_rule_types {
 	NFTNL_UDATA_RULE_COMMENT,
 	NFTNL_UDATA_RULE_EBTABLES_POLICY,
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index d9b0daa..d508154 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -180,6 +180,7 @@ enum nft_table_attributes {
 	NFTA_TABLE_USE,
 	NFTA_TABLE_HANDLE,
 	NFTA_TABLE_PAD,
+	NFTA_TABLE_USERDATA,
 	__NFTA_TABLE_MAX
 };
 #define NFTA_TABLE_MAX		(__NFTA_TABLE_MAX - 1)
diff --git a/src/table.c b/src/table.c
index 94d522b..731c818 100644
--- a/src/table.c
+++ b/src/table.c
@@ -34,6 +34,10 @@ struct nftnl_table {
 	uint64_t 	handle;
 	uint32_t	use;
 	uint32_t	flags;
+	struct {
+		void		*data;
+		uint32_t	len;
+	} user;
 };
 
 EXPORT_SYMBOL(nftnl_table_alloc);
@@ -47,6 +51,8 @@ void nftnl_table_free(const struct nftnl_table *t)
 {
 	if (t->flags & (1 << NFTNL_TABLE_NAME))
 		xfree(t->name);
+	if (t->flags & (1 << NFTNL_TABLE_USERDATA))
+		xfree(t->user.data);
 
 	xfree(t);
 }
@@ -111,6 +117,16 @@ int nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
 	case NFTNL_TABLE_USE:
 		memcpy(&t->use, data, sizeof(t->use));
 		break;
+	case NFTNL_TABLE_USERDATA:
+		if (t->flags & (1 << NFTNL_TABLE_USERDATA))
+			xfree(t->user.data);
+
+		t->user.data = malloc(data_len);
+		if (!t->user.data)
+			return -1;
+		memcpy(t->user.data, data, data_len);
+		t->user.len = data_len;
+		break;
 	}
 	t->flags |= (1 << attr);
 	return 0;
@@ -169,6 +185,9 @@ const void *nftnl_table_get_data(const struct nftnl_table *t, uint16_t attr,
 	case NFTNL_TABLE_USE:
 		*data_len = sizeof(uint32_t);
 		return &t->use;
+	case NFTNL_TABLE_USERDATA:
+		*data_len = t->user.len;
+		return t->user.data;
 	}
 	return NULL;
 }
@@ -216,6 +235,8 @@ void nftnl_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_ta
 		mnl_attr_put_u64(nlh, NFTA_TABLE_HANDLE, htobe64(t->handle));
 	if (t->flags & (1 << NFTNL_TABLE_FLAGS))
 		mnl_attr_put_u32(nlh, NFTA_TABLE_FLAGS, htonl(t->table_flags));
+	if (t->flags & (1 << NFTNL_TABLE_USERDATA))
+		mnl_attr_put(nlh, NFTA_TABLE_USERDATA, t->user.len, t->user.data);
 }
 
 static int nftnl_table_parse_attr_cb(const struct nlattr *attr, void *data)
@@ -240,6 +261,10 @@ static int nftnl_table_parse_attr_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	case NFTA_TABLE_USERDATA:
+		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
+			abi_breakage();
+		break;
 	}
 
 	tb[type] = attr;
@@ -251,6 +276,7 @@ int nftnl_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_table *t)
 {
 	struct nlattr *tb[NFTA_TABLE_MAX+1] = {};
 	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
+	int ret;
 
 	if (mnl_attr_parse(nlh, sizeof(*nfg), nftnl_table_parse_attr_cb, tb) < 0)
 		return -1;
@@ -275,6 +301,13 @@ int nftnl_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_table *t)
 		t->handle = be64toh(mnl_attr_get_u64(tb[NFTA_TABLE_HANDLE]));
 		t->flags |= (1 << NFTNL_TABLE_HANDLE);
 	}
+	if (tb[NFTA_TABLE_USERDATA]) {
+		ret = nftnl_table_set_data(t, NFTNL_TABLE_USERDATA,
+			mnl_attr_get_payload(tb[NFTA_TABLE_USERDATA]),
+			mnl_attr_get_payload_len(tb[NFTA_TABLE_USERDATA]));
+		if (ret < 0)
+			return ret;
+	}
 
 	t->family = nfg->nfgen_family;
 	t->flags |= (1 << NFTNL_TABLE_FAMILY);
-- 
2.27.0

