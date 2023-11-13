Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 698EEC4167B
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 13:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbjKMNjN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 08:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbjKMNjL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 08:39:11 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50239189
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 05:39:08 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, thaller@redhat.com
Subject: [PATCH nft,v2 06/11] tests: shell: skip multidevice chain tests if kernel lacks support
Date:   Mon, 13 Nov 2023 14:38:53 +0100
Message-Id: <20231113133858.121324-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231113133858.121324-1-pablo@netfilter.org>
References: <20231113133858.121324-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: use git describe --contains, requested by Florian.

 .../shell/features/netdev_chain_multidevice.sh  | 17 +++++++++++++++++
 .../shell/testcases/chains/0042chain_variable_0 |  2 ++
 2 files changed, 19 insertions(+)
 create mode 100755 tests/shell/features/netdev_chain_multidevice.sh

diff --git a/tests/shell/features/netdev_chain_multidevice.sh b/tests/shell/features/netdev_chain_multidevice.sh
new file mode 100755
index 000000000000..d2a56d6da7f2
--- /dev/null
+++ b/tests/shell/features/netdev_chain_multidevice.sh
@@ -0,0 +1,17 @@
+#!/bin/bash
+
+# d54725cd11a5 ("netfilter: nf_tables: support for multiple devices per netdev hook")
+# v5.5-rc1~174^2~312^2~4
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

