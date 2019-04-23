Return-Path: <SRS0=M2Uw=SZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63109C10F14
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CB3020645
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfDWNWo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 09:22:44 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57332 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726421AbfDWNWn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 09:22:43 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hIvNh-0000qC-5r; Tue, 23 Apr 2019 15:22:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH xtables-nft 6/6] tests: add test script for race-free restore
Date:   Tue, 23 Apr 2019 15:16:25 +0200
Message-Id: <20190423131625.23377-7-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190423131625.23377-1-fw@strlen.de>
References: <20190423131625.23377-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

xtables-nft-restore ignores -w, check that we don't add
duplicate rules when parallel restores happen.

With a slightly older iptables-nft version this ususally fails with:
I: [EXECUTING] iptables/tests/shell/testcases/ipt-restore/0004-restore-race_0
iptables-restore v1.8.2 (nf_tables):
line 5: CHAIN_USER_ADD failed (File exists): chain UC-0
line 6: CHAIN_USER_ADD failed (File exists): chain UC-1
W: [FAILED] ipt-restore/0004-restore-race_0: expected 0 but got 4

or
I: [EXECUTING]   iptables/tests/shell/testcases/ipt-restore/0004-restore-race_0
iptables-restore v1.8.2 (nf_tables):
line 1: TABLE_FLUSH failed (No such file or directory): table filter

or
/tmp/tmp.SItN4URxxF /tmp/tmp.P1y4LIxhTl differ: byte 7159, line 137

As the legacy version should not have such race (due to nature
of full-table-replace), only do one iteration for legacy case.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testcases/ipt-restore/0004-restore-race_0 | 119 ++++++++++++++++++
 1 file changed, 119 insertions(+)
 create mode 100755 iptables/tests/shell/testcases/ipt-restore/0004-restore-race_0

diff --git a/iptables/tests/shell/testcases/ipt-restore/0004-restore-race_0 b/iptables/tests/shell/testcases/ipt-restore/0004-restore-race_0
new file mode 100755
index 000000000000..14b910eb373b
--- /dev/null
+++ b/iptables/tests/shell/testcases/ipt-restore/0004-restore-race_0
@@ -0,0 +1,119 @@
+#!/bin/bash
+
+export XTABLES_LIBDIR=$(pwd)/extensions
+have_nft=false
+nft -v > /dev/null && have_nft=true
+
+dumpfile=""
+tmpfile=""
+
+set -e
+
+clean()
+{
+	$XT_MULTI iptables -t filter -F
+	$XT_MULTI iptables -t filter -X
+	$have_nft && nft flush ruleset
+}
+
+clean_tempfile()
+{
+	[ -n "${tmpfile}" ] && rm -f "${tmpfile}"
+	[ -n "${dumpfile}" ] && rm -f "${dumpfile}"
+	clean
+}
+
+trap clean_tempfile EXIT
+
+ENTRY_NUM=$((RANDOM%100))
+UCHAIN_NUM=$((RANDOM%10))
+
+get_target()
+{
+	if [ $UCHAIN_NUM -eq 0 ]; then
+		echo -n "ACCEPT"
+		return
+	fi
+
+
+	x=$((RANDOM%2))
+	if [ $x -eq 0 ];then
+		echo -n "ACCEPT"
+	else
+		printf -- "UC-%x" $((RANDOM%UCHAIN_NUM))
+	fi
+}
+
+make_dummy_rules()
+{
+
+	echo "*filter"
+	echo ":INPUT ACCEPT [0:0]"
+	echo ":FORWARD ACCEPT [0:0]"
+	echo ":OUTPUT ACCEPT [0:0]"
+
+	if [ $UCHAIN_NUM -gt 0 ]; then
+		for i in $(seq 0 $UCHAIN_NUM); do
+			printf -- ":UC-%x - [0:0]\n" $i
+		done
+	fi
+
+	for proto in tcp udp sctp; do
+		for i in $(seq 0 $ENTRY_NUM); do
+			t=$(get_target)
+			printf -- "-A INPUT -i lo -p $proto --dport %d -j %s\n" $((61000-i)) $t
+			t=$(get_target)
+			printf -- "-A FORWARD -i lo -o lo -p $proto --dport %d -j %s\n" $((61000-i)) $t
+			t=$(get_target)
+			printf -- "-A OUTPUT -o lo -p $proto --dport %d -j %s\n" $((61000-i)) $t
+			[ $UCHAIN_NUM -gt 0 ] && printf -- "-A UC-%x -j ACCEPT\n" $((RANDOM%UCHAIN_NUM))
+		done
+	done
+	echo COMMIT
+}
+
+tmpfile=$(mktemp) || exit 1
+dumpfile=$(mktemp) || exit 1
+
+make_dummy_rules > $dumpfile
+$XT_MULTI iptables-restore -w < $dumpfile
+LINES=$(wc -l < $dumpfile)
+$XT_MULTI iptables-save | grep -v '^#' > $dumpfile
+LINES2=$(wc -l < $dumpfile)
+
+if [ $LINES -ne $LINES2 ]; then
+	echo "Original dump has $LINES, not $LINES2" 1>&2
+	exit 111
+fi
+
+case "$XT_MULTI" in
+*/xtables-nft-multi)
+	attempts=$((RANDOM%200))
+	attempts=$((attempts+1))
+	;;
+*)
+	attempts=1
+	;;
+esac
+
+while [ $attempts -gt 0 ]; do
+	attempts=$((attempts-1))
+
+	clean
+
+	for i in $(seq 1 10); do
+		$XT_MULTI iptables-restore -w 15 < $dumpfile &
+	done
+
+	for i in $(seq 1 10); do
+		# causes exit in case ipt-restore failed (runs with set -e)
+		wait %$i
+	done
+
+	$XT_MULTI iptables-save | grep -v '^#' > $tmpfile
+
+	clean
+	cmp $tmpfile $dumpfile
+done
+
+exit 0
-- 
2.21.0

