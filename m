Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714913C4B87;
	Tue, 23 Jun 2026 22:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782252967; cv=none; b=bLDAWnkcMZZ/2R03NMOP/0INA8/wo/iR0VP2HAVlHiGBJ9peIXwGY0RccuOi5s0XLjMAjW84Xh6nNxsg3G7gYXU8bhZZxgeqh1u142GMgPe+VEYXipzPRV+SKaN5ZcEinRDQ4rBZZdRHZeW2pDzSJpqDrA5INiKs42ytU2w4/rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782252967; c=relaxed/simple;
	bh=n1ps/ADFDoP8+am8yxuTBeFgQ4CxJPF3+Jlj4VgDOIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1w0jI35iW0Lnq46geP1El1XpmbxIYJPyZNLq3Q+ZyJUAqT0OOBV8Kueu1BI5OG+qoEp6F50/+7CxotGh6GIo/Dvnf050GbPCSSC6G1d3TlHfblXCURw0NAmT6V0mQgiR1kvnXeKb4mOMpHKDTPlq98yA2pVzGSxVj4Jmr8l9ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gddHOHeZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gddHOHeZ"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 51EA56057E;
	Wed, 24 Jun 2026 00:16:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782252963;
	bh=Neb3EG86AfNr4tcf3nQZaCGhO8Yepun5BuLMR68wuAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gddHOHeZVQ03UTgv+T3Iu4d/a38ZHMr9H5HbCsmeTnj8sRPZ9c7ENRALG79XYL0mV
	 POztkX020INtfL7QXpgtY4vJIuC7aiCW0hmzKyPDT2r6gL0rM3vPzYctqLw6JLq2b2
	 bfg+WEuGMIFjWiqQNI2O61SVCg3L7r9k2PGtdzT8BbGUQC85fGtq9rjt+5uYUu+aLk
	 B8LZ2zPvhlFgjoUC7xL1ycvbNdVS0Y5vjU6JaRn/enN6vlo+JnettIGQQ6PDdRTRU6
	 VkkL+kUnIA/5obnPyj+9s1wBJVIEcnapfkDV5IXgGmRbZEaHTGD29wa9GPqEbFJajD
	 mC7Vrbouvh71g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 08/14] selftests: nft_queue.sh: add a bridge queue test
Date: Wed, 24 Jun 2026 00:15:41 +0200
Message-ID: <20260623221548.701545-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623221548.701545-1-pablo@netfilter.org>
References: <20260623221548.701545-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Add a test queueing from bridge family.
This was lacking: we queued from inet for ipv4 and ipv6 but
we had no bridge queue test so far.

Given kernel MUST validate that in/out port are still part of
a bridge device on reinject add a test case for this before
adding this check.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/net/netfilter/nft_queue.sh      | 66 ++++++++++++++++---
 1 file changed, 58 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index d80390848e85..7c857a2e0f34 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -85,11 +85,12 @@ ip -net "$ns3" route add default via 10.0.3.1
 ip -net "$ns3" route add default via dead:3::1
 
 load_ruleset() {
-	local name=$1
-	local prio=$2
+	local family=$1
+	local name=$2
+	local prio=$3
 
 ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
-table inet $name {
+table $family $name {
 	chain nfq {
 		ip protocol icmp queue bypass
 		icmpv6 type { "echo-request", "echo-reply" } queue num 1 bypass
@@ -228,6 +229,7 @@ nf_queue_wait()
 test_queue()
 {
 	local expected="$1"
+	local family="$2"
 	local last=""
 
 	# spawn nf_queue listeners
@@ -255,11 +257,13 @@ test_queue()
 		if [ x"$last" != x"$expected packets total" ]; then
 			echo "FAIL: Expected $expected packets total, but got $last" 1>&2
 			ip netns exec "$nsrouter" nft list ruleset
+			echo -n "$TMPFILE0: ";cat "$TMPFILE0"
+			echo -n "$TMPFILE1: ";cat "$TMPFILE1"
 			exit 1
 		fi
 	done
 
-	echo "PASS: Expected and received $last"
+	echo "PASS: Expected and received $last ($family)"
 }
 
 listener_ready()
@@ -400,6 +404,8 @@ EOF
 
 	kill "$nfqpid"
 	echo "PASS: icmp+nfqueue via vrf"
+	ip -net "$ns1" link del tvrf
+	ip netns exec "$ns1" nft flush ruleset
 }
 
 sctp_listener_ready()
@@ -814,12 +820,53 @@ EOF
 	check_tainted "queue program exiting while packets queued"
 }
 
+test_queue_bridge()
+{
+	ip -net "$nsrouter" addr flush dev veth0
+	ip -net "$nsrouter" addr flush dev veth1
+
+	ip -net "$nsrouter" link add br0 type bridge
+	ip -net "$nsrouter" link set veth0 master br0
+	ip -net "$nsrouter" link set veth1 master br0
+
+	ip -net "$nsrouter" link set br0 up
+
+	ip -net "$nsrouter" addr add 10.0.2.1/16 dev br0
+	ip -net "$nsrouter" addr add dead:2::1/64 dev br0 nodad
+
+	ip -net "$ns1" addr flush dev eth0
+	ip -net "$ns2" addr flush dev eth0
+
+	ip -net "$ns1" addr add 10.0.1.1/16 dev eth0
+	ip -net "$ns1" addr add dead:2::2/64 dev eth0 nodad
+
+	ip -net "$ns2" addr add 10.0.2.99/16 dev eth0
+	ip -net "$ns2" addr add dead:2::99/64 dev eth0 nodad
+
+	ip netns exec "$nsrouter" nft flush ruleset
+
+	ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=0 > /dev/null
+	ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth0.forwarding=0 > /dev/null
+	ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth1.forwarding=0 > /dev/null
+
+	if ! test_ping;then
+		echo "FAIL: netns bridge connectivity" 1>&2
+		exit $ret
+	fi
+
+	load_ruleset "bridge" "filter" 10
+	test_queue 10 "bridge"
+
+	load_ruleset "bridge" "filter2" 20
+	test_queue 20 "bridge"
+}
+
 ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth2.forwarding=1 > /dev/null
 
-load_ruleset "filter" 0
+load_ruleset "inet" "filter" 0
 
 if test_ping; then
 	# queue bypass works (rules were skipped, no listener)
@@ -842,11 +889,11 @@ load_counter_ruleset 10
 # 1x icmp prerouting,forward,postrouting -> 3 queue events (6 incl. reply).
 # 1x icmp prerouting,input,output postrouting -> 4 queue events incl. reply.
 # so we expect that userspace program receives 10 packets.
-test_queue 10
+test_queue 10 "inet"
 
 # same.  We queue to a second program as well.
-load_ruleset "filter2" 20
-test_queue 20
+load_ruleset "inet" "filter2" 20
+test_queue 20 "inet"
 ip netns exec "$ns1" nft flush ruleset
 
 test_tcp_forward
@@ -863,4 +910,7 @@ test_queue_stress
 test_icmp_vrf
 test_queue_removal
 
+# turns router into a bridge
+test_queue_bridge
+
 exit $ret
-- 
2.47.3

