Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5012C433B4
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 23:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EBD961417
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 23:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbhDTX0Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Apr 2021 19:26:25 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40420 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233964AbhDTX0Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Apr 2021 19:26:25 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id D7A1F630C2
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Apr 2021 01:25:20 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] expr: socket: add cgroups v2 support
Date:   Wed, 21 Apr 2021 01:25:49 +0200
Message-Id: <20210420232549.10885-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add NFT_SOCKET_CGROUPSV2 key type and NFTA_SOCKET_LEVEL attribute.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/expr.h             |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 src/expr/socket.c                   | 18 ++++++++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 8e90a6ae60a3..4e6059a609df 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -81,6 +81,7 @@ enum {
 enum {
 	NFTNL_EXPR_SOCKET_KEY	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_SOCKET_DREG,
+	NFTNL_EXPR_SOCKET_LEVEL,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index b21be8afa6f1..e0d573647c38 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -992,6 +992,7 @@ enum nft_socket_attributes {
 	NFTA_SOCKET_UNSPEC,
 	NFTA_SOCKET_KEY,
 	NFTA_SOCKET_DREG,
+	NFTA_SOCKET_LEVEL,
 	__NFTA_SOCKET_MAX
 };
 #define NFTA_SOCKET_MAX		(__NFTA_SOCKET_MAX - 1)
@@ -1007,6 +1008,7 @@ enum nft_socket_keys {
 	NFT_SOCKET_TRANSPARENT,
 	NFT_SOCKET_MARK,
 	NFT_SOCKET_WILDCARD,
+	NFT_SOCKET_CGROUPV2,
 	__NFT_SOCKET_MAX
 };
 #define NFT_SOCKET_MAX	(__NFT_SOCKET_MAX - 1)
diff --git a/src/expr/socket.c b/src/expr/socket.c
index c7337cf75378..02d86f8ac57c 100644
--- a/src/expr/socket.c
+++ b/src/expr/socket.c
@@ -22,6 +22,7 @@
 struct nftnl_expr_socket {
 	enum nft_socket_keys	key;
 	enum nft_registers	dreg;
+	uint32_t		level;
 };
 
 static int
@@ -37,6 +38,9 @@ nftnl_expr_socket_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_SOCKET_DREG:
 		memcpy(&socket->dreg, data, sizeof(socket->dreg));
 		break;
+	case NFTNL_EXPR_SOCKET_LEVEL:
+		memcpy(&socket->level, data, sizeof(socket->level));
+		break;
 	default:
 		return -1;
 	}
@@ -56,6 +60,9 @@ nftnl_expr_socket_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_SOCKET_DREG:
 		*data_len = sizeof(socket->dreg);
 		return &socket->dreg;
+	case NFTNL_EXPR_SOCKET_LEVEL:
+		*data_len = sizeof(socket->level);
+		return &socket->level;
 	}
 	return NULL;
 }
@@ -71,6 +78,7 @@ static int nftnl_expr_socket_cb(const struct nlattr *attr, void *data)
 	switch (type) {
 	case NFTA_SOCKET_KEY:
 	case NFTA_SOCKET_DREG:
+	case NFTA_SOCKET_LEVEL:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -89,6 +97,8 @@ nftnl_expr_socket_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 		mnl_attr_put_u32(nlh, NFTA_SOCKET_KEY, htonl(socket->key));
 	if (e->flags & (1 << NFTNL_EXPR_SOCKET_DREG))
 		mnl_attr_put_u32(nlh, NFTA_SOCKET_DREG, htonl(socket->dreg));
+	if (e->flags & (1 << NFTNL_EXPR_SOCKET_LEVEL))
+		mnl_attr_put_u32(nlh, NFTA_SOCKET_LEVEL, htonl(socket->level));
 }
 
 static int
@@ -108,6 +118,10 @@ nftnl_expr_socket_parse(struct nftnl_expr *e, struct nlattr *attr)
 		socket->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_SOCKET_DREG]));
 		e->flags |= (1 << NFTNL_EXPR_SOCKET_DREG);
 	}
+	if (tb[NFTA_SOCKET_LEVEL]) {
+		socket->level = ntohl(mnl_attr_get_u32(tb[NFTA_SOCKET_LEVEL]));
+		e->flags |= (1 << NFTNL_EXPR_SOCKET_LEVEL);
+	}
 
 	return 0;
 }
@@ -116,6 +130,7 @@ static const char *socket_key2str_array[NFT_SOCKET_MAX + 1] = {
 	[NFT_SOCKET_TRANSPARENT] = "transparent",
 	[NFT_SOCKET_MARK] = "mark",
 	[NFT_SOCKET_WILDCARD] = "wildcard",
+	[NFT_SOCKET_CGROUPV2] = "cgroupv2",
 };
 
 static const char *socket_key2str(uint8_t key)
@@ -136,6 +151,9 @@ nftnl_expr_socket_snprintf(char *buf, size_t len,
 		return snprintf(buf, len, "load %s => reg %u ",
 				socket_key2str(socket->key), socket->dreg);
 	}
+	if (e->flags & (1 << NFTNL_EXPR_SOCKET_LEVEL))
+		return snprintf(buf, len, "level %u ", socket->level);
+
 	return 0;
 }
 
-- 
2.30.2

