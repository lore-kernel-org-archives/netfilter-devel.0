Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E3678C91
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Sep 2024 12:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726059465; cv=none; b=fPoW3pQY8NNVOK7fPfvQKWt5AwHdmO0TLc+FCNR8UIJWH5nW0+RDOmbeh+Wa7Ze4NpbhruxACu4I9CWSN2Iw3RLqcGMNo+gjYms7HiJflZYd362J9F9c2ni/9Ff0poL+r/hriA2fmjfGVM7bl9c5mOk2VGUiOP3QmlmJCp4mZqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726059465; c=relaxed/simple;
	bh=vfKJWl2WF1fVCmg4GSOsif/h410YA1b/mA92PNrTxGY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=CzpMyKMEahoxw23KOVRSeOuBq64Ns3PQ9IpOSkCDc1ue4UcGG3aF1lSVLrfHOfxAPOQkcbhShxVtcXmaSaqswYbs3ifgAq1/oWYda/rDCNnvcbOvXOl13OftCFIWJ9ZI0gK33yud1Q6O8H2Qj/9JDhji9HlbbabLUTD/Apl7Wro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=li/3BlQW; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="li/3BlQW"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6d7124939beso196883157b3.2
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Sep 2024 05:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726059462; x=1726664262; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1y3pAHaGkCjoaicHaht38QIGhiQREhW8ZxCJDexaQos=;
        b=li/3BlQWtdusmC2/QrvdDC1NtoMQbaemVhOb51txFbbEadX0Hbtj0jiSdwMdHvE505
         p9WrQCehlerBi2Uxh70GB6/70PvSA1B5/VV6QZAgP0nlVM417FSXArh9/ILFZf2C/AVv
         h7N+w5JlagxNFw1bifBSER8MI425RzOgOvUTFK+7QuY83PiFPNZm8YHGo90bAFPjXMnz
         AwNHvgOnT8QovuZQBgLv/iTUuVaLudqkMajHYo+umo0tfzOOhCZcHacR6sczqWTsX66a
         cgsiIdkS1l/AMaKz3L8MoneH/J68HH5ohH1cua2cXLx4JeXfxyLwVa4nlVCo53lTnlKa
         3rUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726059462; x=1726664262;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1y3pAHaGkCjoaicHaht38QIGhiQREhW8ZxCJDexaQos=;
        b=gf2GQ8sH1O6VPC05OWQ07VwDlbTpG+sWgwF7lA583D6IWAegN1DnrvZv+hfp7aKsH1
         P1huUA4oFm/45YDSeJeJY9SE6DrNI4znZVevDf1sKeoxR6skpCmkLMlJNNhjxwi3q5xq
         s4hysEYMTOmQg2MTWxh6WmOcSpPLFCOZrzasr9H2IUTRJ7vnoZEANleuDTMafBZyCLgX
         3D1JUBFjS/GHdCIta3PZxvjgEGO1VklDkI6d3Gud0Y4u1c+W5L+IWl9jPv+1wTo18UUC
         5hzdwQuDPZ6eE8ThSM3RUABn58CaF45WtTWb+R7LA4oEl0WkiV+v1hkWE0HOec88ZpgI
         7RFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnC9K8UrM859Nx4UO+kal2WMBDVzCdCZhe9IAuG8816ppAOdHobeEAaON2MUCPrCBWeMPJqfAY0D8bh5HqcFM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAJsjjBdPk8WgZWiZkKw8aIXYqbWowScNXFQuOA8AX/UYTa35/
	B0wOwv9xXjIGnE45u3WlGzPBoNZPUA00r1zz2xfzqUvQPTjKdxbjwIBCS9iDaq+MkKtRHu3bow=
	=
X-Google-Smtp-Source: AGHT+IFrKncF3a0Fogv0DzjjE9eh6Prybx3eYaT0vdRwEJKV8jjv6y4Z99cBK6ywW83E1ze7dlHXgeKDWw==
X-Received: from aojea.c.googlers.com ([fda3:e722:ac3:cc00:b9:d560:ac1c:71ab])
 (user=aojea job=sendgmr) by 2002:a05:690c:4b10:b0:68e:8de6:618b with SMTP id
 00721157ae682-6db44d89f07mr10143607b3.2.1726059462103; Wed, 11 Sep 2024
 05:57:42 -0700 (PDT)
Date: Wed, 11 Sep 2024 12:57:27 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911125727.3431419-1-aojea@google.com>
Subject: [PATCH v2] selftests: netfilter: tproxy tcp and udp tests
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
present to reliable test UDP due to the connectionless nature of the protocol.
UDP only covers the scenarios involving the prerouting hook.

The UDP tests are signfinicantly slower than the TCP ones, hence they
use a larger timeout, 20 seconds on a 48 vCPU Intel(R) Xeon(R) CPU @ 2.60GHz


Signed-off-by: Antonio Ojea <aojea@google.com>
---
Changelog since v1:
- indentantion fixes, replace spaces by tabs
- add UDP tests spliting each transport protocol in its own file

 .../testing/selftests/net/netfilter/Makefile  |   2 +
 .../selftests/net/netfilter/nft_tproxy_tcp.sh | 358 ++++++++++++++++++
 .../selftests/net/netfilter/nft_tproxy_udp.sh | 262 +++++++++++++
 3 files changed, 622 insertions(+)
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

