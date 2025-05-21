Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76906248861
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 09:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747820416; cv=none; b=C76UeV2N4snZHAAa9f9hAHzrHUUKj8GvCiV5csZhaRm6ukwYZezP959kc2datV0cdq0QbY9gqF8zKtIDJBlfNUjk8REiwseVSR9aVeKwlsbU1408UY9Pz15++eHnXHOCwr2ZJheHe7K9XOd483CkcJKtM9cWmxpBok526XgDtGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747820416; c=relaxed/simple;
	bh=pPmNj16sA1/U8+L/iSWiyvwACs9CmexiMY38vQga8l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mq8vEZv+2ONQp/oc6EKic6P0QWdJVms0nVN7uUb7QIWZq9oniUcptdx+dUh9dYZawcD/3dJbwBdkjWR0QoDn1XqlhyqQlHU4lFbq/yVlRjoJrKxBs/8t9ZXGeJBr5FLNThxjcLALF0jesxZ+SK4xXFI/6ZY+MXUAYVdBYUdO8b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7F02D602AE; Wed, 21 May 2025 11:40:12 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 2/5] selftests: netfilter: move fib vrf test to nft_fib.sh
Date: Wed, 21 May 2025 11:38:46 +0200
Message-ID: <20250521093858.1831-3-fw@strlen.de>
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

It was located in conntrack_vrf.sh because that already had the VRF bits.
Lets not add to this and move it to nft_fib.sh where this belongs.

No functional changes for the subtest intended.
The subtest is limited, it only covered 'fib oif'
(route output interface query) when the incoming interface is part
of a VRF.

Next we can extend it to cover 'fib type' for VRFs and also check fib
results when there is an unrelated VRF in same netns.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/conntrack_vrf.sh  | 34 -------
 .../selftests/net/netfilter/nft_fib.sh        | 90 +++++++++++++++++++
 2 files changed, 90 insertions(+), 34 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_vrf.sh b/tools/testing/selftests/net/netfilter/conntrack_vrf.sh
index 025b58f2ae91..207b79932d91 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_vrf.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_vrf.sh
@@ -32,7 +32,6 @@ source lib.sh
 
 IP0=172.30.30.1
 IP1=172.30.30.2
-DUMMYNET=10.9.9
 PFXL=30
 ret=0
 
@@ -52,8 +51,6 @@ trap cleanup EXIT
 
 setup_ns ns0 ns1
 
-ip netns exec "$ns0" sysctl -q -w net.ipv4.conf.all.forwarding=1
-
 if ! ip link add veth0 netns "$ns0" type veth peer name veth0 netns "$ns1" > /dev/null 2>&1; then
 	echo "SKIP: Could not add veth device"
 	exit $ksft_skip
@@ -64,18 +61,13 @@ if ! ip -net "$ns0" li add tvrf type vrf table 9876; then
 	exit $ksft_skip
 fi
 
-ip -net "$ns0" link add dummy0 type dummy
-
 ip -net "$ns0" li set veth0 master tvrf
-ip -net "$ns0" li set dummy0 master tvrf
 ip -net "$ns0" li set tvrf up
 ip -net "$ns0" li set veth0 up
-ip -net "$ns0" li set dummy0 up
 ip -net "$ns1" li set veth0 up
 
 ip -net "$ns0" addr add $IP0/$PFXL dev veth0
 ip -net "$ns1" addr add $IP1/$PFXL dev veth0
-ip -net "$ns0" addr add $DUMMYNET.1/$PFXL dev dummy0
 
 listener_ready()
 {
@@ -216,35 +208,9 @@ EOF
 	fi
 }
 
-test_fib()
-{
-ip netns exec "$ns0" nft -f - <<EOF
-flush ruleset
-table ip t {
-	counter fibcount { }
-
-	chain prerouting {
-		type filter hook prerouting priority 0;
-		meta iifname veth0 ip daddr $DUMMYNET.2 fib daddr oif dummy0 counter name fibcount notrack
-	}
-}
-EOF
-	ip -net "$ns1" route add 10.9.9.0/24 via "$IP0" dev veth0
-	ip netns exec "$ns1" ping -q -w 1 -c 1 "$DUMMYNET".2 > /dev/null
-
-	if ip netns exec "$ns0" nft list counter t fibcount | grep -q "packets 1"; then
-		echo "PASS: fib lookup returned exepected output interface"
-	else
-		echo "FAIL: fib lookup did not return exepected output interface"
-		ret=1
-		return
-	fi
-}
-
 test_ct_zone_in
 test_masquerade_vrf "default"
 test_masquerade_vrf "pfifo"
 test_masquerade_veth
-test_fib
 
 exit $ret
diff --git a/tools/testing/selftests/net/netfilter/nft_fib.sh b/tools/testing/selftests/net/netfilter/nft_fib.sh
index 4b93e4954536..f636ad781033 100755
--- a/tools/testing/selftests/net/netfilter/nft_fib.sh
+++ b/tools/testing/selftests/net/netfilter/nft_fib.sh
@@ -252,6 +252,23 @@ test_ping() {
   return 0
 }
 
+test_ping_unreachable() {
+  local daddr4=$1
+  local daddr6=$2
+
+  if ip netns exec "$ns1" ping -c 1 -w 1 -q "$daddr4" > /dev/null; then
+	echo "FAIL: ${ns1} could reach $daddr4" 1>&2
+	return 1
+  fi
+
+  if ip netns exec "$ns1" ping -c 1 -w 1 -q "$daddr6" > /dev/null; then
+	echo "FAIL: ${ns1} could reach $daddr6" 1>&2
+	return 1
+  fi
+
+  return 0
+}
+
 test_fib_type() {
 	local notice="$1"
 	local errmsg="addr-on-if"
@@ -295,6 +312,77 @@ test_fib_type() {
 	fi
 }
 
+test_fib_vrf_dev_add_dummy()
+{
+	if ! ip -net "$nsrouter" link add dummy0 type dummy ;then
+		echo "SKIP: VRF tests: dummy device type not supported"
+		return 1
+	fi
+
+	if ! ip -net "$nsrouter" link add tvrf type vrf table 9876;then
+		echo "SKIP: VRF tests: vrf device type not supported"
+		return 1
+	fi
+
+	ip -net "$nsrouter" link set veth0 master tvrf
+	ip -net "$nsrouter" link set dummy0 master tvrf
+	ip -net "$nsrouter" link set dummy0 up
+	ip -net "$nsrouter" link set tvrf up
+}
+
+# Extends nsrouter config by adding dummy0+vrf.
+#
+#  10.0.1.99     10.0.1.1           10.0.2.1         10.0.2.99
+# dead:1::99    dead:1::1          dead:2::1        dead:2::99
+# ns1 <-------> [ veth0 ] nsrouter [veth1] <-------> ns2
+#                         [dummy0]
+#                         10.9.9.1
+#                        dead:9::1
+#                          [tvrf]
+test_fib_vrf()
+{
+	local dummynet="10.9.9"
+	local dummynet6="dead:9"
+	local cntname=""
+
+	if ! test_fib_vrf_dev_add_dummy; then
+		[ $ret -eq 0 ] && ret=$ksft_skip
+		return
+	fi
+
+	ip -net "$nsrouter" addr add "$dummynet.1"/24 dev dummy0
+	ip -net "$nsrouter" addr add "${dummynet6}::1"/64 dev dummy0 nodad
+
+
+ip netns exec "$nsrouter" nft -f - <<EOF
+flush ruleset
+table inet t {
+	counter fibcount4 { }
+	counter fibcount6 { }
+
+	chain prerouting {
+		type filter hook prerouting priority 0;
+		meta iifname veth0 ip daddr ${dummynet}.2 fib daddr oif dummy0 counter name fibcount4
+		meta iifname veth0 ip6 daddr ${dummynet6}::2 fib daddr oif dummy0 counter name fibcount6
+	}
+}
+EOF
+	# no echo reply for these addresses: The dummy interface is part of tvrf,
+	test_ping_unreachable "$dummynet.2" "${dummynet6}::2" &
+
+	wait
+
+	for cntname in fibcount4 fibcount6;do
+		if ip netns exec "$nsrouter" nft list counter inet t "$cntname" | grep -q "packets 1"; then
+			echo "PASS: vrf fib lookup did return expected output interface for $cntname"
+		else
+			ip netns exec "$nsrouter" nft list counter inet t "$cntname"
+			echo "FAIL: vrf fib lookup did not return expected output interface for $cntname"
+			ret=1
+		fi
+	done
+}
+
 ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
@@ -416,4 +504,6 @@ test_fib_type "default table"
 ip netns exec "$nsrouter" nft delete table ip filter
 ip netns exec "$nsrouter" nft delete table ip6 filter
 
+test_fib_vrf
+
 exit $ret
-- 
2.49.0

