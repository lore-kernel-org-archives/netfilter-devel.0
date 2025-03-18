Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE981422AB
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Mar 2025 09:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742290916; cv=none; b=trLDVzuan4Z2uRotZMYHo4jsCT5tFKR0vrZ5MHA6W7qWnuSorThqZbSILrvB97nnpiKFOnpi0iSt+aSrYNblGssWCp1iSapHgi5MOZRoxL85E4CC1XOL1moI6gy6jKzGZeDuX4BOwy8ngPBTVz6d6GaGDbS3D4bM25a/gShnWPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742290916; c=relaxed/simple;
	bh=J0TrbMNH15CYP6qn8dC+f8U2qUKxFmbnnJRgjkhIbQc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Dz7RnmjybVBRBPJnu2GSRfxXM/CZp6hc2gzxxwiAdISBDNFTzXWJmK5OXKjaJYDfjzfOO1AouosHWo7EO+4tUgsF0XHak6smPsBdPcxc3ohBkuxL7hofovSIs7xmCfsOVOw2PEa27V6/Cfs3KxlVxDI/B2bMfiUtOstdvIUOLvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EwrRD9Jv; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EwrRD9Jv"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5d9e4d33f04so4720627a12.0
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Mar 2025 02:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742290909; x=1742895709; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zk0pVCGdbcjp2+oJPrk9OZ55/P2Qm7eumSMivxhWyyY=;
        b=EwrRD9JvN3oDREfYYQ4Ieu03eeCnFVHYl3M6jo0lOVUoEDDllCt8Gc07CK/9Xyksys
         Uv0dVsv0xZmWGxEIH3TGRX39D/cAnnSE8JZPa9kkpWsQHLr2voLP3IBc896M8NJ2DqK+
         2KV9VD5PpOvOksIw3INcJF6RUi8vle3AK6H3Y9p2Fgwn93Q2B+bUaStRtasOSzBcVa4E
         T3r9ObqlGuga6N5QL2V5/Gs3KkVnLVkkB1XW6Ggfkjb5mNJr9OOQqA9ohFbHV34eTiHe
         8GXhc8EVHgjoss1RytQsm906VMQcIOUg9WxkaCxQ1X1WQhCJcWK4gDRIlMLtGVoRzF1a
         0JXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742290909; x=1742895709;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zk0pVCGdbcjp2+oJPrk9OZ55/P2Qm7eumSMivxhWyyY=;
        b=b9IBWI5T08kskNWW46uD/8BxtlPejVAdPB8Yovs9eb4MyxoDsfLzfRUxPGDNajISsQ
         5nGI0IbgGDskbd97UEiO7F3kmPPLu3OwtF6YzTA+lI6yvb2lUr/kBPG09jA9IvinDesM
         SUG9a8L8iAJ5dNOd3TfJ6Y33hM+cJWmKJttfiuNpXUJ/QE9VsPNYYJO6J/W37YMqk80o
         9HGO/HX9cnKSmU0IsbQ3oRGW5JPTGopUP25wUTYvXBsX8CuC/UcjEfHFaEgKzunpi6vx
         fIOx64n40qyQHkh0OOA9D+DOoy+BfrmOVZcJtpcPvONb+DhhRLNVZiT3lg/5WNcDvC5P
         l3Fg==
X-Forwarded-Encrypted: i=1; AJvYcCVU/TXBmg2uaLncIZrybHWH9W08iEQp9ryk8/77HlxMe3WU2aGscxfcoXdzegZMHQ7K5+hv0tR2DpxHEVys8ZY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSA6R6RmsVM6uR8shxOjxJakYw08nIVfTfN5hp11pH9Uwj/0Wk
	Cb3lFzpNEM9tw+goLmriWP17vAwIMFAxpmBuBQK5CurnHP2zIpwUg9y/ZAi1HDNgJE6U/Ay+QQ=
	=
X-Google-Smtp-Source: AGHT+IEXYj1NQFkUF5Pwp2GO711AdW+23B/xAJnYPWTUVaR0AvjB49BFMcunABVHX0ObvmrkmD49e4eS9g==
X-Received: from edap25.prod.google.com ([2002:a05:6402:5019:b0:5e5:be0b:5f20])
 (user=aojea job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:27cb:b0:5e7:9359:58cb
 with SMTP id 4fb4d7f45d1cf-5eb1deca033mr2958338a12.11.1742290909067; Tue, 18
 Mar 2025 02:41:49 -0700 (PDT)
Date: Tue, 18 Mar 2025 09:41:38 +0000
In-Reply-To: <20250313231341.3040002-1-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250313231341.3040002-1-aojea@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318094138.3328627-1-aojea@google.com>
Subject: [PATCH v3] selftests: netfilter: conntrack respect reject rules
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
---
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 tools/testing/selftests/net/netfilter/config  |   1 +
 .../nft_conntrack_reject_established.sh       | 312 ++++++++++++++++++
 3 files changed, 314 insertions(+)
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
index 000000000000..05d51b543a30
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nft_conntrack_reject_established.sh
@@ -0,0 +1,312 @@
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
+	if test_tcp_established PING7 $TMPFILEIN $TMPFILEOUT 1 ; then
+		echo "ERROR: $testname: ns1 connected succesfully to $vip_ip_port"
+		ret=1
+	else
+		echo "PASS: $testname: fail to connect over the established connection to $vip_ip_port"
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

