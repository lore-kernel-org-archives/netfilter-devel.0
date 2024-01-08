Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EBAE3FE46
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2024 12:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: extend coverage for netdevice removal
Date: Mon,  8 Jan 2024 13:14:45 +0100
Message-Id: <20240108121445.149895-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add two extra tests to exercise netdevice removal path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../chains/dumps/netdev_chain_dev_gone.nodump |  0
 .../dumps/netdev_chain_multidev_gone.nodump   |  0
 .../testcases/chains/netdev_chain_dev_gone    | 25 ++++++++++++++
 .../chains/netdev_chain_multidev_gone         | 34 +++++++++++++++++++
 4 files changed, 59 insertions(+)
 create mode 100644 tests/shell/testcases/chains/dumps/netdev_chain_dev_gone.nodump
 create mode 100644 tests/shell/testcases/chains/dumps/netdev_chain_multidev_gone.nodump
 create mode 100755 tests/shell/testcases/chains/netdev_chain_dev_gone
 create mode 100755 tests/shell/testcases/chains/netdev_chain_multidev_gone

diff --git a/tests/shell/testcases/chains/dumps/netdev_chain_dev_gone.nodump b/tests/shell/testcases/chains/dumps/netdev_chain_dev_gone.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/chains/dumps/netdev_chain_multidev_gone.nodump b/tests/shell/testcases/chains/dumps/netdev_chain_multidev_gone.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/chains/netdev_chain_dev_gone b/tests/shell/testcases/chains/netdev_chain_dev_gone
new file mode 100755
index 000000000000..02dacffb7a03
--- /dev/null
+++ b/tests/shell/testcases/chains/netdev_chain_dev_gone
@@ -0,0 +1,25 @@
+#!/bin/bash
+
+set -e
+
+iface_cleanup() {
+        ip link del d0 &>/dev/null || :
+}
+trap 'iface_cleanup' EXIT
+
+ip link add d0 type dummy
+
+# Test auto-removal of chain hook on device removal
+RULESET="table netdev x {
+	chain x {}
+	chain w {
+		ip daddr 8.7.6.0/24 jump x
+	}
+	chain y {
+		type filter hook ingress device \"d0\" priority 0;
+		ip saddr { 1.2.3.4, 2.3.4.5 } counter
+		ip daddr vmap { 5.4.3.0/24 : jump w, 8.9.0.0/24 : jump x }
+	}
+}"
+
+$NFT -f - <<< $RULESET
diff --git a/tests/shell/testcases/chains/netdev_chain_multidev_gone b/tests/shell/testcases/chains/netdev_chain_multidev_gone
new file mode 100755
index 000000000000..bc5ca7d04bbe
--- /dev/null
+++ b/tests/shell/testcases/chains/netdev_chain_multidev_gone
@@ -0,0 +1,34 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_chain_binding)
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_netdev_chain_multidevice)
+
+set -e
+
+iface_cleanup() {
+        ip link del d0 &>/dev/null || :
+        ip link del d1 &>/dev/null || :
+        ip link del d2 &>/dev/null || :
+}
+trap 'iface_cleanup' EXIT
+
+ip link add d0 type dummy
+ip link add d1 type dummy
+ip link add d2 type dummy
+
+# Test auto-removal of chain hook on device removal
+RULESET="table netdev x {
+	chain x {}
+	chain w {
+		ip daddr 8.7.6.0/24 jump {
+			ip daddr vmap { 8.7.6.3 : jump x, 8.7.6.4 : jump x }
+		}
+	}
+	chain y {
+		type filter hook ingress devices = { d0, d1, d2 } priority 0;
+		ip saddr { 1.2.3.4, 2.3.4.5 } counter
+		ip daddr vmap { 5.4.3.0/24 : jump w, 8.9.0.0/24 : jump x }
+	}
+}"
+
+$NFT -f - <<< $RULESET
-- 
2.30.2

