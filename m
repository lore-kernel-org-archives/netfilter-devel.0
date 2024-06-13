Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43B4A38F
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Jun 2024 00:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718238186; cv=none; b=E9qxSuRvlJU0T1lIS+u70kXk1bgQpmsUQ/IqLgWrSKz2facneb8PyolrXU25uXX2eDRW/SrXqvaqPV+Uxu5CtIIs7l5tERrZlpAl+Jv9IdTDVr8J0nmiB4yckHX49f89RsRKuvDwHj9Td6AwqGxw7nfwFikYts85ZFYc0FcSDRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718238186; c=relaxed/simple;
	bh=V0LWsNr1WSMW9DHryHQCcmftHZ8QltVWVafZPt3+L1I=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=Wx45nCho+JOFB0PCHE0kyaKCsGT3Q5fYdl/HWaYXEDCfgdDWulva5Ww9Vm7ehKSpDkhH6zIbQ0n8Ly1QAQUd462LU4/jtkqA/WDKeR+67BpBZMqXaZZjBuu+rZsLyKZHCNysdMgCPdbGysBMfGtSwOH6zZJWk0yU4FJXcbnludA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/4] tests: shell: add dependencies to skip unsupported tests in older kernels
Date: Thu, 13 Jun 2024 02:22:50 +0200
Message-Id: <20240613002253.103683-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Skip tests which contain unsupported feature in older kernels.

Fixes: f09171e077f8 ("tests: shell: combine dormant flag with netdevice removal")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/chains/netdev_chain_dormant_autoremove | 2 ++
 tests/shell/testcases/maps/named_ct_objects                  | 1 +
 tests/shell/testcases/maps/nat_addr_port                     | 5 +++++
 tests/shell/testcases/optimizations/ruleset                  | 1 +
 tests/shell/testcases/transactions/0049huge_0                | 5 +++++
 5 files changed, 14 insertions(+)

diff --git a/tests/shell/testcases/chains/netdev_chain_dormant_autoremove b/tests/shell/testcases/chains/netdev_chain_dormant_autoremove
index 0a684e565bdf..3093ce25319c 100755
--- a/tests/shell/testcases/chains/netdev_chain_dormant_autoremove
+++ b/tests/shell/testcases/chains/netdev_chain_dormant_autoremove
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_netdev_chain_multidevice)
+
 set -e
 
 ip link add dummy0 type dummy
diff --git a/tests/shell/testcases/maps/named_ct_objects b/tests/shell/testcases/maps/named_ct_objects
index 61b87c1ab14a..518140b0693d 100755
--- a/tests/shell/testcases/maps/named_ct_objects
+++ b/tests/shell/testcases/maps/named_ct_objects
@@ -1,6 +1,7 @@
 #!/bin/bash
 
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_cttimeout)
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_ctexpect)
 
 $NFT -f /dev/stdin <<EOF || exit 1
 table inet t {
diff --git a/tests/shell/testcases/maps/nat_addr_port b/tests/shell/testcases/maps/nat_addr_port
index 2804d48ca406..703a2ad9d431 100755
--- a/tests/shell/testcases/maps/nat_addr_port
+++ b/tests/shell/testcases/maps/nat_addr_port
@@ -84,6 +84,11 @@ $NFT add rule 'ip6 ip6foo c ip6 saddr f0:0b::a3 dnat to [1c::3]:42' && exit 1
 # should fail: rule has no test for l4 protocol, but map has inet_service
 $NFT add rule 'ip6 ip6foo c dnat to ip daddr map @y' && exit 1
 
+if [ "$NFT_TEST_HAVE_inet_nat" = n ]; then
+	echo "Test partially skipped due to NFT_TEST_HAVE_inet_nat=n"
+	exit 77
+fi
+
 # skeleton inet
 $NFT -f /dev/stdin <<EOF || exit 1
 table inet inetfoo {
diff --git a/tests/shell/testcases/optimizations/ruleset b/tests/shell/testcases/optimizations/ruleset
index 2b2d80ffc009..f7c3b74702ba 100755
--- a/tests/shell/testcases/optimizations/ruleset
+++ b/tests/shell/testcases/optimizations/ruleset
@@ -1,6 +1,7 @@
 #!/bin/bash
 
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_prerouting_reject)
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_inet_nat)
 
 RULESET="table inet uni {
 	chain gtfo {
diff --git a/tests/shell/testcases/transactions/0049huge_0 b/tests/shell/testcases/transactions/0049huge_0
index f66953c2ab70..698716b2b156 100755
--- a/tests/shell/testcases/transactions/0049huge_0
+++ b/tests/shell/testcases/transactions/0049huge_0
@@ -42,6 +42,11 @@ if [ "$NFT_TEST_HAVE_json" != n ]; then
 	test $($NFT -j -e -a -f - <<< "$RULESET" |sed 's/\({"add":\)/\n\1/g' |grep '"handle"' |wc -l) -eq ${RULE_COUNT} || exit 1
 fi
 
+if [ "$NFT_TEST_HAVE_inet_nat" = n ]; then
+	echo "Test partially skipped due to missing inet nat support."
+	exit 77
+fi
+
 # Now an example from firewalld's testsuite
 #
 $NFT flush ruleset
-- 
2.30.2

