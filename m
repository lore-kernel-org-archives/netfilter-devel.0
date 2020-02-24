Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE158C35670
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 00:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0CAC2071C
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 00:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbgBXADt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 19:03:49 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46008 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726534AbgBXADt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 19:03:49 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j61Dt-0004lQ-Pl; Mon, 24 Feb 2020 01:03:46 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     nevola@gmail.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/6] evaluate: process concat expressions when used as mapped-to expr
Date:   Mon, 24 Feb 2020 01:03:20 +0100
Message-Id: <20200224000324.9333-3-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200224000324.9333-1-fw@strlen.de>
References: <20200224000324.9333-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Needed to avoid triggering the 'dtype->size == 0' tests.
Evaluation will build a new concatenated type that holds the
size of the aggregate.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index ae629abe247a..7a70eff95998 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3368,6 +3368,10 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 			return set_error(ctx, set, "map definition does not "
 					 "specify mapping data type");
 
+		if (set->data->etype == EXPR_CONCAT &&
+		    expr_evaluate_concat(ctx, &set->data, false) < 0)
+			return -1;
+
 		if (set->data->len == 0 && set->data->dtype->type != TYPE_VERDICT)
 			return set_key_data_error(ctx, set,
 						  set->data->dtype, type);
-- 
2.24.1

