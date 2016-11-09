From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] tests: shell: add testcases for comments in set elements
Date: Wed, 09 Nov 2016 10:38:26 +0100
Message-ID: <147868430640.16308.4596452647568416119.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:57053 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751577AbcKIJiX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2016 04:38:23 -0500
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 0AADB51F266
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 09:38:20 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id e6VS28x0U4Xr for <netfilter-devel@vger.kernel.org>;
        Wed,  9 Nov 2016 10:38:14 +0100 (CET)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id B945E51F1D8
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 10:38:14 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arturo Borrero Gonzalez <arturo@debian.org>

This patch adds a several testcases for comments in set elements.
This includes the netfilter bug #1090 about comments in set interval elements.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 tests/shell/testcases/sets/0008comments_interval_0 |   12 ++++++++++++
 tests/shell/testcases/sets/0009comments_timeout_0  |   12 ++++++++++++
 tests/shell/testcases/sets/0010comments_0          |   11 +++++++++++
 3 files changed, 35 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0008comments_interval_0
 create mode 100755 tests/shell/testcases/sets/0009comments_timeout_0
 create mode 100755 tests/shell/testcases/sets/0010comments_0

diff --git a/tests/shell/testcases/sets/0008comments_interval_0 b/tests/shell/testcases/sets/0008comments_interval_0
new file mode 100755
index 0000000..98c709c
--- /dev/null
+++ b/tests/shell/testcases/sets/0008comments_interval_0
@@ -0,0 +1,12 @@
+#!/bin/bash
+
+# This test netfilter bug #1090
+# https://bugzilla.netfilter.org/show_bug.cgi?id=1090
+
+$NFT add table t
+$NFT add set t s {type ipv4_addr \; flags interval \;}
+$NFT add element t s { 1.1.1.1 comment "test" }
+if ! $NFT list ruleset | grep test >/dev/null ; then
+	echo "E: missing comment in set element" >&2
+	exit 1
+fi
diff --git a/tests/shell/testcases/sets/0009comments_timeout_0 b/tests/shell/testcases/sets/0009comments_timeout_0
new file mode 100755
index 0000000..4e3f80c
--- /dev/null
+++ b/tests/shell/testcases/sets/0009comments_timeout_0
@@ -0,0 +1,12 @@
+#!/bin/bash
+
+# Test that comments are added to set elements in timemout sets.
+
+$NFT flush ruleset
+$NFT add table t
+$NFT add set t s {type ipv4_addr \; flags timeout \;}
+$NFT add element t s { 1.1.1.1 comment "test" }
+if ! $NFT list ruleset | grep test >/dev/null ; then
+	echo "E: missing comment in set element" >&2
+	exit 1
+fi
diff --git a/tests/shell/testcases/sets/0010comments_0 b/tests/shell/testcases/sets/0010comments_0
new file mode 100755
index 0000000..4467a3b
--- /dev/null
+++ b/tests/shell/testcases/sets/0010comments_0
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+# Test that comments are added to set elements in standard sets.
+
+$NFT add table inet t
+$NFT add set inet t s {type ipv6_addr \; }
+$NFT add element inet t s { ::1 comment "test" }
+if ! $NFT list ruleset | grep test >/dev/null ; then
+	echo "E: missing comment in set element" >&2
+	exit 1
+fi

