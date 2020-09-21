Return-Path: <SRS0=tgdo=C6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 334FAC43466
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Sep 2020 13:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3121206A4
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Sep 2020 13:35:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="EtWcWxDK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgIUNfu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Sep 2020 09:35:50 -0400
Received: from mx1.riseup.net ([198.252.153.129]:40524 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726584AbgIUNfu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Sep 2020 09:35:50 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 09:35:50 EDT
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4Bw4zF58MMzFfLJ;
        Mon, 21 Sep 2020 06:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1600694953; bh=TyNqZvuCaGDXo0qvtirXlT7hqBdo2drXNAqaxVt+rV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtWcWxDKqZsRVA6Vlxf9JaAhABiW/YR4qcOBxan4t4WW5oh5ZjvxV9UFjrSyhM2gX
         bdve3oC3uKYIBEpm2PKrQ5YGizl1BpQlhCZVxjRD8+TVSQTun8rs7/qcDwpjwrlf19
         LZRYY9vIRLNnPnpurFS5ndDBW4YSMZQRysGLnQt0=
X-Riseup-User-ID: D337F35E3405600BE6D425BC31BD19C5C3F54DFA9D822F09E4B4F92AA1ADBEAF
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4Bw4zD6JkyzJnD0;
        Mon, 21 Sep 2020 06:29:12 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl 2/3] chain: add userdata and comment support
Date:   Mon, 21 Sep 2020 15:28:22 +0200
Message-Id: <20200921132822.55231-3-guigom@riseup.net>
In-Reply-To: <20200921132822.55231-1-guigom@riseup.net>
References: <20200921132822.55231-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Adds NFTNL_CHAIN_USERDATA, in order to support userdata for chains.

Adds NFTNL_UDATA_CHAIN_COMMENT chain userdata type to support storing a
comment.

Relies on NFTA_CHAIN_USERDATA.

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 include/libnftnl/chain.h            |  1 +
 include/libnftnl/udata.h            |  6 ++++++
 include/linux/netfilter/nf_tables.h |  2 ++
 src/chain.c                         | 31 +++++++++++++++++++++++++++++
 4 files changed, 40 insertions(+)

diff --git a/include/libnftnl/chain.h b/include/libnftnl/chain.h
index 0e57a5a..f56e581 100644
--- a/include/libnftnl/chain.h
+++ b/include/libnftnl/chain.h
@@ -34,6 +34,7 @@ enum nftnl_chain_attr {
 	NFTNL_CHAIN_DEVICES,
 	NFTNL_CHAIN_FLAGS,
 	NFTNL_CHAIN_ID,
+	NFTNL_CHAIN_USERDATA,
 	__NFTNL_CHAIN_MAX
 };
 #define NFTNL_CHAIN_MAX (__NFTNL_CHAIN_MAX - 1)
diff --git a/include/libnftnl/udata.h b/include/libnftnl/udata.h
index 2e38fcc..dbf3a60 100644
--- a/include/libnftnl/udata.h
+++ b/include/libnftnl/udata.h
@@ -15,6 +15,12 @@ enum nftnl_udata_table_types {
 };
 #define NFTNL_UDATA_TABLE_MAX (__NFTNL_UDATA_TABLE_MAX - 1)
 
+enum nftnl_udata_chain_types {
+	NFTNL_UDATA_CHAIN_COMMENT,
+	__NFTNL_UDATA_CHAIN_MAX
+};
+#define NFTNL_UDATA_CHAIN_MAX (__NFTNL_UDATA_CHAIN_MAX - 1)
+
 enum nftnl_udata_rule_types {
 	NFTNL_UDATA_RULE_COMMENT,
 	NFTNL_UDATA_RULE_EBTABLES_POLICY,
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 8099777..77d178a 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -197,6 +197,7 @@ enum nft_table_attributes {
  * @NFTA_CHAIN_TYPE: type name of the string (NLA_NUL_STRING)
  * @NFTA_CHAIN_COUNTERS: counter specification of the chain (NLA_NESTED: nft_counter_attributes)
  * @NFTA_CHAIN_FLAGS: chain flags
+ * @NFTA_CHAIN_USERDATA: user data (NLA_BINARY)
  */
 enum nft_chain_attributes {
 	NFTA_CHAIN_UNSPEC,
@@ -211,6 +212,7 @@ enum nft_chain_attributes {
 	NFTA_CHAIN_PAD,
 	NFTA_CHAIN_FLAGS,
 	NFTA_CHAIN_ID,
+	NFTA_CHAIN_USERDATA,
 	__NFTA_CHAIN_MAX
 };
 #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
diff --git a/src/chain.c b/src/chain.c
index 94efa90..aac9da6 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -51,6 +51,11 @@ struct nftnl_chain {
 	uint32_t	flags;
 	uint32_t	chain_id;
 
+	struct {
+		void		*data;
+		uint32_t	len;
+	} user;
+
 	struct list_head rule_list;
 };
 
@@ -125,6 +130,8 @@ void nftnl_chain_free(const struct nftnl_chain *c)
 		xfree(c->type);
 	if (c->flags & (1 << NFTNL_CHAIN_DEV))
 		xfree(c->dev);
+	if (c->flags & (1 << NFTNL_CHAIN_USERDATA))
+		xfree(c->user.data);
 	if (c->flags & (1 << NFTNL_CHAIN_DEVICES)) {
 		for (i = 0; i < c->dev_array_len; i++)
 			xfree(c->dev_array[i]);
@@ -290,6 +297,16 @@ int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 	case NFTNL_CHAIN_ID:
 		memcpy(&c->chain_id, data, sizeof(c->chain_id));
 		break;
+	case NFTNL_CHAIN_USERDATA:
+		if (c->flags & (1 << NFTNL_CHAIN_USERDATA))
+			xfree(c->user.data);
+
+		c->user.data = malloc(data_len);
+		if (!c->user.data)
+			return -1;
+		memcpy(c->user.data, data, data_len);
+		c->user.len = data_len;
+		break;
 	}
 	c->flags |= (1 << attr);
 	return 0;
@@ -391,6 +408,9 @@ const void *nftnl_chain_get_data(const struct nftnl_chain *c, uint16_t attr,
 	case NFTNL_CHAIN_ID:
 		*data_len = sizeof(uint32_t);
 		return &c->chain_id;
+	case NFTNL_CHAIN_USERDATA:
+		*data_len = c->user.len;
+		return c->user.data;
 	}
 	return NULL;
 }
@@ -513,6 +533,8 @@ void nftnl_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_ch
 		mnl_attr_put_u32(nlh, NFTA_CHAIN_FLAGS, htonl(c->chain_flags));
 	if (c->flags & (1 << NFTNL_CHAIN_ID))
 		mnl_attr_put_u32(nlh, NFTA_CHAIN_ID, htonl(c->chain_id));
+	if (c->flags & (1 << NFTNL_CHAIN_USERDATA))
+		mnl_attr_put(nlh, NFTA_CHAIN_USERDATA, c->user.len, c->user.data);
 }
 
 EXPORT_SYMBOL(nftnl_chain_rule_add);
@@ -576,6 +598,10 @@ static int nftnl_chain_parse_attr_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
 			abi_breakage();
 		break;
+	case NFTA_CHAIN_USERDATA:
+		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
+			abi_breakage();
+		break;
 	}
 
 	tb[type] = attr;
@@ -777,6 +803,11 @@ int nftnl_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_chain *c)
 		c->chain_id = ntohl(mnl_attr_get_u32(tb[NFTA_CHAIN_ID]));
 		c->flags |= (1 << NFTNL_CHAIN_ID);
 	}
+	if (tb[NFTA_CHAIN_USERDATA]) {
+		nftnl_chain_set_data(c, NFTNL_CHAIN_USERDATA,
+				     mnl_attr_get_payload(tb[NFTA_CHAIN_USERDATA]),
+				     mnl_attr_get_payload_len(tb[NFTA_CHAIN_USERDATA]));
+	}
 
 	c->family = nfg->nfgen_family;
 	c->flags |= (1 << NFTNL_CHAIN_FAMILY);
-- 
2.27.0

