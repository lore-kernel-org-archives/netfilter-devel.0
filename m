Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7AB41E260E;
	Wed,  9 Oct 2024 21:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728509948; cv=none; b=hGvTLOxEXvmNr47kmhGV2T665rvt0/NM8kFpEkiUhcW9gyrCCVQeN8w9dwp0bZ5HhWxJRgVidNRz2sgG0TP6rj+U9KIxArk4lXfM/u1tVhzFPlJmhBxFR9VCX2jyrMBituQhjeqkyNDxHQSIMepO7PJygmkgKnUbGv13yufpbE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728509948; c=relaxed/simple;
	bh=4zoZNq9poeHvSsjDP93oEWX2HsZ72OIXz5JR3VwnDkI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UdICVQvDMlQx3FKUXVDx8Rebunidub06gRy/fEUqvHzpUxILdPwJdhbmvxMJZglLTiN74o+0CqF8oOAaMHROaTsD02TaNiHGCcMiJNJ+HUpjR4kN2CMQjndoQYvstM7MV1xZaH5VQW5Ass+iXr8q/83bN1jW57NPYIlIYJAAus4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 3/3] selftests: netfilter: conntrack_vrf.sh: add fib test case
Date: Wed,  9 Oct 2024 23:38:58 +0200
Message-Id: <20241009213858.3565808-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241009213858.3565808-1-pablo@netfilter.org>
References: <20241009213858.3565808-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

meta iifname veth0 ip daddr ... fib daddr oif

... is expected to return "dummy0" interface which is part of same vrf
as veth0.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/net/netfilter/conntrack_vrf.sh  | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_vrf.sh b/tools/testing/selftests/net/netfilter/conntrack_vrf.sh
index 073e8e62d350..e95ecb37c2b1 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_vrf.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_vrf.sh
@@ -32,6 +32,7 @@ source lib.sh
 
 IP0=172.30.30.1
 IP1=172.30.30.2
+DUMMYNET=10.9.9
 PFXL=30
 ret=0
 
@@ -54,6 +55,7 @@ setup_ns ns0 ns1
 ip netns exec "$ns0" sysctl -q -w net.ipv4.conf.default.rp_filter=0
 ip netns exec "$ns0" sysctl -q -w net.ipv4.conf.all.rp_filter=0
 ip netns exec "$ns0" sysctl -q -w net.ipv4.conf.all.rp_filter=0
+ip netns exec "$ns0" sysctl -q -w net.ipv4.conf.all.forwarding=1
 
 if ! ip link add veth0 netns "$ns0" type veth peer name veth0 netns "$ns1" > /dev/null 2>&1; then
 	echo "SKIP: Could not add veth device"
@@ -65,13 +67,18 @@ if ! ip -net "$ns0" li add tvrf type vrf table 9876; then
 	exit $ksft_skip
 fi
 
+ip -net "$ns0" link add dummy0 type dummy
+
 ip -net "$ns0" li set veth0 master tvrf
+ip -net "$ns0" li set dummy0 master tvrf
 ip -net "$ns0" li set tvrf up
 ip -net "$ns0" li set veth0 up
+ip -net "$ns0" li set dummy0 up
 ip -net "$ns1" li set veth0 up
 
 ip -net "$ns0" addr add $IP0/$PFXL dev veth0
 ip -net "$ns1" addr add $IP1/$PFXL dev veth0
+ip -net "$ns0" addr add $DUMMYNET.1/$PFXL dev dummy0
 
 listener_ready()
 {
@@ -212,9 +219,35 @@ EOF
 	fi
 }
 
+test_fib()
+{
+ip netns exec "$ns0" nft -f - <<EOF
+flush ruleset
+table ip t {
+	counter fibcount { }
+
+	chain prerouting {
+		type filter hook prerouting priority 0;
+		meta iifname veth0 ip daddr $DUMMYNET.2 fib daddr oif dummy0 counter name fibcount notrack
+	}
+}
+EOF
+	ip -net "$ns1" route add 10.9.9.0/24 via "$IP0" dev veth0
+	ip netns exec "$ns1" ping -q -w 1 -c 1 "$DUMMYNET".2 > /dev/null
+
+	if ip netns exec "$ns0" nft list counter t fibcount | grep -q "packets 1"; then
+		echo "PASS: fib lookup returned exepected output interface"
+	else
+		echo "FAIL: fib lookup did not return exepected output interface"
+		ret=1
+		return
+	fi
+}
+
 test_ct_zone_in
 test_masquerade_vrf "default"
 test_masquerade_vrf "pfifo"
 test_masquerade_veth
+test_fib
 
 exit $ret
-- 
2.30.2

