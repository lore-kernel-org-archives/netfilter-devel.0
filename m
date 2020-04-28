Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1F38C83009
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 15:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C2AF206C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 15:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgD1Plc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 11:41:32 -0400
Received: from correo.us.es ([193.147.175.20]:49366 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728131AbgD1Pla (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 11:41:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 89C841F0CE6
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 17:41:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 79ADABAAB5
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 17:41:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6F6C4BAAB4; Tue, 28 Apr 2020 17:41:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 763A120670
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 17:41:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Apr 2020 17:41:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 645E542EF4E1
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 17:41:26 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v3 4/9] src: add STMT_NAT_F_CONCAT flag and use it
Date:   Tue, 28 Apr 2020 17:41:15 +0200
Message-Id: <20200428154120.20061-5-pablo@netfilter.org>
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

Replace ipportmap boolean field by flags.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/statement.h       | 2 +-
 src/evaluate.c            | 2 +-
 src/netlink_delinearize.  | 0
 src/netlink_delinearize.c | 2 +-
 src/netlink_linearize.c   | 6 +++---
 src/parser_bison.y        | 2 +-
 src/statement.c           | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)
 create mode 100644 src/netlink_delinearize.

diff --git a/include/statement.h b/include/statement.h
index 01fe416c415a..7d96b3947dfc 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -122,6 +122,7 @@ extern const char *nat_etype2str(enum nft_nat_etypes type);
 enum {
 	STMT_NAT_F_INTERVAL	= (1 << 0),
 	STMT_NAT_F_PREFIX	= (1 << 1),
+	STMT_NAT_F_CONCAT	= (1 << 2),
 };
 
 struct nat_stmt {
@@ -130,7 +131,6 @@ struct nat_stmt {
 	struct expr		*proto;
 	uint32_t		flags;
 	uint8_t			family;
-	bool			ipportmap;
 	uint32_t		type_flags;
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index a116f7b66e07..cad65cfb7343 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2973,7 +2973,7 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 		if (err < 0)
 			return err;
 
-		if (stmt->nat.ipportmap) {
+		if (stmt->nat.type_flags & STMT_NAT_F_CONCAT) {
 			err = stmt_evaluate_nat_map(ctx, stmt);
 			if (err < 0)
 				return err;
diff --git a/src/netlink_delinearize. b/src/netlink_delinearize.
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index b039a1e3c7ac..772559c838f5 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1110,7 +1110,7 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 
 	if (is_nat_proto_map(addr, family)) {
 		stmt->nat.family = family;
-		stmt->nat.ipportmap = true;
+		stmt->nat.type_flags |= STMT_NAT_F_CONCAT;
 		ctx->stmt = stmt;
 		return;
 	}
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 944fcdae4ee9..08f7f89f1066 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1127,15 +1127,15 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 			}
 		}
 
-		if (stmt->nat.ipportmap) {
+		if (stmt->nat.type_flags & STMT_NAT_F_CONCAT) {
 			/* nat_stmt evaluation step doesn't allow
-			 * stmt->nat.ipportmap && stmt->nat.proto.
+			 * STMT_NAT_F_CONCAT && stmt->nat.proto.
 			 */
 			assert(stmt->nat.proto == NULL);
 
 			pmin_reg = amin_reg;
 
-			/* if ipportmap is set, the mapped type is a
+			/* if STMT_NAT_F_CONCAT is set, the mapped type is a
 			 * concatenation of 'addr . inet_service'.
 			 * The map lookup will then return the
 			 * concatenated value, so we need to skip
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3b470cc63235..b1e869d568a1 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3192,7 +3192,7 @@ nat_stmt_args		:	stmt_expr
 			{
 				$<stmt>0->nat.family = $1;
 				$<stmt>0->nat.addr = $6;
-				$<stmt>0->nat.ipportmap = true;
+				$<stmt>0->nat.type_flags = STMT_NAT_F_CONCAT;
 			}
 			|	nf_key_proto INTERVAL TO	stmt_expr
 			{
diff --git a/src/statement.c b/src/statement.c
index 8a1cd6e04f61..21a1bc8d40dd 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -607,7 +607,7 @@ static void nat_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 			break;
 		}
 
-		if (stmt->nat.ipportmap)
+		if (stmt->nat.type_flags & STMT_NAT_F_CONCAT)
 			nft_print(octx, " addr . port");
 		else if (stmt->nat.type_flags & STMT_NAT_F_PREFIX)
 			nft_print(octx, " prefix");
-- 
2.20.1

