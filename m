Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA8BDC8300A
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 15:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B306320746
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 15:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgD1Plb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 11:41:31 -0400
Received: from correo.us.es ([193.147.175.20]:49362 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728156AbgD1Pla (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 11:41:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 38D271F0CE2
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 17:41:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2835FBAAB5
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 17:41:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1DBC9BAAB4; Tue, 28 Apr 2020 17:41:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2568366E2
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 17:41:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Apr 2020 17:41:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 11DA842EF4E1
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 17:41:26 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v3 3/9] src: add netmap support
Date:   Tue, 28 Apr 2020 17:41:14 +0200
Message-Id: <20200428154120.20061-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200428154120.20061-1-pablo@netfilter.org>
References: <20200428154120.20061-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows you to specify an interval of IP address in maps.

 table ip x {
        chain y {
                type nat hook postrouting priority srcnat; policy accept;
                snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24 }
        }
 }

The example above performs SNAT to packets that comes from
10.141.11.0/24 using the prefix 192.168.2.0/24, e.g. 10.141.11.4 is
mangled to 192.168.2.4.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_nat.h |  4 +++-
 include/statement.h              |  1 +
 src/netlink_delinearize.c        |  4 ++++
 src/parser_bison.y               | 17 +++++++++++++++++
 src/statement.c                  |  2 ++
 5 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_nat.h b/include/linux/netfilter/nf_nat.h
index 4a95c0db14d4..a64586e77b24 100644
--- a/include/linux/netfilter/nf_nat.h
+++ b/include/linux/netfilter/nf_nat.h
@@ -11,6 +11,7 @@
 #define NF_NAT_RANGE_PERSISTENT			(1 << 3)
 #define NF_NAT_RANGE_PROTO_RANDOM_FULLY		(1 << 4)
 #define NF_NAT_RANGE_PROTO_OFFSET		(1 << 5)
+#define NF_NAT_RANGE_NETMAP			(1 << 6)
 
 #define NF_NAT_RANGE_PROTO_RANDOM_ALL		\
 	(NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PROTO_RANDOM_FULLY)
@@ -18,7 +19,8 @@
 #define NF_NAT_RANGE_MASK					\
 	(NF_NAT_RANGE_MAP_IPS | NF_NAT_RANGE_PROTO_SPECIFIED |	\
 	 NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PERSISTENT |	\
-	 NF_NAT_RANGE_PROTO_RANDOM_FULLY | NF_NAT_RANGE_PROTO_OFFSET)
+	 NF_NAT_RANGE_PROTO_RANDOM_FULLY | NF_NAT_RANGE_PROTO_OFFSET | \
+	 NF_NAT_RANGE_NETMAP)
 
 struct nf_nat_ipv4_range {
 	unsigned int			flags;
diff --git a/include/statement.h b/include/statement.h
index 8427f47e4071..01fe416c415a 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -121,6 +121,7 @@ extern const char *nat_etype2str(enum nft_nat_etypes type);
 
 enum {
 	STMT_NAT_F_INTERVAL	= (1 << 0),
+	STMT_NAT_F_PREFIX	= (1 << 1),
 };
 
 struct nat_stmt {
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index f41223a8e24a..b039a1e3c7ac 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -15,6 +15,7 @@
 #include <limits.h>
 #include <linux/netfilter/nf_tables.h>
 #include <arpa/inet.h>
+#include <linux/netfilter/nf_nat.h>
 #include <linux/netfilter.h>
 #include <net/ethernet.h>
 #include <netlink.h>
@@ -1060,6 +1061,9 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_NAT_FLAGS))
 		stmt->nat.flags = nftnl_expr_get_u32(nle, NFTNL_EXPR_NAT_FLAGS);
 
+	if (stmt->nat.flags & NF_NAT_RANGE_NETMAP)
+		stmt->nat.type_flags |= STMT_NAT_F_PREFIX;
+
 	addr = NULL;
 	reg1 = netlink_parse_register(nle, NFTNL_EXPR_NAT_REG_ADDR_MIN);
 	if (reg1) {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 731a5b3ecdf4..3b470cc63235 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3205,6 +3205,23 @@ nat_stmt_args		:	stmt_expr
 				$<stmt>0->nat.addr = $3;
 				$<stmt>0->nat.type_flags = STMT_NAT_F_INTERVAL;
 			}
+			|	nf_key_proto PREFIX TO	stmt_expr
+			{
+				$<stmt>0->nat.family = $1;
+				$<stmt>0->nat.addr = $4;
+				$<stmt>0->nat.type_flags =
+						STMT_NAT_F_PREFIX |
+						STMT_NAT_F_INTERVAL;
+				$<stmt>0->nat.flags |= NF_NAT_RANGE_NETMAP;
+			}
+			|	PREFIX TO	stmt_expr
+			{
+				$<stmt>0->nat.addr = $3;
+				$<stmt>0->nat.type_flags =
+						STMT_NAT_F_PREFIX |
+						STMT_NAT_F_INTERVAL;
+				$<stmt>0->nat.flags |= NF_NAT_RANGE_NETMAP;
+			}
 			;
 
 masq_stmt		:	masq_stmt_alloc		masq_stmt_args
diff --git a/src/statement.c b/src/statement.c
index 5bbc054055bc..8a1cd6e04f61 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -609,6 +609,8 @@ static void nat_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 
 		if (stmt->nat.ipportmap)
 			nft_print(octx, " addr . port");
+		else if (stmt->nat.type_flags & STMT_NAT_F_PREFIX)
+			nft_print(octx, " prefix");
 		else if (stmt->nat.type_flags & STMT_NAT_F_INTERVAL)
 			nft_print(octx, " interval");
 
-- 
2.20.1

