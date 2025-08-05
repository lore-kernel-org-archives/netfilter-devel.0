Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4813F21D5BF
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Aug 2025 19:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754422852; cv=none; b=F/KoXM3rpsGNrwvG1pD38/3K1sc6aASwVAzdrkdon3l+hPsAT83ZwavpQW9Q0HEmZFl4QEj2nStTNOLSWGz49Aa3Ed/pULh2iP3MwZOvGnM/q1gBGSmzpbMzjk4KBJGuzaV/seO2vLvbLlrQ7jR1ux3P/9NvCEiIHCNwtOXJeaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754422852; c=relaxed/simple;
	bh=KuFg2113LSpz5NAbo/0HgPHY2DbbmDlcMzPhugHIxTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kK0ymU1rb4G1tv32DR+eBhhvuCsl1FkMQeZwRh32Dva2sP+tgXGW7aha5EAg4hJfhockkX4N1KMOO1LK0gBhk6POy+rrtexpze4KbCdFtYsN1xGsp91HdWGIuvknGB9dNtJfrYoJ0KhSjSyqulCb6gI6TntMqcu6kgLjGhsGvg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D64B061830; Tue,  5 Aug 2025 21:40:41 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/2] tests: shell: add parser and packetpath test
Date: Tue,  5 Aug 2025 21:40:15 +0200
Message-ID: <20250805194032.18288-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250805194032.18288-1-fw@strlen.de>
References: <20250805194032.18288-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

One to validate parsing, and one to test that packets match the
expected mapping.

omits json file because of:
internal:0:0-0: Error: Expression type payload not allowed in context (RHS, STMT).

i.e. there is more work to be done on json side to support this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 I suggest to defer this until after 1.1.4 is out.

.../bitwise/bitwise_in_sets_and_maps          | 27 ++++++++
 .../dumps/bitwise_in_sets_and_maps.nft        | 17 ++++++
 .../testcases/packetpath/bitwise_with_map     | 61 +++++++++++++++++++
 .../packetpath/dumps/bitwise_with_map.nft     | 16 +++++
 4 files changed, 121 insertions(+)
 create mode 100755 tests/shell/testcases/bitwise/bitwise_in_sets_and_maps
 create mode 100644 tests/shell/testcases/bitwise/dumps/bitwise_in_sets_and_maps.nft
 create mode 100755 tests/shell/testcases/packetpath/bitwise_with_map
 create mode 100644 tests/shell/testcases/packetpath/dumps/bitwise_with_map.nft

diff --git a/tests/shell/testcases/bitwise/bitwise_in_sets_and_maps b/tests/shell/testcases/bitwise/bitwise_in_sets_and_maps
new file mode 100755
index 000000000000..4f5044f512aa
--- /dev/null
+++ b/tests/shell/testcases/bitwise/bitwise_in_sets_and_maps
@@ -0,0 +1,27 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_bitshift)
+
+set -e
+
+$NFT -f - <<EOF
+table ip t {
+	map m {
+		typeof ip saddr : mark
+		elements = { 1.2.3.4 : 42 }
+	}
+
+	chain c {
+		meta mark set ip saddr map @m
+		meta mark set ip saddr & 255.255.255.0 map @m
+		meta mark set ip saddr ^ 255.255.255.0 map @m
+		meta mark set ip saddr ^ ip daddr map @m
+		meta mark set ip saddr ^ 1 map @m
+
+		meta mark set ip saddr & ip daddr map { 10.1.2.3 : 1, 10.2.3.4 : 2 }
+		meta mark set ip saddr ^ ip daddr map { 10.1.2.3 : 1, 10.2.3.4 : 2 }
+	}
+}
+EOF
+
+$NFT add element "t m { 10.1.2.1 : 23 }"
diff --git a/tests/shell/testcases/bitwise/dumps/bitwise_in_sets_and_maps.nft b/tests/shell/testcases/bitwise/dumps/bitwise_in_sets_and_maps.nft
new file mode 100644
index 000000000000..a29d6c011fbb
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/bitwise_in_sets_and_maps.nft
@@ -0,0 +1,17 @@
+table ip t {
+	map m {
+		typeof ip saddr : meta mark
+		elements = { 1.2.3.4 : 0x0000002a,
+			     10.1.2.1 : 0x00000017 }
+	}
+
+	chain c {
+		meta mark set ip saddr map @m
+		meta mark set ip saddr & 255.255.255.0 map @m
+		meta mark set ip saddr ^ 255.255.255.0 map @m
+		meta mark set ip saddr ^ ip daddr map @m
+		meta mark set ip saddr ^ 0.0.0.1 map @m
+		meta mark set ip saddr & ip daddr map { 10.1.2.3 : 0x00000001, 10.2.3.4 : 0x00000002 }
+		meta mark set ip saddr ^ ip daddr map { 10.1.2.3 : 0x00000001, 10.2.3.4 : 0x00000002 }
+	}
+}
diff --git a/tests/shell/testcases/packetpath/bitwise_with_map b/tests/shell/testcases/packetpath/bitwise_with_map
new file mode 100755
index 000000000000..33419e42f2f4
--- /dev/null
+++ b/tests/shell/testcases/packetpath/bitwise_with_map
@@ -0,0 +1,61 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_bitshift)
+
+set -e
+ret=0
+
+ip link set lo up
+
+$NFT -f - <<EOF
+table ip test-binop {
+	chain in {
+		type filter hook input priority 0
+
+		icmp type echo-request jump {
+			meta mark 0 counter
+			meta mark 1 counter
+			meta mark 2 counter
+			meta mark 3 counter
+		}
+	}
+
+	chain out {
+		type filter hook output priority 0
+
+		icmp type echo-request meta mark set ip saddr ^ ip daddr map { 0.0.0.0 : 1, 0.1.2.2 : 2, 127.0.0.1 : 3 }
+	}
+}
+EOF
+
+test_match()
+{
+	mark="$1"
+	packets="$2"
+	str=$(printf "mark 0x%08x" $mark)
+
+	if ! $NFT list chain test-binop in | grep "$str" | grep "packets $packets"; then
+		$NFT list chain test-binop in
+		echo "Failed counter for mark $mark: not $packets"
+		ret=1
+	fi
+}
+
+test_ping_and_match()
+{
+	ping="$1"
+	mark="$2"
+	packets="$3"
+
+	ping -q -c 1 "$ping"
+	test_match "$mark" "$packets"
+}
+
+test_ping_and_match "127.0.0.1" 1 1
+test_ping_and_match "127.1.2.3" 2 1
+
+# validation of 0 counters done via dump.
+# validation of 1-counters done manually to make
+# sure each ping triggers the expected counter.
+
+exit $ret
diff --git a/tests/shell/testcases/packetpath/dumps/bitwise_with_map.nft b/tests/shell/testcases/packetpath/dumps/bitwise_with_map.nft
new file mode 100644
index 000000000000..ba1ef8ac3f1f
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/bitwise_with_map.nft
@@ -0,0 +1,16 @@
+table ip test-binop {
+	chain in {
+		type filter hook input priority filter; policy accept;
+		icmp type echo-request jump {
+			meta mark 0x00000000 counter packets 0 bytes 0
+			meta mark 0x00000001 counter packets 1 bytes 84
+			meta mark 0x00000002 counter packets 1 bytes 84
+			meta mark 0x00000003 counter packets 0 bytes 0
+		}
+	}
+
+	chain out {
+		type filter hook output priority filter; policy accept;
+		icmp type echo-request meta mark set ip saddr ^ ip daddr map { 0.0.0.0 : 0x00000001, 0.1.2.2 : 0x00000002, 127.0.0.1 : 0x00000003 }
+	}
+}
-- 
2.49.1

