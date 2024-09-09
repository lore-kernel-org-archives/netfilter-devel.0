Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41A31BA285
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Sep 2024 14:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725892061; cv=none; b=a9TlyOehdooo+KqRi216C25JgpAeIQFnCfHn3CXQesYyLmdxpX05RekvF1WKRKvdRGJjOr4HiFwB8j5PoNj781UGbkrut1llAa+0g5E3dTVvd27H3G+i22nHAx+gR28ODwiutanwGCa8lJRYAI/xGUfxag5fVJudFxVOzpzJsV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725892061; c=relaxed/simple;
	bh=EM44a/w9zFfmtB3Q+U9UYbVgrGI7bsX0sRoDlgCcLeY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=o6SYayDHz0G0ub5qoxqGZk6QY8IfThmvkQsbM0QGxkVCUauxGvgBn0gp8nNCuaOUB5Pfg7CEUUBasIgOwazpDDuhlwGpPHNCnVG8Ed1COBvG78OfnuBcwKWDWAqDNo6J3bKgW1PbQKf0Jsi7DSH5ed8KQfq7RNIJGkqnkeq3KRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2qKQkSf+; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2qKQkSf+"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6d7124939beso138206597b3.2
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Sep 2024 07:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725892059; x=1726496859; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pkUWus3kJmandrqsv0GCa7aVXbFpb2ykNRuGccSSiZw=;
        b=2qKQkSf+OBMqoUJ9JiNgtFi4kgqL1HoHu7W13prKU55bYU1iwczDRCUAt94x7Io29T
         cjvU7YjFzebZ+YQAdg7kX5JV4iwFi4bcvya2Y0g7oF+H8PfppWUtIZOt9vOU3TdDEKy6
         oTE1QSJJteMXeyo7ytxvd8nKg5cw/n0c5ttYxtfnNIq6RgQpXGvZbbIWPLuorUdS3VUK
         BFNbJr6Soc7AY5Og8sWpOKEYmvw8G6Fbe734ASbEw+DvX7XAEPiGn8P3vsgPAw6KEnk2
         Fd/FuN8jDmc0x2adQ+/Jl+mzs+nDyX405hc0Ger9uvi9FSSF1STUqUtRKA31ss7H4n2z
         twZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725892059; x=1726496859;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pkUWus3kJmandrqsv0GCa7aVXbFpb2ykNRuGccSSiZw=;
        b=kFIy6cisYCg2vFir0rIWZA3Idk9jvXLixpxGI+Bzog7aFfHW5tm5Ak1so0H+ga/Eur
         asZE7odV5B6en6r9agrQ8/k6vbzHt3EkS7hT2jd69+GAcIXVXAz0EzhudIIiaD6YXxcm
         3h1W7aTGhvTUIWoYWUFKzFCU026Gh0Md8P9PqmEQhStnHPOFK44GlJ2YD+LBnN34ic28
         9p/1QMD4BWqwb/1wS5usIgxj1U5nDL8xj8jVASPmxqWP72mehTCYtgOgDkjS+MMoBLcR
         rYIkSQDutdxfhcZF362QAzwWFDrTG0DeYlgpFZLndnn7CkPUF9lbyQSHT5OKLapso7JX
         S6eg==
X-Forwarded-Encrypted: i=1; AJvYcCV+4N8UZPx35YALcu1sAXQmZNAezqKdszhCnsFAX0vBG0h2PS91kO/P+Ndbo3Jcx1FHGMRNh2cpkiM0MHLa3AY=@vger.kernel.org
X-Gm-Message-State: AOJu0YztqEs9xSyOolL2Q5aV9/JGYFOLYWWgg66gN1/tsvrcxfZXNx+n
	7whQU7Ea8zZ+CBPCkuJacTy4kv4H600M80D5u0oBZmY84wSQxUxurKRoBByZ/Vo+dZSp7EUV+w=
	=
X-Google-Smtp-Source: AGHT+IGvzK/IiLIIeFuqiFDTDsQwJlxMYp/qjlSrKc2Kf4YPZxieQC/eWAy1CTMnCm0biwZI8OahfKx1NA==
X-Received: from aojea.c.googlers.com ([fda3:e722:ac3:cc00:b9:d560:ac1c:71ab])
 (user=aojea job=sendgmr) by 2002:a05:690c:448a:b0:663:ddc1:eab8 with SMTP id
 00721157ae682-6db45154765mr2398807b3.4.1725892058845; Mon, 09 Sep 2024
 07:27:38 -0700 (PDT)
Date: Mon,  9 Sep 2024 14:27:30 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240909142730.734565-1-aojea@google.com>
Subject: [PATCH] selftests: netfilter: nft_tproxy.sh: add tcp tests
From: Antonio Ojea <aojea@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org, 
	Antonio Ojea <aojea@google.com>
Content-Type: text/plain; charset="UTF-8"

The TPROXY functionality is widely used, however, there are only mptcp
selftests covering this feature.

The selftests represent the most common scenarios and can also be used
as selfdocumentation of the feature.

UDP tests are left for a future patch since present some technical
challenges due to the connectionless nature of the protocol.

Signed-off-by: Antonio Ojea <aojea@google.com>
---
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../selftests/net/netfilter/nft_tproxy.sh     | 367 ++++++++++++++++++
 2 files changed, 368 insertions(+)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_tproxy.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index d13fb5ea3e89..f378344f59cc 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -26,6 +26,7 @@ TEST_PROGS += nft_nat.sh
 TEST_PROGS += nft_nat_zones.sh
 TEST_PROGS += nft_queue.sh
 TEST_PROGS += nft_synproxy.sh
+TEST_PROGS += nft_tproxy.sh
 TEST_PROGS += nft_zones_many.sh
 TEST_PROGS += rpath.sh
 TEST_PROGS += xt_string.sh
diff --git a/tools/testing/selftests/net/netfilter/nft_tproxy.sh b/tools/testing/selftests/net/netfilter/nft_tproxy.sh
new file mode 100755
index 000000000000..dc68aa615c7b
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nft_tproxy.sh
@@ -0,0 +1,367 @@
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
+# shellcheck disable=SC2162,SC2317
+
+source lib.sh
+ret=0
+timeout=5
+
+cleanup()
+{
+        ip netns pids "$ns1" | xargs kill 2>/dev/null
+        ip netns pids "$ns2" | xargs kill 2>/dev/null
+        ip netns pids "$ns3" | xargs kill 2>/dev/null
+        ip netns pids "$nsrouter" | xargs kill 2>/dev/null
+
+        cleanup_all_ns
+}
+
+checktool "nft --version" "test without nft tool"
+checktool "socat -h" "run test without socat"
+
+trap cleanup EXIT
+
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
+        return 1
+  fi
+
+  if ! ip netns exec "$ns1" ping -c 1 -q dead:2::99 > /dev/null; then
+        return 2
+  fi
+
+  if ! ip netns exec "$ns1" ping -c 1 -q 10.0.3.99 > /dev/null; then
+        return 1
+  fi
+
+  if ! ip netns exec "$ns1" ping -c 1 -q dead:3::99 > /dev/null; then
+        return 2
+  fi
+
+  return 0
+}
+
+test_ping_router() {
+  if ! ip netns exec "$ns1" ping -c 1 -q 10.0.2.1 > /dev/null; then
+        return 3
+  fi
+
+  if ! ip netns exec "$ns1" ping -c 1 -q dead:2::1 > /dev/null; then
+        return 4
+  fi
+
+  return 0
+}
+
+
+listener_ready()
+{
+        local ns="$1"
+        local port="$2"
+        local proto="$3"
+        ss -N "$ns" -ln "$proto" -o "sport = :$port" | grep -q "$port"
+}
+
+test_tproxy()
+{
+        local traffic_origin="$1"
+	local ip_proto="$2"
+        local proto="$3"
+        local expect_ns1_ns2="$4"
+        local expect_ns1_ns3="$5"
+        local expect_nsrouter_ns2="$6"
+        local expect_nsrouter_ns3="$7"
+
+	# derived variables
+	local testname="test_${ip_proto}_${proto}_${traffic_origin}"
+        local tproxy_listener
+	local server_listener
+	local ns2_ip
+	local ns3_ip
+	local ns2_target
+	local ns3_target
+	local nftables_subject
+	local ip_command
+
+        # socat 1.8.0 has a bug that requires to specify the IP family to bind (fixed in 1.8.0.1)
+	case $ip_proto in
+	"ip")
+		tproxy_listener="$proto"4-listen:12345,fork,ip-transparent
+		server_listener="$proto"4-listen:8080,fork
+		ns2_ip=10.0.2.99
+		ns3_ip=10.0.3.99
+		ns2_target="$proto":"$ns2_ip":8080
+		ns3_target="$proto":"$ns3_ip":8080
+		nftables_subject="ip daddr $ns2_ip $proto dport 8080"
+		ip_command="ip"
+	;;
+	"ip6")
+		tproxy_listener="$proto"6-listen:12345,fork,ip-transparent
+		server_listener="$proto"6-listen:8080,fork
+		ns2_ip=dead:2::99
+		ns3_ip=dead:3::99
+		ns2_target="$proto":["$ns2_ip"]:8080
+		ns3_target="$proto":["$ns3_ip"]:8080
+		nftables_subject="ip6 daddr $ns2_ip $proto dport 8080"
+		ip_command="ip -6"
+        ;;
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
+        chain divert {
+                type filter hook prerouting priority 0; policy accept;
+                $nftables_subject tproxy $ip_proto to :12345 meta mark set 1 accept
+        }
+        chain output {
+                type route hook output priority 0; policy accept;
+                $nftables_subject meta mark set 1 accept
+        }
+}"
+	;;
+	"forward")
+		nftables_rules="
+flush ruleset
+table inet filter {
+        chain divert {
+                type filter hook prerouting priority 0; policy accept;
+                $nftables_subject tproxy $ip_proto to :12345 meta mark set 1 accept
+        }
+}"
+	;;
+	*)
+	echo "FAIL: unsupported parameter for traffic origin"
+	exit 255
+	;;
+	esac
+
+	# shellcheck disable=SC2046 # Intended splitting of ip_command
+        ip netns exec "$nsrouter" $ip_command rule add fwmark 1 table 100
+        ip netns exec "$nsrouter" $ip_command route add local "${ns2_ip}" dev lo table 100
+        echo "$nftables_rules" | ip netns exec "$nsrouter" nft -f /dev/stdin
+
+        timeout "$timeout" ip netns exec "$nsrouter" socat "$tproxy_listener" SYSTEM:"echo PROXIED" 2>/dev/null &
+        local tproxy_pid=$!
+
+        timeout "$timeout" ip netns exec "$ns2" socat "$server_listener" SYSTEM:"echo PONG_NS2" 2>/dev/null &
+        local server2_pid=$!
+
+        timeout "$timeout" ip netns exec "$ns3" socat "$server_listener" SYSTEM:"echo PONG_NS3" 2>/dev/null &
+        local server3_pid=$!
+
+        busywait "$BUSYWAIT_TIMEOUT" listener_ready "$nsrouter" 12345 "-t"
+        busywait "$BUSYWAIT_TIMEOUT" listener_ready "$ns2" 8080 "-t"
+        busywait "$BUSYWAIT_TIMEOUT" listener_ready "$ns3" 8080 "-t"
+
+        local result
+        # request from ns1 to ns2 (forwarded traffic)
+        result=$(echo PING | ip netns exec "$ns1" socat -t 2 -T 2 STDIO "$ns2_target")
+        if [ "$result" == "$expect_ns1_ns2" ] ;then
+                echo "PASS: tproxy test $testname: ns1 got reply \"$result\" connecting to ns2"
+        else
+                echo "ERROR: tproxy test $testname: ns1 got reply \"$result\" connecting to ns2, not \"${expect_ns1_ns2}\" as intended"
+                ret=1
+        fi
+
+        # request from ns1 to ns2 (forwarded traffic)
+        result=$(echo PING | ip netns exec "$ns1" socat -t 2 -T 2 STDIO "$ns3_target")
+        if [ "$result" = "$expect_ns1_ns3" ] ;then
+                echo "PASS: tproxy test $testname: ns1 got reply \"$result\" connecting to ns3"
+        else
+                echo "ERROR: tproxy test $testname: ns1 got reply \"$result\" connecting to ns3, not \"$expect_ns1_ns3\" as intended"
+                ret=1
+        fi
+
+        # request from nsrouter to ns2 (localy originated traffic)
+        result=$(echo PING | ip netns exec "$nsrouter" socat -t 2 -T 2 STDIO "$ns2_target")
+        if [ "$result" == "$expect_nsrouter_ns2" ] ;then
+                echo "PASS: tproxy test $testname: nsrouter got reply \"$result\" connecting to ns2"
+        else
+                echo "ERROR: tproxy test $testname: nsrouter got reply \"$result\" connecting to ns2, not \"$expect_nsrouter_ns2\" as intended"
+                ret=1
+        fi
+
+        # request from nsrouter to ns3 (localy originated traffic)
+        result=$(echo PING | ip netns exec "$nsrouter" socat -t 2 -T 2 STDIO "$ns3_target")
+        if [ "$result" = "$expect_nsrouter_ns3" ] ;then
+                echo "PASS: tproxy test $testname: nsrouter got reply \"$result\" connecting to ns3"
+        else
+                echo "ERROR: tproxy test $testname: nsrouter got reply \"$result\" connecting to ns3, not \"$expect_nsrouter_ns3\"  as intended"
+                ret=1
+        fi
+
+	# cleanup
+        kill "$tproxy_pid" "$server2_pid" "$server3_pid" 2>/dev/null
+	# shellcheck disable=SC2046 # Intended splitting of ip_command
+        ip netns exec "$nsrouter" $ip_command rule del fwmark 1 table 100
+        ip netns exec "$nsrouter" $ip_command route flush table 100
+}
+
+
+test_ipv4_tcp_forward()
+{
+        local traffic_origin="forward"
+        local ip_proto="ip"
+        local proto="tcp"
+        local expect_ns1_ns2="PROXIED"
+        local expect_ns1_ns3="PONG_NS3"
+        local expect_nsrouter_ns2="PONG_NS2"
+        local expect_nsrouter_ns3="PONG_NS3"
+
+        test_tproxy     "$traffic_origin" \
+                        "$ip_proto" \
+                        "$proto" \
+                        "$expect_ns1_ns2" \
+                        "$expect_ns1_ns3" \
+                        "$expect_nsrouter_ns2" \
+                        "$expect_nsrouter_ns3"
+}
+
+test_ipv4_tcp_local()
+{
+        local traffic_origin="local"
+        local ip_proto="ip"
+        local proto="tcp"
+        local expect_ns1_ns2="PROXIED"
+        local expect_ns1_ns3="PONG_NS3"
+        local expect_nsrouter_ns2="PROXIED"
+        local expect_nsrouter_ns3="PONG_NS3"
+
+        test_tproxy     "$traffic_origin" \
+                        "$ip_proto" \
+                        "$proto" \
+                        "$expect_ns1_ns2" \
+                        "$expect_ns1_ns3" \
+                        "$expect_nsrouter_ns2" \
+                        "$expect_nsrouter_ns3"
+}
+
+test_ipv6_tcp_forward()
+{
+        local traffic_origin="forward"
+        local ip_proto="ip6"
+        local proto="tcp"
+        local expect_ns1_ns2="PROXIED"
+        local expect_ns1_ns3="PONG_NS3"
+        local expect_nsrouter_ns2="PONG_NS2"
+        local expect_nsrouter_ns3="PONG_NS3"
+
+        test_tproxy     "$traffic_origin" \
+                        "$ip_proto" \
+                        "$proto" \
+                        "$expect_ns1_ns2" \
+                        "$expect_ns1_ns3" \
+                        "$expect_nsrouter_ns2" \
+                        "$expect_nsrouter_ns3"
+}
+
+test_ipv6_tcp_local()
+{
+        local traffic_origin="local"
+        local ip_proto="ip6"
+        local proto="tcp"
+        local expect_ns1_ns2="PROXIED"
+        local expect_ns1_ns3="PONG_NS3"
+        local expect_nsrouter_ns2="PROXIED"
+        local expect_nsrouter_ns3="PONG_NS3"
+
+        test_tproxy     "$traffic_origin" \
+                        "$ip_proto" \
+                        "$proto" \
+                        "$expect_ns1_ns2" \
+                        "$expect_ns1_ns3" \
+                        "$expect_nsrouter_ns2" \
+                        "$expect_nsrouter_ns3"
+}
+
+if test_ping; then
+        # queue bypass works (rules were skipped, no listener)
+        echo "PASS: ${ns1} can reach ${ns2}"
+else
+        echo "FAIL: ${ns1} cannot reach ${ns2}: $ret" 1>&2
+        exit $ret
+fi
+
+test_ipv4_tcp_forward
+test_ipv4_tcp_local
+test_ipv6_tcp_forward
+test_ipv6_tcp_local
+# TODO: udp tests
+# The tproxy functionality works, socat receives the packet but does not
+# reuse the original IP and port hence the return packet is rejected with
+# an icmp port unreachable
+
+exit $ret
-- 
2.46.0.469.g59c65b2a67-goog

