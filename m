Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28858C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Feb 2021 10:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC1D864EC8
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Feb 2021 10:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbhBXKI6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Feb 2021 05:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234763AbhBXKIz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Feb 2021 05:08:55 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB8AC061786
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Feb 2021 02:08:14 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lEr5Y-00016C-8A; Wed, 24 Feb 2021 11:08:12 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables-nft] iptables-nft: fix -Z option
Date:   Wed, 24 Feb 2021 11:08:02 +0100
Message-Id: <20210224100802.2352-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

it zeroes the rule counters, so it needs fully populated cache.
Add a test case to cover this.

Fixes: 9d07514ac5c7a ("nft: calculate cache requirements from list of commands")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft-cmd.c                            |  2 +-
 .../testcases/iptables/0007-zero-counters_0   | 64 +++++++++++++++++++
 2 files changed, 65 insertions(+), 1 deletion(-)
 create mode 100755 iptables/tests/shell/testcases/iptables/0007-zero-counters_0

diff --git a/iptables/nft-cmd.c b/iptables/nft-cmd.c
index 5d33f1f00f57..f2b935c57dab 100644
--- a/iptables/nft-cmd.c
+++ b/iptables/nft-cmd.c
@@ -185,7 +185,7 @@ int nft_cmd_chain_zero_counters(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
-	nft_cache_level_set(h, NFT_CL_CHAINS, cmd);
+	nft_cache_level_set(h, NFT_CL_RULES, cmd);
 
 	return 1;
 }
diff --git a/iptables/tests/shell/testcases/iptables/0007-zero-counters_0 b/iptables/tests/shell/testcases/iptables/0007-zero-counters_0
new file mode 100755
index 000000000000..36da1907e3b2
--- /dev/null
+++ b/iptables/tests/shell/testcases/iptables/0007-zero-counters_0
@@ -0,0 +1,64 @@
+#!/bin/bash
+
+RC=0
+COUNTR=$RANDOM$RANDOM
+
+$XT_MULTI iptables-restore -c <<EOF
+*filter
+:INPUT ACCEPT [1:23]
+:FOO - [0:0]
+[12:345] -A INPUT -i lo -p icmp -m comment --comment "$COUNTR"
+[22:123] -A FOO -m comment --comment one
+[44:123] -A FOO -m comment --comment two
+COMMIT
+EOF
+EXPECT="*filter
+:INPUT ACCEPT [0:0]
+:FORWARD ACCEPT [0:0]
+:OUTPUT ACCEPT [0:0]
+:FOO - [0:0]
+[0:0] -A INPUT -i lo -p icmp -m comment --comment "$COUNTR"
+[0:0] -A FOO -m comment --comment one
+[0:0] -A FOO -m comment --comment two
+COMMIT"
+
+COUNTER=$($XT_MULTI iptables-save -c |grep "comment $COUNTR"| cut -f 1 -d " ")
+if [ $COUNTER != "[12:345]" ]; then
+	echo "Counter $COUNTER is wrong, expected 12:345"
+	RC=1
+fi
+
+$XT_MULTI iptables -Z FOO
+COUNTER=$($XT_MULTI iptables-save -c |grep "comment $COUNTR"| cut -f 1 -d " ")
+if [ $COUNTER = "[0:0]" ]; then
+	echo "Counter $COUNTER is wrong, should not have been zeroed"
+	RC=1
+fi
+
+for c in one two; do
+	COUNTER=$($XT_MULTI iptables-save -c |grep "comment $c"| cut -f 1 -d " ")
+	if [ $COUNTER != "[0:0]" ]; then
+		echo "Counter $COUNTER is wrong, should have been zeroed at rule $c"
+		RC=1
+	fi
+done
+
+$XT_MULTI iptables -Z
+COUNTER=$($XT_MULTI iptables-save -c |grep "comment $COUNTR"| cut -f 1 -d " ")
+
+if [ $COUNTER != "[0:0]" ]; then
+	echo "Counter $COUNTER is wrong, expected 0:0 after -Z"
+	RC=1
+fi
+
+diff -u -Z <(echo -e "$EXPECT") <($XT_MULTI iptables-save -c | grep -v '^#')
+if [ $? -ne 0 ]; then
+	echo "Diff error: counters were not zeroed"
+	RC=1
+fi
+
+$XT_MULTI iptables -D INPUT -i lo -p icmp -m comment --comment "$COUNTR"
+$XT_MULTI iptables -D FOO -m comment --comment one
+$XT_MULTI iptables -D FOO -m comment --comment two
+$XT_MULTI iptables -X FOO
+exit $RC
-- 
2.26.2

