Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208A345005
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Dec 2024 11:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733570238; cv=none; b=kmaZlVtQpx5yow5W8vJKGBfj52cbwkaANqcddU+x8tMV0XSQErCt9EnlyCPyTCkDclE+O2G8Z4/uVY7zh7osAG1G/RFvGWYTsC7urlpBRaDiXYmvpnpNzoTeWhCgAekg9Qfv1IaBXccZ64v1/B1QQh073gTDJ30FqvqEDKOIAow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733570238; c=relaxed/simple;
	bh=EEcbtWwFITz+9YzXYiV1XuAyCeDvN1PympJw+fP9fFE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hm4ippbFh73fLWfBedG6Qssz0I0ugKyz4EOs+wuJCcZbhXMm4hFwilUTBtymrGyMgO9+OlRXLO8W/wsEDYFhs9mRgkWNroEvHkdjXgvFzDwGe/1BATOuBXOmjx19Azgp08ZKxDcydz9WtiXGkJY+C6OwHpUQMX0XyQXHHKTr5Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tJsoC-0002nz-6z; Sat, 07 Dec 2024 12:17:12 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: add a test case for netdev ruleset flush + parallel link down
Date: Sat,  7 Dec 2024 12:17:02 +0100
Message-ID: <20241207111707.7322-1-fw@strlen.de>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test for bug added with kernel commit
c03d278fdf35 ("netfilter: nf_tables: wait for rcu grace period on net_device removal")

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../dumps/netdev_chain_dev_addremove.nodump   |  0
 .../chains/netdev_chain_dev_addremove         | 48 +++++++++++++++++++
 2 files changed, 48 insertions(+)
 create mode 100644 tests/shell/testcases/chains/dumps/netdev_chain_dev_addremove.nodump
 create mode 100755 tests/shell/testcases/chains/netdev_chain_dev_addremove

diff --git a/tests/shell/testcases/chains/dumps/netdev_chain_dev_addremove.nodump b/tests/shell/testcases/chains/dumps/netdev_chain_dev_addremove.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/chains/netdev_chain_dev_addremove b/tests/shell/testcases/chains/netdev_chain_dev_addremove
new file mode 100755
index 000000000000..14260d54b778
--- /dev/null
+++ b/tests/shell/testcases/chains/netdev_chain_dev_addremove
@@ -0,0 +1,48 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_inet_ingress)
+
+set -e
+
+iface_cleanup() {
+        ip link del d0 &>/dev/null || :
+}
+trap 'iface_cleanup' EXIT
+
+load_rules()
+{
+$NFT -f - <<EOF
+add table netdev nm-mlag-dummy0
+add set netdev nm-mlag-dummy0 macset-tagged { typeof ether saddr . vlan id; size 65535; flags dynamic,timeout; }
+add set netdev nm-mlag-dummy0 macset-untagged { typeof ether saddr; size 65535; flags dynamic,timeout; }
+add chain netdev nm-mlag-dummy0 tx-snoop-source-mac { type filter hook egress devices = { dummy0 } priority filter; policy accept; }
+add rule netdev nm-mlag-dummy0 tx-snoop-source-mac update @macset-tagged { ether saddr . vlan id timeout 5s } return
+add rule netdev nm-mlag-dummy0 tx-snoop-source-mac update @macset-untagged { ether saddr timeout 5s }
+add chain netdev nm-mlag-dummy0 rx-drop-looped-packets { type filter hook ingress devices = { dummy0 } priority filter; policy accept; }
+add rule netdev nm-mlag-dummy0 rx-drop-looped-packets ether saddr . vlan id @macset-tagged drop
+add rule netdev nm-mlag-dummy0 rx-drop-looped-packets ether type 8021q return
+add rule netdev nm-mlag-dummy0 rx-drop-looped-packets ether saddr @macset-untagged drop
+EOF
+}
+
+for i in $(seq 1 500);do
+	read taint < /proc/sys/kernel/tainted
+	if [ "$taint" -ne 0 ]; then
+		exit 1
+	fi
+	ip link add dummy0 type dummy
+	load_rules
+
+	# zap ruleset and down device at same time
+	$NFT flush ruleset &
+	ip link del dummy0 &
+	wait
+done
+
+read taint < /proc/sys/kernel/tainted
+
+if [ "$taint" -ne 0 ]; then
+	exit 1
+fi
+
+exit 0
-- 
2.45.2

