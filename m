Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93070C05021
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 16:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343869AbjKIQXQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 11:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343803AbjKIQXP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 11:23:15 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8DC36327D
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 08:23:12 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     thaller@redhat.com, fw@strlen.de
Subject: [PATCH nft 07/12] tests: shell: skip multidevice chain tests if kernel lacks support
Date:   Thu,  9 Nov 2023 17:22:59 +0100
Message-Id: <20231109162304.119506-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231109162304.119506-1-pablo@netfilter.org>
References: <20231109162304.119506-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/features/netdev_chain_multidevice.sh  | 14 ++++++++++++++
 tests/shell/testcases/chains/0042chain_variable_0 |  2 ++
 2 files changed, 16 insertions(+)
 create mode 100755 tests/shell/features/netdev_chain_multidevice.sh

diff --git a/tests/shell/features/netdev_chain_multidevice.sh b/tests/shell/features/netdev_chain_multidevice.sh
new file mode 100755
index 000000000000..07f892035301
--- /dev/null
+++ b/tests/shell/features/netdev_chain_multidevice.sh
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+trap "ip link del d0; ip link del d1" EXIT
+
+ip link add d0 type dummy
+ip link add d1 type dummy
+
+EXPECTED="table netdev filter2 {
+        chain Main_Ingress2 {
+                type filter hook ingress devices = { \"d0\", \"d1\" } priority -500; policy accept;
+        }
+}"
+
+$NFT -f - <<< $EXPECTED
diff --git a/tests/shell/testcases/chains/0042chain_variable_0 b/tests/shell/testcases/chains/0042chain_variable_0
index a4b929f7344c..c5de495ef074 100755
--- a/tests/shell/testcases/chains/0042chain_variable_0
+++ b/tests/shell/testcases/chains/0042chain_variable_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_netdev_chain_multidevice)
+
 set -e
 
 ip link add name d23456789012345 type dummy
-- 
2.30.2

