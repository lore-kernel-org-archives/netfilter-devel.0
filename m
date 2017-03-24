From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft 2/2] tests: Add test for flush command selectiveness on
 sets
Date: Fri, 24 Mar 2017 12:31:31 -0300
Message-ID: <20170324153131.GA6454@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:35814 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932990AbdCXPbn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2017 11:31:43 -0400
Received: by mail-qk0-f175.google.com with SMTP id v127so5313187qkb.2
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 08:31:42 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This tests the selectiveness of flush command on structures that use the
generic set infrastructure (sets, maps and flow tables).

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 .../testcases/sets/0022type_selective_flush_0      | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0022type_selective_flush_0

diff --git a/tests/shell/testcases/sets/0022type_selective_flush_0 b/tests/shell/testcases/sets/0022type_selective_flush_0
new file mode 100755
index 0000000..f8878f7
--- /dev/null
+++ b/tests/shell/testcases/sets/0022type_selective_flush_0
@@ -0,0 +1,41 @@
+#!/bin/bash
+
+# This tests the selectiveness of flush command on structures that use the
+# generic set infrastructure (sets, maps and flow tables).
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+echo "
+add table t
+add chain t c
+add set t s {type ipv4_addr;}
+add map t m {type ipv4_addr : inet_service;}
+add rule t c tcp dport 80 flow table f {ip saddr limit rate 10/second}
+" >$tmpfile
+
+$NFT -f $tmpfile
+
+# Commands that should be invalid
+
+declare -a cmds=(
+		"flush set t m" "flush set t f"
+		"flush map t s" "flush map t f"
+		"flush flow table t s" "flush flow table t m"
+		)
+
+for i in "${cmds[@]}"
+do
+	echo "$i" >$tmpfile
+	$NFT -f $tmpfile &>/dev/null
+	ret=$?
+
+	if [ $ret -eq 0 ]; then
+		exit 1
+	fi
+done
-- 
2.7.4

