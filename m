From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH] tests: shell: Add test for ambguity while setting the value
Date: Fri,  9 Jun 2017 15:00:33 +0530
Message-ID: <1497000633-10954-1-git-send-email-mayhs11saini@gmail.com>
Cc: pablo@netfilter.org, arturo@netfilter.org, fw@strlen.de,
        Shyam Saini <mayhs11saini@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:32871 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751505AbdFIJbF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Jun 2017 05:31:05 -0400
Received: by mail-pg0-f66.google.com with SMTP id a70so7207335pge.0
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Jun 2017 02:31:04 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This test checks bug identified and fixed in the commit mentioned below
In a statement if there are  multiple src data then it  would be
totally ambiguous to decide which value to set.

We don't add this test in python testsuite, because there we only have
"ok"  and "fail"  as return code. So, we can't detect 134 != 1 there.
(both 1 and 134 stats failure)

Test: 986dea8 ("evaluate: avoid reference to multiple src data in statements which set values")
Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 .../testcases/sets/0023unknown_value_to_use_0      | 34 ++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0023unknown_value_to_use_0

diff --git a/tests/shell/testcases/sets/0023unknown_value_to_use_0 b/tests/shell/testcases/sets/0023unknown_value_to_use_0
new file mode 100755
index 0000000..011cedd
--- /dev/null
+++ b/tests/shell/testcases/sets/0023unknown_value_to_use_0
@@ -0,0 +1,34 @@
+#!/bin/bash
+
+	# This test checks bug identified and fixed in the commit Id "986dea8".
+	# i.e, If in a statement there are  multiple src data then it would be totally ambiguous to decide which value to set.
+        
+	# Before this commit 986dea8, nft returns 134 which indicates the bug but after this commit it returns 1.
+	# We don't add this test in python testsuite, because there we can't detect 134 != 1 (returns code stating failure) 	
+
+declare -a rules=( 
+		 "tcp dport set {1, 2, 3}" "udp dport set {1, 2, 3}"
+		 "meta pkttype set {unicast, multicast, broadcast}"
+		 "meta mark set {0xffff, 0xcc}"
+		 "ct mark set {0x11333, 0x11}" "ct zone set {123, 127}"
+		 "ct label set {123, 127}" 
+		 "ct event set {new, related, destroy, label}"
+		 "ether daddr set {01:00:5e:00:01:01, 01:00:5e:00:02:02}"
+		 "ip saddr set {192.19.1.2, 191.1.22.1}"
+		 )
+
+$NFT add table t
+$NFT add chain t c
+
+for (( i = 0 ; i < ${#rules[@]} ; i++ ))
+do
+	$1
+	`$NFT add rule t c ${rules[$i]} 2>>/dev/null`
+	ret=$?
+	if [ $ret -ne 1 ];
+	then
+		echo "E: failed test: $1 returned $ret instead of 1" >&2
+		exit 1
+	fi
+done
+
-- 
1.9.1

