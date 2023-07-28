Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 798E8C001E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jul 2023 12:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbjG1McM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 08:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234825AbjG1McK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 08:32:10 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19D310FA
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jul 2023 05:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gN4iYRuXDN7mEINCREPoLs1oXrrNEDLmCoy8qU48Aoc=; b=M4QjHVzPOp+P9l2W7f9E9KesdH
        5It9TL8QBFIpxPyc+wOV7mja1kKcwNUyqzqRmA64jA5LjPbZk2DEgBe1eqnMzYYjTevJnfgMBJFjW
        qtLyfaDHYbh9Y6HRumyHiCtgt4oMQaFf8hAhNMMok2/bPmIEBiG+SgFKYUbl9g/v4ZAlPT6gAdIO8
        pCTAQ4g7F0DCbV1rOV8bZH5JGlsB6foCgL7MnAVly/GH2NLlzY9GnXM/dQQDqzgeNMGJRAmigrwMC
        sjyq60RvRB9EmBsgqBDUJCuioBJyN27F88t+VD5rEH8gVitP5Q4+jnpWvXDjsh1FAVPu66EyVFdie
        uQWXgJPA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qPMdb-0006Bw-Ad
        for netfilter-devel@vger.kernel.org; Fri, 28 Jul 2023 14:32:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/4] tests: shell: Fix and extend chain rename test
Date:   Fri, 28 Jul 2023 14:31:47 +0200
Message-Id: <20230728123147.15750-4-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230728123147.15750-1-phil@nwl.cc>
References: <20230728123147.15750-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The old version exited unintentionally before testing ip6tables. Replace
it by a more complete variant testing for all tools, creating and
renaming of,chains with various illegal names instead of just renaming
to a clashing name.

Fixes: ed9cfe1b48526 ("tests: add initial save/restore test cases")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../tests/shell/testcases/chain/0003rename_0  | 40 +++++++++++++++++++
 .../tests/shell/testcases/chain/0003rename_1  | 12 ------
 2 files changed, 40 insertions(+), 12 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/chain/0003rename_0
 delete mode 100755 iptables/tests/shell/testcases/chain/0003rename_1

diff --git a/iptables/tests/shell/testcases/chain/0003rename_0 b/iptables/tests/shell/testcases/chain/0003rename_0
new file mode 100755
index 0000000000000..4cb2745bc2523
--- /dev/null
+++ b/iptables/tests/shell/testcases/chain/0003rename_0
@@ -0,0 +1,40 @@
+#!/bin/bash -x
+
+die() {
+	echo "E: $@"
+	exit 1
+}
+
+cmds="iptables ip6tables"
+[[ $XT_MULTI == *xtables-nft-multi ]] && cmds+=" arptables ebtables"
+
+declare -A invnames
+invnames["existing"]="c2"
+invnames["spaced"]="foo bar"
+invnames["dashed"]="-foo"
+invnames["negated"]="!foo"
+# XXX: ebtables-nft accepts 255 chars
+#invnames["overlong"]="thisisquitealongnameforachain"
+invnames["standard target"]="ACCEPT"
+invnames["extension target"]="DNAT"
+
+for cmd in $cmds; do
+	$XT_MULTI $cmd -N c1 || die "$cmd: can't add chain c1"
+	$XT_MULTI $cmd -N c2 || die "$cmd: can't add chain c2"
+	for key in "${!invnames[@]}"; do
+		val="${invnames[$key]}"
+		if [[ $key == "extension target" ]]; then
+			if [[ $cmd == "arptables" ]]; then
+				val="mangle"
+			elif [[ $cmd == "ebtables" ]]; then
+				val="dnat"
+			fi
+		fi
+		$XT_MULTI $cmd -N "$val" && \
+			die "$cmd: added chain with $key name"
+		$XT_MULTI $cmd -E c1 "$val" && \
+			die "$cmd: renamed to $key name"
+	done
+done
+
+exit 0
diff --git a/iptables/tests/shell/testcases/chain/0003rename_1 b/iptables/tests/shell/testcases/chain/0003rename_1
deleted file mode 100755
index 975c8e196b9f5..0000000000000
--- a/iptables/tests/shell/testcases/chain/0003rename_1
+++ /dev/null
@@ -1,12 +0,0 @@
-#!/bin/bash
-
-$XT_MULTI iptables -N c1 || exit 0
-$XT_MULTI iptables -N c2 || exit 0
-$XT_MULTI iptables -E c1 c2 || exit 1
-
-$XT_MULTI ip6tables -N c1 || exit 0
-$XT_MULTI ip6tables -N c2 || exit 0
-$XT_MULTI ip6tables -E c1 c2 || exit 1
-
-echo "E: Renamed with existing chain" >&2
-exit 0
-- 
2.40.0

