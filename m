Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2D7823DE;
	Tue, 23 Apr 2024 11:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713870683; cv=none; b=M8eg6z8G9zBO+9Q18UdWukpteFDQwPXD/LQms+A/Ms0RzsPOEb1AgJek09vFL6NeZYt/auqaQpk95SXR4BwsnwDBgWFBwDEK1ktILIE4FmfaSjRV0U9qC6X8nBgotnVTRg4Ed/cFrMA187im+wrBSXPgueo4YpZI6/b2YNy6r00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713870683; c=relaxed/simple;
	bh=/5I5lwIPx9PUX8/fZPeDyG1iBAYxbA5KU6P3hlbkIKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXi4nk3L58SfVr00h5J1D4TWf7AcBP5aiEf7YLYzTQDMx1MPtSxFbbt4igVm0xNgsspQmQDm16AbaUqNWnBIe10AfiHaoSN1U9ZoFYEvjm0EKf8vFdqb9HYjBEOZCRov93KqVpPWiJYmhwGyWreW6dP6dGggkcYijz14sRwkFWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rzE3S-0006xA-7c; Tue, 23 Apr 2024 13:11:18 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 7/7] selftests: netfilter: conntrack_vrf.sh: prefer socat, not iperf3
Date: Tue, 23 Apr 2024 15:05:50 +0200
Message-ID: <20240423130604.7013-8-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240423130604.7013-1-fw@strlen.de>
References: <20240423130604.7013-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use socat, like most of the other scripts already do.  This also makes
the script complete slightly faster (3s -> 1s).

iperf3 establishes two connections (1 control connection, and 1+x
depending on test), so adjust expected counter values as well.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/conntrack_vrf.sh  | 40 ++++++++++---------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_vrf.sh b/tools/testing/selftests/net/netfilter/conntrack_vrf.sh
index f7417004ec71..073e8e62d350 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_vrf.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_vrf.sh
@@ -43,15 +43,9 @@ cleanup()
 	cleanup_all_ns
 }
 
-if ! nft --version > /dev/null 2>&1;then
-	echo "SKIP: Could not run test without nft tool"
-	exit $ksft_skip
-fi
-
-if ! conntrack --version > /dev/null 2>&1;then
-	echo "SKIP: Could not run test without conntrack tool"
-	exit $ksft_skip
-fi
+checktool "nft --version" "run test without nft"
+checktool "conntrack --version" "run test without conntrack"
+checktool "socat -h" "run test without socat"
 
 trap cleanup EXIT
 
@@ -79,7 +73,15 @@ ip -net "$ns1" li set veth0 up
 ip -net "$ns0" addr add $IP0/$PFXL dev veth0
 ip -net "$ns1" addr add $IP1/$PFXL dev veth0
 
-ip netns exec "$ns1" iperf3 -s > /dev/null 2>&1 &
+listener_ready()
+{
+        local ns="$1"
+
+        ss -N "$ns" -l -n -t -o "sport = :55555" | grep -q "55555"
+}
+
+ip netns exec "$ns1" socat -u -4 TCP-LISTEN:55555,reuseaddr,fork STDOUT > /dev/null &
+busywait $BUSYWAIT_TIMEOUT listener_ready "$ns1"
 
 # test vrf ingress handling.
 # The incoming connection should be placed in conntrack zone 1,
@@ -160,16 +162,16 @@ table ip nat {
 	}
 }
 EOF
-	if ! ip netns exec "$ns0" ip vrf exec tvrf iperf3 -t 1 -c $IP1 >/dev/null; then
-		echo "FAIL: iperf3 connect failure with masquerade + sport rewrite on vrf device"
+	if ! ip netns exec "$ns0" ip vrf exec tvrf socat -u -4 STDIN TCP:"$IP1":55555 < /dev/null > /dev/null;then
+		echo "FAIL: connect failure with masquerade + sport rewrite on vrf device"
 		ret=1
 		return
 	fi
 
 	# must also check that nat table was evaluated on second (lower device) iteration.
-	ip netns exec "$ns0" nft list table ip nat |grep -q 'counter packets 2' &&
-	if ip netns exec "$ns0" nft list table ip nat |grep -q 'untracked counter packets [1-9]'; then
-		echo "PASS: iperf3 connect with masquerade + sport rewrite on vrf device ($qdisc qdisc)"
+	if ip netns exec "$ns0" nft list table ip nat |grep -q 'counter packets 1' &&
+	   ip netns exec "$ns0" nft list table ip nat |grep -q 'untracked counter packets [1-9]'; then
+		echo "PASS: connect with masquerade + sport rewrite on vrf device ($qdisc qdisc)"
 	else
 		echo "FAIL: vrf rules have unexpected counter value"
 		ret=1
@@ -195,15 +197,15 @@ table ip nat {
 	}
 }
 EOF
-	if ! ip netns exec "$ns0" ip vrf exec tvrf iperf3 -t 1 -c $IP1 > /dev/null; then
-		echo "FAIL: iperf3 connect failure with masquerade + sport rewrite on veth device"
+	if ! ip netns exec "$ns0" ip vrf exec tvrf socat -u -4 STDIN TCP:"$IP1":55555 < /dev/null > /dev/null;then
+		echo "FAIL: connect failure with masquerade + sport rewrite on veth device"
 		ret=1
 		return
 	fi
 
 	# must also check that nat table was evaluated on second (lower device) iteration.
-	if ip netns exec "$ns0" nft list table ip nat |grep -q 'counter packets 2'; then
-		echo "PASS: iperf3 connect with masquerade + sport rewrite on veth device"
+	if ip netns exec "$ns0" nft list table ip nat |grep -q 'counter packets 1'; then
+		echo "PASS: connect with masquerade + sport rewrite on veth device"
 	else
 		echo "FAIL: vrf masq rule has unexpected counter value"
 		ret=1
-- 
2.43.2

