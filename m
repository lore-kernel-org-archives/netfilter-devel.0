From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC nft PATCH 2/3] tests/operations: add maps tests cases
Date: Fri, 09 Oct 2015 14:38:17 +0200
Message-ID: <20151009123817.32207.32567.stgit@r2d2.cica.es>
References: <20151009123529.32207.81925.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: fw@strlen.de, kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:51464 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933331AbbJINsF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Oct 2015 09:48:05 -0400
In-Reply-To: <20151009123529.32207.81925.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's add some tests cases for maps.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 .../operations/testcases/maps/anonymous_snat_map_0 |    7 +++++++
 tests/operations/testcases/maps/named_snat_map_0   |    9 +++++++++
 2 files changed, 16 insertions(+)
 create mode 100755 tests/operations/testcases/maps/anonymous_snat_map_0
 create mode 100755 tests/operations/testcases/maps/named_snat_map_0

diff --git a/tests/operations/testcases/maps/anonymous_snat_map_0 b/tests/operations/testcases/maps/anonymous_snat_map_0
new file mode 100755
index 0000000..67698ec
--- /dev/null
+++ b/tests/operations/testcases/maps/anonymous_snat_map_0
@@ -0,0 +1,7 @@
+#!/bin/bash
+
+# anonymous map can be added to a snat rule
+
+$NFT add table nat
+$NFT add chain nat postrouting
+$NFT add rule nat postrouting snat ip saddr map {1.1.1.1 : 2.2.2.2}
diff --git a/tests/operations/testcases/maps/named_snat_map_0 b/tests/operations/testcases/maps/named_snat_map_0
new file mode 100755
index 0000000..6e11051
--- /dev/null
+++ b/tests/operations/testcases/maps/named_snat_map_0
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+# nameds map can be addedd to a snat rule
+
+$NFT add table nat
+$NFT add chain nat postrouting
+$NFT add map nat m { type ipv4_addr : ipv4_addr\; }
+$NFT add element nat m {1.1.1.1: 2.2.2.2}
+$NFT add rule nat postrouting snat ip saddr map @m

