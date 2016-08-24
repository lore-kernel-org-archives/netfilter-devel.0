From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 4/4] tests: shell: cover add and create set command
Date: Wed, 24 Aug 2016 16:45:07 +0200
Message-ID: <1472049907-7935-4-git-send-email-pablo@netfilter.org>
References: <1472049907-7935-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43030 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756085AbcHXOqY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2016 10:46:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D665B231664
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 16:45:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C7E04100A59
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 16:45:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CC320100A59
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 16:45:13 +0200 (CEST)
In-Reply-To: <1472049907-7935-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch validates that creation of an already existing element
bails out with EEXIST.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/sets/0007create_element_0 | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0007create_element_0

diff --git a/tests/shell/testcases/sets/0007create_element_0 b/tests/shell/testcases/sets/0007create_element_0
new file mode 100755
index 0000000..47b3559
--- /dev/null
+++ b/tests/shell/testcases/sets/0007create_element_0
@@ -0,0 +1,15 @@
+#!/bin/bash
+
+# This testcase checks for add and create element commands.
+
+set -e
+$NFT add table t
+$NFT add set t s { type ipv4_addr \; }
+$NFT add element t s { 1.1.1.1 }
+if $NFT create element t s { 1.1.1.1 } 2>/dev/null ; then
+	echo "E: accepted element creation that already exists" >&2
+	exit 1
+fi
+$NFT add element t s { 1.1.1.1 }
+
+exit 0
-- 
2.1.4

