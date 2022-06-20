Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0172CC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jun 2022 08:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbiFTIcb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jun 2022 04:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239445AbiFTIc2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jun 2022 04:32:28 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7BD7312A9A
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2022 01:32:26 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 09/18] optimize: add fib expression support
Date:   Mon, 20 Jun 2022 10:32:06 +0200
Message-Id: <20220620083215.1021238-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620083215.1021238-1-pablo@netfilter.org>
References: <20220620083215.1021238-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend expr_cmp() to compare fib expressions used in relational.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/src/optimize.c b/src/optimize.c
index 919f8013046b..2063761a503a 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -93,6 +93,12 @@ static bool __expr_cmp(const struct expr *expr_a, const struct expr *expr_b)
 		if (expr_a->xfrm.direction != expr_b->xfrm.direction)
 			return false;
 		break;
+	case EXPR_FIB:
+		if (expr_a->fib.flags != expr_b->fib.flags)
+			return false;
+		if (expr_a->fib.result != expr_b->fib.result)
+			return false;
+		break;
 	default:
 		return false;
 	}
-- 
2.30.2

