Return-Path: <SRS0=psrB=5C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F87C18E5B
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Mar 2020 13:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31FA720724
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Mar 2020 13:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgCQNO7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Mar 2020 09:14:59 -0400
Received: from correo.us.es ([193.147.175.20]:52120 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726794AbgCQNO7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Mar 2020 09:14:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 79216F23B8
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2020 14:14:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A190FC5EA
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2020 14:14:29 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6992AFC5E6; Tue, 17 Mar 2020 14:14:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 885CDFC5EC
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2020 14:14:27 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Mar 2020 14:14:27 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6D78842EE399
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2020 14:14:27 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] set: support for NFTNL_SET_EXPR
Date:   Tue, 17 Mar 2020 14:14:53 +0100
Message-Id: <20200317131453.30649-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds support for the NFTA_SET_EXPR netlink attribute.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/set.h              |  1 +
 include/libnftnl/udata.h            |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 include/set.h                       |  1 +
 src/set.c                           | 27 +++++++++++++++++++++++++++
 5 files changed, 32 insertions(+)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 6843adfa0c1e..5138bb99b426 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -30,6 +30,7 @@ enum nftnl_set_attr {
 	NFTNL_SET_OBJ_TYPE,
 	NFTNL_SET_HANDLE,
 	NFTNL_SET_DESC_CONCAT,
+	NFTNL_SET_EXPR,
 	__NFTNL_SET_MAX
 };
 #define NFTNL_SET_MAX (__NFTNL_SET_MAX - 1)
diff --git a/include/libnftnl/udata.h b/include/libnftnl/udata.h
index 8044041189b1..1d57bc3dce16 100644
--- a/include/libnftnl/udata.h
+++ b/include/libnftnl/udata.h
@@ -24,6 +24,7 @@ enum nftnl_udata_set_types {
 	NFTNL_UDATA_SET_MERGE_ELEMENTS,
 	NFTNL_UDATA_SET_KEY_TYPEOF,
 	NFTNL_UDATA_SET_DATA_TYPEOF,
+	NFTNL_UDATA_SET_EXPR,
 	__NFTNL_UDATA_SET_MAX
 };
 #define NFTNL_UDATA_SET_MAX (__NFTNL_UDATA_SET_MAX - 1)
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 57e83e152bf3..2d291f6eab62 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -342,6 +342,7 @@ enum nft_set_field_attributes {
  * @NFTA_SET_USERDATA: user data (NLA_BINARY)
  * @NFTA_SET_OBJ_TYPE: stateful object type (NLA_U32: NFT_OBJECT_*)
  * @NFTA_SET_HANDLE: set handle (NLA_U64)
+ * @NFTA_SET_EXPR: set expression (NLA_NESTED: nft_expr_attributes)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -361,6 +362,7 @@ enum nft_set_attributes {
 	NFTA_SET_PAD,
 	NFTA_SET_OBJ_TYPE,
 	NFTA_SET_HANDLE,
+	NFTA_SET_EXPR,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
diff --git a/include/set.h b/include/set.h
index 895ffdb48bdb..66ac129836de 100644
--- a/include/set.h
+++ b/include/set.h
@@ -33,6 +33,7 @@ struct nftnl_set {
 	uint32_t		flags;
 	uint32_t		gc_interval;
 	uint64_t		timeout;
+	struct nftnl_expr	*expr;
 };
 
 struct nftnl_set_list;
diff --git a/src/set.c b/src/set.c
index 651dcfa56022..15fa29d5f02c 100644
--- a/src/set.c
+++ b/src/set.c
@@ -51,6 +51,8 @@ void nftnl_set_free(const struct nftnl_set *s)
 		xfree(s->name);
 	if (s->flags & (1 << NFTNL_SET_USERDATA))
 		xfree(s->user.data);
+	if (s->flags & (1 << NFTNL_SET_EXPR))
+		nftnl_expr_free(s->expr);
 
 	list_for_each_entry_safe(elem, tmp, &s->element_list, head) {
 		list_del(&elem->head);
@@ -96,6 +98,9 @@ void nftnl_set_unset(struct nftnl_set *s, uint16_t attr)
 	case NFTNL_SET_USERDATA:
 		xfree(s->user.data);
 		break;
+	case NFTNL_SET_EXPR:
+		nftnl_expr_free(s->expr);
+		break;
 	default:
 		return;
 	}
@@ -195,6 +200,12 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 		memcpy(s->user.data, data, data_len);
 		s->user.len = data_len;
 		break;
+	case NFTNL_SET_EXPR:
+		if (s->flags & (1 << NFTNL_SET_EXPR))
+			nftnl_expr_free(s->expr);
+
+		s->expr = (void *)data;
+		break;
 	}
 	s->flags |= (1 << attr);
 	return 0;
@@ -283,6 +294,8 @@ const void *nftnl_set_get_data(const struct nftnl_set *s, uint16_t attr,
 	case NFTNL_SET_USERDATA:
 		*data_len = s->user.len;
 		return s->user.data;
+	case NFTNL_SET_EXPR:
+		return s->expr;
 	}
 	return NULL;
 }
@@ -432,6 +445,13 @@ void nftnl_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_set *s)
 		mnl_attr_put_u32(nlh, NFTA_SET_GC_INTERVAL, htonl(s->gc_interval));
 	if (s->flags & (1 << NFTNL_SET_USERDATA))
 		mnl_attr_put(nlh, NFTA_SET_USERDATA, s->user.len, s->user.data);
+	if (s->flags & (1 << NFTNL_SET_EXPR)) {
+		struct nlattr *nest1;
+
+		nest1 = mnl_attr_nest_start(nlh, NFTA_SET_EXPR);
+		nftnl_expr_build_payload(nlh, s->expr);
+		mnl_attr_nest_end(nlh, nest1);
+	}
 }
 
 
@@ -635,6 +655,13 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 		if (ret < 0)
 			return ret;
 	}
+	if (tb[NFTA_SET_EXPR]) {
+		s->expr = nftnl_expr_parse(tb[NFTA_SET_EXPR]);
+		if (!s->expr)
+			return -1;
+
+		s->flags |= (1 << NFTNL_SET_EXPR);
+	}
 
 	s->family = nfg->nfgen_family;
 	s->flags |= (1 << NFTNL_SET_FAMILY);
-- 
2.11.0

