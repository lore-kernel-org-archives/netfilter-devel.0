Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D8618DB0B
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2025 23:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741907633; cv=none; b=ul+KwQeBeFOo2gCy7afxZDNmaSxYumxSjYLJUss/Tl/wXgXTaynAI2/brUr8ILoIU4UdIKTQtHSI4q0SB8NV6H8+Y2txkrr0Vc5H1+fJ/qSch+9VwpvZzTecfnT6vP+Td/wCUX4fL3mqrSZqdLLstJOOtGHRF6ERRBRe0DoZNmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741907633; c=relaxed/simple;
	bh=eoqxsi0QUHXK+DDnyxuLK9FK74j2kIjYAJC2tcpKtEo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Wwzky2l3SwIVy/DIPX0ajNpdde7kYVeVRmb6gRWTeWv7At9MDFpatE04T15Ac8+2MDrPQAs8nJBBHcd6lS/JluBz5qg08FCKcusa+SzIyg8qS7vYpCvgVRZdS7/9gqnKC49gdkELHrnl2EpeA+fOv8Tvd1nraTEnL1c/4VGRU50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qaChyUnP; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qaChyUnP"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5e623fe6aa2so1579007a12.2
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2025 16:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741907629; x=1742512429; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Mo0ZOWIG8xEBUQq9CUWle5LLNwSqTMFECjFo3cDk9BU=;
        b=qaChyUnP9ZvsQrsSVh84hbNW8eWwKHman/JHfg9omfb47J7gai+iwyVXSF7VH9+roR
         kEo8YAcBpC4I29NftM2+Evn5Kiurx6FrkXqmu0HRuwUMRiSltzgjdYR/MFuYBeU+6mrZ
         qrwOJadXGLQ79zo91ZQ2VcHMpIJ+6GLMPEKaj7QCO6XfRJ5+i6NASPElyi7IFj5rEeBZ
         rhnzp2cdl3jiUUVOe0hq4mQ13v0tn/dfOORCuVr+dBMcge1JiBGSyWzcF7lixbfbCBWv
         LM+JeyYuKoh1Sj8/O/cHZoc1tqn75rROuogFxMU50LfeGCRGCZTgEIVXtXDrdEfMiY9z
         2LeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741907629; x=1742512429;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mo0ZOWIG8xEBUQq9CUWle5LLNwSqTMFECjFo3cDk9BU=;
        b=ezMTGCxISRtflrjHM2YiLoXPjvWSSM0zeJ+s1S/m78aoy8omz9cRl/cIX9Dt1qfK+G
         Ls+8p4mQ3yDWOY3qKbSF/xb6NtWXQ/ZjcDq+Y7eEZmqoMm+ScT2NCeMfd0hAiGRl69PH
         SIe1l6LiyRKpNlpltQQ+wPHpReuKLSV9+3FHKtt6OVZUlaHqP9lP4iPoCHPXDIx0zIdP
         xIsVAnK/VJhFPHUyljPsfVDyUrZLJiOH6ELu/DTc2cBWFQxG4mYKOI5I4BXhdOZ2wA3k
         qUrjn4NkUjbus3MElbvMXnCW0OI4tLgxvwF1dtnOjjrZloIdNCoR1ieQ2bq233kOhRK3
         N7lQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6sAVKRxWw5w/eMTSsx7OvX7ViygTfU5Bo4mYLYbyPCsrpiXJSI5x4YyW4rYUHY9y8dX608pa91jFvdICchDM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxR5+1tEKgQyAEYYb5Mh2FPIlyL4x2LzX+YvVkw1r1Cmvxp5rgh
	BuSq5XFK4xRS7TdpeSRNUotf0lRq4fJb5RJN0Vmo8trb85zyg3HGoWgRDXdArqR3ZshoS36EEg=
	=
X-Google-Smtp-Source: AGHT+IGX1aKVtFOAEsSLrqeB9qfCyG7tbjSHX4Mr397BUr3X6EwBdBod0NF4EPJIjrixzyY4qCz56JbMYQ==
X-Received: from edbbx25.prod.google.com ([2002:a05:6402:b59:b0:5e5:cbc8:77b7])
 (user=aojea job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:84d:b0:5e5:49af:411d
 with SMTP id 4fb4d7f45d1cf-5e89fa51fe4mr392141a12.17.1741907629423; Thu, 13
 Mar 2025 16:13:49 -0700 (PDT)
Date: Thu, 13 Mar 2025 23:13:41 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250313231341.3040002-1-aojea@google.com>
Subject: [PATCH] selftests: netfilter: conntrack respect reject rules
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

The test then performs the following steps:

1.  Establishes a connection from ns1 to ns2 (direct connection).
2.  Establishes a persistent connection from ns1 to the virtual IP
    (DNAT to ns2).
3.  Establishes another connection from ns1 to the virtual IP.
4.  Adds an nftables rule in nsrouter to reject traffic destined to ns2
    on the service port.
5.  Verifies that subsequent connections from ns1 to ns2 and the
    virtual IP are rejected.
6.  Verifies that the established persistent connection from ns1 to the
    virtual IP is also closed.

Signed-off-by: Antonio Ojea <aojea@google.com>
---
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 tools/testing/selftests/net/netfilter/config  |   1 +
 .../nft_conntrack_reject_established.sh       | 272 ++++++++++++++++++
 3 files changed, 274 insertions(+)
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
index 000000000000..50cdb463804d
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nft_conntrack_reject_established.sh
@@ -0,0 +1,272 @@
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
+	# derived variables
+	local testname="test_${ip_proto}_conntrack_reject_established"
+	local socat_ipproto
+	local vip
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
+	timeout "$timeout" ip netns exec "$ns2" socat -u "$socat_ipproto" tcp-listen:8080,fork STDIO > "$TMPFILEOUT" &
+	local server2_pid=$!
+
+	busywait "$BUSYWAIT_TIMEOUT" listener_ready "$ns2" 8080 "-t"
+
+	local result
+	# request from ns1 to ns2 (direct traffic) must work
+	if ! echo PING1 | ip netns exec "$ns1" socat -t 2 -T 2 -u STDIO tcp:"$ns2_ip_port"; then
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
+	timeout "$timeout" tail -f $TMPFILEIN | ip netns exec "$ns1" socat STDIO tcp:"$vip_ip_port,sourceport=12345" &
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
+	if ! echo PING3 | ip netns exec "$ns1" socat -t 2 -T 2 -u STDIO tcp:"$vip_ip_port"; then
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
+	ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
+table inet filter {
+	chain kube-proxy {
+		type filter hook forward priority 0; policy accept;
+		$ip_proto daddr $ns2_ip tcp dport 8080 counter reject with tcp reset
+	}
+}
+EOF
+
+	# request from ns1 to ns2 (direct traffic)
+	result=$(echo PING5 | ip netns exec "$ns1" socat -t 2 -T 2 -u STDIO tcp:"$ns2_ip_port" 2>&1 >/dev/null)
+	if [[ "$result" == *"Connection refused"* ]] ;then
+		echo "PASS: $testname: ns1 got \"Connection refused\" connecting to vip (ns2)"
+	else
+		echo "ERROR: $testname: ns1 got reply \"$result\" connecting to vip, not \"Connection refused\" as intended"
+		ret=1
+	fi
+
+	# request from ns1 to vip (DNAT to ns2)
+	result=$(echo PING6 | ip netns exec "$ns1" socat -t 2 -T 2 -u STDIO tcp:"$vip_ip_port" 2>&1 >/dev/null)
+	if [[ "$result" == *"Connection refused"* ]] ;then
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
+	if [ "$result" == "PING4" ] ; then
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
+test_conntrack_reject_established "ip"
+test_conntrack_reject_established "ip6"
+
+exit $ret
-- 
2.49.0.rc1.451.g8f38331e32-goog

