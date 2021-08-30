Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D2DC4320A
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 22:34:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 044C060FF2
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 22:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238897AbhH3WfQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Aug 2021 18:35:16 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45476 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238898AbhH3WfP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Aug 2021 18:35:15 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id D7C1D60087;
        Tue, 31 Aug 2021 00:33:20 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft 2/2] rule: remove redundant meta protocol from the evaluation step
Date:   Tue, 31 Aug 2021 00:34:12 +0200
Message-Id: <20210830223412.12865-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210830223412.12865-1-pablo@netfilter.org>
References: <20210830223412.12865-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

567ea4774e13 ("netlink_delinearize: incorrect meta protocol dependency kill")
does not document two cases that are handled in this patch:

- 'meta protocol ip' is removed if used in the ip family.
- 'meta protocol ip6' is removed if used in the ip6 family.

This patch removes this redundancy earlier, from the evaluation step
before netlink bytecode generation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c                  | 77 ++++++++++++++++++++++++++-----------
 tests/py/ip/meta.t          |  2 +-
 tests/py/ip/meta.t.payload  |  2 -
 tests/py/ip6/meta.t         |  2 +-
 tests/py/ip6/meta.t.payload |  2 -
 5 files changed, 56 insertions(+), 29 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 3e59f27c69be..6091067f608b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2757,49 +2757,80 @@ static void payload_do_merge(struct stmt *sa[], unsigned int n)
 }
 
 /**
- * payload_try_merge - try to merge consecutive payload match statements
+ * stmt_reduce - reduce statements in rule
  *
  * @rule:	nftables rule
  *
+ * This function aims to:
+ *
+ * - remove redundant statement, e.g. remove 'meta protocol ip' if family is ip
+ * - merge consecutive payload match statements
+ *
  * Locate sequences of payload match statements referring to adjacent
  * header locations and merge those using only equality relations.
  *
  * As a side-effect, payload match statements are ordered in ascending
  * order according to the location of the payload.
  */
-static void payload_try_merge(const struct rule *rule)
+static void stmt_reduce(const struct rule *rule)
 {
+	struct stmt *stmt, *dstmt = NULL, *next;
 	struct stmt *sa[rule->num_stmts];
-	struct stmt *stmt, *next;
 	unsigned int idx = 0;
 
 	list_for_each_entry_safe(stmt, next, &rule->stmts, list) {
+		/* delete this redundant statement */
+		if (dstmt) {
+			list_del(&dstmt->list);
+			stmt_free(dstmt);
+			dstmt = NULL;
+		}
+
 		/* Must not merge across other statements */
-		if (stmt->ops->type != STMT_EXPRESSION)
-			goto do_merge;
+		if (stmt->ops->type != STMT_EXPRESSION) {
+			if (idx < 2)
+				continue;
 
-		if (stmt->expr->etype != EXPR_RELATIONAL)
+			payload_do_merge(sa, idx);
+			idx = 0;
 			continue;
-		if (stmt->expr->left->etype != EXPR_PAYLOAD)
+		}
+
+		if (stmt->expr->etype != EXPR_RELATIONAL)
 			continue;
 		if (stmt->expr->right->etype != EXPR_VALUE)
 			continue;
-		switch (stmt->expr->op) {
-		case OP_EQ:
-		case OP_IMPLICIT:
-		case OP_NEQ:
-			break;
-		default:
-			continue;
-		}
 
-		sa[idx++] = stmt;
-		continue;
-do_merge:
-		if (idx < 2)
-			continue;
-		payload_do_merge(sa, idx);
-		idx = 0;
+		if (stmt->expr->left->etype == EXPR_PAYLOAD) {
+			switch (stmt->expr->op) {
+			case OP_EQ:
+			case OP_IMPLICIT:
+			case OP_NEQ:
+				break;
+			default:
+				continue;
+			}
+
+			sa[idx++] = stmt;
+		} else if (stmt->expr->left->etype == EXPR_META) {
+			switch (stmt->expr->op) {
+			case OP_EQ:
+			case OP_IMPLICIT:
+				if (stmt->expr->left->meta.key == NFT_META_PROTOCOL) {
+					uint16_t protocol;
+
+					protocol = mpz_get_uint16(stmt->expr->right->value);
+					if ((rule->handle.family == NFPROTO_IPV4 &&
+					     protocol == ETH_P_IP) ||
+					    (rule->handle.family == NFPROTO_IPV6 &&
+					     protocol == ETH_P_IPV6))
+						dstmt = stmt;
+				}
+				break;
+			default:
+				break;
+			}
+		}
 	}
 
 	if (idx > 1)
@@ -2808,6 +2839,6 @@ do_merge:
 
 struct error_record *rule_postprocess(struct rule *rule)
 {
-	payload_try_merge(rule);
+	stmt_reduce(rule);
 	return NULL;
 }
diff --git a/tests/py/ip/meta.t b/tests/py/ip/meta.t
index fecd0caf71a7..5a05923a1ce1 100644
--- a/tests/py/ip/meta.t
+++ b/tests/py/ip/meta.t
@@ -8,7 +8,7 @@ meta l4proto ipv6-icmp icmpv6 type nd-router-advert;ok;icmpv6 type nd-router-adv
 meta l4proto 58 icmpv6 type nd-router-advert;ok;icmpv6 type nd-router-advert
 icmpv6 type nd-router-advert;ok
 
-meta protocol ip udp dport 67;ok
+meta protocol ip udp dport 67;ok;udp dport 67
 
 meta ibrname "br0";fail
 meta obrname "br0";fail
diff --git a/tests/py/ip/meta.t.payload b/tests/py/ip/meta.t.payload
index a1fd00864ef9..afde5cc13ac5 100644
--- a/tests/py/ip/meta.t.payload
+++ b/tests/py/ip/meta.t.payload
@@ -47,8 +47,6 @@ ip6 test-ip4 input
 
 # meta protocol ip udp dport 67
 ip test-ip4 input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
diff --git a/tests/py/ip6/meta.t b/tests/py/ip6/meta.t
index 2c1aee2309a9..471e14811975 100644
--- a/tests/py/ip6/meta.t
+++ b/tests/py/ip6/meta.t
@@ -10,7 +10,7 @@ meta l4proto 1 icmp type echo-request;ok;icmp type echo-request
 icmp type echo-request;ok
 
 meta protocol ip udp dport 67;ok
-meta protocol ip6 udp dport 67;ok
+meta protocol ip6 udp dport 67;ok;udp dport 67
 
 meta sdif "lo" accept;ok
 meta sdifname != "vrf1" accept;ok
diff --git a/tests/py/ip6/meta.t.payload b/tests/py/ip6/meta.t.payload
index 59c20d994138..0e3db6ba07f9 100644
--- a/tests/py/ip6/meta.t.payload
+++ b/tests/py/ip6/meta.t.payload
@@ -56,8 +56,6 @@ ip6 test-ip6 input
 
 # meta protocol ip6 udp dport 67
 ip6 test-ip6 input
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-- 
2.20.1

