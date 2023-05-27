Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A83C77B73
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 May 2023 16:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjE0Q0s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 May 2023 12:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjE0QZA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 May 2023 12:25:00 -0400
Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FEBE1
        for <netfilter-devel@vger.kernel.org>; Sat, 27 May 2023 09:24:58 -0700 (PDT)
Received: from fews01-sea.riseup.net (fews01-sea-pn.riseup.net [10.0.1.109])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx1.riseup.net (Postfix) with ESMTPS id 4QT6Zf36tnzDqPs
        for <netfilter-devel@vger.kernel.org>; Sat, 27 May 2023 16:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1685204698; bh=pw2i0a956VNe40Xi/TyG5XF6B8TGueYvWc4YDrGQ2Go=;
        h=From:To:Cc:Subject:Date:From;
        b=HeEymVwaZSewHC3BuGF6V9Kms2x+yJRfDdza4YwPotltOQCgdgsQYfDY1BcbF9dJq
         xjZQZibwWPKonFYvWFJwy2RJpffr7J/e+oe+UhQlXcxwmyJ92U4UotNLOMFrbeGUPM
         jnzJOvSqvf8uF3OpEVDDHk29gprub43u/26Da23w=
X-Riseup-User-ID: 9AE62900DC6AF9D851C0763D7FD74965E341197DB699EC848CA078B079D0C283
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews01-sea.riseup.net (Postfix) with ESMTPSA id 4QT6Zd4DpGzJq9Q;
        Sat, 27 May 2023 16:24:57 +0000 (UTC)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft] tests: extend tests for destroy command
Date:   Sat, 27 May 2023 18:24:24 +0200
Message-Id: <20230527162424.122135-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend tests to cover destroy command for chains, flowtables, sets,
maps. In addition rename a destroy command test for rules with a
duplicated number.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 tests/shell/testcases/chains/0044chain_destroy_0          | 7 +++++++
 tests/shell/testcases/chains/0045chain_destroy_0          | 8 ++++++++
 .../shell/testcases/chains/dumps/0044chain_destroy_0.nft  | 2 ++
 .../shell/testcases/chains/dumps/0045chain_destroy_0.nft  | 2 ++
 tests/shell/testcases/flowtable/0015destroy_0             | 7 +++++++
 tests/shell/testcases/flowtable/0016destroy_0             | 6 ++++++
 tests/shell/testcases/flowtable/dumps/0015destroy_0.nft   | 2 ++
 tests/shell/testcases/flowtable/dumps/0016destroy_0.nft   | 2 ++
 tests/shell/testcases/maps/0014destroy_0                  | 8 ++++++++
 tests/shell/testcases/maps/0015destroy_0                  | 7 +++++++
 tests/shell/testcases/maps/dumps/0014destroy_0.nft        | 2 ++
 tests/shell/testcases/maps/dumps/0015destroy_0.nft        | 2 ++
 .../rule_management/{0011destroy_0 => 0013destroy_0}      | 0
 .../dumps/{0011destroy_0.nft => 0013destroy_0}            | 0
 tests/shell/testcases/sets/0072destroy_0                  | 8 ++++++++
 tests/shell/testcases/sets/0073destroy_0                  | 7 +++++++
 tests/shell/testcases/sets/dumps/0072destroy_0.nft        | 2 ++
 tests/shell/testcases/sets/dumps/0073destroy_0.nft        | 2 ++
 18 files changed, 74 insertions(+)
 create mode 100755 tests/shell/testcases/chains/0044chain_destroy_0
 create mode 100755 tests/shell/testcases/chains/0045chain_destroy_0
 create mode 100644 tests/shell/testcases/chains/dumps/0044chain_destroy_0.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0045chain_destroy_0.nft
 create mode 100755 tests/shell/testcases/flowtable/0015destroy_0
 create mode 100755 tests/shell/testcases/flowtable/0016destroy_0
 create mode 100644 tests/shell/testcases/flowtable/dumps/0015destroy_0.nft
 create mode 100644 tests/shell/testcases/flowtable/dumps/0016destroy_0.nft
 create mode 100755 tests/shell/testcases/maps/0014destroy_0
 create mode 100755 tests/shell/testcases/maps/0015destroy_0
 create mode 100644 tests/shell/testcases/maps/dumps/0014destroy_0.nft
 create mode 100644 tests/shell/testcases/maps/dumps/0015destroy_0.nft
 rename tests/shell/testcases/rule_management/{0011destroy_0 => 0013destroy_0} (100%)
 rename tests/shell/testcases/rule_management/dumps/{0011destroy_0.nft => 0013destroy_0} (100%)
 create mode 100755 tests/shell/testcases/sets/0072destroy_0
 create mode 100755 tests/shell/testcases/sets/0073destroy_0
 create mode 100644 tests/shell/testcases/sets/dumps/0072destroy_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0073destroy_0.nft

diff --git a/tests/shell/testcases/chains/0044chain_destroy_0 b/tests/shell/testcases/chains/0044chain_destroy_0
new file mode 100755
index 00000000..070021cf
--- /dev/null
+++ b/tests/shell/testcases/chains/0044chain_destroy_0
@@ -0,0 +1,7 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table t
+
+$NFT destroy chain t nochain
diff --git a/tests/shell/testcases/chains/0045chain_destroy_0 b/tests/shell/testcases/chains/0045chain_destroy_0
new file mode 100755
index 00000000..b356f8f8
--- /dev/null
+++ b/tests/shell/testcases/chains/0045chain_destroy_0
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table t
+$NFT add chain t c
+
+$NFT destroy chain t c
diff --git a/tests/shell/testcases/chains/dumps/0044chain_destroy_0.nft b/tests/shell/testcases/chains/dumps/0044chain_destroy_0.nft
new file mode 100644
index 00000000..985768ba
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0044chain_destroy_0.nft
@@ -0,0 +1,2 @@
+table ip t {
+}
diff --git a/tests/shell/testcases/chains/dumps/0045chain_destroy_0.nft b/tests/shell/testcases/chains/dumps/0045chain_destroy_0.nft
new file mode 100644
index 00000000..985768ba
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0045chain_destroy_0.nft
@@ -0,0 +1,2 @@
+table ip t {
+}
diff --git a/tests/shell/testcases/flowtable/0015destroy_0 b/tests/shell/testcases/flowtable/0015destroy_0
new file mode 100755
index 00000000..4828d818
--- /dev/null
+++ b/tests/shell/testcases/flowtable/0015destroy_0
@@ -0,0 +1,7 @@
+#!/bin/bash
+
+set -e
+$NFT add table t
+$NFT add flowtable t f { hook ingress priority 10 \; devices = { lo }\; }
+
+$NFT destroy flowtable t f
diff --git a/tests/shell/testcases/flowtable/0016destroy_0 b/tests/shell/testcases/flowtable/0016destroy_0
new file mode 100755
index 00000000..ce23c753
--- /dev/null
+++ b/tests/shell/testcases/flowtable/0016destroy_0
@@ -0,0 +1,6 @@
+#!/bin/bash
+
+set -e
+$NFT add table t
+
+$NFT destroy flowtable t f
diff --git a/tests/shell/testcases/flowtable/dumps/0015destroy_0.nft b/tests/shell/testcases/flowtable/dumps/0015destroy_0.nft
new file mode 100644
index 00000000..985768ba
--- /dev/null
+++ b/tests/shell/testcases/flowtable/dumps/0015destroy_0.nft
@@ -0,0 +1,2 @@
+table ip t {
+}
diff --git a/tests/shell/testcases/flowtable/dumps/0016destroy_0.nft b/tests/shell/testcases/flowtable/dumps/0016destroy_0.nft
new file mode 100644
index 00000000..985768ba
--- /dev/null
+++ b/tests/shell/testcases/flowtable/dumps/0016destroy_0.nft
@@ -0,0 +1,2 @@
+table ip t {
+}
diff --git a/tests/shell/testcases/maps/0014destroy_0 b/tests/shell/testcases/maps/0014destroy_0
new file mode 100755
index 00000000..b769276d
--- /dev/null
+++ b/tests/shell/testcases/maps/0014destroy_0
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table x
+$NFT add map x y { type ipv4_addr : ipv4_addr\; }
+
+$NFT destroy map x y
diff --git a/tests/shell/testcases/maps/0015destroy_0 b/tests/shell/testcases/maps/0015destroy_0
new file mode 100755
index 00000000..abad4d57
--- /dev/null
+++ b/tests/shell/testcases/maps/0015destroy_0
@@ -0,0 +1,7 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table x
+
+$NFT destroy map x nonmap
diff --git a/tests/shell/testcases/maps/dumps/0014destroy_0.nft b/tests/shell/testcases/maps/dumps/0014destroy_0.nft
new file mode 100644
index 00000000..5d4d2caf
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/0014destroy_0.nft
@@ -0,0 +1,2 @@
+table ip x {
+}
diff --git a/tests/shell/testcases/maps/dumps/0015destroy_0.nft b/tests/shell/testcases/maps/dumps/0015destroy_0.nft
new file mode 100644
index 00000000..5d4d2caf
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/0015destroy_0.nft
@@ -0,0 +1,2 @@
+table ip x {
+}
diff --git a/tests/shell/testcases/rule_management/0011destroy_0 b/tests/shell/testcases/rule_management/0013destroy_0
similarity index 100%
rename from tests/shell/testcases/rule_management/0011destroy_0
rename to tests/shell/testcases/rule_management/0013destroy_0
diff --git a/tests/shell/testcases/rule_management/dumps/0011destroy_0.nft b/tests/shell/testcases/rule_management/dumps/0013destroy_0
similarity index 100%
rename from tests/shell/testcases/rule_management/dumps/0011destroy_0.nft
rename to tests/shell/testcases/rule_management/dumps/0013destroy_0
diff --git a/tests/shell/testcases/sets/0072destroy_0 b/tests/shell/testcases/sets/0072destroy_0
new file mode 100755
index 00000000..c9cf9ff7
--- /dev/null
+++ b/tests/shell/testcases/sets/0072destroy_0
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table x
+$NFT add set x s {type ipv4_addr\; size 2\;}
+
+$NFT destroy set x s
diff --git a/tests/shell/testcases/sets/0073destroy_0 b/tests/shell/testcases/sets/0073destroy_0
new file mode 100755
index 00000000..a9d65a55
--- /dev/null
+++ b/tests/shell/testcases/sets/0073destroy_0
@@ -0,0 +1,7 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table x
+
+$NFT destroy set x s
diff --git a/tests/shell/testcases/sets/dumps/0072destroy_0.nft b/tests/shell/testcases/sets/dumps/0072destroy_0.nft
new file mode 100644
index 00000000..5d4d2caf
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0072destroy_0.nft
@@ -0,0 +1,2 @@
+table ip x {
+}
diff --git a/tests/shell/testcases/sets/dumps/0073destroy_0.nft b/tests/shell/testcases/sets/dumps/0073destroy_0.nft
new file mode 100644
index 00000000..5d4d2caf
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0073destroy_0.nft
@@ -0,0 +1,2 @@
+table ip x {
+}
-- 
2.30.2

