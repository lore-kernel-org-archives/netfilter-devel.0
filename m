Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83131EA7DB
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Mar 2025 09:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741944525; cv=none; b=ZBJSZQQFzmfKBmE55P4LpL1FKCNTYEDzC4c63H631Ms4dV5Ozxd3MnKDKGHltIZrEED8pVE4JeoFbvzk9Ci1a/AGFnLIVexg88gb/gGNVImHdFbQNydL176Xk3RdmQ0Q3fi/M1q1Ix1X6CltV+sMOKKVFlR1ateFtCdadlWwWgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741944525; c=relaxed/simple;
	bh=01taXzVYQWabsDA0tAj7jN/IvJG5d/cMnoYMhkIU8rc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qR8DEaIm8YfQyZrkziH+e634saygPIVjr+qlVxmm4l6on2dM9jIg/3pMli6G+Yx2dNEkT1hnNjtstug6YZYJfQmBYhvGvxjffSOVlO0lcnjhPlyC0/0rbIdZiP1wAA2xepkbAKsNnuIzJnS2+NhB8MQWsExT4jsGhWuFzq094Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sAQOAR5B; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sAQOAR5B"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5e5edf8a509so1848010a12.1
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Mar 2025 02:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741944522; x=1742549322; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KeJba4QlEphc5+bR+eUOqsZFiPoLFzkxc7ZgbTwrgHc=;
        b=sAQOAR5B9RInhnPURFqP90A1ai7c7LKZBDaJmESPhh6JwINuXiJuJPvdeHqjwyDPOn
         xiE131H95ipfH1TiUIHMJvaIHvhyiK0XD0sd4a0lw/mxCNNlbTzaXFf+ig3D9IJ91rN0
         1B8b1ch45BahGfNKgGsqPWzjBEwt8gK8ddNENDv9uPQ1ChDLHpnJuE/LnhEiuR991nd+
         mAFhRjEVuI0WjCVyW73dgytKd5oKnFvhwwMGToT4DzWJYpSFxNVKHpTgjEm3T1Sqregy
         3Aw6arW2kXr3Igz5+1whyxTV6Somi1pb0sNxxJng11ODf9V7Lwep4ilVi+edK1SCIEKP
         6ntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741944522; x=1742549322;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KeJba4QlEphc5+bR+eUOqsZFiPoLFzkxc7ZgbTwrgHc=;
        b=cBNIB6/lvYUgyEhciAp0ueO6jm1HBA4bMuqaS0jf0W31M6gsOFwg5RHpIiR77zgqYF
         7p3VaGynXwM79IFoL4dBMvaVdf7CFcDCkb6R2jDQYnwLtRH8ElcxmCJk06FrOz9bgzxv
         5Z1rMKCRxcQN6P5yNycLfWhTZbrm9v64mSsZIPlO2Xd/99CGGlt3ezSxUD4r5kWFR7n1
         MQowK8h0WGuFOCmQK2A8j5gT9yaduRzi5hzFs2HPmlSvbWUcjixyLXvD0RUNrGqBQHtD
         Go4k0olLA3tJzCvYI1hCzBJN76yAn24Cx0zNES61+/sm0cwBIhDVENbIdo8YoWCYgvLx
         3Zkg==
X-Forwarded-Encrypted: i=1; AJvYcCUJWc8HlZ6iWJ+L0Z66CK9m1nRdfEwN4BeQpGbKPAHIW7nQxg1llehXOwlv8HQefrjGK1YQp33RS1hAORsdJWQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAUXJ0Q5ONXUbaVIsdbp6E4LfNqBYQrGyatJwgsigc+11U1Dgr
	45Kh5sdn/Foa/6yGeEH3i3pxnDqVwBNNEFa+P92UBVz3pbH8SnnEndp92+/L1P361ziG2Ktlpw=
	=
X-Google-Smtp-Source: AGHT+IGP5hc7am+QvFYcstPb5ea3qY9uSnsy4/WlpyUSxZfTPUEUEOqyZdvJ7t7QN1jRFDrvMoWDqRxfLg==
X-Received: from edbfd5.prod.google.com ([2002:a05:6402:3885:b0:5e4:9866:2778])
 (user=aojea job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:1d4e:b0:5e4:9348:72c3
 with SMTP id 4fb4d7f45d1cf-5e89fa29a7amr1507109a12.10.1741944522195; Fri, 14
 Mar 2025 02:28:42 -0700 (PDT)
Date: Fri, 14 Mar 2025 09:28:37 +0000
In-Reply-To: <20250313231341.3040002-1-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250313231341.3040002-1-aojea@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250314092837.3381916-1-aojea@google.com>
Subject: [PATCH v2] selftests: netfilter: conntrack respect reject rules
From: Antonio Ojea <aojea@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org, 
	Antonio Ojea <aojea@google.com>
Content-Type: text/plain; charset="UTF-8"

This test ensures that conntrack correctly applies reject rules to
established connections after DNAT, even when those connections are
persistent.

The test sets up three network namespaces: ns1, ns2, and nsrouter.
nsrouter acts as a router with DNAT, exposing a service running in ns2
via a virtual IP.

The test validates that is possible to filter and reject new and
established connections to the DNATed IP in the prerouting and forward
filters.

Signed-off-by: Antonio Ojea <aojea@google.com>
---
V1 -> V2:
* Modified the test function to accept a third argument which contains
  the nftables rules to be applied.

* Add a new test case to filter and reject in the prerouting hook.
---
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 tools/testing/selftests/net/netfilter/config  |   1 +
 .../nft_conntrack_reject_established.sh       | 294 ++++++++++++++++++
 3 files changed, 296 insertions(+)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_conntrack_reject_established.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index ffe161fac8b5..c276b8ac2383 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -21,6 +21,7 @@ TEST_PROGS += nf_nat_edemux.sh
 TEST_PROGS += nft_audit.sh
 TEST_PROGS += nft_concat_range.sh
 TEST_PROGS += nft_conntrack_helper.sh
+TEST_PROGS += nft_conntrack_reject_established.sh
 TEST_PROGS += nft_fib.sh
 TEST_PROGS += nft_flowtable.sh
 TEST_PROGS += nft_meta.sh
diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index 43d8b500d391..44ed1a7eb0b5 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -81,6 +81,7 @@ CONFIG_NFT_NUMGEN=m
 CONFIG_NFT_QUEUE=m
 CONFIG_NFT_QUOTA=m
 CONFIG_NFT_REDIR=m
+CONFIG_NFT_REJECT=m
 CONFIG_NFT_SYNPROXY=m
 CONFIG_NFT_TPROXY=m
 CONFIG_VETH=m
diff --git a/tools/testing/selftests/net/netfilter/nft_conntrack_reject_established.sh b/tools/testing/selftests/net/netfilter/nft_conntrack_reject_established.sh
new file mode 100755
index 000000000000..69a5d426991f
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nft_conntrack_reject_established.sh
@@ -0,0 +1,294 @@
+#!/bin/bash
+#
+# This tests conntrack on the following scenario:
+#
+#                         +------------+
+# +-------+               |  nsrouter  |                  +-------+
+# |ns1    |.99          .1|            |.1             .99|    ns2|
+# |   eth0|---------------|veth0  veth1|------------------|eth0   |
+# |       |  10.0.1.0/24  |            |   10.0.2.0/24    |       |
+# +-------+  dead:1::/64  |    veth2   |   dead:2::/64    +-------+
+#                         +------------+
+#
+# nsrouters implement loadbalancing using DNAT with a virtual IP
+# 10.0.4.10 - dead:4::a
+# shellcheck disable=SC2162,SC2317
+
+source lib.sh
+ret=0
+
+timeout=15
+
+cleanup()
+{
+	ip netns pids "$ns1" | xargs kill 2>/dev/null
+	ip netns pids "$ns2" | xargs kill 2>/dev/null
+	ip netns pids "$nsrouter" | xargs kill 2>/dev/null
+
+	cleanup_all_ns
+}
+
+checktool "nft --version" "test without nft tool"
+checktool "socat -h" "run test without socat"
+
+trap cleanup EXIT
+setup_ns ns1 ns2 nsrouter
+
+if ! ip link add veth0 netns "$nsrouter" type veth peer name eth0 netns "$ns1" > /dev/null 2>&1; then
+    echo "SKIP: No virtual ethernet pair device support in kernel"
+    exit $ksft_skip
+fi
+ip link add veth1 netns "$nsrouter" type veth peer name eth0 netns "$ns2"
+
+ip -net "$nsrouter" link set veth0 up
+ip -net "$nsrouter" addr add 10.0.1.1/24 dev veth0
+ip -net "$nsrouter" addr add dead:1::1/64 dev veth0 nodad
+
+ip -net "$nsrouter" link set veth1 up
+ip -net "$nsrouter" addr add 10.0.2.1/24 dev veth1
+ip -net "$nsrouter" addr add dead:2::1/64 dev veth1 nodad
+
+
+ip -net "$ns1" link set eth0 up
+ip -net "$ns2" link set eth0 up
+
+ip -net "$ns1" addr add 10.0.1.99/24 dev eth0
+ip -net "$ns1" addr add dead:1::99/64 dev eth0 nodad
+ip -net "$ns1" route add default via 10.0.1.1
+ip -net "$ns1" route add default via dead:1::1
+
+ip -net "$ns2" addr add 10.0.2.99/24 dev eth0
+ip -net "$ns2" addr add dead:2::99/64 dev eth0 nodad
+ip -net "$ns2" route add default via 10.0.2.1
+ip -net "$ns2" route add default via dead:2::1
+
+
+ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
+ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
+ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+
+test_ping() {
+  if ! ip netns exec "$ns1" ping -c 1 -q 10.0.2.99 > /dev/null; then
+	return 1
+  fi
+
+  if ! ip netns exec "$ns1" ping -c 1 -q dead:2::99 > /dev/null; then
+	return 2
+  fi
+
+  return 0
+}
+
+test_ping_router() {
+  if ! ip netns exec "$ns1" ping -c 1 -q 10.0.2.1 > /dev/null; then
+	return 3
+  fi
+
+  if ! ip netns exec "$ns1" ping -c 1 -q dead:2::1 > /dev/null; then
+	return 4
+  fi
+
+  return 0
+}
+
+
+listener_ready()
+{
+	local ns="$1"
+	local port="$2"
+	local proto="$3"
+	ss -N "$ns" -ln "$proto" -o "sport = :$port" | grep -q "$port"
+}
+
+test_conntrack_reject_established()
+{
+	local ip_proto="$1"
+	local testname="$2-$ip_proto"
+	local test_rules="$3"
+	# derived variables
+	local socat_ipproto
+	local vip
+	local vip_ip_port
+	local ns2_ip
+	local ns2_ip_port
+
+	# socat 1.8.0 has a bug that requires to specify the IP family to bind (fixed in 1.8.0.1)
+	case $ip_proto in
+	"ip")
+		socat_ipproto="-4"
+		vip=10.0.4.10
+		ns2_ip=10.0.2.99
+		vip_ip_port="$vip:8080"
+		ns2_ip_port="$ns2_ip:8080"
+	;;
+	"ip6")
+		socat_ipproto="-6"
+		vip=dead:4::a
+		ns2_ip=dead:2::99
+		vip_ip_port="[$vip]:8080"
+		ns2_ip_port="[$ns2_ip]:8080"
+	;;
+	*)
+	echo "FAIL: unsupported protocol"
+	exit 255
+	;;
+	esac
+
+	# nsroute expose ns2 server in a virtual IP using DNAT
+	ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
+flush ruleset
+table inet nat {
+	chain kube-proxy {
+		type nat hook prerouting priority 0; policy accept;
+		$ip_proto daddr $vip tcp dport 8080 dnat to $ns2_ip_port
+	}
+}
+EOF
+
+	TMPFILEIN=$(mktemp)
+	TMPFILEOUT=$(mktemp)
+	# set up a server in ns2
+	timeout "$timeout" ip netns exec "$ns2" socat -u "$socat_ipproto" tcp-listen:8080,fork STDIO > "$TMPFILEOUT" 2> /dev/null &
+	local server2_pid=$!
+
+	busywait "$BUSYWAIT_TIMEOUT" listener_ready "$ns2" 8080 "-t"
+
+	local result
+	# request from ns1 to ns2 (direct traffic) must work
+	if ! echo PING1 | ip netns exec "$ns1" socat -t 2 -T 2 -u STDIO tcp:"$ns2_ip_port" 2> /dev/null ; then
+		echo "ERROR: $testname: fail to connect to $ns2_ip_port"
+		ret=1
+	fi
+	result=$( tail -n 1 "$TMPFILEOUT" )
+	if [ "$result" == "PING1" ] ;then
+		echo "PASS: $testname: ns1 got reply \"$result\" connecting to ns2"
+	else
+		echo "ERROR: $testname: ns1 got reply \"$result\" connecting to ns2, not \"PING1\" as intended"
+		ret=1
+	fi
+
+	# set up a persistent connection through DNAT to ns2
+	timeout "$timeout" tail -f $TMPFILEIN | ip netns exec "$ns1" socat STDIO tcp:"$vip_ip_port,sourceport=12345" 2> /dev/null &
+	local client1_pid=$!
+
+	# request from ns1 to vip (DNAT to ns2) on an existing connection
+	# if we don't read from the pipe the traffic loops forever
+	echo PING2 >> "$TMPFILEIN"
+	sleep 0.5
+	result=$( tail -n 1 "$TMPFILEOUT" )
+	if [ "$result" = "PING2" ] ;then
+		echo "PASS: $testname: ns1 got reply \"$result\" connecting to vip using persistent connection"
+	else
+		echo "ERROR: $testname: ns1 got reply \"$result\" connecting to vip using persistent connection, not \"PING2\" as intended"
+		ret=1
+	fi
+
+	# request from ns1 to vip (DNAT to ns2)
+	if ! echo PING3 | ip netns exec "$ns1" socat -t 2 -T 2 -u STDIO tcp:"$vip_ip_port" 2> /dev/null; then
+		echo "ERROR: $testname: fail to connect to $vip_ip_port"
+		ret=1
+	fi
+	result=$( tail -n 1 "$TMPFILEOUT" )
+	if [ "$result" == "PING3" ] ;then
+		echo "PASS: $testname: ns1 got reply \"$result\" connecting to vip"
+	else
+		echo "ERROR: $testname: ns1 got reply \"$result\" connecting to vip, not \"PING3\" as intended"
+		ret=1
+	fi
+
+	# request from ns1 to vip (DNAT to ns2) on an existing connection
+	echo PING4 >> "$TMPFILEIN"
+	sleep 0.5
+	result=$( tail -n 1 "$TMPFILEOUT" )
+	if [ "$result" = "PING4" ] ;then
+		echo "PASS: $testname: ns1 got reply \"$result\" connecting to vip using persistent connection"
+	else
+		echo "ERROR: $testname: ns1 got reply \"$result\" connecting to vip using persistent connection, not \"PING4\" as intended"
+		ret=1
+	fi
+
+	# add a rule to filter traffic to ns2 ip and port (after DNAT)
+	eval "echo \"$test_rules\"" | ip netns exec "$nsrouter" nft -f /dev/stdin
+
+	# request from ns1 to ns2 (direct traffic) must work
+	if ! echo PING5 | ip netns exec "$ns1" socat -t 2 -T 2 -u STDIO tcp:"$ns2_ip_port" ; then
+		echo "ERROR: $testname: fail to connect to $ns2_ip_port directly"
+		ret=1
+	fi
+	result=$( tail -n 1 "$TMPFILEOUT" )
+	if [ "$result" == "PING5" ] ;then
+		echo "PASS: $testname: ns1 got reply \"$result\" connecting to ns2"
+	else
+		echo "ERROR: $testname: ns1 got reply \"$result\" connecting to ns2, not \"PING5\" as intended"
+		ret=1
+	fi
+
+	# request from ns1 to vip (DNAT to ns2)
+	if ! echo PING6 | ip netns exec "$ns1" socat -t 2 -T 2 -u STDIO tcp:"$vip_ip_port" 2> /dev/null ; then
+		echo "PASS: $testname: ns1 connection to vip is closed (ns2)"
+	else
+		echo "ERROR: $testname: ns1 got reply \"$result\" connecting to vip, not \"Connection refused\" as intended"
+		ret=1
+	fi
+
+	# request from ns1 to vip (DNAT to ns2) on an existing connection
+	echo -e "PING7" >> "$TMPFILEIN"
+	sleep 0.5
+	result=$( tail -n 1 "$TMPFILEOUT" )
+	if [ "$result" == "PING5" ] ; then
+		echo "PASS: $testname: ns1 got no response"
+	else
+		echo "ERROR: $testname: ns1 got reply \"$result\" connecting to vip, persistent connection is not closed as intended"
+		ret=1
+	fi
+
+	if ! kill -0 "$client1_pid" 2>/dev/null; then
+		echo "PASS: $testname: persistent connection is closed as intended"
+	else
+		echo "ERROR: $testname: persistent connection is not closed as intended"
+		kill $client1_pid 2>/dev/null
+		ret=1
+	fi
+
+	kill $server2_pid 2>/dev/null
+	rm -f "$TMPFILEIN"
+	rm -f "$TMPFILEOUT"
+}
+
+
+if test_ping; then
+	# queue bypass works (rules were skipped, no listener)
+	echo "PASS: ${ns1} can reach ${ns2}"
+else
+	echo "FAIL: ${ns1} cannot reach ${ns2}: $ret" 1>&2
+	exit $ret
+fi
+
+# Define different rule combinations
+declare -A testcases
+
+testcases["frontend filter"]='
+flush table inet nat
+table inet filter {
+	chain kube-proxy {
+		type filter hook prerouting priority -1; policy accept;
+		$ip_proto daddr $vip tcp dport 8080 reject with tcp reset
+	}
+}'
+
+testcases["backend filter"]='
+table inet filter {
+	chain kube-proxy {
+		type filter hook forward priority -1; policy accept;
+		ct original $ip_proto daddr $ns2_ip accept
+		$ip_proto daddr $ns2_ip tcp dport 8080 reject with tcp reset
+	}
+}'
+
+
+for testname in "${!testcases[@]}"; do
+	test_conntrack_reject_established "ip" "$testname" "${testcases[$testname]}"
+	test_conntrack_reject_established "ip6" "$testname" "${testcases[$testname]}"
+done
+
+exit $ret
-- 
2.49.0.rc1.451.g8f38331e32-goog

