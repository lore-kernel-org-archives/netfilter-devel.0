Return-Path: <SRS0=MXnI=C7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D01AC2D0E2
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Sep 2020 22:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D2A82076E
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Sep 2020 22:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgIVWmc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Sep 2020 18:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIVWmc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Sep 2020 18:42:32 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5223C061755
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2020 15:42:32 -0700 (PDT)
Received: from localhost ([::1]:52108 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kKqzX-0007Wl-5M; Wed, 23 Sep 2020 00:42:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Serhey Popovych <serhe.popovych@gmail.com>
Subject: [iptables PATCH 3/3] libxtables: Register multiple extensions in ascending order
Date:   Wed, 23 Sep 2020 00:53:41 +0200
Message-Id: <20200922225341.8976-4-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200922225341.8976-1-phil@nwl.cc>
References: <20200922225341.8976-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The newly introduced ordered insert algorithm in
xtables_register_{match,target}() works best if extensions of same name
are passed in ascending revisions. Since this is the case in about all
extensions' arrays, iterate over them from beginning to end.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtables.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index de74d361a53af..90b1195c45a58 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1139,9 +1139,10 @@ static bool xtables_fully_register_pending_match(struct xtables_match *me,
 
 void xtables_register_matches(struct xtables_match *match, unsigned int n)
 {
-	do {
-		xtables_register_match(&match[--n]);
-	} while (n > 0);
+	int i;
+
+	for (i = 0; i < n; i++)
+		xtables_register_match(&match[i]);
 }
 
 void xtables_register_target(struct xtables_target *me)
@@ -1264,9 +1265,10 @@ static bool xtables_fully_register_pending_target(struct xtables_target *me,
 
 void xtables_register_targets(struct xtables_target *target, unsigned int n)
 {
-	do {
-		xtables_register_target(&target[--n]);
-	} while (n > 0);
+	int i;
+
+	for (i = 0; i < n; i++)
+		xtables_register_target(&target[i]);
 }
 
 /* receives a list of xtables_rule_match, release them */
-- 
2.28.0

