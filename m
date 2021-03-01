Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D6A3C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Mar 2021 15:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9104614A5
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Mar 2021 15:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237103AbhCAPVM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Mar 2021 10:21:12 -0500
Received: from correo.us.es ([193.147.175.20]:33202 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237107AbhCAPUZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Mar 2021 10:20:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 202D7DA7E8
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Mar 2021 16:19:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E21BDA704
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Mar 2021 16:19:40 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0341DDA78C; Mon,  1 Mar 2021 16:19:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A76A6DA722
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Mar 2021 16:19:37 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 01 Mar 2021 16:19:37 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 962D842DC6E3
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Mar 2021 16:19:37 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] table: add table owner support
Date:   Mon,  1 Mar 2021 16:19:33 +0100
Message-Id: <20210301151933.21332-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add support for NFTA_TABLE_OWNER.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/table.h            |  1 +
 include/linux/netfilter/nf_tables.h |  1 +
 src/table.c                         | 14 +++++++++++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/libnftnl/table.h b/include/libnftnl/table.h
index a37fba2c81a1..d28c375c63e8 100644
--- a/include/libnftnl/table.h
+++ b/include/libnftnl/table.h
@@ -24,6 +24,7 @@ enum nftnl_table_attr {
 	NFTNL_TABLE_USE,
 	NFTNL_TABLE_HANDLE,
 	NFTNL_TABLE_USERDATA,
+	NFTNL_TABLE_OWNER,
 	__NFTNL_TABLE_MAX
 };
 #define NFTNL_TABLE_MAX (__NFTNL_TABLE_MAX - 1)
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 5cf3faf4b66f..b21be8afa6f1 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -181,6 +181,7 @@ enum nft_table_attributes {
 	NFTA_TABLE_HANDLE,
 	NFTA_TABLE_PAD,
 	NFTA_TABLE_USERDATA,
+	NFTA_TABLE_OWNER,
 	__NFTA_TABLE_MAX
 };
 #define NFTA_TABLE_MAX		(__NFTA_TABLE_MAX - 1)
diff --git a/src/table.c b/src/table.c
index 731c8183ad96..32f1bf705f9f 100644
--- a/src/table.c
+++ b/src/table.c
@@ -34,6 +34,7 @@ struct nftnl_table {
 	uint64_t 	handle;
 	uint32_t	use;
 	uint32_t	flags;
+	uint32_t	owner;
 	struct {
 		void		*data;
 		uint32_t	len;
@@ -76,8 +77,8 @@ void nftnl_table_unset(struct nftnl_table *t, uint16_t attr)
 	case NFTNL_TABLE_FLAGS:
 	case NFTNL_TABLE_HANDLE:
 	case NFTNL_TABLE_FAMILY:
-		break;
 	case NFTNL_TABLE_USE:
+	case NFTNL_TABLE_OWNER:
 		break;
 	}
 	t->flags &= ~(1 << attr);
@@ -127,6 +128,9 @@ int nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
 		memcpy(t->user.data, data, data_len);
 		t->user.len = data_len;
 		break;
+	case NFTNL_TABLE_OWNER:
+		memcpy(&t->owner, data, sizeof(t->owner));
+		break;
 	}
 	t->flags |= (1 << attr);
 	return 0;
@@ -188,6 +192,9 @@ const void *nftnl_table_get_data(const struct nftnl_table *t, uint16_t attr,
 	case NFTNL_TABLE_USERDATA:
 		*data_len = t->user.len;
 		return t->user.data;
+	case NFTNL_TABLE_OWNER:
+		*data_len = sizeof(uint32_t);
+		return &t->owner;
 	}
 	return NULL;
 }
@@ -258,6 +265,7 @@ static int nftnl_table_parse_attr_cb(const struct nlattr *attr, void *data)
 		break;
 	case NFTA_TABLE_FLAGS:
 	case NFTA_TABLE_USE:
+	case NFTA_TABLE_OWNER:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -308,6 +316,10 @@ int nftnl_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_table *t)
 		if (ret < 0)
 			return ret;
 	}
+	if (tb[NFTA_TABLE_OWNER]) {
+		t->owner = ntohl(mnl_attr_get_u32(tb[NFTA_TABLE_OWNER]));
+		t->flags |= (1 << NFTNL_TABLE_OWNER);
+	}
 
 	t->family = nfg->nfgen_family;
 	t->flags |= (1 << NFTNL_TABLE_FAMILY);
-- 
2.20.1

