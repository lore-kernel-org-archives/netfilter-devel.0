Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E34E30C1D2;
	Mon,  5 May 2025 23:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746488529; cv=none; b=kjUkqX4KPc0JAcuH24ksfvVSnr2Vtb7SuFmSPvAMm5ME82IUbX3Sl2y/9Bt/Iu/HrCDGRX3/mVcaCfVSQeK82yvCVYJA3vIjkG2g6K+xv4Bq9fNtFy1/kuk//dZOBx5S8aMPBd1/8uP6y90YHc8JO5+dm5CeLpQ0nIgelqPEVfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746488529; c=relaxed/simple;
	bh=sSfHDqSkIRNH2Zbsua3cxcMbComX9LPnFjKdICJZK+w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QbFUpWGrXgN/A0SNPJ4cEeGsua5CA3s17KrLh4ootza7E3AiaeqLAdrOEx7QlGlqzM82D+Xuw8EzhzRoZjONPRHWIS2qH1WfnbK9800covw5rnPlfh0TsY0+Fnldr3/vnKpnfOrAcuNRb4xTQ3k6zwzR0jC14V1gqX061SH4HXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=W7a83lZf; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NEmIJZJ7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="W7a83lZf";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NEmIJZJ7"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B8E416065F; Tue,  6 May 2025 01:42:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746488525;
	bh=vNMhcfQFarfKWoQcaNGicbi0udp4R34bDbpbvWcM6jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7a83lZfKf+/JyL490D4M2/+PXvU0vCnxlV2yh0ODdFTCWs2+QjbdL/NLNqXN1Z3A
	 4T/1eQtyHv27BQwo2LOYcUIAGVvFm14JgjCBVWMH+5spNdJafUAPezk8tOOU9m21fi
	 8na4g2u2vCQA86S4Gn6CnMJEyUArimy0cAKNInGarw7PmbKy9RLq2FfH8BTMdu3spR
	 NOyC4uoO9MHzWUwRUyQnkdGgbTbzyYhriGQNGXGXJghKE/k5neY7T7jUpADiVV4w++
	 9Uzfjg1O5MbZPdgA8u32Dryav4b5+fmPp/EQduXGLn8ORW2HhebF1iaLP7dhLH/0F2
	 OnjDEMOw09tWw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 720E660658;
	Tue,  6 May 2025 01:41:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746488517;
	bh=vNMhcfQFarfKWoQcaNGicbi0udp4R34bDbpbvWcM6jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEmIJZJ7PLBlGYF50KILGJvk2yCrm5XS5gmPANbyEvR1g7vnnNRvJBiW/R7t46RiP
	 TGA/Wmn1cTPcSCmGA0WYVq9bvLvAXetCkOEk1y2z89YSkSgMLdo7PXpxQ/0AwWrSlP
	 u9zVI9GS2CZGVSB8bWp1mDvBDQUMFlpPuZmgk6CiUKInyJewdNyo7Pk2jHxR1kjAGo
	 xmHfcEWzKKpVl/ASLrd62jLgggqxS/CZAa67NZFzfcCRWrM0Hc/ZmH/rStUfhGzj2K
	 StwTPjHR21oPMtl7+5ebbQUqkkOxstmJ2NF1BTlK11mgU5ka/3SkZE8ZV3EFpZLLeT
	 IZSvCGUP90C/A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH nf-next 2/7] selftests: netfilter: add conntrack stress test
Date: Tue,  6 May 2025 01:41:46 +0200
Message-Id: <20250505234151.228057-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250505234151.228057-1-pablo@netfilter.org>
References: <20250505234151.228057-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Add a new test case to check:
 - conntrack_max limit is effective
 - conntrack_max limit cannot be exceeded from within a netns
 - resizing the hash table while packets are inflight works
 - removal of all conntrack rules disables conntrack in netns
 - conntrack tool dump (conntrack -L) returns expected number
   of (unique) entries
 - procfs interface - if available - has same number of entries
   as conntrack -L dump

Expected output with selftest framework:
 selftests: net/netfilter: conntrack_resize.sh
 PASS: got 1 connections: netns conntrack_max is pernet bound
 PASS: got 100 connections: netns conntrack_max is init_net bound
 PASS: dump in netns had same entry count (-C 1778, -L 1778, -p 1778, /proc 0)
 PASS: dump in netns had same entry count (-C 2000, -L 2000, -p 2000, /proc 0)
 PASS: test parallel conntrack dumps
 PASS: resize+flood
 PASS: got 0 connections: conntrack disabled
 PASS: got 1 connections: conntrack enabled
ok 1 selftests: net/netfilter: conntrack_resize.sh

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 tools/testing/selftests/net/netfilter/config  |   1 +
 .../net/netfilter/conntrack_resize.sh         | 406 ++++++++++++++++++
 3 files changed, 408 insertions(+)
 create mode 100755 tools/testing/selftests/net/netfilter/conntrack_resize.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index ffe161fac8b5..3bdcbbdba925 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -12,6 +12,7 @@ TEST_PROGS += conntrack_dump_flush.sh
 TEST_PROGS += conntrack_icmp_related.sh
 TEST_PROGS += conntrack_ipip_mtu.sh
 TEST_PROGS += conntrack_tcp_unreplied.sh
+TEST_PROGS += conntrack_resize.sh
 TEST_PROGS += conntrack_sctp_collision.sh
 TEST_PROGS += conntrack_vrf.sh
 TEST_PROGS += conntrack_reverse_clash.sh
diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index 43d8b500d391..363646f4fefe 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -46,6 +46,7 @@ CONFIG_NETFILTER_XT_MATCH_STATE=m
 CONFIG_NETFILTER_XT_MATCH_STRING=m
 CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
 CONFIG_NF_CONNTRACK=m
+CONFIG_NF_CONNTRACK_PROCFS=y
 CONFIG_NF_CONNTRACK_EVENTS=y
 CONFIG_NF_CONNTRACK_FTP=m
 CONFIG_NF_CONNTRACK_MARK=y
diff --git a/tools/testing/selftests/net/netfilter/conntrack_resize.sh b/tools/testing/selftests/net/netfilter/conntrack_resize.sh
new file mode 100755
index 000000000000..aabc7c51181e
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/conntrack_resize.sh
@@ -0,0 +1,406 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+source lib.sh
+
+checktool "conntrack --version" "run test without conntrack"
+checktool "nft --version" "run test without nft tool"
+
+init_net_max=0
+ct_buckets=0
+tmpfile=""
+ret=0
+
+modprobe -q nf_conntrack
+if ! sysctl -q net.netfilter.nf_conntrack_max >/dev/null;then
+	echo "SKIP: conntrack sysctls not available"
+	exit $KSFT_SKIP
+fi
+
+init_net_max=$(sysctl -n net.netfilter.nf_conntrack_max) || exit 1
+ct_buckets=$(sysctl -n net.netfilter.nf_conntrack_buckets) || exit 1
+
+cleanup() {
+	cleanup_all_ns
+
+	rm -f "$tmpfile"
+
+	# restore original sysctl setting
+	sysctl -q net.netfilter.nf_conntrack_max=$init_net_max
+	sysctl -q net.netfilter.nf_conntrack_buckets=$ct_buckets
+}
+trap cleanup EXIT
+
+check_max_alias()
+{
+	local expected="$1"
+	# old name, expected to alias to the first, i.e. changing one
+	# changes the other as well.
+	local lv=$(sysctl -n net.nf_conntrack_max)
+
+	if [ $expected -ne "$lv" ];then
+		echo "nf_conntrack_max sysctls should have identical values"
+		exit 1
+	fi
+}
+
+insert_ctnetlink() {
+	local ns="$1"
+	local count="$2"
+	local i=0
+	local bulk=16
+
+	while [ $i -lt $count ] ;do
+		ip netns exec "$ns" bash -c "for i in \$(seq 1 $bulk); do \
+			if ! conntrack -I -s \$((\$RANDOM%256)).\$((\$RANDOM%256)).\$((\$RANDOM%256)).\$((\$RANDOM%255+1)) \
+					  -d \$((\$RANDOM%256)).\$((\$RANDOM%256)).\$((\$RANDOM%256)).\$((\$RANDOM%255+1)) \
+					  --protonum 17 --timeout 120 --status ASSURED,SEEN_REPLY --sport \$RANDOM --dport 53; then \
+					  return;\
+			fi & \
+		done ; wait" 2>/dev/null
+
+		i=$((i+bulk))
+	done
+}
+
+check_ctcount() {
+	local ns="$1"
+	local count="$2"
+	local msg="$3"
+
+	local now=$(ip netns exec "$ns" conntrack -C)
+
+	if [ $now -ne "$count" ] ;then
+		echo "expected $count entries in $ns, not $now: $msg"
+		exit 1
+	fi
+
+	echo "PASS: got $count connections: $msg"
+}
+
+ctresize() {
+	local duration="$1"
+	local now=$(date +%s)
+	local end=$((now + duration))
+
+	while [ $now -lt $end ]; do
+		sysctl -q net.netfilter.nf_conntrack_buckets=$RANDOM
+		now=$(date +%s)
+	done
+}
+
+do_rsleep() {
+	local limit="$1"
+	local r=$RANDOM
+
+	r=$((r%limit))
+	sleep "$r"
+}
+
+ct_flush_once() {
+	local ns="$1"
+
+	ip netns exec "$ns" conntrack -F 2>/dev/null
+}
+
+ctflush() {
+	local ns="$1"
+	local duration="$2"
+	local now=$(date +%s)
+	local end=$((now + duration))
+
+	do_rsleep "$duration"
+
+        while [ $now -lt $end ]; do
+		ct_flush_once "$ns"
+		do_rsleep "$duration"
+		now=$(date +%s)
+        done
+}
+
+ctflood()
+{
+	local ns="$1"
+	local duration="$2"
+	local msg="$3"
+	local now=$(date +%s)
+	local end=$((now + duration))
+	local j=0
+	local k=0
+
+        while [ $now -lt $end ]; do
+		j=$((j%256))
+		k=$((k%256))
+
+		ip netns exec "$ns" bash -c \
+			"j=$j k=$k; for i in \$(seq 1 254); do ping -q -c 1 127.\$k.\$j.\$i & done; wait" >/dev/null 2>&1
+
+		j=$((j+1))
+
+		if [ $j -eq 256 ];then
+			k=$((k+1))
+		fi
+
+		now=$(date +%s)
+	done
+
+	wait
+}
+
+# dump to /dev/null.  We don't want dumps to cause infinite loops
+# or use-after-free even when conntrack table is altered while dumps
+# are in progress.
+ct_nulldump()
+{
+	local ns="$1"
+
+	ip netns exec "$ns" conntrack -L > /dev/null 2>&1 &
+
+	# Don't require /proc support in conntrack
+	if [ -r /proc/self/net/nf_conntrack ] ; then
+		ip netns exec "$ns" bash -c "wc -l < /proc/self/net/nf_conntrack" > /dev/null &
+	fi
+
+	wait
+}
+
+check_taint()
+{
+	local tainted_then="$1"
+	local msg="$2"
+
+	local tainted_now=0
+
+	if [ "$tainted_then" -ne 0 ];then
+		return
+	fi
+
+	read tainted_now < /proc/sys/kernel/tainted
+
+	if [ "$tainted_now" -eq 0 ];then
+		echo "PASS: $msg"
+	else
+		echo "TAINT: $msg"
+		dmesg
+		exit 1
+	fi
+}
+
+insert_flood()
+{
+	local n="$1"
+	local r=0
+
+	r=$((RANDOM%2000))
+
+	ctflood "$n" "$timeout" "floodresize" &
+	insert_ctnetlink "$n" "$r" &
+	ctflush "$n" "$timeout" &
+	ct_nulldump "$n" &
+
+	wait
+}
+
+test_floodresize_all()
+{
+	local timeout=20
+	local n=""
+	local tainted_then=""
+
+	read tainted_then < /proc/sys/kernel/tainted
+
+	for n in "$nsclient1" "$nsclient2";do
+		insert_flood "$n" &
+	done
+
+	# resize table constantly while flood/insert/dump/flushs
+	# are happening in parallel.
+	ctresize "$timeout"
+
+	# wait for subshells to complete, everything is limited
+	# by $timeout.
+	wait
+
+	check_taint "$tainted_then" "resize+flood"
+}
+
+check_dump()
+{
+	local ns="$1"
+	local protoname="$2"
+	local c=0
+	local proto=0
+	local proc=0
+	local unique=""
+
+	c=$(ip netns exec "$ns" conntrack -C)
+
+	# NOTE: assumes timeouts are large enough to not have
+	# expirations in all following tests.
+	l=$(ip netns exec "$ns" conntrack -L 2>/dev/null | tee "$tmpfile" | wc -l)
+
+	if [ "$c" -ne "$l" ]; then
+		echo "FAIL: count inconsistency for $ns: $c != $l"
+		ret=1
+	fi
+
+	# check the dump we retrieved is free of duplicated entries.
+	unique=$(sort "$tmpfile" | uniq | wc -l)
+	if [ "$l" -ne "$unique" ]; then
+		echo "FAIL: count identical but listing contained redundant entries: $l != $unique"
+		ret=1
+	fi
+
+	# we either inserted icmp or only udp, hence, --proto should return same entry count as without filter.
+	proto=$(ip netns exec "$ns" conntrack -L --proto $protoname 2>/dev/null | wc -l)
+	if [ "$l" -ne "$proto" ]; then
+		echo "FAIL: dump inconsistency for $ns: $l != $proto"
+		ret=1
+	fi
+
+	if [ -r /proc/self/net/nf_conntrack ] ; then
+		proc=$(ip netns exec "$ns" bash -c "wc -l < /proc/self/net/nf_conntrack")
+
+		if [ "$l" -ne "$proc" ]; then
+			echo "FAIL: proc inconsistency for $ns: $l != $proc"
+			ret=1
+		fi
+
+		proc=$(ip netns exec "$ns" bash -c "sort < /proc/self/net/nf_conntrack | uniq | wc -l")
+
+		if [ "$l" -ne "$proc" ]; then
+			echo "FAIL: proc inconsistency after uniq filter for $ns: $l != $proc"
+			ret=1
+		fi
+	fi
+
+	echo "PASS: dump in netns had same entry count (-C $c, -L $l, -p $proto, /proc $proc)"
+}
+
+test_dump_all()
+{
+	local timeout=3
+	local tainted_then=""
+
+	read tainted_then < /proc/sys/kernel/tainted
+
+	ct_flush_once "$nsclient1"
+	ct_flush_once "$nsclient2"
+
+	ctflood "$nsclient1" $timeout "dumpall" &
+	insert_ctnetlink "$nsclient2" 2000
+
+	wait
+
+	check_dump "$nsclient1" "icmp"
+	check_dump "$nsclient2" "udp"
+
+	check_taint "$tainted_then" "test parallel conntrack dumps"
+}
+
+check_sysctl_immutable()
+{
+	local ns="$1"
+	local name="$2"
+	local failhard="$3"
+	local o=0
+	local n=0
+
+	o=$(ip netns exec "$ns" sysctl -n "$name" 2>/dev/null)
+	n=$((o+1))
+
+	# return value isn't reliable, need to read it back
+	ip netns exec "$ns" sysctl -q "$name"=$n 2>/dev/null >/dev/null
+
+	n=$(ip netns exec "$ns" sysctl -n "$name" 2>/dev/null)
+
+	[ -z "$n" ] && return 1
+
+	if [ $o -ne $n ]; then
+		if [ $failhard -gt 0 ] ;then
+			echo "FAIL: net.$name should not be changeable from namespace (now $n)"
+			ret=1
+		fi
+		return 0
+	fi
+
+	return 1
+}
+
+test_conntrack_max_limit()
+{
+	sysctl -q net.netfilter.nf_conntrack_max=100
+	insert_ctnetlink "$nsclient1" 101
+
+	# check netns is clamped by init_net, i.e., either netns follows
+	# init_net value, or a higher pernet limit (compared to init_net) is ignored.
+	check_ctcount "$nsclient1" 100 "netns conntrack_max is init_net bound"
+
+	sysctl -q net.netfilter.nf_conntrack_max=$init_net_max
+}
+
+test_conntrack_disable()
+{
+	local timeout=2
+
+	# disable conntrack pickups
+	ip netns exec "$nsclient1" nft flush table ip test_ct
+
+	ct_flush_once "$nsclient1"
+	ct_flush_once "$nsclient2"
+
+	ctflood "$nsclient1" "$timeout" "conntrack disable"
+	ip netns exec "$nsclient2" ping -q -c 1 127.0.0.1 >/dev/null 2>&1
+
+	# Disabled, should not have picked up any connection.
+	check_ctcount "$nsclient1" 0 "conntrack disabled"
+
+	# This one is still active, expect 1 connection.
+	check_ctcount "$nsclient2" 1 "conntrack enabled"
+}
+
+init_net_max=$(sysctl -n net.netfilter.nf_conntrack_max)
+
+check_max_alias $init_net_max
+
+sysctl -q net.netfilter.nf_conntrack_max="262000"
+check_max_alias 262000
+
+setup_ns nsclient1 nsclient2
+
+# check this only works from init_net
+for n in netfilter.nf_conntrack_buckets netfilter.nf_conntrack_expect_max net.nf_conntrack_max;do
+	check_sysctl_immutable "$nsclient1" "net.$n" 1
+done
+
+# won't work on older kernels. If it works, check that the netns obeys the limit
+if check_sysctl_immutable "$nsclient1" net.netfilter.nf_conntrack_max 0;then
+	# subtest: if pernet is changeable, check that reducing it in pernet
+	# limits the pernet entries.  Inverse, pernet clamped by a lower init_net
+	# setting, is already checked by "test_conntrack_max_limit" test.
+
+	ip netns exec "$nsclient1" sysctl -q net.netfilter.nf_conntrack_max=1
+	insert_ctnetlink "$nsclient1" 2
+	check_ctcount "$nsclient1" 1 "netns conntrack_max is pernet bound"
+	ip netns exec "$nsclient1" sysctl -q net.netfilter.nf_conntrack_max=$init_net_max
+fi
+
+for n in "$nsclient1" "$nsclient2";do
+# enable conntrack in both namespaces
+ip netns exec "$n" nft -f - <<EOF
+table ip test_ct {
+	chain input {
+		type filter hook input priority 0
+		ct state new counter
+	}
+}
+EOF
+done
+
+tmpfile=$(mktemp)
+test_conntrack_max_limit
+test_dump_all
+test_floodresize_all
+test_conntrack_disable
+
+exit $ret
-- 
2.30.2

