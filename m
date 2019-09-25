Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCA6C432C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B672620673
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfIYV1y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:27:54 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45896 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbfIYV1y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 17:27:54 -0400
Received: from localhost ([::1]:58986 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDEpE-0005ID-R6; Wed, 25 Sep 2019 23:27:52 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 02/24] tests/shell: Speed up ipt-restore/0004-restore-race_0
Date:   Wed, 25 Sep 2019 23:25:43 +0200
Message-Id: <20190925212605.1005-3-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925212605.1005-1-phil@nwl.cc>
References: <20190925212605.1005-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This test tended to cause quite excessive load on my system, sometimes
taking longer than all other tests combined. Even with the reduced
numbers, it still fails reliably after reverting commit 58d7de0181f61
("xtables: handle concurrent ruleset modifications").

Fixes: 4000b4cf2ea38 ("tests: add test script for race-free restore")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../tests/shell/testcases/ipt-restore/0004-restore-race_0     | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/tests/shell/testcases/ipt-restore/0004-restore-race_0 b/iptables/tests/shell/testcases/ipt-restore/0004-restore-race_0
index a92d18dcee058..96a5e66d0ab81 100755
--- a/iptables/tests/shell/testcases/ipt-restore/0004-restore-race_0
+++ b/iptables/tests/shell/testcases/ipt-restore/0004-restore-race_0
@@ -24,7 +24,7 @@ clean_tempfile()
 
 trap clean_tempfile EXIT
 
-ENTRY_NUM=$((RANDOM%100))
+ENTRY_NUM=$((RANDOM%10))
 UCHAIN_NUM=$((RANDOM%10))
 
 get_target()
@@ -87,7 +87,7 @@ fi
 
 case "$XT_MULTI" in
 */xtables-nft-multi)
-	attempts=$((RANDOM%200))
+	attempts=$((RANDOM%10))
 	attempts=$((attempts+1))
 	;;
 *)
-- 
2.23.0

