Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D1F2FFFAA
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Sep 2025 16:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041656; cv=none; b=Jwc17KPkrB0NtXv2crOK97mgFMchiYaG6UT/SNC5ETmqWGUJIn+DAwu5HfFuYvs5ezyBQ37XPf+0a8hUi+56L4gqujEw5rWXVnyTOCJ0esHFoqwzUC9JrZNAl2wJbzChEWh22F+SQXmbGM8iwEu8QKKWXDbHBncrNj1knMNwQ4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041656; c=relaxed/simple;
	bh=5TqN/7u78V5c6WJvB8S+ya7dVQrWEYuxDmqvo0fp7qc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b72zpj/krjJu1GuTvfmuBdlotZkqwk3LlrAiI36TKLrFUUdEEnvDeTJ3lCPuT21XyMPwJtNLoamehz7Yp3fP44yp+b8tpwD1RbXxMEOGzoAIfRt8KFRLwkmX0eU7gQJw2Yadr2R+D+y0bQkyr9pUmdV0bxW2fdn6iB6svrRKS70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BF3F960308; Tue, 16 Sep 2025 18:54:11 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: add regression tests for set flush+add bugs
Date: Tue, 16 Sep 2025 18:52:53 +0200
Message-ID: <20250916165255.15356-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Create a helper file to:
1. create client <-> router <-> server topology
2. floodping from client to server
3. add a chain + set that contains both client and server
   addresses
4. a control counter that should never match
5. then, flush the set (not the ruleset) and re-add the
   addresses in one transaction

Report failure when counter had a match.

The test cases for the set types are done in separate files to take
advantage of run-tests.sh parallelization.

The expected behavior is that every ping packet is matched by the set.
The packet path should either match the old state, right before flush,
or the new state, after re-add.

As the flushed addresses are re-added in the same transaction we must
not observe in-limbo state where existing elements are deactivated but
new elements are not found.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 NB: This still fails on nf-next when AVX2 is available
 for the pipapo test case due to thinko, NFT_GENMASK_ANY
 has to be replaced with 0 to get the effect the (wrong)
 fix wanted.

 .../helpers/set_flush_add_atomic_helpers      | 223 ++++++++++++++++++
 .../dumps/set_flush_add_atomic_bitmap.nodump  |   0
 .../dumps/set_flush_add_atomic_hash.nodump    |   0
 .../set_flush_add_atomic_hash_fast.nodump     |   0
 .../dumps/set_flush_add_atomic_pipapo.nodump  |   0
 .../dumps/set_flush_add_atomic_rbtree.nodump  |   0
 .../dumps/set_flush_add_atomic_rhash.nodump   |   0
 .../packetpath/set_flush_add_atomic_bitmap    |  18 ++
 .../packetpath/set_flush_add_atomic_hash      |  18 ++
 .../packetpath/set_flush_add_atomic_hash_fast |  18 ++
 .../packetpath/set_flush_add_atomic_pipapo    |  20 ++
 .../packetpath/set_flush_add_atomic_rbtree    |  18 ++
 .../packetpath/set_flush_add_atomic_rhash     |  18 ++
 13 files changed, 333 insertions(+)
 create mode 100644 tests/shell/helpers/set_flush_add_atomic_helpers
 create mode 100644 tests/shell/testcases/packetpath/dumps/set_flush_add_atomic_bitmap.nodump
 create mode 100644 tests/shell/testcases/packetpath/dumps/set_flush_add_atomic_hash.nodump
 create mode 100644 tests/shell/testcases/packetpath/dumps/set_flush_add_atomic_hash_fast.nodump
 create mode 100644 tests/shell/testcases/packetpath/dumps/set_flush_add_atomic_pipapo.nodump
 create mode 100644 tests/shell/testcases/packetpath/dumps/set_flush_add_atomic_rbtree.nodump
 create mode 100644 tests/shell/testcases/packetpath/dumps/set_flush_add_atomic_rhash.nodump
 create mode 100755 tests/shell/testcases/packetpath/set_flush_add_atomic_bitmap
 create mode 100755 tests/shell/testcases/packetpath/set_flush_add_atomic_hash
 create mode 100755 tests/shell/testcases/packetpath/set_flush_add_atomic_hash_fast
 create mode 100755 tests/shell/testcases/packetpath/set_flush_add_atomic_pipapo
 create mode 100755 tests/shell/testcases/packetpath/set_flush_add_atomic_rbtree
 create mode 100755 tests/shell/testcases/packetpath/set_flush_add_atomic_rhash

diff --git a/tests/shell/helpers/set_flush_add_atomic_helpers b/tests/shell/helpers/set_flush_add_atomic_helpers
new file mode 100644
index 000000000000..fe895e98169b
--- /dev/null
+++ b/tests/shell/helpers/set_flush_add_atomic_helpers
@@ -0,0 +1,223 @@
+# Test skeleton for kernel fixes:
+# b2f742c846ca netfilter: nf_tables: restart set lookup on base_seq change
+# a60f7bf4a152 netfilter: nft_set_rbtree: continue traversal if element is inactive
+# .. and related patches.
+#
+# Generate traffic and then flush the set contents and replace
+# them with the same matching entries.
+#
+# Fail when a packet gets through.
+
+# global variables:
+# R, S, C (network namespaces).
+# ip_s (server address)
+
+# helpers:
+# set_flush_add_atomic_cleanup
+# set_flush_add_create_topo
+# set_flush_add_atomic_run_test
+
+[ -z "$TIMEOUT" ] && TIMEOUT=30
+
+set_flush_add_atomic_cleanup()
+{
+	local tmp="$1"
+	local i
+
+	rm -f "$tmp"
+
+	ip netns exec $R $NFT --debug netlink list ruleset
+
+	for i in $C $S $R;do
+		kill $(ip netns pid $i) 2>/dev/null
+		ip netns del $i
+	done
+}
+
+check_counter()
+{
+	local tmp="$1"
+	local then="$2"
+
+	if ip netns exec $R $NFT list chain ip filter block-spoofed | grep -q 'counter packets 0 bytes 0'; then
+		return 0
+	fi
+
+	local now=$(date +%s)
+	echo "$0 failed counter check after $((now-then))s"
+
+	rm -f "$tmp"
+	kill $(ip netns pid $C) 2>/dev/null
+	return 1
+}
+
+load_ruleset()
+{
+	local type="$1"
+	local flags="$2"
+	local elements="$3"
+	local expr="$4"
+
+ip netns exec $R $NFT -f - <<EOF
+table ip filter {
+  set match {
+    type $type
+    $flags
+    elements = { $elements }
+  }
+
+  set bogon {
+     type ipv4_addr . ipv4_addr . icmp_type
+     flags dynamic
+     size 8
+     timeout 5m
+  }
+
+  chain block-spoofed {
+    type filter hook prerouting priority filter; policy accept;
+    $expr @match accept
+    counter add @bogon { ip saddr . ip daddr . icmp type } comment "must not match"
+  }
+}
+EOF
+}
+
+reload_set()
+{
+	local tmp="$1"
+	local elements="$2"
+
+	while [ -f "$tmp" ]; do
+ip netns exec $R $NFT -f - <<EOF
+flush set ip filter match
+create element ip filter match { $elements }
+EOF
+		if [ $? -ne 0 ];then
+			echo "reload of set failed unexpectedly"
+			rm -f "$tmp"
+			exit 1
+		fi
+
+	done
+}
+
+monitor_counter()
+{
+	local tmp="$1"
+	local then="$2"
+
+	while [ -f "$tmp" ]; do
+		sleep 1
+		check_counter "$tmp" "$then" || return 1
+	done
+
+	return 0
+}
+
+wait_for_timeout()
+{
+	local tmp="$1"
+	local rc=0
+
+	local then=$(date +%s)
+	local end=$((then+TIMEOUT))
+
+	while [ -f "$tmp" ];do
+		local now=$(date +%s)
+		[ "$now" -ge "$end" ] && break
+		sleep 1
+	done
+
+	test -f "$tmp" || rc=1
+	rm -f "$tmp"
+
+	return $rc
+}
+
+set_flush_add_create_topo()
+{
+	local test="$1"
+	local ip_r1=192.168.2.1
+	local ip_r2=192.168.3.1
+	# global
+	ip_c=192.168.2.30
+	ip_s=192.168.3.10
+
+	rnd=$(mktemp -u XXXXXXXX)
+	C="$test-client-$rnd"
+	R="$test-router-$rnd"
+	S="$test-server-$rnd"
+
+	ip netns add $S
+	ip netns add $R
+	ip netns add $C
+
+	ip link add veth0 netns $S type veth peer name rs netns $R
+	ip link add veth0 netns $C type veth peer name rc netns $R
+
+	ip -net $S link set veth0 up
+	ip -net $C link set veth0 up
+	ip -net $R link set rs up
+	ip -net $R link set rc up
+	ip -net $S link set lo up
+	ip -net $C link set lo up
+	ip -net $R link set lo up
+
+	for n in $S $R $C;do
+		ip netns exec $n sysctl -q net.ipv4.conf.all.rp_filter=0
+	done
+
+	ip netns exec $R sysctl -q net.ipv4.ip_forward=1
+
+	ip -net $S addr add ${ip_s}/24  dev veth0
+	ip -net $C addr add ${ip_c}/24  dev veth0
+	ip -net $R addr add ${ip_r1}/24 dev rc
+	ip -net $R addr add ${ip_r2}/24 dev rs
+
+	ip -net $C route add default via ${ip_r1} dev veth0
+	ip -net $S route add default via ${ip_r2} dev veth0
+
+	ip netns exec $S ping -q -c 1 -i 0.1 ${ip_c} || exit 1
+	ip netns exec $C ping -q -c 1 -i 0.1 ${ip_s} || exit 2
+}
+
+start_ping_flood()
+{
+	for i in $(seq 1 4);do
+		timeout $TIMEOUT ip netns exec $C ping -W 0.00001 -l 200 -q -f ${ip_s} &
+	done
+
+	wait
+}
+
+set_flush_add_atomic_run_test()
+{
+	local tmp="$1"
+	local type="$2"
+	local flags="$3"
+	local elements="$4"
+	local expr="$5"
+
+	local then=$(date +%s)
+	local now=$(date +%s)
+
+	load_ruleset "$type" "$flags" "$elements" "$expr"
+
+	# sanity check, counter must be 0, no parallel set flush/elem add yet.
+	check_counter "$tmp" "$then" || exit 3
+
+	start_ping_flood &
+
+	reload_set "$tmp" "$elements" &
+
+	monitor_counter "$tmp" "$then" &
+
+	wait_for_timeout "$tmp" || return 1
+	wait
+
+	check_counter "$tmp" "$then" || return 1
+
+	local now=$(date +%s)
+	echo "$0 test took $((now-then))s"
+	return 0
+}
diff --git a/tests/shell/testcases/packetpath/dumps/set_flush_add_atomic_bitmap.nodump b/tests/shell/testcases/packetpath/dumps/set_flush_add_atomic_bitmap.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/packetpath/dumps/set_flush_add_atomic_hash.nodump b/tests/shell/testcases/packetpath/dumps/set_flush_add_atomic_hash.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/packetpath/dumps/set_flush_add_atomic_hash_fast.nodump b/tests/shell/testcases/packetpath/dumps/set_flush_add_atomic_hash_fast.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/packetpath/dumps/set_flush_add_atomic_pipapo.nodump b/tests/shell/testcases/packetpath/dumps/set_flush_add_atomic_pipapo.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/packetpath/dumps/set_flush_add_atomic_rbtree.nodump b/tests/shell/testcases/packetpath/dumps/set_flush_add_atomic_rbtree.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/packetpath/dumps/set_flush_add_atomic_rhash.nodump b/tests/shell/testcases/packetpath/dumps/set_flush_add_atomic_rhash.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/packetpath/set_flush_add_atomic_bitmap b/tests/shell/testcases/packetpath/set_flush_add_atomic_bitmap
new file mode 100755
index 000000000000..65fc71fc6d8e
--- /dev/null
+++ b/tests/shell/testcases/packetpath/set_flush_add_atomic_bitmap
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+. $NFT_TEST_BASEDIR/helpers/set_flush_add_atomic_helpers
+
+tmp=$(mktemp)
+
+cleanup()
+{
+	set_flush_add_atomic_cleanup "$tmp"
+}
+
+trap cleanup EXIT
+
+set_flush_add_create_topo "bitmap"
+
+set_flush_add_atomic_run_test "$tmp" "icmp_type" "" "echo-reply, echo-request" "icmp type" || exit 1
+
+exit 0
diff --git a/tests/shell/testcases/packetpath/set_flush_add_atomic_hash b/tests/shell/testcases/packetpath/set_flush_add_atomic_hash
new file mode 100755
index 000000000000..6f14ce10f157
--- /dev/null
+++ b/tests/shell/testcases/packetpath/set_flush_add_atomic_hash
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+. $NFT_TEST_BASEDIR/helpers/set_flush_add_atomic_helpers
+
+tmp=$(mktemp)
+
+cleanup()
+{
+	set_flush_add_atomic_cleanup "$tmp"
+}
+
+trap cleanup EXIT
+
+set_flush_add_create_topo "hash"
+
+set_flush_add_atomic_run_test "$tmp" "ipv4_addr . ipv4_addr" "size 2" "$ip_c . $ip_s, $ip_s . $ip_c" "ip saddr . ip daddr" || exit 1
+
+exit 0
diff --git a/tests/shell/testcases/packetpath/set_flush_add_atomic_hash_fast b/tests/shell/testcases/packetpath/set_flush_add_atomic_hash_fast
new file mode 100755
index 000000000000..12858d876104
--- /dev/null
+++ b/tests/shell/testcases/packetpath/set_flush_add_atomic_hash_fast
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+. $NFT_TEST_BASEDIR/helpers/set_flush_add_atomic_helpers
+
+tmp=$(mktemp)
+
+cleanup()
+{
+	set_flush_add_atomic_cleanup "$tmp"
+}
+
+trap cleanup EXIT
+
+set_flush_add_create_topo "hash_fast"
+
+set_flush_add_atomic_run_test "$tmp" "ipv4_addr" "size 2" "$ip_c, $ip_s" "ip saddr" || exit 1
+
+exit 0
diff --git a/tests/shell/testcases/packetpath/set_flush_add_atomic_pipapo b/tests/shell/testcases/packetpath/set_flush_add_atomic_pipapo
new file mode 100755
index 000000000000..5d6b39f6f614
--- /dev/null
+++ b/tests/shell/testcases/packetpath/set_flush_add_atomic_pipapo
@@ -0,0 +1,20 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_pipapo)
+
+. $NFT_TEST_BASEDIR/helpers/set_flush_add_atomic_helpers
+
+tmp=$(mktemp)
+
+cleanup()
+{
+	set_flush_add_atomic_cleanup "$tmp"
+}
+
+trap cleanup EXIT
+
+set_flush_add_create_topo "pipapo"
+
+set_flush_add_atomic_run_test "$tmp" "ipv4_addr . ipv4_addr" "flags interval" "$ip_c . $ip_s, $ip_s . $ip_c" "ip saddr . ip daddr" || exit 1
+
+exit 0
diff --git a/tests/shell/testcases/packetpath/set_flush_add_atomic_rbtree b/tests/shell/testcases/packetpath/set_flush_add_atomic_rbtree
new file mode 100755
index 000000000000..c5cef3cc6c9e
--- /dev/null
+++ b/tests/shell/testcases/packetpath/set_flush_add_atomic_rbtree
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+. $NFT_TEST_BASEDIR/helpers/set_flush_add_atomic_helpers
+
+tmp=$(mktemp)
+
+cleanup()
+{
+	set_flush_add_atomic_cleanup "$tmp"
+}
+
+trap cleanup EXIT
+
+set_flush_add_create_topo "rbtree"
+
+set_flush_add_atomic_run_test "$tmp" "ipv4_addr" "flags interval" "0.0.0.0-192.168.2.19, 192.168.2.21-255.255.255.255" "ip saddr" || exit 1
+
+exit 0
diff --git a/tests/shell/testcases/packetpath/set_flush_add_atomic_rhash b/tests/shell/testcases/packetpath/set_flush_add_atomic_rhash
new file mode 100755
index 000000000000..185d8e7612dd
--- /dev/null
+++ b/tests/shell/testcases/packetpath/set_flush_add_atomic_rhash
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+. $NFT_TEST_BASEDIR/helpers/set_flush_add_atomic_helpers
+
+tmp=$(mktemp)
+
+cleanup()
+{
+	set_flush_add_atomic_cleanup "$tmp"
+}
+
+trap cleanup EXIT
+
+set_flush_add_create_topo "rhash"
+
+set_flush_add_atomic_run_test "$tmp" "ipv4_addr" "flags dynamic" "$ip_c, $ip_s" "ip saddr" || exit 1
+
+exit 0
-- 
2.49.1

