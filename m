Return-Path: <SRS0=t7ih=D6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87870C4363A
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Oct 2020 12:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AB65206DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Oct 2020 12:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372365AbgJWM1g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Oct 2020 08:27:36 -0400
Received: from correo.us.es ([193.147.175.20]:58740 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S372336AbgJWM1f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Oct 2020 08:27:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7D324DA714
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2020 14:27:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 70889DA73F
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2020 14:27:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 65FE2DA789; Fri, 23 Oct 2020 14:27:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 58538DA73F
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2020 14:27:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 23 Oct 2020 14:27:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 4433F4301DE0
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2020 14:27:31 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] Revert "monitor: do not print generation ID with --echo"
Date:   Fri, 23 Oct 2020 14:27:27 +0200
Message-Id: <20201023122727.2999-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Revert 0e258556f7f3 ("monitor: do not print generation ID with --echo").

There is actually a kernel bug which is preventing from displaying
this generation ID message.

Update the tests/shell to remove the last line of the --echo output
which displays the generation ID once the "netfilter: nftables: fix netlink
report logic in flowtable and genid" kernel fix is applied.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/monitor.c                                               | 2 +-
 tests/shell/testcases/sets/0036add_set_element_expiration_0 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/monitor.c b/src/monitor.c
index 9e508f8f7574..3872ebcfbdaf 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -849,7 +849,7 @@ static int netlink_events_newgen_cb(const struct nlmsghdr *nlh, int type,
 			break;
 		}
 	}
-	if (!nft_output_echo(&monh->ctx->nft->output) && genid >= 0) {
+	if (genid >= 0) {
 		nft_mon_print(monh, "# new generation %d", genid);
 		if (pid >= 0)
 			nft_mon_print(monh, " by process %d (%s)", pid, name);
diff --git a/tests/shell/testcases/sets/0036add_set_element_expiration_0 b/tests/shell/testcases/sets/0036add_set_element_expiration_0
index 51ed0f2c1b3e..7b2e39a3f040 100755
--- a/tests/shell/testcases/sets/0036add_set_element_expiration_0
+++ b/tests/shell/testcases/sets/0036add_set_element_expiration_0
@@ -6,7 +6,7 @@ RULESET="add table ip x
 add set ip x y { type ipv4_addr; flags dynamic,timeout; } 
 add element ip x y { 1.1.1.1 timeout 30s expires 15s }"
 
-test_output=$($NFT -e -f - <<< "$RULESET" 2>&1)
+test_output=$($NFT -e -f - <<< "$RULESET" 2>&1 | head -n -1)
 
 if [ "$test_output" != "$RULESET" ] ; then
 	$DIFF -u <(echo "$test_output") <(echo "$RULESET")
-- 
2.20.1

