Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6389B1B3F29
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Sep 2024 13:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725887633; cv=none; b=AT0jfVKDQnj00WzuJEjJsGsJm/WVQt8vImxvZVhS8RhrsGoI9rrhcFrRF4115tXElZ1qPr0XzVi1vGo1QUgD67B0hTK7x0waxdiWlCIK8Lgepbh/XuZTTotyMR4YqPxnv/fkrWTtv6VsHcMb2SlgDRSYbEjXatup4w6Bsqoph9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725887633; c=relaxed/simple;
	bh=oRFFnJHQP1PhR5lEjYGLU0+sRyty/Uw3ZIoE9208y0Q=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=PbmSZPtjQCFueDm8hXydL7P7aQ2VArb4E+8hQ2ao2hv6Oq8J2XsRSXoTQy8HNsjZNCKvruOt5p9uxC3EtG2xnfmYG6ZAbAQeknHFnkDQS6wUeM3D4E4faQfIKdPT+ZnnxM9ll1KBPIDGaCnI0qlj5VgfKk99OItwgzVTLXPvMxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] tests: shell: stabilize packetpath/payload
Date: Mon,  9 Sep 2024 15:13:38 +0200
Message-Id: <20240909131339.290879-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- Add sleep calls after setting up container topology.
- Extend TCP connect timeout to 4 seconds. Test has no listener, this is
  just sending SYN packets that are rejected but it works to test the
  payload mangling ruleset.
- fix incorrect logic to check for 0 matching packets through grep.

Fixes: 84da729e067a ("tests: shell: add test to cover payload transport match and mangle")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/packetpath/payload | 64 +++++++++++++-----------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/tests/shell/testcases/packetpath/payload b/tests/shell/testcases/packetpath/payload
index 4c5c42dafa92..1fb86aa94b17 100755
--- a/tests/shell/testcases/packetpath/payload
+++ b/tests/shell/testcases/packetpath/payload
@@ -42,6 +42,8 @@ run_test()
 	ip -net "$ns1" addr add $ns1_addr/$cidr dev veth0
 	ip -net "$ns2" addr add $ns2_addr/$cidr dev veth0
 
+	sleep 3
+
 RULESET="table netdev payload_netdev {
        counter ingress {}
        counter egress {}
@@ -90,33 +92,33 @@ table inet payload_inet {
 
 	ip netns exec "$ns1" $NFT -f - <<< "$RULESET" || exit 1
 
-	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8887,connect-timeout=2 < /dev/null > /dev/null
-	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8888,connect-timeout=2 < /dev/null > /dev/null
+	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8887,connect-timeout=4 < /dev/null > /dev/null
+	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8888,connect-timeout=4 < /dev/null > /dev/null
 
-	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8880,connect-timeout=2 < /dev/null > /dev/null
-	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8881,connect-timeout=2 < /dev/null > /dev/null
+	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8880,connect-timeout=4 < /dev/null > /dev/null
+	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8881,connect-timeout=4 < /dev/null > /dev/null
 
-	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7777,connect-timeout=2 < /dev/null > /dev/null
-	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7778,connect-timeout=2 < /dev/null > /dev/null
+	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7777,connect-timeout=4 < /dev/null > /dev/null
+	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7778,connect-timeout=4 < /dev/null > /dev/null
 
-	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7770,connect-timeout=2 < /dev/null > /dev/null
-	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7771,connect-timeout=2 < /dev/null > /dev/null
+	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7770,connect-timeout=4 < /dev/null > /dev/null
+	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7771,connect-timeout=4 < /dev/null > /dev/null
 
 	ip netns exec "$ns1" $NFT list ruleset
 
-	ip netns exec "$ns1" $NFT list counter netdev payload_netdev ingress | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" $NFT list counter netdev payload_netdev mangle_ingress | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" $NFT list counter netdev payload_netdev mangle_ingress_match | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" $NFT list counter netdev payload_netdev egress | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" $NFT list counter netdev payload_netdev mangle_egress | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" $NFT list counter netdev payload_netdev mangle_egress_match | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter netdev payload_netdev ingress | grep -q "packets 0" && exit 1
+	ip netns exec "$ns1" $NFT list counter netdev payload_netdev mangle_ingress | grep -q "packets 0" && exit 1
+	ip netns exec "$ns1" $NFT list counter netdev payload_netdev mangle_ingress_match | grep -q "packets 0" && exit 1
+	ip netns exec "$ns1" $NFT list counter netdev payload_netdev egress | grep -q "packets 0" && exit 1
+	ip netns exec "$ns1" $NFT list counter netdev payload_netdev mangle_egress | grep -q "packets 0" && exit 1
+	ip netns exec "$ns1" $NFT list counter netdev payload_netdev mangle_egress_match | grep -q "packets 0" && exit 1
 
-	ip netns exec "$ns1" $NFT list counter inet payload_inet input | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" $NFT list counter inet payload_inet mangle_input | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" $NFT list counter inet payload_inet mangle_input_match | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" $NFT list counter inet payload_inet output | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" $NFT list counter inet payload_inet mangle_output | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" $NFT list counter inet payload_inet mangle_output_match | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter inet payload_inet input | grep -q "packets 0" && exit 1
+	ip netns exec "$ns1" $NFT list counter inet payload_inet mangle_input | grep -q "packets 0" && exit 1
+	ip netns exec "$ns1" $NFT list counter inet payload_inet mangle_input_match | grep -q "packets 0" && exit 1
+	ip netns exec "$ns1" $NFT list counter inet payload_inet output | grep -q "packets 0" && exit 1
+	ip netns exec "$ns1" $NFT list counter inet payload_inet mangle_output | grep -q "packets 0" && exit 1
+	ip netns exec "$ns1" $NFT list counter inet payload_inet mangle_output_match | grep -q "packets 0" && exit 1
 
 	#
 	# ... next stage
@@ -135,6 +137,8 @@ table inet payload_inet {
 	ip -net "$ns1" addr add $ns1_addr/$cidr dev br0
 	ip -net "$ns1" link set up dev br0
 
+	sleep 3
+
 RULESET="table bridge payload_bridge {
        counter input {}
        counter output {}
@@ -160,20 +164,20 @@ RULESET="table bridge payload_bridge {
 
 	ip netns exec "$ns1" $NFT -f - <<< "$RULESET" || exit 1
 
-	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8880,connect-timeout=2 < /dev/null > /dev/null
-	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8881,connect-timeout=2 < /dev/null > /dev/null
+	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8880,connect-timeout=4 < /dev/null > /dev/null
+	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8881,connect-timeout=4 < /dev/null > /dev/null
 
-	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7770,connect-timeout=2 < /dev/null > /dev/null
-	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7771,connect-timeout=2 < /dev/null > /dev/null
+	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7770,connect-timeout=4 < /dev/null > /dev/null
+	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7771,connect-timeout=4 < /dev/null > /dev/null
 
 	ip netns exec "$ns1" $NFT list ruleset
 
-	ip netns exec "$ns1" $NFT list counter bridge payload_bridge input | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" $NFT list counter bridge payload_bridge mangle_input | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" $NFT list counter bridge payload_bridge mangle_input_match | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" $NFT list counter bridge payload_bridge output | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" $NFT list counter bridge payload_bridge mangle_output | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" $NFT list counter bridge payload_bridge mangle_output_match | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter bridge payload_bridge input | grep -q "packets 0" && exit 1
+	ip netns exec "$ns1" $NFT list counter bridge payload_bridge mangle_input | grep -q "packets 0" && exit 1
+	ip netns exec "$ns1" $NFT list counter bridge payload_bridge mangle_input_match | grep -q "packets 0" && exit 1
+	ip netns exec "$ns1" $NFT list counter bridge payload_bridge output | grep -q "packets 0" && exit 1
+	ip netns exec "$ns1" $NFT list counter bridge payload_bridge mangle_output | grep -q "packets 0" && exit 1
+	ip netns exec "$ns1" $NFT list counter bridge payload_bridge mangle_output_match | grep -q "packets 0" && exit 1
 }
 
 run_test "4" "10.141.10.2" "10.141.10.3" "24"
-- 
2.30.2

