Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D7FF18FC65
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Oct 2024 22:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730153844; cv=none; b=RW1NbN3VpYrGHOlQNfZq2+KUrdTp1CPAID6v/2QOgpERxleDuZu5aHypdGEdzO1uJpbx8Kulf3kapPWPD0oc4AjLSBq4PEtbvqrgH2uymSBtlXZZ9gAEfUSnns0Vhggc1U5vSz3kfw6Ee3L9sGp/bLlqneY6bZPNEOjl+4s4TtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730153844; c=relaxed/simple;
	bh=hPSORu8X84wHamJsSnuT0+lTJu1yarz+EC2HLEomrxY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=GOOEvY77bjkIjGV0aU5sajhQCBNXf1q1otFfv1mCpKSGxblf+e2fzHSlXzDG0dC+JFcUSTQTji+9ABssdnO0IIK+nQdNgGrd3Ye3ivHt5kyVcPeiXzDfb58l7kN2pBnfCRtDW0jm6a+SkwkA0V+W+fR7+5PDTAx0Lw2SN4MerJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: move device to different namespace
Date: Mon, 28 Oct 2024 23:17:14 +0100
Message-Id: <20241028221714.1428-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This actually triggers a UNREGISTER event, it is similar to existing
tests, but add this test to improve coverage for this scenario.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../shell/testcases/chains/netdev_move_device | 39 +++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100755 tests/shell/testcases/chains/netdev_move_device

diff --git a/tests/shell/testcases/chains/netdev_move_device b/tests/shell/testcases/chains/netdev_move_device
new file mode 100755
index 000000000000..a2948d8d287f
--- /dev/null
+++ b/tests/shell/testcases/chains/netdev_move_device
@@ -0,0 +1,39 @@
+#!/bin/bash
+
+set -e
+
+rnd=$(mktemp -u XXXXXXXX)
+ns1="nft1-$rnd"
+
+cleanup() {
+	ip netns del "$ns1"
+	ip link del d0 &>/dev/null || :
+}
+trap 'cleanup' EXIT
+
+RULESET="table netdev x {
+	chain x {}
+	chain w {
+		ip daddr 8.7.6.0/24 counter
+	}
+	chain y {
+		type filter hook ingress device d0 priority 0;
+		ip saddr { 1.2.3.4, 2.3.4.5 } counter
+		ip daddr vmap { 5.4.3.0/24 : jump w, 8.9.0.0/24 : jump x }
+	}
+}"
+
+ip netns add $ns1
+ip link add d0 type dummy
+$NFT -f - <<< $RULESET
+
+# move device to $ns1 triggers UNREGISTER event
+ip link set d0 netns $ns1
+
+$NFT delete table netdev x
+
+# a simple test that also triggers UNREGISTER event
+ip netns add $ns1
+ip -netns $ns1 link add d0 type dummy
+ip netns exec $ns1 $NFT -f - <<< $RULESET
+cleanup
-- 
2.30.2

