From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft] tests: shell: Add test for IPv4 Mapped IPv6 address.
Date: Sun, 19 Nov 2017 18:04:32 +0530
Message-ID: <20171119123432.8894-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:46719 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdKSMfM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Nov 2017 07:35:12 -0500
Received: by mail-pg0-f42.google.com with SMTP id z184so5256069pgd.13
        for <netfilter-devel@vger.kernel.org>; Sun, 19 Nov 2017 04:35:12 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds test case for IPv4 Mapped IPv6 address and renames
file 0025named_limit_0 to 0026named_limit_0.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 .../sets/{0025named_limit_0 => 0026named_limit_0}  |  0
 tests/shell/testcases/sets/0027ipv6_maps_ipv4_0    | 25 ++++++++++++++++++++++
 2 files changed, 25 insertions(+)
 rename tests/shell/testcases/sets/{0025named_limit_0 => 0026named_limit_0} (100%)
 create mode 100755 tests/shell/testcases/sets/0027ipv6_maps_ipv4_0

diff --git a/tests/shell/testcases/sets/0025named_limit_0 b/tests/shell/testcases/sets/0026named_limit_0
similarity index 100%
rename from tests/shell/testcases/sets/0025named_limit_0
rename to tests/shell/testcases/sets/0026named_limit_0
diff --git a/tests/shell/testcases/sets/0027ipv6_maps_ipv4_0 b/tests/shell/testcases/sets/0027ipv6_maps_ipv4_0
new file mode 100755
index 0000000..5420fbf
--- /dev/null
+++ b/tests/shell/testcases/sets/0027ipv6_maps_ipv4_0
@@ -0,0 +1,25 @@
+#!/bin/bash
+
+# Tests IPv4 Mapped IPv6 addresses.
+
+set -e
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+echo "
+table inet t {
+	set s {
+		type ipv6_addr
+		flags interval
+		elements = { ::ffff:0.0.0.0/96 }
+	}
+}
+" > $tmpfile
+
+$NFT -f $tmpfile
-- 
2.14.3

