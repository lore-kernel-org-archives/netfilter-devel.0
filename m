Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 221BAEE49A0
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 22:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjHUWHd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 18:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjHUWHd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 18:07:33 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E02210E
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 15:07:30 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack] tests/conntrack: add initial stress test for conntrack
Date:   Tue, 22 Aug 2023 00:07:25 +0200
Message-Id: <20230821220725.358374-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a shell script that creates many conntrack entries and it updates
the mark to cover for recent bugs in the 1.4.7 release when moving to
libmnl. This test can be extended to cover for more commands.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/conntrack/load-stress.sh | 62 ++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 tests/conntrack/load-stress.sh

diff --git a/tests/conntrack/load-stress.sh b/tests/conntrack/load-stress.sh
new file mode 100644
index 000000000000..597c4c6189fd
--- /dev/null
+++ b/tests/conntrack/load-stress.sh
@@ -0,0 +1,62 @@
+#!/bin/bash
+
+SPORT_COUNT=128
+DPORT_COUNT=128
+
+function ct_data_gen()
+{
+	for (( d = 1; d <= $DPORT_COUNT; d++ )) do
+		for (( s = 1; s <= $SPORT_COUNT; s++ )) do
+			ip netns exec ct-ns-test conntrack -I -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport ${s} --dport ${d} --state LISTEN -u SEEN_REPLY -t 300 &> /dev/null
+			if [ $? -ne 0 ]
+			then
+				echo "[FAILED] cannot insert conntrack entries"
+				exit 1
+			fi
+		done
+	done
+}
+
+ip netns add ct-ns-test
+
+if [ $UID -ne 0 ]
+then
+	echo "Run this test as root"
+	exit 1
+fi
+
+echo "Creating conntrack entries, please wait..."
+ct_data_gen
+ip netns exec ct-ns-test conntrack -U -p tcp -m 1
+if [ $? -ne 0 ]
+then
+	echo "[FAILED] cannot update conntrack entries"
+	exit 1
+fi
+
+COUNT=`ip netns exec ct-ns-test conntrack -L | wc -l`
+if [ $COUNT -ne 16384 ]
+then
+	echo "$COUNT entries, expecting 131072"
+	exit 1
+fi
+
+ip netns exec ct-ns-test conntrack -F
+if [ $? -ne 0 ]
+then
+	echo "[FAILED] faild to flush conntrack entries"
+	exit 1
+fi
+
+COUNT=`ip netns exec ct-ns-test conntrack -L | wc -l`
+if [ $COUNT -ne 0 ]
+then
+	echo "$COUNT entries, expecting 0"
+	exit 1
+fi
+
+ip netns del ct-ns-test
+
+echo "[OK] test successful"
+
+exit 0
-- 
2.30.2

