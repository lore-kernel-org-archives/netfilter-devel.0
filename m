Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E334121ADA7
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Mar 2025 11:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743163149; cv=none; b=EuekzrK46NrYZgtVRV4iPM4ZPADD26iuFbrOhM7F1JyRP5kVm093hzPkzik4zD6Y8VXAAT4xvq4SKfGAYoz/GGo9j7wSVEUZhTF9lWiIqRPgrXCb9ysGp4i/cbtkLV2sbvJKUXo+kHvICheGXas+YNeTMKCimJZUdKDL+1GIBs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743163149; c=relaxed/simple;
	bh=ffMyiRlu902SpfilI5Bpur0uL5Dodzk8OjBW+TvQ8/c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=In0KzSujraohPp8UeChSfPC9Io0VeTjq3uMxtcjRNh4aBn3tCKYmt+AFTvxqgebTOeoGZi9s0+31bXxeYI8OWLXDqGw7EJbOW60xAc6uzRBCM1wtr35JO8h0RxnhT6FU5YTfi+b3Lg7VK7ZAOysb02WkuDIU68KVGX+sw09LFMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=HNtcj9WQ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="HNtcj9WQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zHsUiBYAguoG277bBLSVfpFoKenxaYlt7QWZbA3/wv0=; b=HNtcj9WQzyqEvjDufj1qMxZ+7d
	PlgnBNNIBiQaDQmOH/n6oV+FU4YzkEyLjbgjNGMq/2MSB5VtfsypXvi4ZOBtZd9uDdrNvITSdsIAD
	5DOjLiGj3F22yGFT99ndG7FHkBJSV0J5iWhjJyUbZIxI8zPF7HzzgGBbflQ7fso+NzL10h9canBQy
	iUX03KPr+ezb6xpQR+4RPX8a0KWMqUt2zimuKTF0o/cI8xlmi1IHNU64rtDN4gfgt3xhqGWkksfGz
	0PYTdN/O1mv0/9CoDLdL1APkKwxMo1vVpMwsyFAWr9bzVXMBmrVWw8xPSq+Qm3I5gUjliSToFZRZh
	MIMYW1PQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ty8MV-000000005yw-1VEF;
	Fri, 28 Mar 2025 12:58:59 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: shell: Add socat availability feature test
Date: Fri, 28 Mar 2025 12:58:55 +0100
Message-ID: <20250328115855.6426-1-phil@nwl.cc>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several tests did this manually and skipped if unavail, others just
implicitly depended on the tool.

Note that for the sake of simplicity, this will skip
packetpath/tcp_options test entirely when it did a partial run before.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/features/socat.sh                  | 4 ++++
 tests/shell/testcases/packetpath/cgroupv2      | 7 ++-----
 tests/shell/testcases/packetpath/flowtables    | 1 +
 tests/shell/testcases/packetpath/match_l4proto | 1 +
 tests/shell/testcases/packetpath/payload       | 1 +
 tests/shell/testcases/packetpath/tcp_options   | 9 +--------
 tests/shell/testcases/packetpath/tcp_reset     | 4 ++--
 7 files changed, 12 insertions(+), 15 deletions(-)
 create mode 100755 tests/shell/features/socat.sh

diff --git a/tests/shell/features/socat.sh b/tests/shell/features/socat.sh
new file mode 100755
index 0000000000000..93cad6f20d2ee
--- /dev/null
+++ b/tests/shell/features/socat.sh
@@ -0,0 +1,4 @@
+#!/bin/sh
+
+# check whether socat is installed
+socat -h >/dev/null 2>&1
diff --git a/tests/shell/testcases/packetpath/cgroupv2 b/tests/shell/testcases/packetpath/cgroupv2
index 5c5bea0c903d3..65916e9db1e8c 100755
--- a/tests/shell/testcases/packetpath/cgroupv2
+++ b/tests/shell/testcases/packetpath/cgroupv2
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_socat)
+
 doit="$1"
 rc=0
 
@@ -11,11 +13,6 @@ rc=0
 # should never match, it only exists so we
 # can create cgroupv2 match rules.
 
-if ! socat -h > /dev/null ; then
-	echo "socat tool is missing"
-	exit 77
-fi
-
 if [ ! -r /sys/fs/cgroup/cgroup.procs ] ;then
 	echo "cgroup filesystem not available"
 	exit 77
diff --git a/tests/shell/testcases/packetpath/flowtables b/tests/shell/testcases/packetpath/flowtables
index 2c4a7e1f725ad..d4e0a5bd1c073 100755
--- a/tests/shell/testcases/packetpath/flowtables
+++ b/tests/shell/testcases/packetpath/flowtables
@@ -1,5 +1,6 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_socat)
 # NFT_TEST_SKIP(NFT_TEST_SKIP_slow)
 
 set -x
diff --git a/tests/shell/testcases/packetpath/match_l4proto b/tests/shell/testcases/packetpath/match_l4proto
index 31fbe6c27d66a..e61524e9cbdb8 100755
--- a/tests/shell/testcases/packetpath/match_l4proto
+++ b/tests/shell/testcases/packetpath/match_l4proto
@@ -1,6 +1,7 @@
 #!/bin/bash
 
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_netdev_egress)
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_socat)
 
 rnd=$(mktemp -u XXXXXXXX)
 ns1="nft1payload-$rnd"
diff --git a/tests/shell/testcases/packetpath/payload b/tests/shell/testcases/packetpath/payload
index 83e0b7fc647ac..1e6b5a51969bb 100755
--- a/tests/shell/testcases/packetpath/payload
+++ b/tests/shell/testcases/packetpath/payload
@@ -1,6 +1,7 @@
 #!/bin/bash
 
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_netdev_egress)
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_socat)
 
 rnd=$(mktemp -u XXXXXXXX)
 ns1="nft1payload-$rnd"
diff --git a/tests/shell/testcases/packetpath/tcp_options b/tests/shell/testcases/packetpath/tcp_options
index 57e228c5990e0..88c095ff66dec 100755
--- a/tests/shell/testcases/packetpath/tcp_options
+++ b/tests/shell/testcases/packetpath/tcp_options
@@ -1,9 +1,7 @@
 #!/bin/bash
 
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_reset_tcp_options)
-
-have_socat="no"
-socat -h > /dev/null && have_socat="yes"
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_socat)
 
 ip link set lo up
 
@@ -33,11 +31,6 @@ if [ $? -ne 0 ]; then
 	exit 1
 fi
 
-if [ $have_socat != "yes" ]; then
-	echo "Ran partial test, socat not available (skipped)"
-	exit 77
-fi
-
 # This will fail (drop in output -> connect fails with eperm)
 socat -u STDIN TCP:127.0.0.1:22345,connect-timeout=1 < /dev/null > /dev/null
 
diff --git a/tests/shell/testcases/packetpath/tcp_reset b/tests/shell/testcases/packetpath/tcp_reset
index 3dfcdde40c77a..559260a377090 100755
--- a/tests/shell/testcases/packetpath/tcp_reset
+++ b/tests/shell/testcases/packetpath/tcp_reset
@@ -1,10 +1,10 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_socat)
+
 # regression check for kernel commit
 # netfilter: nf_reject: init skb->dev for reset packet
 
-socat -h > /dev/null || exit 77
-
 ip link set lo up
 
 $NFT -f - <<EOF
-- 
2.48.1

