Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068E51A3BD7
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 09:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747820418; cv=none; b=JR81E31cqeP9H4Bao/P57CH/y+Dp3BuJXAnr2TEalt0x3JxyZc9KidYcl1GwPRPTYamrV3NoP7EAVF0LYXLhJhI12mXBmkDhgbWV227W0/YAyxX5x/oBy5YHnkcL1lYXvyHs7gtZ1H6EvLl/4RKRipKtSyVDMkasw1E97Qwm32k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747820418; c=relaxed/simple;
	bh=Jmul+C0rcByF7WLVSixfWY+5+KaDJUEL07XaMfnptuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxGxYUryyAPudrYaNousvt47KeNua/P+UPTN3Ew9F6M4MImtHWlhiSG5Fv+y97sp2VXpfvan6uMbmnOySsjSEzC5BV5ULPqpBpMv5iDK46w/hRmhk0oS2KIGy+SaNPu3Q/yDuBsERbPaQ2SaA+KRPHQcY7ZK0XgQsO3LOJrMiOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 27A6C602AC; Wed, 21 May 2025 11:40:08 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 1/5] selftests: netfilter: nft_fib.sh: add 'type' mode tests
Date: Wed, 21 May 2025 11:38:45 +0200
Message-ID: <20250521093858.1831-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521093858.1831-1-fw@strlen.de>
References: <20250521093858.1831-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fib can either lookup the interface id/name of the output interface that
would be used for the given address, or it can check for the type of the
address according to the fib, e.g. local, unicast, multicast and so on.

This can be used to e.g. make a locally configured address only reachable
through its interface.

Example: given eth0:10.1.1.1 and eth1:10.1.2.1 then 'fib daddr type' for
10.1.1.1 arriving on eth1 will be 'local', but 'fib daddr . iif type' is
expected to return 'unicast', whereas 'fib daddr' and 'fib daddr . iif'
are expected to indicate 'local' if such a packet arrives on eth0.

So far nft_fib.sh only covered oif/oifname, not type.

Repeat tests both with default and a policy (ip rule) based setup.

Also try to run all remaining tests even if a subtest has failed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nft_fib.sh        | 184 +++++++++++++++++-
 1 file changed, 174 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_fib.sh b/tools/testing/selftests/net/netfilter/nft_fib.sh
index 82780b39277c..4b93e4954536 100755
--- a/tools/testing/selftests/net/netfilter/nft_fib.sh
+++ b/tools/testing/selftests/net/netfilter/nft_fib.sh
@@ -3,6 +3,10 @@
 # This tests the fib expression.
 #
 # Kselftest framework requirement - SKIP code is 4.
+#
+#  10.0.1.99     10.0.1.1           10.0.2.1         10.0.2.99
+# dead:1::99    dead:1::1          dead:2::1        dead:2::99
+# ns1 <-------> [ veth0 ] nsrouter [veth1] <-------> ns2
 
 source lib.sh
 
@@ -72,6 +76,89 @@ table inet filter {
 EOF
 }
 
+load_type_ruleset() {
+	local netns=$1
+
+	for family in ip ip6;do
+ip netns exec "$netns" nft -f /dev/stdin <<EOF
+table $family filter {
+	chain type_match_in {
+		fib daddr type local counter comment "daddr configured on other iface"
+		fib daddr . iif type local counter comment "daddr configured on iif"
+		fib daddr type unicast counter comment "daddr not local"
+		fib daddr . iif type unicast counter comment "daddr not configured on iif"
+	}
+
+	chain type_match_out {
+		fib daddr type unicast counter
+		fib daddr . oif type unicast counter
+		fib daddr type local counter
+		fib daddr . oif type local counter
+	}
+
+	chain prerouting {
+		type filter hook prerouting priority 0;
+		icmp type echo-request counter jump type_match_in
+		icmpv6 type echo-request counter jump type_match_in
+	}
+
+	chain input {
+		type filter hook input priority 0;
+		icmp type echo-request counter jump type_match_in
+		icmpv6 type echo-request counter jump type_match_in
+	}
+
+	chain forward {
+		type filter hook forward priority 0;
+		icmp type echo-request counter jump type_match_in
+		icmpv6 type echo-request counter jump type_match_in
+	}
+
+	chain output {
+		type filter hook output priority 0;
+		icmp type echo-request counter jump type_match_out
+		icmpv6 type echo-request counter jump type_match_out
+	}
+
+	chain postrouting {
+		type filter hook postrouting priority 0;
+		icmp type echo-request counter jump type_match_out
+		icmpv6 type echo-request counter jump type_match_out
+	}
+}
+EOF
+done
+}
+
+reload_type_ruleset() {
+	ip netns exec "$1" nft flush table ip filter
+	ip netns exec "$1" nft flush table ip6 filter
+	load_type_ruleset "$1"
+}
+
+check_fib_type_counter_family() {
+	local family="$1"
+	local want="$2"
+	local ns="$3"
+	local chain="$4"
+	local what="$5"
+	local errmsg="$6"
+
+	if ! ip netns exec "$ns" nft list chain "$family" filter "$chain" | grep "$what" | grep -q "packets $want";then
+		echo "Netns $ns $family fib type counter doesn't match expected packet count of $want for $what $errmsg" 1>&2
+		ip netns exec "$ns" nft list chain "$family" filter "$chain"
+		ret=1
+		return 1
+	fi
+
+	return 0
+}
+
+check_fib_type_counter() {
+	check_fib_type_counter_family "ip" "$@" || return 1
+	check_fib_type_counter_family "ip6" "$@" || return 1
+}
+
 load_ruleset_count() {
 	local netns=$1
 
@@ -90,6 +177,7 @@ check_drops() {
 	if dmesg | grep -q ' nft_rpfilter: ';then
 		dmesg | grep ' nft_rpfilter: '
 		echo "FAIL: rpfilter did drop packets"
+		ret=1
 		return 1
 	fi
 
@@ -164,17 +252,70 @@ test_ping() {
   return 0
 }
 
+test_fib_type() {
+	local notice="$1"
+	local errmsg="addr-on-if"
+	local lret=0
+
+	if ! load_type_ruleset "$nsrouter";then
+		echo "SKIP: Could not load fib type ruleset"
+		[ $ret -eq 0 ] && ret=$ksft_skip
+		return
+	fi
+
+	# makes router receive packet for addresses configured on incoming
+	# interface.
+	test_ping 10.0.1.1 dead:1::1 || return 1
+
+	# expectation: triggers all 'local' in prerouting/input.
+	check_fib_type_counter 2 "$nsrouter" "type_match_in" "fib daddr type local" "$errmsg" || lret=1
+	check_fib_type_counter 2 "$nsrouter" "type_match_in" "fib daddr . iif type local" "$errmsg" || lret=1
+
+	reload_type_ruleset "$nsrouter"
+	# makes router receive packet for address configured on a different (but local)
+	# interface.
+	test_ping 10.0.2.1 dead:2::1 || return 1
+
+	# expectation: triggers 'unicast' in prerouting/input for daddr . iif and local for 'daddr'.
+	errmsg="addr-on-host"
+	check_fib_type_counter 2 "$nsrouter" "type_match_in" "fib daddr type local" "$errmsg" || lret=1
+	check_fib_type_counter 2 "$nsrouter" "type_match_in" "fib daddr . iif type unicast" "$errmsg" || lret=1
+
+	reload_type_ruleset "$nsrouter"
+	test_ping 10.0.2.99 dead:2::99 || return 1
+	errmsg="addr-on-otherhost"
+	check_fib_type_counter 2 "$nsrouter" "type_match_in" "fib daddr type unicast" "$errmsg" || lret=1
+	check_fib_type_counter 2 "$nsrouter" "type_match_in" "fib daddr . iif type unicast" "$errmsg" || lret=1
+
+	if [ $lret -eq 0 ];then
+		echo "PASS: fib expression address types match ($notice)"
+	else
+		echo "FAIL: fib expression address types match ($notice)"
+		ret=1
+	fi
+}
+
 ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
 
 test_ping 10.0.2.1 dead:2::1 || exit 1
-check_drops || exit 1
+check_drops
 
 test_ping 10.0.2.99 dead:2::99 || exit 1
-check_drops || exit 1
+check_drops
 
-echo "PASS: fib expression did not cause unwanted packet drops"
+[ $ret -eq 0 ] && echo "PASS: fib expression did not cause unwanted packet drops"
+
+load_input_ruleset "$ns1"
+
+test_ping 127.0.0.1 ::1
+check_drops
+
+test_ping 10.0.1.99 dead:1::99
+check_drops
+
+[ $ret -eq 0 ] && echo "PASS: fib expression did not discard loopback packets"
 
 load_input_ruleset "$ns1"
 
@@ -234,7 +375,7 @@ ip -net "$nsrouter" addr del dead:2::1/64 dev veth0
 # ... pbr ruleset for the router, check iif+oif.
 if ! load_pbr_ruleset "$nsrouter";then
 	echo "SKIP: Could not load fib forward ruleset"
-	exit $ksft_skip
+	[ "$ret" -eq 0 ] && ret=$ksft_skip
 fi
 
 ip -net "$nsrouter" rule add from all table 128
@@ -245,11 +386,34 @@ ip -net "$nsrouter" route add table 129 to 10.0.2.0/24 dev veth1
 # drop main ipv4 table
 ip -net "$nsrouter" -4 rule delete table main
 
-if ! test_ping 10.0.2.99 dead:2::99;then
-	ip -net "$nsrouter" nft list ruleset
-	echo "FAIL: fib mismatch in pbr setup"
-	exit 1
+if test_ping 10.0.2.99 dead:2::99;then
+	echo "PASS: fib expression forward check with policy based routing"
+else
+	echo "FAIL: fib expression forward check with policy based routing"
+	ret=1
 fi
 
-echo "PASS: fib expression forward check with policy based routing"
-exit 0
+test_fib_type "policy routing"
+ip netns exec "$nsrouter" nft delete table ip filter
+ip netns exec "$nsrouter" nft delete table ip6 filter
+
+# Un-do policy routing changes
+ip -net "$nsrouter" rule del from all table 128
+ip -net "$nsrouter" rule del from all iif veth0 table 129
+
+ip -net "$nsrouter" route del table 128 to 10.0.1.0/24 dev veth0
+ip -net "$nsrouter" route del table 129 to 10.0.2.0/24 dev veth1
+
+ip -net "$ns1" -4 route del default
+ip -net "$ns1" -6 route del default
+
+ip -net "$ns1" -4 route add default via 10.0.1.1
+ip -net "$ns1" -6 route add default via dead:1::1
+
+ip -net "$nsrouter" -4 rule add from all table main priority 32766
+
+test_fib_type "default table"
+ip netns exec "$nsrouter" nft delete table ip filter
+ip netns exec "$nsrouter" nft delete table ip6 filter
+
+exit $ret
-- 
2.49.0

