Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E60927A92D
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Jan 2026 16:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768493212; cv=none; b=fbxL4ITQ5xGR4/+FZpIdQLiyRseOgU/7alm6pZszx/ORuLl1V18UNXbjsx2Hj1/iQBgm0wE1ugRwtPToV1wDwNxjco706EjyF0DdrtiHRuC2Z0/7JAzXnIKCOL/cpA0MKkR5pfnDnxE+JRXeYUblJ/UJFan4u83gnM2BTn2biIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768493212; c=relaxed/simple;
	bh=v4cxjpmoOTS9nseyYIzue42JfJ7qV/0bjKMGAoP0jIw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=id59Az82s/VTZSF7RlKtuNReqZW7ETSvLD2Wu4CQMLEnKpI5QvZ2eIBrA5dCPwMnQLoxvKnepLdWCtIfgVUFYTaupkXdq7jqGRniiqrTmYiHd9o3fvc9SNY+QnPuqGKFyuoFfZTD8t+L/UFa8YhKi2OXm9Uj3lrF612FKKsfuUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 65229606D9; Thu, 15 Jan 2026 17:06:48 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: add small packetpath test for hash and rbtree types
Date: Thu, 15 Jan 2026 17:06:39 +0100
Message-ID: <20260115160641.20953-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add tests to exercise packet path for rbtree and hash set types.
We check both positive (added address is matched) and negative
matches (set doesn't indicate match for deleted address).

For ranges, also validate that addresses preceeding or trailing
a range do not match.

Pipapo has no test to avoid duplicating what is already in
kernel kselftest (nft_concat_range.sh).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/helpers/set_match_nomatch_helpers | 584 ++++++++++++++++++
 .../dumps/set_match_nomatch_hash.nodump       |   0
 .../dumps/set_match_nomatch_hash_fast.nodump  |   0
 .../dumps/set_match_nomatch_rbtree.nodump     |   0
 .../dumps/set_match_nomatch_rhash.nodump      |   0
 .../packetpath/set_match_nomatch_hash         |  14 +
 .../packetpath/set_match_nomatch_hash_fast    |  14 +
 .../packetpath/set_match_nomatch_rbtree       |  14 +
 .../packetpath/set_match_nomatch_rhash        |  14 +
 9 files changed, 640 insertions(+)
 create mode 100644 tests/shell/helpers/set_match_nomatch_helpers
 create mode 100644 tests/shell/testcases/packetpath/dumps/set_match_nomatch_hash.nodump
 create mode 100644 tests/shell/testcases/packetpath/dumps/set_match_nomatch_hash_fast.nodump
 create mode 100644 tests/shell/testcases/packetpath/dumps/set_match_nomatch_rbtree.nodump
 create mode 100644 tests/shell/testcases/packetpath/dumps/set_match_nomatch_rhash.nodump
 create mode 100755 tests/shell/testcases/packetpath/set_match_nomatch_hash
 create mode 100755 tests/shell/testcases/packetpath/set_match_nomatch_hash_fast
 create mode 100755 tests/shell/testcases/packetpath/set_match_nomatch_rbtree
 create mode 100755 tests/shell/testcases/packetpath/set_match_nomatch_rhash

diff --git a/tests/shell/helpers/set_match_nomatch_helpers b/tests/shell/helpers/set_match_nomatch_helpers
new file mode 100644
index 000000000000..35114895c68c
--- /dev/null
+++ b/tests/shell/helpers/set_match_nomatch_helpers
@@ -0,0 +1,584 @@
+# Test skeleton for set (map) matching.
+#
+# Verify both 'match' and 'no match' for control plane
+# and packet path.
+#
+# 1. create random addresses/ranges
+# 2. check address matches via packetpath by validating each elements counter value
+# 3. check we had expected number of hits on global 'match' counter
+# 4. check we had expected number of hits on 'nomatch' counter
+# 5. for ranges, check first and last addresses and a random
+#    addess within the range matches
+# 6. check address preceeding and trailing the range will not match
+# 7. repeat checks with previous addresses after removing / adding
+#    more addresses.
+
+# global variables:
+# R, C (network namespaces).
+# ip_s (server address)
+
+# helpers:
+# set_match_nomatch_cleanup
+# set_match_nomatch_run_test
+
+[ -z "$TIMEOUT" ] && TIMEOUT=30
+
+exit_fatal()
+{
+	echo "Fatal: $@"
+	exit 1
+}
+
+tmpfile=""
+
+set_match_nomatch_cleanup()
+{
+	rm -f "$tmpfile"
+
+	local i
+
+	ip netns exec $R $NFT --debug netlink list ruleset
+
+	for i in $C $R;do
+		kill $(ip netns pid $i) 2>/dev/null
+		ip netns del $i
+	done
+}
+
+load_ruleset()
+{
+	local type="$1"
+	local flags="$2"
+	local expr="$3"
+
+ip netns exec $R $NFT -f - <<EOF
+table ip test {
+  counter match { }
+  counter nomatch { }
+  set s {
+    type $type
+    $flags
+    counter
+  }
+
+  chain c {
+    type filter hook prerouting priority filter; policy accept;
+    $expr @s counter name match accept
+    counter name nomatch
+  }
+}
+EOF
+}
+
+gen_random_address()
+{
+	local a=$(((RANDOM%254) + 1))
+	local b=$((RANDOM%255))
+	local c=$((RANDOM%255))
+	local d=$((RANDOM%255))
+
+	# else client might ping itself
+	[ $a -eq 127 ] && a=128
+
+	if [ $a -eq 192 ] && [ $b -eq 168 ] && [ $c -eq 0 ] && [ $d -eq 1 ] ;then
+		c=1
+	fi
+
+	echo "$a.$b.$c.$d"
+}
+
+gen_random_range()
+{
+	local a=$(((RANDOM%254) + 1))
+	local b=$((RANDOM%255))
+	local c=$((RANDOM%255))
+	local start=$((RANDOM%253))
+	local end=$((RANDOM%255))
+	local count
+
+	# else client might ping itself
+	[ $a -eq 127 ] && a=128
+
+	if [ $a -eq 192 ] && [ $b -eq 168 ] && [ $c -eq 0 ] ;then
+		c=1
+	fi
+
+	if [ $start -eq $end ];then
+		end=$((end+1))
+	fi
+
+	if [ $start -gt $end ]; then
+		local x=$start
+
+		start=$end
+		end=$x
+	fi
+
+	count=$((end-start))
+	echo "$a.$b.$c.$start-$a.$b.$c.$end"
+}
+
+gen_random_ranges()
+{
+	local count="$1"
+	local ranges=" "
+
+	while [ $count -gt 0 ];do
+		local r=$(gen_random_range)
+		local needle="${r%-*}"
+		needle=" ${needle%\.*}."
+		local match="${ranges%%*$needle*}"
+
+		count=$((count-1))
+
+		# We don't want overlaps.
+		[ -z "$match" ] && continue
+
+		ranges="$r $ranges"
+	done
+
+	echo "$ranges"
+}
+
+create_topo()
+{
+	local test="$1"
+	local ip_c=192.168.0.1
+	local ip_r1=192.168.0.2
+	local ip_r2=192.168.1.1
+	local ip_rr=192.168.1.99
+
+	rnd=$(mktemp -u XXXXXXXX)
+	C="$test-client-$rnd"
+	R="$test-router-$rnd"
+
+	ip netns add $R
+	ip netns add $C
+
+	ip link add veth0 netns $C type veth peer name rc netns $R
+	ip -net $C link set veth0 up
+
+	ip -net $R link add dummy0 type dummy
+	ip -net $R link set dummy0 up
+
+	ip -net $R link set rc up
+	ip -net $C link set lo up
+	ip -net $R link set lo up
+
+	for n in $R $C;do
+		ip netns exec $n sysctl -q net.ipv4.conf.all.rp_filter=0
+	done
+
+	ip netns exec $R sysctl -q net.ipv4.ip_forward=1
+
+	ip -net $C addr add ${ip_c}/24 dev veth0
+	ip -net $R addr add ${ip_r1}/24 dev rc
+	ip -net $R addr add ${ip_r2}/24 dev dummy0
+
+	ip -net $C route add default via ${ip_r1} dev veth0
+	ip -net $R route add default via ${ip_rr} dev dummy0
+
+	ip netns exec $C ping -q -c 1 -i 0.1 ${ip_r1} || exit 2
+	ip netns exec $C ping -q -c 1 -i 0.1 ${ip_r2} || exit 3
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
+# addresses were added, matches expected
+test_match()
+{
+	local type="$1"
+	local psent=0
+	local addrs_notsent=""
+	local addrs_sent=""
+
+	local cnt_matched=0
+	local cnt_unmatched=0
+	local ip
+
+	shift
+
+	local addresses="$@"
+	for ip in $addresses; do
+		local r=$((RANDOM%2))
+
+		if [ $r -eq 0 ];then
+			ip netns exec $C ping -q -W 0.001 -c 1 $ip >/dev/null &
+			addrs_sent="$addrs_sent $ip"
+			psent=$((psent+1))
+		else
+			addrs_notsent="$addrs_notsent $ip"
+		fi
+	done
+
+	wait
+
+	for ip in $addrs_sent; do
+		local elem="$ip"
+
+		[ "$type" = "hash" ] && elem="\"rc\" . $ip"
+
+		echo > "$tmpfile"
+		ip netns exec $R $NFT reset element ip test s { $elem } > "$tmpfile" || exit_fatal "Cannot fetch element \"$elem\""
+
+		if grep -q 'counter packets 1 ' "$tmpfile"; then
+			cnt_matched=$((cnt_matched+1))
+		else
+			cat "$tmpfile"
+			exit_fatal "Expected matched element \"$elem\" with 1 matched packet"
+		fi
+	done
+
+	for ip in $addrs_notsent; do
+		local elem="$ip"
+
+		[ "$type" = "hash" ] && elem="\"rc\" . $ip"
+
+		if ip netns exec $R $NFT get element ip test s { $elem } | grep -q 'counter packets 0'; then
+			cnt_unmatched=$((cnt_unmatched+1))
+		else
+			ip netns exec "$R" $NFT get element ip test s { $elem }
+			exit_fatal "Expected element with counter 0"
+		fi
+	done
+
+	if ip netns exec "$R" $NFT list counter ip test match | grep -q "packets $psent"; then
+		echo "Checked $cnt_matched addresses have matching counter and $cnt_unmatched addresses exist in set with packet counter 0"
+		ip netns exec "$R" $NFT reset counter ip test match
+		ip netns exec "$R" $NFT list counter ip test nomatch | grep -q 'packets 0' && return
+	fi
+
+	exit_fatal "match counter should have $psent packets, nomatch counter should be 0"
+}
+
+test_match_rnd()
+{
+	local type="$1"
+	local addrs=""
+	local a=""
+
+	shift
+
+	for a in $@;do
+		local r=$((RANDOM%8))
+
+		[ $r -ne 0 ] && continue
+
+		addrs="$a $addrs"
+	done
+
+	test_match "$type" $addrs
+}
+
+# addresses were never added, no matches expected
+test_nomatch()
+{
+	local addrs_notsent=""
+	local addrs_sent=""
+
+	local psent=0
+	local ip
+
+	for ip in $@; do
+		ip netns exec $C ping -q -W 0.001 -c 1 $ip >/dev/null &
+		psent=$((psent+1))
+	done
+
+	wait
+
+	[ "$psent" -eq 0 ] && exit_fatal "empty nomatch list"
+
+	if ip netns exec "$R" $NFT list set ip test s | grep -q 'counter packets 1' ; then
+		ip netns exec "$R" $NFT list set ip test s
+		exit_fatal "Unexpected entry listed as matching"
+	fi
+
+	if ip netns exec "$R" $NFT list counter ip test nomatch | grep -q "packets $psent"; then
+		echo "Checked $psent addresses don't match entries in the set"
+		ip netns exec "$R" $NFT reset counter ip test nomatch
+		return
+	fi
+
+	exit_fatal "nomatch counter has unexpected packet count, expected $psent"
+}
+
+test_match_ranges()
+{
+	local first_addrs=""
+	local last_addrs=""
+	local rnd_addrs=""
+	local bad_addrs=""
+	local r
+
+	for r in $@;do
+		local first="${r%-*}"
+		local last="${r#*-}"
+		local a="${first##*\.}"
+		local b="${last##*\.}"
+		local prefix="${first%\.*}"
+		local cnt=$((b-a))
+		local d=$(((RANDOM%cnt)+a))
+
+		first_addrs="$first $first_addrs"
+		last_addrs="$last $last_addrs"
+		rnd_addrs="$prefix.$d $rnd_addrs"
+
+		local bad
+
+		if [ $a -gt 0 ];then
+			bad="$prefix.$((a-1))"
+			bad_addrs="$bad $bad_addrs"
+		fi
+		if [ $b -lt 255 ];then
+			bad="$prefix.$((b+1))"
+			bad_addrs="$bad $bad_addrs"
+		fi
+	done
+
+	echo Validate: range start
+	test_match "rbtree" $first_addrs
+	echo Validate: range end
+	test_match "rbtree" $last_addrs
+	echo Validate: random address within range
+	test_match "rbtree" $rnd_addrs
+
+	echo Validate addresses outside range
+	test_nomatch $bad_addrs
+}
+
+test_match_ranges_rnd()
+{
+	local ranges=""
+	local r
+
+	for r in $@;do
+		local rnd=$((RANDOM%2))
+
+		[ $rnd -ne 0 ] && continue
+
+		ranges="$r $ranges"
+	done
+
+	test_match_ranges $ranges
+}
+
+test_nomatch_ranges()
+{
+	local first_addrs=""
+	local last_addrs=""
+	local rnd_addrs=""
+	local r
+
+	echo "Testing deleted ranges"
+
+	for r in $@;do
+		local first="${r%-*}"
+		local last="${r#*-}"
+		local a="${first##*\.}"
+		local b="${last##*\.}"
+		local prefix="${first%\.*}"
+		local cnt=$((b-a))
+		local d=$(((RANDOM%cnt)+a))
+
+		first_addrs="$first $first_addrs"
+		last_addrs="$last $last_addrs"
+		rnd_addrs="$prefix.$d $rnd_addrs"
+	done
+
+	test_nomatch $first_addrs
+	test_nomatch $last_addrs
+	test_nomatch $rnd_addrs
+}
+
+add_to_set()
+{
+	local type="$1"
+	shift
+	local batch_add=""
+	local a
+
+	for a in $@; do
+		local elem="$a"
+
+		[ "$type" = "hash" ] && elem="\"rc\" . $a"
+
+		batch_add="$batch_add $elem, "
+	done
+
+	ip netns exec "$R" $NFT add element ip test s { $batch_add } || exit_fatal "cannot add elements"
+}
+
+del_from_set()
+{
+	local type="$1"
+	local elem="$2"
+
+	[ "$type" = "hash" ] && elem="\"rc\" . $2"
+
+	ip netns exec "$R" $NFT delete element ip test s { $elem } || exit_fatal "cannot delete element"
+	echo "Removed element \"$elem\" from set"
+}
+
+do_test_run_rbtree()
+{
+	local naddrs="$1"
+	local batch=$(((RANDOM%64) + 1))
+	local all_deleted_ranges=""
+	local all_added_ranges=""
+	local batch_ranges=""
+	local i=0
+
+	local ranges=$(gen_random_ranges $naddrs)
+
+	for r in $ranges; do
+		local rnd=$((RANDOM%2))
+		local del=""
+
+		i=$((i+1))
+
+		if [ $i -le $batch ]; then
+			batch_ranges="$batch_ranges $r"
+			continue
+		fi
+
+		if [ $rnd -eq 0 ]; then
+			del="$r"
+			all_deleted_ranges="$all_deleted_ranges $del"
+		fi
+
+		if [ -z "$batch_ranges " ]; then
+			exit_fatal "nothing to add for $i  atch $batch"
+		fi
+
+		add_to_set "rbtree" $batch_ranges $del
+		test_match_ranges $batch_ranges
+
+		# repeat with a few previously added ranges, to make
+		# sure set changes (e.g. rebalance) won't hide existing ranges.
+		all_added_ranges="$all_added_ranges $batch_ranges"
+		test_match_ranges_rnd $all_added_ranges $del
+
+		batch=$(((RANDOM%64) + 1))
+		batch_ranges=""
+		i=0
+
+		if [ ! -z "$del" ];then
+			del_from_set "rbtree" $del
+			del=""
+		fi
+	done
+
+	[ -z "$all_deleted_ranges" ] || test_nomatch_ranges $all_deleted_ranges
+
+	if ip netns exec "$R" $NFT list set ip test s | grep -q 'counter packets 1' ; then
+		ip netns exec "$R" $NFT list set ip test s
+		exit_fatal "Unexpected entry flagged as matched"
+	fi
+}
+
+do_test_run()
+{
+	local type="$1"
+
+	local addrs=$(((RANDOM%257)+64))
+
+	if [ "$type" = "rbtree" ]; then
+		do_test_run_rbtree $addrs
+		return
+	fi
+
+	local batch=$(((RANDOM%64) + 1))
+	local all_deleted_addrs=""
+	local batch_addrs=""
+	local all_addrs=" "
+	local i=0
+
+	while [	$addrs -gt 0 ];do
+		local a=$(gen_random_address)
+		local rnd=$((RANDOM%2))
+		local del=""
+
+		local needle=" $a"
+		local match="${all_addrs%%*$needle*}"
+
+		addrs=$((addrs-1))
+
+		[ -z "$match" ] && continue
+
+		i=$((i+1))
+
+		if [ $i -le $batch ]; then
+			batch_addrs="$batch_addrs $a"
+			continue
+		fi
+
+		if [ $rnd -eq 0 ]; then
+			del="$a"
+			all_deleted_addrs="$all_deleted_addrs $del"
+		else
+			batch_addrs="$batch_addrs $a"
+		fi
+
+		all_addrs="$all_addrs $batch_addrs"
+		add_to_set "$type" $batch_addrs $del
+
+		echo "Validate: newly added addresses"
+		test_match "$type" $batch_addrs $del
+
+		# repeat with a few previously added addresses, this to make
+		# sure set changes (e.g. hash resize) won't hide existing addresses.
+		echo "Validate: any added addresses"
+		test_match_rnd "$type" $all_addrs $del
+
+		batch=$(((RANDOM%64) + 1))
+		batch_addrs=""
+		i=0
+
+		[ -z "$del" ] || del_from_set "$type" $del
+		del=""
+	done
+
+	echo "Validate: non-matching"
+	[ -z "$all_deleted_addrs" ] || test_nomatch $all_deleted_addrs
+
+	if ip netns exec "$R" $NFT list set ip test s | grep -q 'counter packets 1' ; then
+		ip netns exec "$R" $NFT list set ip test s
+		exit_fatal "Unexpected entry flagged as matched"
+	fi
+}
+
+set_match_nomatch_run_test()
+{
+	local settype="$1"
+	local type="$2"
+	local flags="$3"
+	local expr="$4"
+
+	create_topo "$settype"
+
+	local then=$(date +%s)
+
+	load_ruleset "$type" "$flags" "$expr"
+
+	tmpfile=$(mktemp)
+	do_test_run "$settype"
+
+	local now=$(date +%s)
+	echo "$0 test took $((now-then))s"
+	return 0
+}
diff --git a/tests/shell/testcases/packetpath/dumps/set_match_nomatch_hash.nodump b/tests/shell/testcases/packetpath/dumps/set_match_nomatch_hash.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/packetpath/dumps/set_match_nomatch_hash_fast.nodump b/tests/shell/testcases/packetpath/dumps/set_match_nomatch_hash_fast.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/packetpath/dumps/set_match_nomatch_rbtree.nodump b/tests/shell/testcases/packetpath/dumps/set_match_nomatch_rbtree.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/packetpath/dumps/set_match_nomatch_rhash.nodump b/tests/shell/testcases/packetpath/dumps/set_match_nomatch_rhash.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/packetpath/set_match_nomatch_hash b/tests/shell/testcases/packetpath/set_match_nomatch_hash
new file mode 100755
index 000000000000..f6cbf3542ceb
--- /dev/null
+++ b/tests/shell/testcases/packetpath/set_match_nomatch_hash
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+. $NFT_TEST_BASEDIR/helpers/set_match_nomatch_helpers
+
+cleanup()
+{
+	set_match_nomatch_cleanup
+}
+
+trap cleanup EXIT
+
+set_match_nomatch_run_test "hash" "ifname . ipv4_addr" "size 16536" "meta iifname . ip daddr" || exit 1
+
+exit 0
diff --git a/tests/shell/testcases/packetpath/set_match_nomatch_hash_fast b/tests/shell/testcases/packetpath/set_match_nomatch_hash_fast
new file mode 100755
index 000000000000..dca6f5196fb3
--- /dev/null
+++ b/tests/shell/testcases/packetpath/set_match_nomatch_hash_fast
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+. $NFT_TEST_BASEDIR/helpers/set_match_nomatch_helpers
+
+cleanup()
+{
+	set_match_nomatch_cleanup
+}
+
+trap cleanup EXIT
+
+set_match_nomatch_run_test "hash_fast" "ipv4_addr" "size 16536" "ip daddr" || exit 1
+
+exit 0
diff --git a/tests/shell/testcases/packetpath/set_match_nomatch_rbtree b/tests/shell/testcases/packetpath/set_match_nomatch_rbtree
new file mode 100755
index 000000000000..c8965d89b97b
--- /dev/null
+++ b/tests/shell/testcases/packetpath/set_match_nomatch_rbtree
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+. $NFT_TEST_BASEDIR/helpers/set_match_nomatch_helpers
+
+cleanup()
+{
+	set_match_nomatch_cleanup
+}
+
+trap cleanup EXIT
+
+set_match_nomatch_run_test "rbtree" "ipv4_addr" "flags interval" "ip daddr" || exit 1
+
+exit 0
diff --git a/tests/shell/testcases/packetpath/set_match_nomatch_rhash b/tests/shell/testcases/packetpath/set_match_nomatch_rhash
new file mode 100755
index 000000000000..fe655b05818c
--- /dev/null
+++ b/tests/shell/testcases/packetpath/set_match_nomatch_rhash
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+. $NFT_TEST_BASEDIR/helpers/set_match_nomatch_helpers
+
+cleanup()
+{
+	set_match_nomatch_cleanup
+}
+
+trap cleanup EXIT
+
+set_match_nomatch_run_test "rhash" "ipv4_addr" "" "ip daddr" || exit 1
+
+exit 0
-- 
2.52.0

