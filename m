Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6119CC0015E
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Aug 2023 11:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbjHALmw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 07:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbjHALmv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 07:42:51 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18EC103
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 04:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4yq9AShB3tFQFEjSW6UmlXi/ilmP58owRMsLvB1/Z84=; b=EoPNMsHM97VuYW8ICt5xBcmylv
        VepKzBYTh5TJntyatIBEdRjSz9Tq3SWqiNuCqsNTji1gRCfE238Oo9JK1pr1/Kxq8VSSg/dOu+Kjb
        8AzlmjAizQMj7vV7UKoEnckURGRo0mVdmoqW7VSPjxcNrFsQREKofs0nMiPh80ezFMDPfLL+bkuvI
        mVpnmE+U148ZLmQhaBdfrHvdwurIbcKCf0K5alIMANXCiDnTDb2h7Oo7Ci//KeTrYLenmzk2BVJS0
        hCyhCqoBWv12A3FM4gY+rGlmQ10+kZXOFWryuoNsnL8V6lK2IVkz2PKWGjMjNhhqdwiKVPSBWqpO6
        x6AvrjUA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qQnm1-0003Bl-5u; Tue, 01 Aug 2023 13:42:45 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     "Fernando F . Mancera" <ffmancera@riseup.net>
Subject: [nft PATCH] tests: shell: Review test-cases for destroy command
Date:   Tue,  1 Aug 2023 13:42:36 +0200
Message-Id: <20230801114236.27235-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Having separate files for successful destroy of existing and
non-existing objects is a bit too much, just combine them into one.

While being at it:

* Check that deleted objects are actually gone
* No bashisms, using /bin/sh is fine
* Append '-e' to shebang itself instead of calling 'set'
* Use 'nft -a -e' instead of assuming the created rule's handle value
* Shellcheck warned about curly braces, quote them

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/chains/0044chain_destroy_0    | 12 ++++++++----
 tests/shell/testcases/chains/0045chain_destroy_0    |  8 --------
 tests/shell/testcases/flowtable/0015destroy_0       | 10 +++++++---
 tests/shell/testcases/flowtable/0016destroy_0       |  6 ------
 tests/shell/testcases/maps/0014destroy_0            | 11 +++++++----
 tests/shell/testcases/maps/0015destroy_0            |  7 -------
 tests/shell/testcases/rule_management/0012destroy_0 | 10 ++++++++--
 tests/shell/testcases/rule_management/0013destroy_0 |  8 --------
 tests/shell/testcases/sets/0072destroy_0            | 11 +++++++----
 tests/shell/testcases/sets/0073destroy_0            |  7 -------
 10 files changed, 37 insertions(+), 53 deletions(-)
 delete mode 100755 tests/shell/testcases/chains/0045chain_destroy_0
 delete mode 100755 tests/shell/testcases/flowtable/0016destroy_0
 delete mode 100755 tests/shell/testcases/maps/0015destroy_0
 delete mode 100755 tests/shell/testcases/rule_management/0013destroy_0
 delete mode 100755 tests/shell/testcases/sets/0073destroy_0

diff --git a/tests/shell/testcases/chains/0044chain_destroy_0 b/tests/shell/testcases/chains/0044chain_destroy_0
index 070021cf12f24..fbc1044474b12 100755
--- a/tests/shell/testcases/chains/0044chain_destroy_0
+++ b/tests/shell/testcases/chains/0044chain_destroy_0
@@ -1,7 +1,11 @@
-#!/bin/bash
-
-set -e
+#!/bin/sh -e
 
 $NFT add table t
 
-$NFT destroy chain t nochain
+# pass for non-existent chain
+$NFT destroy chain t c
+
+# successfully delete existing chain
+$NFT add chain t c
+$NFT destroy chain t c
+! $NFT list chain t c 2>/dev/null
diff --git a/tests/shell/testcases/chains/0045chain_destroy_0 b/tests/shell/testcases/chains/0045chain_destroy_0
deleted file mode 100755
index b356f8f885ca4..0000000000000
--- a/tests/shell/testcases/chains/0045chain_destroy_0
+++ /dev/null
@@ -1,8 +0,0 @@
-#!/bin/bash
-
-set -e
-
-$NFT add table t
-$NFT add chain t c
-
-$NFT destroy chain t c
diff --git a/tests/shell/testcases/flowtable/0015destroy_0 b/tests/shell/testcases/flowtable/0015destroy_0
index 4828d8187018c..01af84869a3e0 100755
--- a/tests/shell/testcases/flowtable/0015destroy_0
+++ b/tests/shell/testcases/flowtable/0015destroy_0
@@ -1,7 +1,11 @@
-#!/bin/bash
+#!/bin/sh -e
 
-set -e
 $NFT add table t
-$NFT add flowtable t f { hook ingress priority 10 \; devices = { lo }\; }
 
+# pass for non-existent flowtable
 $NFT destroy flowtable t f
+
+# successfully delete existing flowtable
+$NFT add flowtable t f '{ hook ingress priority 10; devices = { lo }; }'
+$NFT destroy flowtable t f
+! $NFT list flowtable t f 2>/dev/null
diff --git a/tests/shell/testcases/flowtable/0016destroy_0 b/tests/shell/testcases/flowtable/0016destroy_0
deleted file mode 100755
index ce23c753365af..0000000000000
--- a/tests/shell/testcases/flowtable/0016destroy_0
+++ /dev/null
@@ -1,6 +0,0 @@
-#!/bin/bash
-
-set -e
-$NFT add table t
-
-$NFT destroy flowtable t f
diff --git a/tests/shell/testcases/maps/0014destroy_0 b/tests/shell/testcases/maps/0014destroy_0
index b769276d52599..6e639a11e2ac2 100755
--- a/tests/shell/testcases/maps/0014destroy_0
+++ b/tests/shell/testcases/maps/0014destroy_0
@@ -1,8 +1,11 @@
-#!/bin/bash
-
-set -e
+#!/bin/sh -e
 
 $NFT add table x
-$NFT add map x y { type ipv4_addr : ipv4_addr\; }
 
+# pass for non-existent map
+$NFT destroy map x y
+
+# successfully delete existing map
+$NFT add map x y '{ type ipv4_addr : ipv4_addr; }'
 $NFT destroy map x y
+! $NFT list map x y 2>/dev/null
diff --git a/tests/shell/testcases/maps/0015destroy_0 b/tests/shell/testcases/maps/0015destroy_0
deleted file mode 100755
index abad4d57e7221..0000000000000
--- a/tests/shell/testcases/maps/0015destroy_0
+++ /dev/null
@@ -1,7 +0,0 @@
-#!/bin/bash
-
-set -e
-
-$NFT add table x
-
-$NFT destroy map x nonmap
diff --git a/tests/shell/testcases/rule_management/0012destroy_0 b/tests/shell/testcases/rule_management/0012destroy_0
index 1b61155e9b7ef..57c4da99c285c 100755
--- a/tests/shell/testcases/rule_management/0012destroy_0
+++ b/tests/shell/testcases/rule_management/0012destroy_0
@@ -1,7 +1,13 @@
-#!/bin/bash
+#!/bin/sh -e
 
-set -e
 $NFT add table t
 $NFT add chain t c
 
+# pass for non-existent rule
 $NFT destroy rule t c handle 3333
+
+# successfully delete existing rule
+handle=$($NFT -a -e insert rule t c accept | \
+	sed -n 's/.*handle \([0-9]*\)$/\1/p')
+$NFT destroy rule t c handle "$handle"
+! $NFT list chain t c | grep -q accept
diff --git a/tests/shell/testcases/rule_management/0013destroy_0 b/tests/shell/testcases/rule_management/0013destroy_0
deleted file mode 100755
index 895c24a4dacba..0000000000000
--- a/tests/shell/testcases/rule_management/0013destroy_0
+++ /dev/null
@@ -1,8 +0,0 @@
-#!/bin/bash
-
-set -e
-$NFT add table t
-$NFT add chain t c
-$NFT insert rule t c accept # should have handle 2
-
-$NFT destroy rule t c handle 2
diff --git a/tests/shell/testcases/sets/0072destroy_0 b/tests/shell/testcases/sets/0072destroy_0
index c9cf9ff716349..80d24b4760099 100755
--- a/tests/shell/testcases/sets/0072destroy_0
+++ b/tests/shell/testcases/sets/0072destroy_0
@@ -1,8 +1,11 @@
-#!/bin/bash
-
-set -e
+#!/bin/sh -e
 
 $NFT add table x
-$NFT add set x s {type ipv4_addr\; size 2\;}
 
+# pass for non-existent set
+$NFT destroy set x s
+
+# successfully delete existing set
+$NFT add set x s '{type ipv4_addr; size 2;}'
 $NFT destroy set x s
+! $NFT list set x s 2>/dev/null
diff --git a/tests/shell/testcases/sets/0073destroy_0 b/tests/shell/testcases/sets/0073destroy_0
deleted file mode 100755
index a9d65a5541c53..0000000000000
--- a/tests/shell/testcases/sets/0073destroy_0
+++ /dev/null
@@ -1,7 +0,0 @@
-#!/bin/bash
-
-set -e
-
-$NFT add table x
-
-$NFT destroy set x s
-- 
2.40.0

