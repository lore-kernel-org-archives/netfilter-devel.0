Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 314AB4404
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Jun 2024 00:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718238187; cv=none; b=uwOjyfE9AGdN2cl8Wacp9XyQZPJpAuNzTaJaHWhF4cpCrT6bAFyqdMIZP+djtMADB+cRBsid33Ki32JHHqiJnL2agZvfjyw8GpDM64KdqDCog1BWB/fRaYfwV0q39YXv+Qc5y4MlHAAWExa828yHTq72gFF5gxKInKG6pMcLFZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718238187; c=relaxed/simple;
	bh=PiUzRRmzzy2oFCQYIj5b25fRnMp3sVlyXQnwp4SEicY=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZPCV6iny9hs+1/xVKAKL9FTIblW5HDM2MGg7CSyfUZZiL+llH6l0A6ILglc0CUmkrJ3ipoeuJLoJbhun5ThFDg+udcdhHrEWoIX9UfP/B7uaKBvP3Ksc1D0ceagE5zsy+E1LydZ2ZbuD6QsEImOg3EffsvOi3deOAIKhWVP++AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 4/4] tests: shell: skip NFTA_RULE_POSITION_ID tests if kernel does not support it
Date: Thu, 13 Jun 2024 02:22:53 +0200
Message-Id: <20240613002253.103683-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240613002253.103683-1-pablo@netfilter.org>
References: <20240613002253.103683-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/features/position_id.sh           | 23 +++++++++++++++++++
 tests/shell/testcases/cache/0011_index_0      |  2 ++
 tests/shell/testcases/transactions/0024rule_0 |  2 ++
 3 files changed, 27 insertions(+)
 create mode 100755 tests/shell/features/position_id.sh

diff --git a/tests/shell/features/position_id.sh b/tests/shell/features/position_id.sh
new file mode 100755
index 000000000000..43ac97aca216
--- /dev/null
+++ b/tests/shell/features/position_id.sh
@@ -0,0 +1,23 @@
+#!/bin/bash
+
+# 75dd48e2e420 ("netfilter: nf_tables: Support RULE_ID reference in new rule")
+# v5.1-rc1~178^2~405^2~27
+
+EXPECTED="table inet t {
+	chain c {
+		tcp dport 1234 accept
+		udp dport 4321 accept
+		accept
+	}
+}"
+
+RULESET="add table inet t
+add chain inet t c
+add rule inet t c tcp dport 1234 accept
+add rule inet t c accept
+insert rule inet t c index 1 udp dport 4321 accept
+"
+
+$NFT -f - <<< $RULESET
+
+diff -u <($NFT list ruleset) - <<<"$EXPECTED"
diff --git a/tests/shell/testcases/cache/0011_index_0 b/tests/shell/testcases/cache/0011_index_0
index c9eb86830c8d..76f2615d471c 100755
--- a/tests/shell/testcases/cache/0011_index_0
+++ b/tests/shell/testcases/cache/0011_index_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_position_id)
+
 set -e
 
 RULESET="flush ruleset
diff --git a/tests/shell/testcases/transactions/0024rule_0 b/tests/shell/testcases/transactions/0024rule_0
index 4c1ac41db3b4..645319e27194 100755
--- a/tests/shell/testcases/transactions/0024rule_0
+++ b/tests/shell/testcases/transactions/0024rule_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_position_id)
+
 RULESET="flush ruleset
 add table x
 add chain x y
-- 
2.30.2

