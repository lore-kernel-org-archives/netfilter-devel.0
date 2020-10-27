Return-Path: <SRS0=ZDGT=EC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A89AC388F9
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Oct 2020 16:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6D1B20790
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Oct 2020 16:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1814517AbgJ0Q4s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Oct 2020 12:56:48 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:60428 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1814480AbgJ0Q4L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Oct 2020 12:56:11 -0400
Received: from localhost ([::1]:58286 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kXSGX-00028s-1v; Tue, 27 Oct 2020 17:56:09 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/2] src: Support odd-sized payload matches
Date:   Tue, 27 Oct 2020 17:56:01 +0100
Message-Id: <20201027165602.26630-2-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201027165602.26630-1-phil@nwl.cc>
References: <20201027165602.26630-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When expanding a payload match, don't disregard oversized templates at
the right offset. A more flexible user may extract less bytes from the
packet if only parts of a field are interesting, e.g. only the prefix of
source/destination address. Support that by using the template, but fix
the length. Later when creating a relational expression for it, detect
the unusually small payload expression length and turn the RHS value
into a prefix expression.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink_delinearize.c | 6 ++++++
 src/payload.c             | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 43d7ff821504d..b7876a8da8375 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1776,6 +1776,12 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 		tmp = constant_expr_splice(right, left->len);
 		expr_set_type(tmp, left->dtype, left->byteorder);
 
+		if (left->payload.tmpl && (left->len < left->payload.tmpl->len)) {
+			mpz_lshift_ui(tmp->value, left->payload.tmpl->len - left->len);
+			tmp->len = left->payload.tmpl->len;
+			tmp = prefix_expr_alloc(&tmp->location, tmp, left->len);
+		}
+
 		nexpr = relational_expr_alloc(&expr->location, expr->op,
 					      left, tmp);
 		if (expr->op == OP_EQ)
diff --git a/src/payload.c b/src/payload.c
index ca422d5bcd561..e51c5797c589a 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -822,6 +822,11 @@ void payload_expr_expand(struct list_head *list, struct expr *expr,
 			expr->payload.offset += tmpl->len;
 			if (expr->len == 0)
 				return;
+		} else if (expr->len > 0) {
+			new = payload_expr_alloc(&expr->location, desc, i);
+			new->len = expr->len;
+			list_add_tail(&new->list, list);
+			return;
 		} else
 			break;
 	}
-- 
2.28.0

