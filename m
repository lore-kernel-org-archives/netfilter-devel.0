Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C02E1898ED
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 08:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728462909; cv=none; b=oSqr08d5M/MIZc0zs4ghoaz58RaDPjUUIJjvoNwU4b42c/NsyLvd5veSu1TCUcmx0g51vfitBNlCMZ5stNThkOtxUOXfoY6bQBsVqFNqQBd8lciuoPPmrLKlIyrks8MYGtR8uMd/0FCGxWktfJKHH6d6ZF3jLwvDbQ2LYQJQmp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728462909; c=relaxed/simple;
	bh=+Hk43T8rFee8POo8guprLWpO8eIq6vVVnh+Z4kYp0nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhNZOmXUekeQWVi5Yo4pL6lvGo6XgKNUdD7//xraWPTJAV0RCwG38/fRfL23g/D8lvhdGWio7JXf52AeolNRsiYLcQ0yQyLLtKL5f7okXzWpBJ1gzMhzdr36JEBdP7IJeevkJHZWzqINzl08afxq5Kf9E/HAdeBq+RWcYnJ7xOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1syS9w-0002py-5D; Wed, 09 Oct 2024 10:35:04 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/2] selftests: netfilter: conntrack_vrf.sh: add fib test case
Date: Wed,  9 Oct 2024 09:19:03 +0200
Message-ID: <20241009071908.17644-2-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241009071908.17644-1-fw@strlen.de>
References: <20241009071908.17644-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  meta iifname veth0 ip daddr ... fib daddr oif

... is expected to return "dummy0" interface which is part of same vrf
as veth0.

Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.46.2

