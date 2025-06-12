Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F8222333B
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 11:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749729155; cv=none; b=IQHV1LZ+RCHu1FOMmq898qvyPoOXdpm0TqW7iSAFTxDVuDXh3/WQaZNdBVPLq8QioNwMMp8gVftUVisqMEks/LBmDbCf0LP5sYyGTA6sZlaBnUWwOHya4Q/Gu6xuf5Xn9DFPH9Wx8yWIDfCiAxAY31bdCRv1ftOV7695AVXlmEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749729155; c=relaxed/simple;
	bh=q376Wj6Iit2VhI9iaOrAU44MIcdr/NvqI4BYyWdK2Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzqN9zZa0YgQEv/hPfbOm09VBh0IX7Ion1TXmrbq4rl6Q/KiThWKlHumC1rhsXK8VRWDfzDFoZoxVVFrV1/jZsZhqDEG6xQuYWo+VgjOElF5sn66JWIFJCnxmpnV4GBzZGJQ+AUgR8nV0X7JtUYQyE3A+8Xa35fSr+ZmUlpQL7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=TR7iQax4; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="TR7iQax4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BjyE98AQzDHYhA8rHCExE29MMPQ6nbMBgqMXvtqaOBg=; b=TR7iQax4ubRNFhFFCHRFV6ks4k
	SJMuFhu6kuonf0BlPWK5yXJCvn8Tpg67MkLxxgEaSgNCpXZRxeAw2m7LguHFtwIwk0JuE3Wbnehb+
	bYoxVLfGnhb+regKar/70vl7p/Libonw5iA29m5/qAfY2H3jwMwgFSwNELELaI+wgQ7zahWA9p80H
	TR7wKrTgP16CPP/SmwzdIsJQZXAUX7DRU4XYxxXC96HI4/Y4okoREjxKAubTf5HAtLa+h6hUtj8CR
	BEiG5+vycNbHA3w1hTsJ3sZ2Mw8xtiwKCWxhjdTlQXrPZdkwWRNHduJz/jWOSmjFu48DJuvO0X7Cy
	Sm8Rj8sg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPgTv-000000006GL-2xtP;
	Thu, 12 Jun 2025 13:52:31 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 6/7] tests: shell: Adjust to ifname-based hooks
Date: Thu, 12 Jun 2025 13:52:17 +0200
Message-ID: <20250612115218.4066-7-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250612115218.4066-1-phil@nwl.cc>
References: <20250612115218.4066-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Interface specs won't disappear anymore upon device removal. Drop them
manually if kernel has ifname-based hooks.

Also drop transactions/0050rule_1 test entirely: It won't fail anymore
as the flowtable is accepted despite the non-existent interfaces and
thus the test as a whole does not work anymore.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/features/ifname_based_hooks.sh    | 12 ++++++++++++
 .../chains/netdev_chain_dormant_autoremove    |  3 +++
 .../flowtable/0012flowtable_variable_0        |  9 ++++++++-
 tests/shell/testcases/listing/0020flowtable_0 |  8 +++++++-
 tests/shell/testcases/transactions/0050rule_1 | 19 -------------------
 .../transactions/dumps/0050rule_1.json-nft    | 11 -----------
 .../transactions/dumps/0050rule_1.nft         |  0
 7 files changed, 30 insertions(+), 32 deletions(-)
 create mode 100755 tests/shell/features/ifname_based_hooks.sh
 delete mode 100755 tests/shell/testcases/transactions/0050rule_1
 delete mode 100644 tests/shell/testcases/transactions/dumps/0050rule_1.json-nft
 delete mode 100644 tests/shell/testcases/transactions/dumps/0050rule_1.nft

diff --git a/tests/shell/features/ifname_based_hooks.sh b/tests/shell/features/ifname_based_hooks.sh
new file mode 100755
index 0000000000000..cada6956f165b
--- /dev/null
+++ b/tests/shell/features/ifname_based_hooks.sh
@@ -0,0 +1,12 @@
+#!/bin/bash
+
+# check if netdev chains survive without a single device
+
+unshare -n bash -c "ip link add d0 type dummy; \
+	$NFT \"table netdev t { \
+		chain c { \
+			type filter hook ingress priority 0; devices = { d0 }; \
+		}; \
+	}\"; \
+	ip link del d0; \
+	$NFT list chain netdev t c"
diff --git a/tests/shell/testcases/chains/netdev_chain_dormant_autoremove b/tests/shell/testcases/chains/netdev_chain_dormant_autoremove
index 3093ce25319cf..8455f310445e9 100755
--- a/tests/shell/testcases/chains/netdev_chain_dormant_autoremove
+++ b/tests/shell/testcases/chains/netdev_chain_dormant_autoremove
@@ -9,3 +9,6 @@ ip link add dummy1 type dummy
 $NFT add table netdev test { flags dormant\; }
 $NFT add chain netdev test ingress { type filter hook ingress devices = { "dummy0", "dummy1" } priority 0\; policy drop\; }
 ip link del dummy0
+if [ "$NFT_TEST_HAVE_ifname_based_hooks" = y ]; then
+	$NFT 'delete chain netdev test ingress { devices = { "dummy0" }; }'
+fi
diff --git a/tests/shell/testcases/flowtable/0012flowtable_variable_0 b/tests/shell/testcases/flowtable/0012flowtable_variable_0
index 9c03820f128e3..ff35548ed8543 100755
--- a/tests/shell/testcases/flowtable/0012flowtable_variable_0
+++ b/tests/shell/testcases/flowtable/0012flowtable_variable_0
@@ -4,11 +4,18 @@
 
 set -e
 
+ft_deldev() {
+	$NFT "delete flowtable $1 $2 { devices = { $3 }; }"
+}
+
 iface_cleanup() {
 	ip link del dummy1 &>/dev/null || :
+	if [ "$NFT_TEST_HAVE_ifname_based_hooks" = y ]; then
+		ft_deldev filter1 Main_ft1 dummy1
+		ft_deldev filter2 Main_ft2 dummy1
+	fi
 }
 trap 'iface_cleanup' EXIT
-iface_cleanup
 
 ip link add name dummy1 type dummy
 
diff --git a/tests/shell/testcases/listing/0020flowtable_0 b/tests/shell/testcases/listing/0020flowtable_0
index 0e89f5dd01393..14b0c909a7eba 100755
--- a/tests/shell/testcases/listing/0020flowtable_0
+++ b/tests/shell/testcases/listing/0020flowtable_0
@@ -48,7 +48,13 @@ EXPECTED3="table ip filter {
 iface_cleanup() {
 	ip link del d0 &>/dev/null || :
 }
-trap 'iface_cleanup' EXIT
+ft_cleanup() {
+	if [ "$NFT_TEST_HAVE_ifname_based_hooks" = y ]; then
+		$NFT 'delete flowtable ip filter f2 { devices = { d0 }; }'
+		$NFT 'delete flowtable inet filter f2 { devices = { d0 }; }'
+	fi
+}
+trap 'iface_cleanup; ft_cleanup' EXIT
 iface_cleanup
 
 ip link add d0 type dummy
diff --git a/tests/shell/testcases/transactions/0050rule_1 b/tests/shell/testcases/transactions/0050rule_1
deleted file mode 100755
index 89e5f42fc9f4d..0000000000000
--- a/tests/shell/testcases/transactions/0050rule_1
+++ /dev/null
@@ -1,19 +0,0 @@
-#!/bin/bash
-
-set -e
-
-RULESET="table inet filter {
-	flowtable ftable {
-		hook ingress priority 0; devices = { eno1, eno0, x };
-	}
-
-chain forward {
-	type filter hook forward priority 0; policy drop;
-
-	ip protocol { tcp, udp } ct mark and 1 == 1 counter flow add @ftable
-	ip6 nexthdr { tcp, udp } ct mark and 2 == 2 counter flow add @ftable
-	ct mark and 30 == 30 ct state established,related log prefix \"nftables accept: \" level info accept
-	}
-}"
-
-$NFT -f - <<< "$RULESET" >/dev/null || exit 0
diff --git a/tests/shell/testcases/transactions/dumps/0050rule_1.json-nft b/tests/shell/testcases/transactions/dumps/0050rule_1.json-nft
deleted file mode 100644
index 546cc5977db61..0000000000000
--- a/tests/shell/testcases/transactions/dumps/0050rule_1.json-nft
+++ /dev/null
@@ -1,11 +0,0 @@
-{
-  "nftables": [
-    {
-      "metainfo": {
-        "version": "VERSION",
-        "release_name": "RELEASE_NAME",
-        "json_schema_version": 1
-      }
-    }
-  ]
-}
diff --git a/tests/shell/testcases/transactions/dumps/0050rule_1.nft b/tests/shell/testcases/transactions/dumps/0050rule_1.nft
deleted file mode 100644
index e69de29bb2d1d..0000000000000
-- 
2.49.0

