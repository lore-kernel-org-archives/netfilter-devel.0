Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90649C76196
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Mar 2023 12:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjC1M0b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Mar 2023 08:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjC1M0a (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2023 08:26:30 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C692ABC
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Mar 2023 05:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=V1IgTwD9FG+pc/b70l6f8z7glpmomsF5KueUbfTyRw0=; b=jsfpL3m1TA+m3lyiDrfXMIbpdS
        i350tnEnf/yUCIIODs1X7Q/pC/Iz40suDWCkGvh+/vmZfayx7MwXcK7d5ESTaWLvcZ74MKE5tNRT4
        +II1YgnNff/GUbMHMof17nEvwCOI4NVqF74EtGEtD+1zWHmF/CK/kolJHr2kOHNG2H6Y5JMMfhXiU
        S4wXdgCN5U54mEz7bsHTzPY4INd/X9FLlUXhwtwLhueckODVHoBfGCHZ+fRy3b/Nl9KJkqe2wxet7
        9j9XtSQajfUgZTIOLy/uEgQdctEXB8bxM6ghg6twlrGYiLcGe5W5mksIxZnvMZ885t6KsmuHF07e0
        jyK/9Lbw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ph8PB-00016X-Px; Tue, 28 Mar 2023 14:26:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] xt: Fix translation error path
Date:   Tue, 28 Mar 2023 14:26:16 +0200
Message-Id: <20230328122616.14100-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If xtables support was compiled in but the required libxtables DSO is
not found, nft prints an error message and leaks memory:

| counter packets 0 bytes 0 XT target MASQUERADE not found

This is not as bad as it seems, the output combines stdout and stderr.
Dropping stderr produces an incomplete ruleset listing, though. While
this seemingly inline output can't easily be avoided, fix a few things:

* Respect octx->error_fp, libnftables might have been configured to
  redirect stderr somewhere else.
* Align error message formatting with others.
* Don't return immediately, but free allocated memory and fall back to
  printing the expression in "untranslated" form.

Fixes: 5c30feeee5cfe ("xt: Delay libxtables access until translation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/xt.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/src/xt.c b/src/xt.c
index f63096a554e7f..b17aafd565382 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -56,9 +56,10 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 	case NFT_XT_MATCH:
 		mt = xtables_find_match(stmt->xt.name, XTF_TRY_LOAD, NULL);
 		if (!mt) {
-			fprintf(stderr, "XT match %s not found\n",
+			fprintf(octx->error_fp,
+				"# Warning: XT match %s not found\n",
 				stmt->xt.name);
-			return;
+			break;
 		}
 		size = XT_ALIGN(sizeof(*m)) + stmt->xt.infolen;
 
@@ -83,9 +84,10 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 	case NFT_XT_TARGET:
 		tg = xtables_find_target(stmt->xt.name, XTF_TRY_LOAD);
 		if (!tg) {
-			fprintf(stderr, "XT target %s not found\n",
+			fprintf(octx->error_fp,
+				"# Warning: XT target %s not found\n",
 				stmt->xt.name);
-			return;
+			break;
 		}
 		size = XT_ALIGN(sizeof(*t)) + stmt->xt.infolen;
 
-- 
2.38.0

