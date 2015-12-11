From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [PATCH 3/5] tests/shell: add maps tests cases
Date: Fri, 11 Dec 2015 11:10:24 +0100
Message-ID: <144982862481.31246.9166601244315040008.stgit@r2d2.cica.es>
References: <144982857800.31246.3547570276555930070.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36366 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754275AbbLKKK0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Dec 2015 05:10:26 -0500
In-Reply-To: <144982857800.31246.3547570276555930070.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's add some tests cases for maps.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/shell/testcases/maps/anonymous_snat_map_0 |    8 ++++++++
 tests/shell/testcases/maps/named_snat_map_0     |   10 ++++++++++
 2 files changed, 18 insertions(+)
 create mode 100755 tests/shell/testcases/maps/anonymous_snat_map_0
 create mode 100755 tests/shell/testcases/maps/named_snat_map_0

diff --git a/tests/shell/testcases/maps/anonymous_snat_map_0 b/tests/shell/testcases/maps/anonymous_snat_map_0
new file mode 100755
index 0000000..32aac8a
--- /dev/null
+++ b/tests/shell/testcases/maps/anonymous_snat_map_0
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+# anonymous map can be added to a snat rule
+
+set -e
+$NFT add table nat
+$NFT add chain nat postrouting
+$NFT add rule nat postrouting snat ip saddr map {1.1.1.1 : 2.2.2.2}
diff --git a/tests/shell/testcases/maps/named_snat_map_0 b/tests/shell/testcases/maps/named_snat_map_0
new file mode 100755
index 0000000..addb9f7
--- /dev/null
+++ b/tests/shell/testcases/maps/named_snat_map_0
@@ -0,0 +1,10 @@
+#!/bin/bash
+
+# nameds map can be addedd to a snat rule
+
+set -e
+$NFT add table nat
+$NFT add chain nat postrouting
+$NFT add map nat m { type ipv4_addr : ipv4_addr\; }
+$NFT add element nat m {1.1.1.1: 2.2.2.2}
+$NFT add rule nat postrouting snat ip saddr map @m

