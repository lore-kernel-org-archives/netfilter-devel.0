Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20EB2EB8FDE
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 00:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbjIHAWk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 20:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233455AbjIHAWj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 20:22:39 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06991BD3;
        Thu,  7 Sep 2023 17:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=G9mXEfJSBER4EnSxCqgA1rbfEQRhxdCUIx4WvO2AO80=; b=kfgB5GXs5R7imCUK3JVH2ZLwfv
        AR3QLJ5uIsoOsJFDrnH9wzDBl3twfBmAF4lBM4U7CrRCsdAKCAvjht8mDblM7dtZ3Yw0GyPHwBca3
        3aAPx98KEy+2P3ptxgCdeTdTUdWiQt6ZoEDzHL56uNHHXN3GrH2BPPN/rB+YmQUjWjDibOKWKWIKp
        +PJ2ByZve5b2NzMuR/CMzN8r3r7niIsHG2zlY/6LizOLdIrln69MMOLUvGqyJZUv+Uv3GfmmojFvR
        0iC6I9Zs01FquYVu1468FLpecASxgw0oeUhS6D8OwYkQFwGWzeXEaGh5bAfR4NlXPUjGPOhQUGVJF
        3RvD7yPw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qePGb-000058-7X; Fri, 08 Sep 2023 02:22:33 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org
Subject: [nf-next RFC 2/2] selftests: netfilter: Test nf_tables audit logging
Date:   Fri,  8 Sep 2023 02:22:29 +0200
Message-ID: <20230908002229.1409-3-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230908002229.1409-1-phil@nwl.cc>
References: <20230908002229.1409-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Perform ruleset modifications and compare the NETFILTER_CFG type
notifications emitted by auditd match expectations.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Calling auditd means enabling audit logging in kernel for the remaining
uptime. So this test will slow down following ones or even cause
spurious failures due to unexpected kernel log entries, timeouts, etc.

Is there a way to test this in a less intrusive way? Maybe fence this
test so it does not run automatically (is it any good having it in
kernel then)?
---
 .../testing/selftests/netfilter/nft_audit.sh  | 75 +++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100755 tools/testing/selftests/netfilter/nft_audit.sh

diff --git a/tools/testing/selftests/netfilter/nft_audit.sh b/tools/testing/selftests/netfilter/nft_audit.sh
new file mode 100755
index 0000000000000..55c750720137f
--- /dev/null
+++ b/tools/testing/selftests/netfilter/nft_audit.sh
@@ -0,0 +1,75 @@
+#!/bin/bash
+
+SKIP_RC=4
+RC=0
+
+nft --version >/dev/null 2>&1 || {
+	echo "SKIP: missing nft tool"
+	exit $SKIP_RC
+}
+
+auditd --help >/dev/null 2>&1
+[ $? -eq 2 ] || {
+	echo "SKIP: missing auditd tool"
+	exit $SKIP_RC
+}
+
+tmpdir=$(mktemp -d)
+audit_log="$tmpdir/audit.log"
+cat >"$tmpdir/auditd.conf" <<EOF
+write_logs = no
+space_left = 75
+EOF
+auditd -f -c "$tmpdir" >"$audit_log" &
+audit_pid=$!
+trap 'kill $audit_pid; rm -rf $tmpdir' EXIT
+sleep 1
+
+logread() {
+	grep 'type=NETFILTER_CFG' "$audit_log" | \
+		sed -e 's/\(type\|msg\|pid\)=[^ ]* //g' \
+		    -e 's/\(table=[^:]*\):[0-9]*/\1/'
+}
+
+do_test() { # (cmd, log)
+	echo -n "testing for cmd: $1 ... "
+	echo >"$audit_log"
+	$1 >/dev/null || exit 1
+	diff -q <(echo "$2") <(logread) >/dev/null && { echo "OK"; return; }
+	echo "FAIL"
+	diff -u <(echo "$2") <(logread)
+	((RC++))
+}
+
+nft flush ruleset
+
+for table in t1 t2; do
+	echo "add table $table"
+	for chain in c1 c2 c3; do
+		echo "add chain $table $chain"
+		echo "add rule $table $chain counter accept"
+		echo "add rule $table $chain counter accept"
+		echo "add rule $table $chain counter accept"
+	done
+done | nft -f - || exit 1
+
+do_test 'nft reset rules t1 c2' \
+	'table=t1 family=2 entries=3 op=nft_reset_rule subj=kernel comm="nft"'
+
+do_test 'nft reset rules table t1' \
+	'table=t1 family=2 entries=9 op=nft_reset_rule subj=kernel comm="nft"'
+
+do_test 'nft reset rules' \
+	'table=t1 family=2 entries=9 op=nft_reset_rule subj=kernel comm="nft"
+table=t2 family=2 entries=9 op=nft_reset_rule subj=kernel comm="nft"'
+
+for ((i = 0; i < 500; i++)); do
+	echo "add rule t2 c3 counter accept comment \"rule $i\""
+done | nft -f - || exit 1
+
+do_test 'nft reset rules t2 c3' \
+	'table=t2 family=2 entries=189 op=nft_reset_rule subj=kernel comm="nft"
+table=t2 family=2 entries=188 op=nft_reset_rule subj=kernel comm="nft"
+table=t2 family=2 entries=126 op=nft_reset_rule subj=kernel comm="nft"'
+
+exit $RC
-- 
2.41.0

