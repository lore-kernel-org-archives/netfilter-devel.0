Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C330719B3CB
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Mar 2025 16:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742315737; cv=none; b=TxJEp3XvN6ElAls+0eVhv1r3Dt2R5827ZBrFj5aDeS/kwLIRpWaSCwI6REqnydJrTFGuQSE7rTeMxDuXyNmHyhAZzsxnhCtQSEywQf4JzGxO/EV/tySiHY5WBVmx+b2YpgzaKLsZ5PvKjgcpjf+aia63Ctwy7xJAuT1WdSJoKEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742315737; c=relaxed/simple;
	bh=vU/SyFsor082KvFy1mEUpzmCwVMJZP+vKbHN4LkHZX8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BTpQjlxioFPNEJ4yG+IwK98SIt+cpiknAlbvj0/+dOzKAU8FTP8KNGQrOQRMihVUBc7PZKXdCDZHTfLkmuwvwAqCGDT+3SnhfPljqB1HGLthAKNt6bvmzFLqj3yt07lppfv8FVBs/AAqMPWWZi1JwDG88V24Oq3ZNhx+snS8JRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z2scClPN; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z2scClPN"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5e5c5ea184dso6293566a12.0
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Mar 2025 09:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742315733; x=1742920533; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F45TZUvKAeq9FBEJtYs7cRZ2b/PpEpJ9zROw1d94C4w=;
        b=z2scClPNIGir6Kfr1sfRthxPH35buCPCccpe3ADzPCHI17iBz1CRB2lvZ7Rhj5gx9u
         mHQ+VygUBcWivzK9iLcA8TN8Ow9tb9Apgihwm4VivYbnGETJaJTCEdofi+w4DiBg9SPV
         ZdCVjHxzcH5AWalkV02YLG9Z+wIyzWFmFkasn/8DcvY5dRZ6Fi38In66WcC6Etfm7Q0N
         n+UD6S9hAna6r8WgyDZfL50qQni1+2H3H9PvBbKOTtFN/8pQmtQsxqfNSzIMkk3Hxab0
         QEghnlb8ojRDWKpP8QJTMsa2M9p94qcwjt1t3+PDa6Ddl7WMDLjY1e5I/38oeFPXtZOt
         Tf1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742315733; x=1742920533;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F45TZUvKAeq9FBEJtYs7cRZ2b/PpEpJ9zROw1d94C4w=;
        b=eeU7LNrLDKo73E4z2fsmWPTv/GZfXuKNmw+zKI5NOjZh+zSn+M9bsHk8iOnW1C2Kb9
         Mw2sf+8VceqYOTkAfbnC7UxGtBwPYK5Q+rbju0etHAPbATmCholKGyl6d/vw/y/l1SkH
         qHkWbFcvaJzdHYdtcNjzh3QCA658hG7AfRaZpKlZep1mZkD8bseXn7ljJ/NLvlvqCvEj
         NH36ba3hOl8aqdf4vsZf8PMylBUpmQKVeI0ggQnrepvGfR8o/o47w5NpDOxnu4il1FV9
         kJUBn9xK3JlNkdUJmWrPhlhYMz00mZjBCy3tF5sJvZle+W/GyJxqtD/Ya21CsczhWraf
         9TCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmGt2an++fWMjEeLxzlx5/Bz8IhIGqj0VWU734ZK7itG4jdU5/qgE1Tji2a8/bM2vJ7P28oHwIyQMmjd1NlFg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4FCZ+znA3GyVFOuEG5YBAjZZB4h3LR6tNgpeUYQuVzI2ZBNMx
	SkEQEvx3iaPn2yMqlbr3ctR1Uq5M+BTB1JKTUVQqFthNVdKF9+AClHD2tGm5ldakJquBZgLLwQ=
	=
X-Google-Smtp-Source: AGHT+IHk5yevRLQ3jVN1q185ZsR1i4ib2+0vdWaP0aCDIX9ptMCpIIyoqGcAOm2pM3zDFePVqbovNvxQuQ==
X-Received: from edxw7.prod.google.com ([2002:a05:6402:707:b0:5e5:6102:25bc])
 (user=aojea job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:5210:b0:5e5:bde4:7575
 with SMTP id 4fb4d7f45d1cf-5e89f24e3b1mr16637634a12.1.1742315733031; Tue, 18
 Mar 2025 09:35:33 -0700 (PDT)
Date: Tue, 18 Mar 2025 16:35:29 +0000
In-Reply-To: <20250318094138.3328627-1-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318094138.3328627-1-aojea@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318163529.3585425-1-aojea@google.com>
Subject: [PATCH v4] selftests: netfilter: conntrack respect reject rules
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
V2 -> V3:
* Add helper functions to remove code duplication
* Use busywait instead of hardcoded sleeps
V3 -> V4:
* Add helper functions to detect process does not exist
* Use busywait to wait for the process to exist
* Increase timeout to wait for possible answer from 1ms to 100ms
---
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 tools/testing/selftests/net/netfilter/config  |   1 +
 .../nft_conntrack_reject_established.sh       | 322 ++++++++++++++++++
 3 files changed, 324 insertions(+)
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
index 000000000000..702da7e23084
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nft_conntrack_reject_established.sh
@@ -0,0 +1,322 @@
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
+	echo "SKIP: No virtual ethernet pair device support in kernel"
+	exit $ksft_skip
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
+	if ! ip netns exec "$ns1" ping -c 1 -q 10.0.2.99 > /dev/null; then
+		return 1
+	fi
+
+	if ! ip netns exec "$ns1" ping -c 1 -q dead:2::99 > /dev/null; then
+		return 2
+	fi
+
+	return 0
+}
+
+test_ping_router() {
+	if ! ip netns exec "$ns1" ping -c 1 -q 10.0.2.1 > /dev/null; then
+		return 3
+	fi
+
+	if ! ip netns exec "$ns1" ping -c 1 -q dead:2::1 > /dev/null; then
+		return 4
+	fi
+
+	return 0
+}
+
+check_last_line() {
+	local file="$1"
+	local string="$2"
+
+	local last_line=$(tail -n 1 "$file")
+	# Compare the last line with the given string.
+	if [[ "$last_line" == "$string" ]]; then
+		return 0
+	else
+		return 1
+	fi
+}
+
+test_tcp_connect() {
+	local ns=$1
+	local dest=$2
+	local string=$3
+	local outputfile=$4
+
+	if ! echo "$string" | ip netns exec "$ns" socat -t 2 -T 2 -u STDIO tcp:"$dest" 2> /dev/null ; then
+		return 1
+	fi
+
+	if ! busywait "$BUSYWAIT_TIMEOUT" check_last_line "$outputfile" "$string" &> /dev/null; then
+		return 1
+	else
+		return 0
+	fi
+}
+
+test_tcp_established() {
+	local string=$1
+	local inputfile=$2
+	local outputfile=$3
+	local timeout=$4
+
+	echo "$string" >> "$inputfile"
+	if ! busywait "$timeout" check_last_line "$outputfile" "$string" &> /dev/null; then
+		return 1
+	else
+		return 0
+	fi
+}
+
+process_does_not_exist()
+{
+	local pid=$1
+	if ! kill -0 "$pid" 2>/dev/null ; then
+		return 0
+	else
+		return 1
+	fi
+}
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
+	# request from ns1 to ns2 (direct traffic) should work
+	if ! test_tcp_connect $ns1 $ns2_ip_port PING1 $TMPFILEOUT ; then
+		echo "ERROR: $testname: fail to connect to $ns2_ip_port"
+		ret=1
+	else
+		echo "PASS: $testname: ns1 connected succesfully to $ns2_ip_port"
+	fi
+
+	# set up a persistent connection through DNAT to ns2
+	timeout "$timeout" tail -f $TMPFILEIN | ip netns exec "$ns1" socat STDIO tcp:"$vip_ip_port,sourceport=12345" 2> /dev/null &
+	local client1_pid=$!
+
+	# request from ns1 to vip (DNAT to ns2) on an existing connection
+	# if we don't read from the pipe the traffic loops forever
+	if ! test_tcp_established PING2 $TMPFILEIN $TMPFILEOUT $BUSYWAIT_TIMEOUT ; then
+		echo "ERROR: $testname: fail to connect over the established connection to $vip_ip_port"
+		ret=1
+	else
+		echo "PASS: $testname: ns1 connected succesfully over the established connection to $vip_ip_port"
+	fi
+
+	# request from ns1 to vip (DNAT to ns2) should work
+	if ! test_tcp_connect $ns1 $vip_ip_port PING3 $TMPFILEOUT ; then
+		echo "ERROR: $testname: fail to connect to $vip_ip_port"
+		ret=1
+	else
+		echo "PASS: $testname: ns1 connected succesfully to $vip_ip_port"
+	fi
+
+	# request from ns1 to vip (DNAT to ns2) on an existing connection should work
+	if ! test_tcp_established PING4 $TMPFILEIN $TMPFILEOUT $BUSYWAIT_TIMEOUT ; then
+		echo "ERROR: $testname: fail to connect over the established connection to $vip_ip_port"
+		ret=1
+	else
+		echo "PASS: $testname: ns1 connected succesfully over the established connection to $vip_ip_port"
+	fi
+
+	# add a rule to reject traffic to ns2 virtual ip and port
+	eval "echo \"$test_rules\"" | ip netns exec "$nsrouter" nft -f /dev/stdin
+
+	# request from ns1 to ns2 (direct traffic) must work
+	if ! test_tcp_connect $ns1 $ns2_ip_port PING5 $TMPFILEOUT ; then
+		echo "ERROR: $testname: fail to connect to $ns2_ip_port"
+		ret=1
+	else
+		echo "PASS: $testname: ns1 connected succesfully to $ns2_ip_port"
+	fi
+
+	# request from ns1 to vip (DNAT to ns2) should fail
+	if test_tcp_connect $ns1 $vip_ip_port PING6 $TMPFILEOUT ; then
+		echo "ERROR: $testname: ns1 connected succesfully to $vip_ip_port"
+		ret=1
+	else
+		echo "PASS: $testname: fail to connect to $vip_ip_port"
+	fi
+
+	# request from ns1 to vip (DNAT to ns2) on an existing connection should fail
+	if test_tcp_established PING7 $TMPFILEIN $TMPFILEOUT 100 ; then
+		echo "ERROR: $testname: ns1 connected succesfully to $vip_ip_port"
+		ret=1
+	else
+		echo "PASS: $testname: fail to connect over the established connection to $vip_ip_port"
+	fi
+
+	if busywait 3000 process_does_not_exist "$client1_pid" ; then
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

