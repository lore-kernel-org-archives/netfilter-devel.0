From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/4] tests: shell: cover add and create set command
Date: Wed, 24 Aug 2016 16:45:05 +0200
Message-ID: <1472049907-7935-2-git-send-email-pablo@netfilter.org>
References: <1472049907-7935-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43024 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755995AbcHXOqY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2016 10:46:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2BF5B231662
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 16:45:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1CBD4100A5D
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 16:45:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6CBA7100A40
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 16:45:12 +0200 (CEST)
In-Reply-To: <1472049907-7935-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch validates that creation of an already existing set bails out
with EEXIST.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/sets/0006create_set_0 | 14 ++++++++++++++
 1 file changed, 14 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0006create_set_0

diff --git a/tests/shell/testcases/sets/0006create_set_0 b/tests/shell/testcases/sets/0006create_set_0
new file mode 100755
index 0000000..ca36cf7
--- /dev/null
+++ b/tests/shell/testcases/sets/0006create_set_0
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+# This testscase checks for add and create set commands.
+
+set -e
+$NFT add table t
+$NFT add set t s { type ipv4_addr \; }
+if $NFT create set t s { type ipv4_addr \; } 2>/dev/null ; then
+	echo "E: accepted set creation that already exists" >&2
+	exit 1
+fi
+$NFT add set t s { type ipv4_addr \; }
+
+exit 0
-- 
2.1.4

