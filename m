Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E0BC3F2C6
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 11:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 376EF206E6
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 11:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgCCL7s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 06:59:48 -0500
Received: from correo.us.es ([193.147.175.20]:39174 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbgCCL7r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 06:59:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4C35319190D
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Mar 2020 12:59:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B0C4DA801
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Mar 2020 12:59:32 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 30A3FDA7B6; Tue,  3 Mar 2020 12:59:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 495AFDA3C4
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Mar 2020 12:59:30 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 03 Mar 2020 12:59:30 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3286542EF4E2
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Mar 2020 12:59:30 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] chain: add NFTNL_CHAIN_FLAGS
Date:   Tue,  3 Mar 2020 12:59:41 +0100
Message-Id: <20200303115941.7016-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds support for chain flags.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/chain.h |  1 +
 src/chain.c              | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/libnftnl/chain.h b/include/libnftnl/chain.h
index 2eb22cc4bc94..291bf22a2fdd 100644
--- a/include/libnftnl/chain.h
+++ b/include/libnftnl/chain.h
@@ -32,6 +32,7 @@ enum nftnl_chain_attr {
 	NFTNL_CHAIN_TYPE,
 	NFTNL_CHAIN_DEV,
 	NFTNL_CHAIN_DEVICES,
+	NFTNL_CHAIN_FLAGS,
 	__NFTNL_CHAIN_MAX
 };
 #define NFTNL_CHAIN_MAX (__NFTNL_CHAIN_MAX - 1)
diff --git a/src/chain.c b/src/chain.c
index c43ba2236673..5f1213013e53 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -43,6 +43,7 @@ struct nftnl_chain {
 	uint32_t	policy;
 	uint32_t	hooknum;
 	int32_t		prio;
+	uint32_t	chain_flags;
 	uint32_t	use;
 	uint64_t	packets;
 	uint64_t	bytes;
@@ -165,6 +166,7 @@ void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr)
 	case NFTNL_CHAIN_PACKETS:
 	case NFTNL_CHAIN_HANDLE:
 	case NFTNL_CHAIN_FAMILY:
+	case NFTNL_CHAIN_FLAGS:
 		break;
 	case NFTNL_CHAIN_DEV:
 		xfree(c->dev);
@@ -189,6 +191,7 @@ static uint32_t nftnl_chain_validate[NFTNL_CHAIN_MAX + 1] = {
 	[NFTNL_CHAIN_PACKETS]	= sizeof(uint64_t),
 	[NFTNL_CHAIN_HANDLE]		= sizeof(uint64_t),
 	[NFTNL_CHAIN_FAMILY]		= sizeof(uint32_t),
+	[NFTNL_CHAIN_FLAGS]		= sizeof(uint32_t),
 };
 
 EXPORT_SYMBOL(nftnl_chain_set_data);
@@ -278,6 +281,9 @@ int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 
 		c->dev_array_len = len;
 		break;
+	case NFTNL_CHAIN_FLAGS:
+		memcpy(&c->chain_flags, data, sizeof(c->chain_flags));
+		break;
 	}
 	c->flags |= (1 << attr);
 	return 0;
@@ -373,6 +379,9 @@ const void *nftnl_chain_get_data(const struct nftnl_chain *c, uint16_t attr,
 	case NFTNL_CHAIN_DEVICES:
 		*data_len = 0;
 		return &c->dev_array[0];
+	case NFTNL_CHAIN_FLAGS:
+		*data_len = sizeof(uint32_t);
+		return &c->chain_flags;
 	}
 	return NULL;
 }
@@ -491,6 +500,8 @@ void nftnl_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_ch
 		mnl_attr_put_u64(nlh, NFTA_CHAIN_HANDLE, be64toh(c->handle));
 	if (c->flags & (1 << NFTNL_CHAIN_TYPE))
 		mnl_attr_put_strz(nlh, NFTA_CHAIN_TYPE, c->type);
+	if (c->flags & (1 << NFTNL_CHAIN_FLAGS))
+		mnl_attr_put_u32(nlh, NFTA_CHAIN_FLAGS, htonl(c->chain_flags));
 }
 
 EXPORT_SYMBOL(nftnl_chain_rule_add);
@@ -545,6 +556,7 @@ static int nftnl_chain_parse_attr_cb(const struct nlattr *attr, void *data)
 		break;
 	case NFTA_CHAIN_POLICY:
 	case NFTA_CHAIN_USE:
+	case NFTA_CHAIN_FLAGS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -745,6 +757,10 @@ int nftnl_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_chain *c)
 			return -1;
 		c->flags |= (1 << NFTNL_CHAIN_TYPE);
 	}
+	if (tb[NFTA_CHAIN_FLAGS]) {
+		c->chain_flags = ntohl(mnl_attr_get_u32(tb[NFTA_CHAIN_FLAGS]));
+		c->flags |= (1 << NFTNL_CHAIN_FLAGS);
+	}
 
 	c->family = nfg->nfgen_family;
 	c->flags |= (1 << NFTNL_CHAIN_FAMILY);
@@ -806,6 +822,11 @@ static int nftnl_chain_snprintf_default(char *buf, size_t size,
 			ret = snprintf(buf + offset, remain, " } ");
 			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		}
+		if (c->flags & (1 << NFTNL_CHAIN_FLAGS)) {
+			ret = snprintf(buf + offset, remain, " flags %x",
+				       c->chain_flags);
+			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		}
 	}
 
 	return offset;
-- 
2.11.0

