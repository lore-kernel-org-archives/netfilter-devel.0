From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH nft V3] tests: shell: Add tests for json import
Date: Mon,  4 Sep 2017 18:01:33 +0530
Message-ID: <1504528293-22052-1-git-send-email-mayhs11saini@gmail.com>
Cc: Shyam Saini <mayhs11saini@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:38481 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753516AbdIDMbq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2017 08:31:46 -0400
Received: by mail-pf0-f194.google.com with SMTP id q76so93893pfq.5
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Sep 2017 05:31:46 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Test upcoming "import json" statement.

Basically it loads same set of rules by "nft -f" and "nft import json" and
prints differences(if any) in the ruleset listed by "nft list ruleset" in
each case.

	For Example:
	$ ./run-tests.sh testcases/import/json_import_0

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>

---
v3:
  Retain json_import_0 file which runs the actaual tests
  Drop all the rules_* files as they are no longer useful
  Drop all_ruleset_list file as rules are already included in test file

v2:
  Add rules_* file for the reference
  Add all_ruleset_list file containing all the ruleset
  Add json_import_0 which runs the tests
---
 tests/shell/testcases/import/json_import_0 | 72 ++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)
 create mode 100755 tests/shell/testcases/import/json_import_0

diff --git a/tests/shell/testcases/import/json_import_0 b/tests/shell/testcases/import/json_import_0
new file mode 100755
index 0000000..a469a4d
--- /dev/null
+++ b/tests/shell/testcases/import/json_import_0
@@ -0,0 +1,72 @@
+#!/bin/bash
+
+tmpfile=$(mktemp)
+
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="table ip mangle {
+	set blackhole {
+		type ipv4_addr
+		elements = { 192.168.1.4, 192.168.1.5 }
+	}
+
+	chain prerouting {
+		type filter hook prerouting priority 0; policy accept;
+		tcp dport { ssh, http } accept
+		ip saddr @blackhole drop
+		icmp type echo-request accept
+		iifname \"lo\" accept
+		icmp type echo-request counter packets 0 bytes 0
+		ct state established,related accept
+		tcp flags != syn counter packets 7 bytes 841
+		ip saddr 192.168.1.100 ip daddr 192.168.1.1 counter packets 0 bytes 0
+	}
+}
+table arp x {
+	chain y {
+		arp htype 22
+		arp ptype ip
+		arp operation != rrequest
+		arp operation { request, reply, rrequest, rreply, inrequest, inreply, nak }
+		arp hlen 33-45
+	}
+}
+table bridge x {
+	chain y {
+		type filter hook input priority 0; policy accept;
+		vlan id 4094
+		vlan id 4094 vlan cfi 0
+		vlan id 1 ip saddr 10.0.0.0/23 udp dport domain
+	}
+}
+table ip6 x {
+	chain y {
+		type nat hook postrouting priority 0; policy accept;
+		icmpv6 id 33-45
+		ip6 daddr fe00::1-fe00::200 udp dport domain counter packets 0 bytes 0
+		meta l4proto tcp masquerade to :1024
+		iifname \"wlan0\" ct state established,new tcp dport vmap { ssh : drop, 222 : drop } masquerade
+		tcp dport ssh ip6 daddr 1::2 ether saddr 00:0f:54:0c:11:04 accept
+		ip6 daddr fe00::1-fe00::200 udp dport domain counter packets 0 bytes 0 masquerade
+	}
+}"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+$NFT export json > $tmpfile
+$NFT flush ruleset
+cat $tmpfile | $NFT import json
+
+RESULT="$($NFT list ruleset)"
+
+
+if [ "$RULESET" != "$RESULT" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$RULESET") <(echo "$RESULT")
+fi
+
-- 
1.9.1

