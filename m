Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E682D7B8
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 06:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726121885; cv=none; b=pgGhpXyciMEpy3tID0VKcJAlaEi7BxexkLDhPZW/lP2Ep19cigs72jEeCIRP/JK54mbFgVrc66gX7tWPeFB5/gQ5LK+iGEkRvrvQwwWSh9saKt2maJ9upY+MbRdRf7twqKYocS4Dxk6Ro0fgwRJ0Jz+C7iiLDQr59cGEz0yzWc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726121885; c=relaxed/simple;
	bh=e/RUQx30IKA3rTYMzCwY0k63TILSCuj+0Y0XQ6UnYxU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YEYqwoKQIsDe+/jugaw9Cw3lGnfqZ8aR06uFg55uGTtHRnLRt9XJPqASVPpp74WiGWGcaIgjjLiKtiAcx5HUqVqDZf8ba/eP6qge38S1zWPideZIbu2W/e6ZVzxFgcdE3lkfjWLpbptasEiCnkd/g5UfzodfZaYNKHn7htSOSPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RgYVm+Dy; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RgYVm+Dy"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-a8a80667ad8so43646266b.2
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Sep 2024 23:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726121881; x=1726726681; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qH+HZLMcu69RL6PXqrB42WLrwXS10kuMnAidZQ4M8GU=;
        b=RgYVm+DyffAO2ZMO1Y8tgFypHl5gsSjVyNuavT2zeIs+79T4n8pYFwC51NYXZZYPzh
         ArA+PgrPN9fb009hxBoPN8XGKKUDMxNsneE7jmD+9zZN8Btn1VaKwguOAizlmKl9Por+
         h2Rf1AnThd7PIbhui2+9tFray5+Kr1kE0OMJdC6cDv8/6CW6zqtUGN+f6dDXDtjWuKbP
         mqNpREDz/MjYyVxZxqp89+97JMwrZaqwzHnunHsWBtNww2hVaQC83kpKgMW+mTrH2+o/
         GEuLtxglNuxz8IvOoU5QW1v9sPTS8RiCAUsWD/UrLCmUWumyCgD0sNzTcd5pVyYsEIWf
         yMyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726121881; x=1726726681;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qH+HZLMcu69RL6PXqrB42WLrwXS10kuMnAidZQ4M8GU=;
        b=l5wVf4tMwwWPoO/Hfid7rnSmwoJUqmFzpY9t058A34QQHhioLeDqyaRXrZsU5xRStV
         6oWuTpCBO9JoRM3P3J6WCg4+a4n4v3wxRHrJGlh017Hpq6cKg+5lWj0Kf+199J/XelRx
         AV/syvyQM6Ix07SbmFpwjTcyNJS7O/CpeyGUL9jOnTS3G/OL6SAxocPQhGl0ZJ6Q+NiY
         dedrW3Qtc0WcBzU4JruESRC/OJ1DBGJh0V58TLD1OAwHbVMsPH8UlU8qhRCFLeYn6X5u
         fnZh49Y5T1/W1QP9F2nmQ3tefcsQSFPYIOXkPZrvRqOgJ1tRISwskrdmH+RGYk10Rb6o
         J/zg==
X-Forwarded-Encrypted: i=1; AJvYcCXorbjPEUeS+tCKn8raLDJv5KfjLRWNhHU9UWNkfVpAp4kNEela2iCtkYLjzhrualELRRtxbR6O3aqt/G0ns3E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyqHsud5ihVD1I5Ng7bBT+6sG0iu65BUDhxGPa0eWmHFyUlgtD
	mk1F3CwNT/PqfDqlr5jKoU6bUlytTU02HsrqhqVXiJo09kjUG9zSl8XPz2un2xN0KADJQ3Q37Q=
	=
X-Google-Smtp-Source: AGHT+IGAMtKb+9EBFRPwi5+W+EB+I5M1lBbE0cRJxcUUYsqVK/2UldIoHRqul0eP/nGmoh3s+/TdD5UjRg==
X-Received: from aojea.c.googlers.com ([fda3:e722:ac3:cc00:b9:d560:ac1c:71ab])
 (user=aojea job=sendgmr) by 2002:a17:906:1808:b0:a8a:75b5:d647 with SMTP id
 a640c23a62f3a-a902941126cmr112366b.5.1726121881074; Wed, 11 Sep 2024 23:18:01
 -0700 (PDT)
Date: Thu, 12 Sep 2024 06:17:54 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240912061754.4187047-1-aojea@google.com>
Subject: [PATCH v3] selftests: netfilter: nft_tproxy.sh: add tcp tests
From: Antonio Ojea <aojea@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org, 
	Antonio Ojea <aojea@google.com>
Content-Type: text/plain; charset="UTF-8"

The TPROXY functionality is widely used, however, there are only mptcp
selftests covering this feature.

The selftests represent the most common scenarios and can also be used
as selfdocumentation of the feature.

UDP and TCP testcases are split in different files because of the
different nature of the protocols, specially due to the challenges that
present to reliable test UDP due to the connectionless nature of the
protocol. UDP only covers the scenarios involving the prerouting hook.

The UDP tests are signfinicantly slower than the TCP ones, hence they
use a larger timeout, it takes 20 seconds to run the full UDP suite
on a 48 vCPU Intel(R) Xeon(R) CPU @2.60GHz.

Signed-off-by: Antonio Ojea <aojea@google.com>
---
Changelog since v2:
  - enable tproxy networking selftests

Changelog since v1:
  - indentantion fixes, replace spaces by tabs
  - add UDP tests spliting each transport protocol in its own file

 .../testing/selftests/net/netfilter/Makefile  |   2 +
 tools/testing/selftests/net/netfilter/config  |   1 +
 .../selftests/net/netfilter/nft_tproxy_tcp.sh | 358 ++++++++++++++++++
 .../selftests/net/netfilter/nft_tproxy_udp.sh | 262 +++++++++++++
 4 files changed, 623 insertions(+)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_tproxy_tcp.sh
 create mode 100755 tools/testing/selftests/net/netfilter/nft_tproxy_udp.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index d13fb5ea3e89..b9b79bbee179 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -26,6 +26,8 @@ TEST_PROGS += nft_nat.sh
 TEST_PROGS += nft_nat_zones.sh
 TEST_PROGS += nft_queue.sh
 TEST_PROGS += nft_synproxy.sh
+TEST_PROGS += nft_tproxy_tcp.sh
+TEST_PROGS += nft_tproxy_udp.sh
 TEST_PROGS += nft_zones_many.sh
 TEST_PROGS += rpath.sh
 TEST_PROGS += xt_string.sh
diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index b2dd4db45215..c5fe7b34eaf1 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -81,6 +81,7 @@ CONFIG_NFT_QUEUE=m
 CONFIG_NFT_QUOTA=m
 CONFIG_NFT_REDIR=m
 CONFIG_NFT_SYNPROXY=m
+CONFIG_NFT_TPROXY=m
 CONFIG_VETH=m
 CONFIG_VLAN_8021Q=m
 CONFIG_XFRM_USER=m
diff --git a/tools/testing/selftests/net/netfilter/nft_tproxy_tcp.sh b/tools/testing/selftests/net/netfilter/nft_tproxy_tcp.sh
new file mode 100755
index 000000000000..e208fb03eeb7
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nft_tproxy_tcp.sh
@@ -0,0 +1,358 @@
+#!/bin/bash
+#
+# This tests tproxy on the following scenario:
+#
+#                         +------------+
+# +-------+               |  nsrouter  |                  +-------+
+# |ns1    |.99          .1|            |.1             .99|    ns2|
+# |   eth0|---------------|veth0  veth1|------------------|eth0   |
+# |       |  10.0.1.0/24  |            |   10.0.2.0/24    |       |
+# +-------+  dead:1::/64  |    veth2   |   dead:2::/64    +-------+
+#                         +------------+
+#                                |.1
+#                                |
+#                                |
+#                                |                        +-------+
+#                                |                     .99|    ns3|
+#                                +------------------------|eth0   |
+#                                       10.0.3.0/24       |       |
+#                                       dead:3::/64       +-------+
+#
+# The tproxy implementation acts as an echo server so the client
+# must receive the same message it sent if it has been proxied.
+# If is not proxied the servers return PONG_NS# with the number
+# of the namespace the server is running.
+#
+# shellcheck disable=SC2162,SC2317
+
+source lib.sh
+ret=0
+timeout=5
+
+cleanup()
+{
+	ip netns pids "$ns1" | xargs kill 2>/dev/null
+	ip netns pids "$ns2" | xargs kill 2>/dev/null
+	ip netns pids "$ns3" | xargs kill 2>/dev/null
+	ip netns pids "$nsrouter" | xargs kill 2>/dev/null
+
+	cleanup_all_ns
+}
+
+checktool "nft --version" "test without nft tool"
+checktool "socat -h" "run test without socat"
+
+trap cleanup EXIT
+setup_ns ns1 ns2 ns3 nsrouter
+
+if ! ip link add veth0 netns "$nsrouter" type veth peer name eth0 netns "$ns1" > /dev/null 2>&1; then
+    echo "SKIP: No virtual ethernet pair device support in kernel"
+    exit $ksft_skip
+fi
+ip link add veth1 netns "$nsrouter" type veth peer name eth0 netns "$ns2"
+ip link add veth2 netns "$nsrouter" type veth peer name eth0 netns "$ns3"
+
+ip -net "$nsrouter" link set veth0 up
+ip -net "$nsrouter" addr add 10.0.1.1/24 dev veth0
+ip -net "$nsrouter" addr add dead:1::1/64 dev veth0 nodad
+
+ip -net "$nsrouter" link set veth1 up
+ip -net "$nsrouter" addr add 10.0.2.1/24 dev veth1
+ip -net "$nsrouter" addr add dead:2::1/64 dev veth1 nodad
+
+ip -net "$nsrouter" link set veth2 up
+ip -net "$nsrouter" addr add 10.0.3.1/24 dev veth2
+ip -net "$nsrouter" addr add dead:3::1/64 dev veth2 nodad
+
+ip -net "$ns1" link set eth0 up
+ip -net "$ns2" link set eth0 up
+ip -net "$ns3" link set eth0 up
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
+ip -net "$ns3" addr add 10.0.3.99/24 dev eth0
+ip -net "$ns3" addr add dead:3::99/64 dev eth0 nodad
+ip -net "$ns3" route add default via 10.0.3.1
+ip -net "$ns3" route add default via dead:3::1
+
+ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
+ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
+ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth2.forwarding=1 > /dev/null
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
+  if ! ip netns exec "$ns1" ping -c 1 -q 10.0.3.99 > /dev/null; then
+	return 1
+  fi
+
+  if ! ip netns exec "$ns1" ping -c 1 -q dead:3::99 > /dev/null; then
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
+test_tproxy()
+{
+	local traffic_origin="$1"
+	local ip_proto="$2"
+	local expect_ns1_ns2="$3"
+	local expect_ns1_ns3="$4"
+	local expect_nsrouter_ns2="$5"
+	local expect_nsrouter_ns3="$6"
+
+	# derived variables
+	local testname="test_${ip_proto}_tcp_${traffic_origin}"
+	local socat_ipproto
+	local ns1_ip
+	local ns2_ip
+	local ns3_ip
+	local ns2_target
+	local ns3_target
+	local nftables_subject
+	local ip_command
+
+	# socat 1.8.0 has a bug that requires to specify the IP family to bind (fixed in 1.8.0.1)
+	case $ip_proto in
+	"ip")
+		socat_ipproto="-4"
+		ns1_ip=10.0.1.99
+		ns2_ip=10.0.2.99
+		ns3_ip=10.0.3.99
+		ns2_target="tcp:$ns2_ip:8080"
+		ns3_target="tcp:$ns3_ip:8080"
+		nftables_subject="ip daddr $ns2_ip tcp dport 8080"
+		ip_command="ip"
+	;;
+	"ip6")
+		socat_ipproto="-6"
+		ns1_ip=dead:1::99
+		ns2_ip=dead:2::99
+		ns3_ip=dead:3::99
+		ns2_target="tcp:[$ns2_ip]:8080"
+		ns3_target="tcp:[$ns3_ip]:8080"
+		nftables_subject="ip6 daddr $ns2_ip tcp dport 8080"
+		ip_command="ip -6"
+	;;
+	*)
+	echo "FAIL: unsupported protocol"
+	exit 255
+	;;
+	esac
+
+	case $traffic_origin in
+	# to capture the local originated traffic we need to mark the outgoing
+	# traffic so the policy based routing rule redirects it and can be processed
+	# in the prerouting chain.
+	"local")
+		nftables_rules="
+flush ruleset
+table inet filter {
+	chain divert {
+		type filter hook prerouting priority 0; policy accept;
+		$nftables_subject tproxy $ip_proto to :12345 meta mark set 1 accept
+	}
+	chain output {
+		type route hook output priority 0; policy accept;
+		$nftables_subject meta mark set 1 accept
+	}
+}"
+	;;
+	"forward")
+		nftables_rules="
+flush ruleset
+table inet filter {
+	chain divert {
+		type filter hook prerouting priority 0; policy accept;
+		$nftables_subject tproxy $ip_proto to :12345 meta mark set 1 accept
+	}
+}"
+	;;
+	*)
+	echo "FAIL: unsupported parameter for traffic origin"
+	exit 255
+	;;
+	esac
+
+	# shellcheck disable=SC2046 # Intended splitting of ip_command
+	ip netns exec "$nsrouter" $ip_command rule add fwmark 1 table 100
+	ip netns exec "$nsrouter" $ip_command route add local "${ns2_ip}" dev lo table 100
+	echo "$nftables_rules" | ip netns exec "$nsrouter" nft -f /dev/stdin
+
+	timeout "$timeout" ip netns exec "$nsrouter" socat "$socat_ipproto" tcp-listen:12345,fork,ip-transparent SYSTEM:"cat" 2>/dev/null &
+	local tproxy_pid=$!
+
+	timeout "$timeout" ip netns exec "$ns2" socat "$socat_ipproto" tcp-listen:8080,fork SYSTEM:"echo PONG_NS2" 2>/dev/null &
+	local server2_pid=$!
+
+	timeout "$timeout" ip netns exec "$ns3" socat "$socat_ipproto" tcp-listen:8080,fork SYSTEM:"echo PONG_NS3" 2>/dev/null &
+	local server3_pid=$!
+
+	busywait "$BUSYWAIT_TIMEOUT" listener_ready "$nsrouter" 12345 "-t"
+	busywait "$BUSYWAIT_TIMEOUT" listener_ready "$ns2" 8080 "-t"
+	busywait "$BUSYWAIT_TIMEOUT" listener_ready "$ns3" 8080 "-t"
+
+	local result
+	# request from ns1 to ns2 (forwarded traffic)
+	result=$(echo I_M_PROXIED | ip netns exec "$ns1" socat -t 2 -T 2 STDIO "$ns2_target")
+	if [ "$result" == "$expect_ns1_ns2" ] ;then
+		echo "PASS: tproxy test $testname: ns1 got reply \"$result\" connecting to ns2"
+	else
+		echo "ERROR: tproxy test $testname: ns1 got reply \"$result\" connecting to ns2, not \"${expect_ns1_ns2}\" as intended"
+		ret=1
+	fi
+
+	# request from ns1 to ns3(forwarded traffic)
+	result=$(echo I_M_PROXIED | ip netns exec "$ns1" socat -t 2 -T 2 STDIO "$ns3_target")
+	if [ "$result" = "$expect_ns1_ns3" ] ;then
+		echo "PASS: tproxy test $testname: ns1 got reply \"$result\" connecting to ns3"
+	else
+		echo "ERROR: tproxy test $testname: ns1 got reply \"$result\" connecting to ns3, not \"$expect_ns1_ns3\" as intended"
+		ret=1
+	fi
+
+	# request from nsrouter to ns2 (localy originated traffic)
+	result=$(echo I_M_PROXIED | ip netns exec "$nsrouter" socat -t 2 -T 2 STDIO "$ns2_target")
+	if [ "$result" == "$expect_nsrouter_ns2" ] ;then
+		echo "PASS: tproxy test $testname: nsrouter got reply \"$result\" connecting to ns2"
+	else
+		echo "ERROR: tproxy test $testname: nsrouter got reply \"$result\" connecting to ns2, not \"$expect_nsrouter_ns2\" as intended"
+		ret=1
+	fi
+
+	# request from nsrouter to ns3 (localy originated traffic)
+	result=$(echo I_M_PROXIED | ip netns exec "$nsrouter" socat -t 2 -T 2 STDIO "$ns3_target")
+	if [ "$result" = "$expect_nsrouter_ns3" ] ;then
+		echo "PASS: tproxy test $testname: nsrouter got reply \"$result\" connecting to ns3"
+	else
+		echo "ERROR: tproxy test $testname: nsrouter got reply \"$result\" connecting to ns3, not \"$expect_nsrouter_ns3\"  as intended"
+		ret=1
+	fi
+
+	# cleanup
+	kill "$tproxy_pid" "$server2_pid" "$server3_pid" 2>/dev/null
+	# shellcheck disable=SC2046 # Intended splitting of ip_command
+	ip netns exec "$nsrouter" $ip_command rule del fwmark 1 table 100
+	ip netns exec "$nsrouter" $ip_command route flush table 100
+}
+
+
+test_ipv4_tcp_forward()
+{
+	local traffic_origin="forward"
+	local ip_proto="ip"
+	local expect_ns1_ns2="I_M_PROXIED"
+	local expect_ns1_ns3="PONG_NS3"
+	local expect_nsrouter_ns2="PONG_NS2"
+	local expect_nsrouter_ns3="PONG_NS3"
+
+	test_tproxy     "$traffic_origin" \
+			"$ip_proto" \
+			"$expect_ns1_ns2" \
+			"$expect_ns1_ns3" \
+			"$expect_nsrouter_ns2" \
+			"$expect_nsrouter_ns3"
+}
+
+test_ipv4_tcp_local()
+{
+	local traffic_origin="local"
+	local ip_proto="ip"
+	local expect_ns1_ns2="I_M_PROXIED"
+	local expect_ns1_ns3="PONG_NS3"
+	local expect_nsrouter_ns2="I_M_PROXIED"
+	local expect_nsrouter_ns3="PONG_NS3"
+
+	test_tproxy     "$traffic_origin" \
+			"$ip_proto" \
+			"$expect_ns1_ns2" \
+			"$expect_ns1_ns3" \
+			"$expect_nsrouter_ns2" \
+			"$expect_nsrouter_ns3"
+}
+
+test_ipv6_tcp_forward()
+{
+	local traffic_origin="forward"
+	local ip_proto="ip6"
+	local expect_ns1_ns2="I_M_PROXIED"
+	local expect_ns1_ns3="PONG_NS3"
+	local expect_nsrouter_ns2="PONG_NS2"
+	local expect_nsrouter_ns3="PONG_NS3"
+
+	test_tproxy     "$traffic_origin" \
+			"$ip_proto" \
+			"$expect_ns1_ns2" \
+			"$expect_ns1_ns3" \
+			"$expect_nsrouter_ns2" \
+			"$expect_nsrouter_ns3"
+}
+
+test_ipv6_tcp_local()
+{
+	local traffic_origin="local"
+	local ip_proto="ip6"
+	local expect_ns1_ns2="I_M_PROXIED"
+	local expect_ns1_ns3="PONG_NS3"
+	local expect_nsrouter_ns2="I_M_PROXIED"
+	local expect_nsrouter_ns3="PONG_NS3"
+
+	test_tproxy     "$traffic_origin" \
+			"$ip_proto" \
+			"$expect_ns1_ns2" \
+			"$expect_ns1_ns3" \
+			"$expect_nsrouter_ns2" \
+			"$expect_nsrouter_ns3"
+}
+
+if test_ping; then
+	# queue bypass works (rules were skipped, no listener)
+	echo "PASS: ${ns1} can reach ${ns2}"
+else
+	echo "FAIL: ${ns1} cannot reach ${ns2}: $ret" 1>&2
+	exit $ret
+fi
+
+test_ipv4_tcp_forward
+test_ipv4_tcp_local
+test_ipv6_tcp_forward
+test_ipv6_tcp_local
+
+exit $ret
diff --git a/tools/testing/selftests/net/netfilter/nft_tproxy_udp.sh b/tools/testing/selftests/net/netfilter/nft_tproxy_udp.sh
new file mode 100755
index 000000000000..d16de13fe5a7
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nft_tproxy_udp.sh
@@ -0,0 +1,262 @@
+#!/bin/bash
+#
+# This tests tproxy on the following scenario:
+#
+#                         +------------+
+# +-------+               |  nsrouter  |                  +-------+
+# |ns1    |.99          .1|            |.1             .99|    ns2|
+# |   eth0|---------------|veth0  veth1|------------------|eth0   |
+# |       |  10.0.1.0/24  |            |   10.0.2.0/24    |       |
+# +-------+  dead:1::/64  |    veth2   |   dead:2::/64    +-------+
+#                         +------------+
+#                                |.1
+#                                |
+#                                |
+#                                |                        +-------+
+#                                |                     .99|    ns3|
+#                                +------------------------|eth0   |
+#                                       10.0.3.0/24       |       |
+#                                       dead:3::/64       +-------+
+#
+# The tproxy implementation acts as an echo server so the client
+# must receive the same message it sent if it has been proxied.
+# If is not proxied the servers return PONG_NS# with the number
+# of the namespace the server is running.
+# shellcheck disable=SC2162,SC2317
+
+source lib.sh
+ret=0
+# UDP is slow
+timeout=15
+
+cleanup()
+{
+	ip netns pids "$ns1" | xargs kill 2>/dev/null
+	ip netns pids "$ns2" | xargs kill 2>/dev/null
+	ip netns pids "$ns3" | xargs kill 2>/dev/null
+	ip netns pids "$nsrouter" | xargs kill 2>/dev/null
+
+	cleanup_all_ns
+}
+
+checktool "nft --version" "test without nft tool"
+checktool "socat -h" "run test without socat"
+
+trap cleanup EXIT
+setup_ns ns1 ns2 ns3 nsrouter
+
+if ! ip link add veth0 netns "$nsrouter" type veth peer name eth0 netns "$ns1" > /dev/null 2>&1; then
+    echo "SKIP: No virtual ethernet pair device support in kernel"
+    exit $ksft_skip
+fi
+ip link add veth1 netns "$nsrouter" type veth peer name eth0 netns "$ns2"
+ip link add veth2 netns "$nsrouter" type veth peer name eth0 netns "$ns3"
+
+ip -net "$nsrouter" link set veth0 up
+ip -net "$nsrouter" addr add 10.0.1.1/24 dev veth0
+ip -net "$nsrouter" addr add dead:1::1/64 dev veth0 nodad
+
+ip -net "$nsrouter" link set veth1 up
+ip -net "$nsrouter" addr add 10.0.2.1/24 dev veth1
+ip -net "$nsrouter" addr add dead:2::1/64 dev veth1 nodad
+
+ip -net "$nsrouter" link set veth2 up
+ip -net "$nsrouter" addr add 10.0.3.1/24 dev veth2
+ip -net "$nsrouter" addr add dead:3::1/64 dev veth2 nodad
+
+ip -net "$ns1" link set eth0 up
+ip -net "$ns2" link set eth0 up
+ip -net "$ns3" link set eth0 up
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
+ip -net "$ns3" addr add 10.0.3.99/24 dev eth0
+ip -net "$ns3" addr add dead:3::99/64 dev eth0 nodad
+ip -net "$ns3" route add default via 10.0.3.1
+ip -net "$ns3" route add default via dead:3::1
+
+ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
+ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
+ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth2.forwarding=1 > /dev/null
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
+  if ! ip netns exec "$ns1" ping -c 1 -q 10.0.3.99 > /dev/null; then
+	return 1
+  fi
+
+  if ! ip netns exec "$ns1" ping -c 1 -q dead:3::99 > /dev/null; then
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
+test_tproxy_udp_forward()
+{
+	local ip_proto="$1"
+
+	local expect_ns1_ns2="I_M_PROXIED"
+	local expect_ns1_ns3="PONG_NS3"
+	local expect_nsrouter_ns2="PONG_NS2"
+	local expect_nsrouter_ns3="PONG_NS3"
+
+	# derived variables
+	local testname="test_${ip_proto}_udp_forward"
+	local socat_ipproto
+	local ns1_ip
+	local ns2_ip
+	local ns3_ip
+	local ns1_ip_port
+	local ns2_ip_port
+	local ns3_ip_port
+	local ip_command
+
+	# socat 1.8.0 has a bug that requires to specify the IP family to bind (fixed in 1.8.0.1)
+	case $ip_proto in
+	"ip")
+		socat_ipproto="-4"
+		ns1_ip=10.0.1.99
+		ns2_ip=10.0.2.99
+		ns3_ip=10.0.3.99
+		ns1_ip_port="$ns1_ip:18888"
+		ns2_ip_port="$ns2_ip:8080"
+		ns3_ip_port="$ns3_ip:8080"
+		ip_command="ip"
+	;;
+	"ip6")
+		socat_ipproto="-6"
+		ns1_ip=dead:1::99
+		ns2_ip=dead:2::99
+		ns3_ip=dead:3::99
+		ns1_ip_port="[$ns1_ip]:18888"
+		ns2_ip_port="[$ns2_ip]:8080"
+		ns3_ip_port="[$ns3_ip]:8080"
+		ip_command="ip -6"
+	;;
+	*)
+	echo "FAIL: unsupported protocol"
+	exit 255
+	;;
+	esac
+
+	# shellcheck disable=SC2046 # Intended splitting of ip_command
+	ip netns exec "$nsrouter" $ip_command rule add fwmark 1 table 100
+	ip netns exec "$nsrouter" $ip_command route add local "$ns2_ip" dev lo table 100
+	ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
+flush ruleset
+table inet filter {
+	chain divert {
+		type filter hook prerouting priority 0; policy accept;
+		$ip_proto daddr $ns2_ip udp dport 8080 tproxy $ip_proto to :12345 meta mark set 1 accept
+	}
+}
+EOF
+
+	timeout "$timeout" ip netns exec "$nsrouter" socat -u "$socat_ipproto" udp-listen:12345,fork,ip-transparent,reuseport udp:"$ns1_ip_port",ip-transparent,reuseport,bind="$ns2_ip_port" 2>/dev/null &
+	local tproxy_pid=$!
+
+	timeout "$timeout" ip netns exec "$ns2" socat "$socat_ipproto" udp-listen:8080,fork SYSTEM:"echo PONG_NS2" 2>/dev/null &
+	local server2_pid=$!
+
+	timeout "$timeout" ip netns exec "$ns3" socat "$socat_ipproto" udp-listen:8080,fork SYSTEM:"echo PONG_NS3" 2>/dev/null &
+	local server3_pid=$!
+
+	busywait "$BUSYWAIT_TIMEOUT" listener_ready "$nsrouter" 12345 "-u"
+	busywait "$BUSYWAIT_TIMEOUT" listener_ready "$ns2" 8080 "-u"
+	busywait "$BUSYWAIT_TIMEOUT" listener_ready "$ns3" 8080 "-u"
+
+	local result
+	# request from ns1 to ns2 (forwarded traffic)
+	result=$(echo I_M_PROXIED | ip netns exec "$ns1" socat -t 2 -T 2 STDIO udp:"$ns2_ip_port",sourceport=18888)
+	if [ "$result" == "$expect_ns1_ns2" ] ;then
+		echo "PASS: tproxy test $testname: ns1 got reply \"$result\" connecting to ns2"
+	else
+		echo "ERROR: tproxy test $testname: ns1 got reply \"$result\" connecting to ns2, not \"${expect_ns1_ns2}\" as intended"
+		ret=1
+	fi
+
+	# request from ns1 to ns3 (forwarded traffic)
+	result=$(echo I_M_PROXIED | ip netns exec "$ns1" socat -t 2 -T 2 STDIO udp:"$ns3_ip_port")
+	if [ "$result" = "$expect_ns1_ns3" ] ;then
+		echo "PASS: tproxy test $testname: ns1 got reply \"$result\" connecting to ns3"
+	else
+		echo "ERROR: tproxy test $testname: ns1 got reply \"$result\" connecting to ns3, not \"$expect_ns1_ns3\" as intended"
+		ret=1
+	fi
+
+	# request from nsrouter to ns2 (localy originated traffic)
+	result=$(echo I_M_PROXIED | ip netns exec "$nsrouter" socat -t 2 -T 2 STDIO udp:"$ns2_ip_port")
+	if [ "$result" == "$expect_nsrouter_ns2" ] ;then
+		echo "PASS: tproxy test $testname: nsrouter got reply \"$result\" connecting to ns2"
+	else
+		echo "ERROR: tproxy test $testname: nsrouter got reply \"$result\" connecting to ns2, not \"$expect_nsrouter_ns2\" as intended"
+		ret=1
+	fi
+
+	# request from nsrouter to ns3 (localy originated traffic)
+	result=$(echo I_M_PROXIED | ip netns exec "$nsrouter" socat -t 2 -T 2 STDIO udp:"$ns3_ip_port")
+	if [ "$result" = "$expect_nsrouter_ns3" ] ;then
+		echo "PASS: tproxy test $testname: nsrouter got reply \"$result\" connecting to ns3"
+	else
+		echo "ERROR: tproxy test $testname: nsrouter got reply \"$result\" connecting to ns3, not \"$expect_nsrouter_ns3\"  as intended"
+		ret=1
+	fi
+
+	# cleanup
+	kill "$tproxy_pid" "$server2_pid" "$server3_pid" 2>/dev/null
+	# shellcheck disable=SC2046 # Intended splitting of ip_command
+	ip netns exec "$nsrouter" $ip_command rule del fwmark 1 table 100
+	ip netns exec "$nsrouter" $ip_command route flush table 100
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
+test_tproxy_udp_forward "ip"
+test_tproxy_udp_forward "ip6"
+
+exit $ret
-- 
2.46.0.598.g6f2099f65c-goog

