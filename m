From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH nft V5 2/2] tests: shell: Add tests for low level json
 import
Date: Tue,  5 Dec 2017 19:37:35 +0530
Message-ID: <1512482855-29426-2-git-send-email-mayhs11saini@gmail.com>
References: <1512482855-29426-1-git-send-email-mayhs11saini@gmail.com>
Cc: Shyam Saini <mayhs11saini@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:39348 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753414AbdLEOH4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Dec 2017 09:07:56 -0500
Received: by mail-pg0-f67.google.com with SMTP id w7so210496pgv.6
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Dec 2017 06:07:56 -0800 (PST)
In-Reply-To: <1512482855-29426-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Test upcoming "import json" statement.

Basically it loads same set of rules by "nft -f" and "nft import vm json"
and prints differences(if any) in the ruleset listed by "nft list
ruleset" in each case.

        For Example:
        $ ./run-tests.sh testcases/import/vm_json_import_0

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
V5:
  Patch series rebased

V4:
  Adopt new "vm" symbol for export/import operations
---
 tests/shell/testcases/import/vm_json_import_0 | 71 +++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)
 create mode 100755 tests/shell/testcases/import/vm_json_import_0

diff --git a/tests/shell/testcases/import/vm_json_import_0 b/tests/shell/testcases/import/vm_json_import_0
new file mode 100755
index 000000000000..dc367f646140
--- /dev/null
+++ b/tests/shell/testcases/import/vm_json_import_0
@@ -0,0 +1,71 @@
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
+$NFT export vm json > $tmpfile
+$NFT flush ruleset
+cat $tmpfile | $NFT import vm json
+
+RESULT="$($NFT list ruleset)"
+
+
+if [ "$RULESET" != "$RESULT" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$RULESET") <(echo "$RESULT")
+fi
-- 
1.9.1

