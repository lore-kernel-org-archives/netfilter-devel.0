Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1496C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Nov 2022 17:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbiKQRqT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Nov 2022 12:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234802AbiKQRqT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Nov 2022 12:46:19 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7722B663E7
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Nov 2022 09:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=K6nafPsyPM8cQHdtBR0hZagy5G0SzPIdM6BzDNQts/8=; b=dh1uMH7d8g4UiOnV2a3QQpb8C8
        JAWKzfDfV25PhxpBy8HC39LJBZr2odizjqmimzNFqQDunmEVwFsipHzQg1t6/yaTBuWMQlsjvKtET
        9QwcVV4twKJYFUib+76rRzgiSY3wm5drzNkKd8zQY8/4h4h0jHA7qPLhjZrjG4OD+a1CoDlty9Gsm
        4eQ97cXesoO7+17HRjzrdORkZFXEOqJ8F1m96MSJQiX/KPXPfvykUkrIjltQyNa7GW5+voCbhaoBk
        02CtcQdV1hvW2IoUCTGuzH2aGUOO/OATABPROYzeau/9ZV+DrDRhiKmgpMRBc8JRvNltX3S5DZwjF
        EN8FwVQQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ovixs-0001km-Ru; Thu, 17 Nov 2022 18:46:16 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 4/4] xt: Detect xlate callback failure
Date:   Thu, 17 Nov 2022 18:45:46 +0100
Message-Id: <20221117174546.21715-5-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221117174546.21715-1-phil@nwl.cc>
References: <20221117174546.21715-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If an extension's xlate callback returns 0, translation is at least
incomplete. Discard the result and resort to opaque dump format in this
case.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/xt.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/src/xt.c b/src/xt.c
index e3063612c353e..178761a42018d 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -116,6 +116,7 @@ static bool xt_stmt_xlate_match(const struct stmt *stmt, void *entry,
 	};
 	struct xtables_match *mt;
 	struct xt_entry_match *m;
+	int rc;
 
 	mt = xtables_find_match(stmt->xt.name, XTF_TRY_LOAD, NULL);
 	if (!mt) {
@@ -132,10 +133,10 @@ static bool xt_stmt_xlate_match(const struct stmt *stmt, void *entry,
 	memcpy(&m->data, stmt->xt.info, stmt->xt.infolen);
 
 	params.match = m;
-	mt->xlate(xl, &params);
+	rc = mt->xlate(xl, &params);
 
 	xfree(m);
-	return true;
+	return rc != 0;
 }
 
 static bool xt_stmt_xlate_target(const struct stmt *stmt, void *entry,
@@ -149,6 +150,7 @@ static bool xt_stmt_xlate_target(const struct stmt *stmt, void *entry,
 	};
 	struct xtables_target *tg;
 	struct xt_entry_target *t;
+	int rc;
 
 	tg = xtables_find_target(stmt->xt.name, XTF_TRY_LOAD);
 	if (!tg) {
@@ -166,10 +168,10 @@ static bool xt_stmt_xlate_target(const struct stmt *stmt, void *entry,
 	strcpy(t->u.user.name, tg->name);
 
 	params.target = t;
-	tg->xlate(xl, &params);
+	rc = tg->xlate(xl, &params);
 
 	xfree(t);
-	return true;
+	return rc != 0;
 }
 #endif
 
-- 
2.38.0

