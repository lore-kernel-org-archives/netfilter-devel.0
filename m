Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D82C31E5E
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 18:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F7F6206BA
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 18:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730369AbfFRS4A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 14:56:00 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:54552 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730162AbfFRSz7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 14:55:59 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hdJGv-0002en-9n; Tue, 18 Jun 2019 20:55:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] src: statement: disable reject statement type omission for bridge
Date:   Tue, 18 Jun 2019 20:43:58 +0200
Message-Id: <20190618184359.29760-3-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190618184359.29760-1-fw@strlen.de>
References: <20190618184359.29760-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

add rule bridge test-bridge input reject with icmp type port-unreachable

... will be printed as 'reject', which is fine on ip family, but not on
bridge -- 'with icmp type' adds an ipv4 dependency, but simple reject
does not (it will use icmpx to also reject ipv6 packets with an icmpv6 error).

Add a toggle to supress short-hand versions in this case.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/statement.h       | 3 ++-
 src/json.c                | 6 ++++--
 src/netlink_delinearize.c | 6 ++++++
 src/statement.c           | 6 ++++--
 4 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 91d6e0e2cb81..6fb5cf15f8bd 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -102,8 +102,9 @@ extern void __limit_stmt_print(const struct limit_stmt *limit);
 
 struct reject_stmt {
 	struct expr		*expr;
-	enum nft_reject_types	type;
+	enum nft_reject_types	type:8;
 	int8_t			icmp_code;
+	uint8_t			verbose_print:1;
 	unsigned int		family;
 };
 
diff --git a/src/json.c b/src/json.c
index a503a97500a9..e0127c5741a0 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1311,13 +1311,15 @@ json_t *reject_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 	case NFT_REJECT_ICMP_UNREACH:
 		switch (stmt->reject.family) {
 		case NFPROTO_IPV4:
-			if (stmt->reject.icmp_code == ICMP_PORT_UNREACH)
+			if (!stmt->reject.verbose_print &&
+			    stmt->reject.icmp_code == ICMP_PORT_UNREACH)
 				break;
 			type = "icmp";
 			jexpr = expr_print_json(stmt->reject.expr, octx);
 			break;
 		case NFPROTO_IPV6:
-			if (stmt->reject.icmp_code == ICMP6_DST_UNREACH_NOPORT)
+			if (!stmt->reject.verbose_print &&
+			    stmt->reject.icmp_code == ICMP6_DST_UNREACH_NOPORT)
 				break;
 			type = "icmpv6";
 			jexpr = expr_print_json(stmt->reject.expr, octx);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 4d720d2938fc..a4044f0c7329 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2202,6 +2202,12 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 			datatype_set(stmt->reject.expr, &icmpx_code_type);
 			break;
 		}
+
+		/* always print full icmp(6) name, simple 'reject' might be ambiguious
+		 * because ipv4 vs. ipv6 info might be lost
+		 */
+		stmt->reject.verbose_print = 1;
+
 		base = rctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
 		desc = rctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
 		protocol = proto_find_num(base, desc);
diff --git a/src/statement.c b/src/statement.c
index a9e8b3ae0780..c5594233a45f 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -516,13 +516,15 @@ static void reject_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	case NFT_REJECT_ICMP_UNREACH:
 		switch (stmt->reject.family) {
 		case NFPROTO_IPV4:
-			if (stmt->reject.icmp_code == ICMP_PORT_UNREACH)
+			if (!stmt->reject.verbose_print &&
+			     stmt->reject.icmp_code == ICMP_PORT_UNREACH)
 				break;
 			nft_print(octx, " with icmp type ");
 			expr_print(stmt->reject.expr, octx);
 			break;
 		case NFPROTO_IPV6:
-			if (stmt->reject.icmp_code == ICMP6_DST_UNREACH_NOPORT)
+			if (!stmt->reject.verbose_print &&
+			    stmt->reject.icmp_code == ICMP6_DST_UNREACH_NOPORT)
 				break;
 			nft_print(octx, " with icmpv6 type ");
 			expr_print(stmt->reject.expr, octx);
-- 
2.21.0

