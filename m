Return-Path: <SRS0=4S6R=YT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8713BCA9EB9
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5877D2070B
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfJZLFW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Oct 2019 07:05:22 -0400
Received: from correo.us.es ([193.147.175.20]:39414 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbfJZLFV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Oct 2019 07:05:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 33E475E4780
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:05:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1F66FA7EC6
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:05:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1509CA7EC0; Sat, 26 Oct 2019 13:05:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E9B54A7EC1
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:05:13 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:05:13 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CD6DC42EE395
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:05:13 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl,v2] chain: multi-device support
Date:   Sat, 26 Oct 2019 13:05:11 +0200
Message-Id: <20191026110512.8973-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add support for NFTA_HOOK_DEVS.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fix incorrect size in reallocation.

 include/libnftnl/chain.h            |   1 +
 include/linux/netfilter/nf_tables.h |   2 +
 src/chain.c                         | 109 +++++++++++++++++++++++++++++++++++-
 3 files changed, 111 insertions(+), 1 deletion(-)

diff --git a/include/libnftnl/chain.h b/include/libnftnl/chain.h
index 31b48cf32bed..f84a2a3a20f2 100644
--- a/include/libnftnl/chain.h
+++ b/include/libnftnl/chain.h
@@ -31,6 +31,7 @@ enum nftnl_chain_attr {
 	NFTNL_CHAIN_HANDLE,
 	NFTNL_CHAIN_TYPE,
 	NFTNL_CHAIN_DEV,
+	NFTNL_CHAIN_DEVICES,
 	__NFTNL_CHAIN_MAX
 };
 #define NFTNL_CHAIN_MAX (__NFTNL_CHAIN_MAX - 1)
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 2e49bc6541a4..81c27d3c9ffd 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -144,12 +144,14 @@ enum nft_list_attributes {
  * @NFTA_HOOK_HOOKNUM: netfilter hook number (NLA_U32)
  * @NFTA_HOOK_PRIORITY: netfilter hook priority (NLA_U32)
  * @NFTA_HOOK_DEV: netdevice name (NLA_STRING)
+ * @NFTA_HOOK_DEVS: list of netdevices (NLA_NESTED)
  */
 enum nft_hook_attributes {
 	NFTA_HOOK_UNSPEC,
 	NFTA_HOOK_HOOKNUM,
 	NFTA_HOOK_PRIORITY,
 	NFTA_HOOK_DEV,
+	NFTA_HOOK_DEVS,
 	__NFTA_HOOK_MAX
 };
 #define NFTA_HOOK_MAX		(__NFTA_HOOK_MAX - 1)
diff --git a/src/chain.c b/src/chain.c
index 26f9b9d61053..84e5414f0cee 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -38,6 +38,8 @@ struct nftnl_chain {
 	const char	*type;
 	const char	*table;
 	const char	*dev;
+	const char	**dev_array;
+	int		dev_array_len;
 	uint32_t	family;
 	uint32_t	policy;
 	uint32_t	hooknum;
@@ -109,6 +111,7 @@ EXPORT_SYMBOL(nftnl_chain_free);
 void nftnl_chain_free(const struct nftnl_chain *c)
 {
 	struct nftnl_rule *r, *tmp;
+	int i;
 
 	list_for_each_entry_safe(r, tmp, &c->rule_list, head)
 		nftnl_rule_free(r);
@@ -121,6 +124,12 @@ void nftnl_chain_free(const struct nftnl_chain *c)
 		xfree(c->type);
 	if (c->flags & (1 << NFTNL_CHAIN_DEV))
 		xfree(c->dev);
+	if (c->flags & (1 << NFTNL_CHAIN_DEVICES)) {
+		for (i = 0; i < c->dev_array_len; i++)
+			xfree(c->dev_array[i]);
+
+		xfree(c->dev_array);
+	}
 	xfree(c);
 }
 
@@ -133,6 +142,8 @@ bool nftnl_chain_is_set(const struct nftnl_chain *c, uint16_t attr)
 EXPORT_SYMBOL(nftnl_chain_unset);
 void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr)
 {
+	int i;
+
 	if (!(c->flags & (1 << attr)))
 		return;
 
@@ -159,6 +170,11 @@ void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr)
 	case NFTNL_CHAIN_DEV:
 		xfree(c->dev);
 		break;
+	case NFTNL_CHAIN_DEVICES:
+		for (i = 0; i < c->dev_array_len; i++)
+			xfree(c->dev_array[i]);
+		xfree(c->dev_array);
+		break;
 	default:
 		return;
 	}
@@ -180,6 +196,9 @@ EXPORT_SYMBOL(nftnl_chain_set_data);
 int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 			 const void *data, uint32_t data_len)
 {
+	const char **dev_array;
+	int len = 0, i;
+
 	nftnl_assert_attr_exists(attr, NFTNL_CHAIN_MAX);
 	nftnl_assert_validate(data, nftnl_chain_validate, attr, data_len);
 
@@ -240,6 +259,26 @@ int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 		if (!c->dev)
 			return -1;
 		break;
+	case NFTNL_CHAIN_DEVICES:
+		dev_array = (const char **)data;
+		while (dev_array[len] != NULL)
+			len++;
+
+		if (c->flags & (1 << NFTNL_CHAIN_DEVICES)) {
+			for (i = 0; i < c->dev_array_len; i++)
+				xfree(c->dev_array[i]);
+			xfree(c->dev_array);
+		}
+
+		c->dev_array = calloc(len + 1, sizeof(char *));
+		if (!c->dev_array)
+			return -1;
+
+		for (i = 0; i < len; i++)
+			c->dev_array[i] = strdup(dev_array[i]);
+
+		c->dev_array_len = len;
+		break;
 	}
 	c->flags |= (1 << attr);
 	return 0;
@@ -325,6 +364,8 @@ const void *nftnl_chain_get_data(const struct nftnl_chain *c, uint16_t attr,
 	case NFTNL_CHAIN_DEV:
 		*data_len = strlen(c->dev) + 1;
 		return c->dev;
+	case NFTNL_CHAIN_DEVICES:
+		return &c->dev_array[0];
 	}
 	return NULL;
 }
@@ -389,6 +430,8 @@ uint8_t nftnl_chain_get_u8(const struct nftnl_chain *c, uint16_t attr)
 EXPORT_SYMBOL(nftnl_chain_nlmsg_build_payload);
 void nftnl_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_chain *c)
 {
+	int i;
+
 	if (c->flags & (1 << NFTNL_CHAIN_TABLE))
 		mnl_attr_put_strz(nlh, NFTA_CHAIN_TABLE, c->table);
 	if (c->flags & (1 << NFTNL_CHAIN_NAME))
@@ -402,6 +445,15 @@ void nftnl_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_ch
 		mnl_attr_put_u32(nlh, NFTA_HOOK_PRIORITY, htonl(c->prio));
 		if (c->flags & (1 << NFTNL_CHAIN_DEV))
 			mnl_attr_put_strz(nlh, NFTA_HOOK_DEV, c->dev);
+		else if (c->flags & (1 << NFTNL_CHAIN_DEVICES)) {
+			struct nlattr *nest_dev;
+
+			nest_dev = mnl_attr_nest_start(nlh, NFTA_HOOK_DEVS);
+			for (i = 0; i < c->dev_array_len; i++)
+				mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME,
+						  c->dev_array[i]);
+			mnl_attr_nest_end(nlh, nest_dev);
+		}
 		mnl_attr_nest_end(nlh, nest);
 	}
 	if (c->flags & (1 << NFTNL_CHAIN_POLICY))
@@ -551,9 +603,46 @@ static int nftnl_chain_parse_hook_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
+static int nftnl_chain_parse_devs(struct nlattr *nest, struct nftnl_chain *c)
+{
+	const char **dev_array;
+	int len = 0, size = 8;
+	struct nlattr *attr;
+
+	dev_array = calloc(8, sizeof(char *));
+	if (!dev_array)
+		return -1;
+
+	mnl_attr_for_each_nested(attr, nest) {
+		if (mnl_attr_get_type(attr) != NFTA_DEVICE_NAME)
+			goto err;
+		dev_array[len++] = strdup(mnl_attr_get_str(attr));
+		if (len >= size) {
+			dev_array = realloc(dev_array,
+					    size * 2 * sizeof(char *));
+			if (!dev_array)
+				goto err;
+
+			size *= 2;
+			memset(&dev_array[len], 0,
+			       (size - len) * sizeof(char *));
+		}
+	}
+
+	c->dev_array = dev_array;
+	c->dev_array_len = len;
+
+	return 0;
+err:
+	while (len--)
+		xfree(dev_array[len]);
+	return -1;
+}
+
 static int nftnl_chain_parse_hook(struct nlattr *attr, struct nftnl_chain *c)
 {
 	struct nlattr *tb[NFTA_HOOK_MAX+1] = {};
+	int ret;
 
 	if (mnl_attr_parse_nested(attr, nftnl_chain_parse_hook_cb, tb) < 0)
 		return -1;
@@ -572,6 +661,12 @@ static int nftnl_chain_parse_hook(struct nlattr *attr, struct nftnl_chain *c)
 			return -1;
 		c->flags |= (1 << NFTNL_CHAIN_DEV);
 	}
+	if (tb[NFTA_HOOK_DEVS]) {
+		ret = nftnl_chain_parse_devs(tb[NFTA_HOOK_DEVS], c);
+		if (ret < 0)
+			return -1;
+		c->flags |= (1 << NFTNL_CHAIN_DEVICES);
+	}
 
 	return 0;
 }
@@ -653,7 +748,7 @@ static inline int nftnl_str2hooknum(int family, const char *hook)
 static int nftnl_chain_snprintf_default(char *buf, size_t size,
 					const struct nftnl_chain *c)
 {
-	int ret, remain = size, offset = 0;
+	int ret, remain = size, offset = 0, i;
 
 	ret = snprintf(buf, remain, "%s %s %s use %u",
 		       nftnl_family2str(c->family), c->table, c->name, c->use);
@@ -681,6 +776,18 @@ static int nftnl_chain_snprintf_default(char *buf, size_t size,
 				       c->dev);
 			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		}
+		if (c->flags & (1 << NFTNL_CHAIN_DEVICES)) {
+			ret = snprintf(buf + offset, remain, " dev { ");
+			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
+			for (i = 0; i < c->dev_array_len; i++) {
+				ret = snprintf(buf + offset, remain, " %s ",
+					       c->dev_array[i]);
+				SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+			}
+			ret = snprintf(buf + offset, remain, " } ");
+			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		}
 	}
 
 	return offset;
-- 
2.11.0

