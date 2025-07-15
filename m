Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4422D46CB
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Jul 2025 09:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752571168; cv=none; b=pZvrGgC+zZPPYXoCcLPWgI+uZ0OhB2xVGKeFVd8c63KlOv1KfZR5S6RpbkppYb5i/yPXhyAvF4I/D78M1rRjS1HJYeTTfs/EvNhibycV9BtsLc6+yDZLZOVAM7y70OitCb6uNGLEPeLQRimD4OwGNoUqZvj9dAsLz8SFD2I/aXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752571168; c=relaxed/simple;
	bh=qG6wLU8i+JF7xYGEzWmCOWXLWIkgkhZv8DlWRXXrG3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qDH/JIBtwNU5MXu33eTHQpubi/LiMiu53CwmJoHK5g/fQuRchsGqMzTwSm4J7fZ00fvNb1FSPoIiE5fFiuJLCJnkfGS1v+kE+6rK4RzArQErbG0j4BS5+mmjSjH4wFFCeuyWC7C3qijUDvjzCWmYJ9UafuImMLoAPhBpXt65gfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eTZNG8k6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eTZNG8k6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752571165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=R5Zo3Qz+/JSqrIqZ0VGhTLm3hexFeESuMhYi9NRfon8=;
	b=eTZNG8k6Mqlx5+9lsw4FejzlbUEFSVQxMc4UKc6u1Jaesxd33T1uTGmb2BcFhval8wLavo
	OMq45qt0wex95A8HKm0QR81X6/qMWQpF/1UPyWA0Dvckcld6c0pEoNlx4yJg3yUJqpKKFX
	4TPcxTloW8HRAWH4nMsq03WVNxNi+X8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644--cOHXMiGOdOXjfxu4GqDYg-1; Tue,
 15 Jul 2025 05:19:22 -0400
X-MC-Unique: -cOHXMiGOdOXjfxu4GqDYg-1
X-Mimecast-MFC-AGG-ID: -cOHXMiGOdOXjfxu4GqDYg_1752571161
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3217B1800290;
	Tue, 15 Jul 2025 09:19:21 +0000 (UTC)
Received: from yiche-laptop.redhat.com (unknown [10.72.116.100])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0763318046C3;
	Tue, 15 Jul 2025 09:19:18 +0000 (UTC)
From: Yi Chen <yiche@redhat.com>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH] tests: shell: add type route chain test case
Date: Tue, 15 Jul 2025 17:19:13 +0800
Message-ID: <20250715091916.24403-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

This test case verifies the functionality of nft type route chain
when used with policy routing based on dscp and fwmark.

Signed-off-by: Yi Chen <yiche@redhat.com>
---
 .../packetpath/dumps/type_route_chain.nodump  |   0
 .../testcases/packetpath/type_route_chain     | 201 ++++++++++++++++++
 2 files changed, 201 insertions(+)
 create mode 100644 tests/shell/testcases/packetpath/dumps/type_route_chain.nodump
 create mode 100755 tests/shell/testcases/packetpath/type_route_chain

diff --git a/tests/shell/testcases/packetpath/dumps/type_route_chain.nodump b/tests/shell/testcases/packetpath/dumps/type_route_chain.nodump
new file mode 100644
index 00000000..e69de29b
diff --git a/tests/shell/testcases/packetpath/type_route_chain b/tests/shell/testcases/packetpath/type_route_chain
new file mode 100755
index 00000000..b4052fd9
--- /dev/null
+++ b/tests/shell/testcases/packetpath/type_route_chain
@@ -0,0 +1,201 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_tcpdump)
+
+. $NFT_TEST_LIBRARY_FILE
+
+cleanup()
+{
+	for i in $C $S $R1 $R2 $B0 $B1;do
+		kill $(ip netns pid $i) 2>/dev/null
+		ip netns del $i
+	done
+	rm -rf $WORKDIR
+}
+trap cleanup EXIT
+
+#     r1_ route1 r1_
+#      │          │
+# s_──br0        br1──c_
+#      │          │
+#     r2_ route2 r2_
+
+rnd=$(mktemp -u XXXXXXXX)
+C="route-type-chain-client-$rnd"
+S="route-type-chain-server-$rnd"
+R1="route-type-chain-route1-$rnd"
+R2="route-type-chain-route2-$rnd"
+B0="route-type-chain-bridge0-$rnd"
+B1="route-type-chain-bridge1-$rnd"
+WORKDIR="/tmp/route-type-chain-$rnd"
+
+umask 022
+mkdir -p "$WORKDIR"
+assert_pass "mkdir $WORKDIR"
+
+ip netns add $S
+ip netns add $C
+ip netns add $R1
+ip netns add $R2
+ip netns add $B0
+ip netns add $B1
+
+ip -net $S  link set lo up
+ip -net $C  link set lo up
+ip -net $R1 link set lo up
+ip -net $R2 link set lo up
+ip -net $B0 link set lo up
+ip -net $B1 link set lo up
+
+ip -n $B0 link add br0 up type bridge
+ip -n $B1 link add br1 up type bridge
+
+ip link add s_br0  up netns $S  type veth peer name br0_s  netns $B0
+ip link add c_br1  up netns $C  type veth peer name br1_c  netns $B1
+ip link add r1_br0 up netns $R1 type veth peer name br0_r1 netns $B0
+ip link add r1_br1 up netns $R1 type veth peer name br1_r1 netns $B1
+ip link add r2_br0 up netns $R2 type veth peer name br0_r2 netns $B0
+ip link add r2_br1 up netns $R2 type veth peer name br1_r2 netns $B1
+
+ip -n $B0 link set br0_s  up master br0
+ip -n $B0 link set br0_r1 up master br0
+ip -n $B0 link set br0_r2 up master br0
+ip -n $B1 link set br1_c  up master br1
+ip -n $B1 link set br1_r1 up master br1
+ip -n $B1 link set br1_r2 up master br1
+
+ip6_s_br0=2000::1
+ip6_r1_br0=2000::a
+ip6_r2_br0=2000::b
+ip6_c_br1=2001::1
+ip6_r1_br1=2001::a
+ip6_r2_br1=2001::b
+
+ip netns exec $R1 sysctl -wq net.ipv6.conf.all.forwarding=1
+ip netns exec $R2 sysctl -wq net.ipv6.conf.all.forwarding=1
+
+ip -n $S  addr add ${ip6_s_br0}/64  dev s_br0  nodad
+ip -n $C  addr add ${ip6_c_br1}/64  dev c_br1  nodad
+ip -n $R1 addr add ${ip6_r1_br0}/64 dev r1_br0 nodad
+ip -n $R1 addr add ${ip6_r1_br1}/64 dev r1_br1 nodad
+ip -n $R2 addr add ${ip6_r2_br0}/64 dev r2_br0 nodad
+ip -n $R2 addr add ${ip6_r2_br1}/64 dev r2_br1 nodad
+
+ip -n $S route add default via ${ip6_r1_br0} dev s_br0
+ip -n $C route add default via ${ip6_r1_br1} dev c_br1
+
+ip4_s_br0=192.168.0.1
+ip4_r1_br0=192.168.0.254
+ip4_r2_br0=192.168.0.253
+ip4_c_br1=192.168.1.1
+ip4_r1_br1=192.168.1.254
+ip4_r2_br1=192.168.1.253
+
+ip netns exec $R1 sysctl -wq net.ipv4.conf.all.forwarding=1
+ip netns exec $R2 sysctl -wq net.ipv4.conf.all.forwarding=1
+
+ip -n $S  addr add ${ip4_s_br0}/24  dev s_br0
+ip -n $C  addr add ${ip4_c_br1}/24  dev c_br1
+ip -n $R1 addr add ${ip4_r1_br0}/24 dev r1_br0
+ip -n $R1 addr add ${ip4_r1_br1}/24 dev r1_br1
+ip -n $R2 addr add ${ip4_r2_br0}/24 dev r2_br0
+ip -n $R2 addr add ${ip4_r2_br1}/24 dev r2_br1
+
+ip -n $S route add default via ${ip4_r1_br0} dev s_br0
+ip -n $C route add default via ${ip4_r1_br1} dev c_br1
+
+ip netns exec $C ping -W 10 ${ip4_s_br0} -c2 > /dev/null
+assert_pass "topo ipv4 initialization"
+ip netns exec $C ping -W 10 ${ip6_s_br0} -c2 > /dev/null
+assert_pass "topo ipv6 initialization"
+
+check_icmp_in_r1()
+{
+	local dst_addr="$1"
+	local PCAP="${WORKDIR}/$(mktemp -u XXXX).pcap"
+	ip netns exec $R1 tcpdump --immediate-mode -Ui r1_br0 -w ${PCAP} 2>/dev/null &
+	local pid=$!
+	ip netns exec $C ping -W 1 ${dst_addr} -c2 > /dev/null
+	assert_pass "ping pass"
+
+	kill $pid; sync
+	tcpdump -nr ${PCAP} 2> /dev/null| grep -q "echo request"
+	assert_fail "echo request should be routed to r2"
+
+	ip netns exec $R1 tcpdump -nr ${PCAP} 2> /dev/null | grep -q "echo reply"
+	assert_pass "echo relpy was observed"
+}
+
+echo -e "\nTest ipv6 dscp reroute"
+# The last two bits of the DSCP field are reserved for ECN.
+# So nft dscp set 0x02 becomes 0x08 after a left shift by 2,
+# which matches ip rule dsfield 0x08.
+ip -6 -n $C route add default via ${ip6_r2_br1} dev c_br1 table 100
+ip -6 -n $C rule add dsfield 0x08 pref 1010 table 100
+assert_pass "Add ipv6 dscp policy routing rule"
+ip netns exec $C nft -f - <<-EOF
+table inet outgoing {
+	chain output_route {
+		type route hook output priority filter; policy accept;
+		icmpv6 type echo-request ip6 dscp set 0x02 counter
+	}
+}
+EOF
+assert_pass "Restore nft ruleset"
+check_icmp_in_r1 ${ip6_s_br0}
+ip -6 -n $C rule del dsfield 0x08 pref 1010 table 100
+ip -6 -n $C route del default via ${ip6_r2_br1} dev c_br1 table 100
+
+
+echo -e "\nTest ipv4 dscp reroute"
+ip -n $C route add default via ${ip4_r2_br1} dev c_br1 table 100
+ip -n $C rule add dsfield 0x08 pref 1010 table 100
+assert_pass "Add ipv4 dscp policy routing rule"
+ip netns exec $C nft -f - <<-EOF
+table inet outgoing {
+	chain output_route {
+		type route hook output priority filter; policy accept;
+		icmp type echo-request ip dscp set 0x02 counter
+	}
+}
+EOF
+assert_pass "Restore nft ruleset"
+check_icmp_in_r1 ${ip4_s_br0}
+ip -n $C rule del dsfield 0x08 pref 1010 table 100
+ip -n $C route del default via ${ip4_r2_br1} dev c_br1 table 100
+
+
+echo -e "\nTest ipv4 fwmark reroute"
+ip -n $C route add default via ${ip4_r2_br1} dev c_br1 table 100
+ip -n $C rule add fwmark 0x0100 lookup 100
+assert_pass "Add ipv4 fwmark policy routing rule"
+ip netns exec $C nft -f - <<-EOF
+table inet outgoing {
+	chain output_route {
+		type route hook output priority filter; policy accept;
+		icmp type echo-request meta mark set 0x0100 counter
+	}
+}
+EOF
+assert_pass "Restore nft ruleset"
+check_icmp_in_r1 ${ip4_s_br0}
+ip -n $C rule del fwmark 0x0100 lookup 100
+ip -n $C route del default via ${ip4_r2_br1} dev c_br1 table 100
+
+
+echo -e "\nTest ipv6 fwmark reroute"
+ip -6 -n $C route add default via ${ip6_r2_br1} dev c_br1 table 100
+ip -6 -n $C rule add fwmark 0x0100 lookup 100
+assert_pass "Add ipv6 fwmark policy routing rule"
+ip netns exec $C nft -f - <<-EOF
+table inet outgoing {
+	chain output_route {
+		type route hook output priority filter; policy accept;
+		icmpv6 type echo-request meta mark set 0x0100 counter
+	}
+}
+EOF
+assert_pass "Restore nft ruleset"
+check_icmp_in_r1 ${ip6_s_br0}
+ip -6 -n $C rule del fwmark 0x0100 lookup 100
+ip -6 -n $C route del default via ${ip6_r2_br1} dev c_br1 table 100
-- 
2.50.0

