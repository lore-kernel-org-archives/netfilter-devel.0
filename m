Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F1FC433FE
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Dec 2020 16:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D98BB22B3B
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Dec 2020 16:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgLDQrx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Dec 2020 11:47:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgLDQrx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Dec 2020 11:47:53 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D065C0613D1
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Dec 2020 08:47:13 -0800 (PST)
Received: from localhost ([::1]:52404 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1klEEf-00081S-TC; Fri, 04 Dec 2020 17:47:09 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] tests/shell: Test for fixed extension registration
Date:   Fri,  4 Dec 2020 17:47:05 +0100
Message-Id: <20201204164705.11281-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use strace to look at iptables-restore behaviour with typically
problematic input (conntrack revision 0 is no longer supported by
current kernels) to make sure the fix in commit a1eaaceb0460b
("libxtables: Simplify pending extension registration") is still
effective.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../0017-pointless-compat-checks_0            | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100755 iptables/tests/shell/testcases/ipt-restore/0017-pointless-compat-checks_0

diff --git a/iptables/tests/shell/testcases/ipt-restore/0017-pointless-compat-checks_0 b/iptables/tests/shell/testcases/ipt-restore/0017-pointless-compat-checks_0
new file mode 100755
index 0000000000000..cf73de32df409
--- /dev/null
+++ b/iptables/tests/shell/testcases/ipt-restore/0017-pointless-compat-checks_0
@@ -0,0 +1,25 @@
+#!/bin/bash
+
+# A bug in extension registration would leave unsupported older extension
+# revisions in pending list and get compatibility checked again for each rule
+# using them. With SELinux enabled, the resulting socket() call per rule leads
+# to significant slowdown (~50% performance in worst cases).
+
+set -e
+
+strace --version >/dev/null || { echo "skip for missing strace"; exit 0; }
+
+RULESET="$(
+	echo "*filter"
+	for ((i = 0; i < 100; i++)); do
+		echo "-A FORWARD -m conntrack --ctstate NEW"
+	done
+	echo "COMMIT"
+)"
+
+cmd="$XT_MULTI iptables-restore"
+socketcount=$(strace -esocket $cmd <<< "$RULESET" 2>&1 | wc -l)
+
+# unpatched iptables-restore would open 111 sockets,
+# patched only 12 but keep a certain margin for future changes
+[[ $socketcount -lt 20 ]]
-- 
2.28.0

