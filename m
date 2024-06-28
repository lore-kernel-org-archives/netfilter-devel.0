Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F4CC1CCCBF;
	Fri, 28 Jun 2024 16:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719590729; cv=none; b=espRkBE4KV4py/gNY9q9jcYhuXkGYR5zD13VB3vHO84i0oGB56+bk7/UJBp+586ll4AR/WGxlv13uYgA1HFeflK41VVAuvUv9XRFemtgm07UpJNENgOT0CWs5+muZh6hAzxJzJ8pPnT4uwV5/TeNWo6/vZJKMr1VEdtX/t/6UJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719590729; c=relaxed/simple;
	bh=ekxrUgpca4XqudLWJwFZWii+C51P2o6RNcl7sfbkIyU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nRDu/b03ClvlpIRBUKIcfaw6f2l+r8bnR7SLk0HvE7DBwTqZ3ZU6/B3u4Rrw68rgD61BOBPbrEfxsuMEyh1VRwCy7BiG5miMKvYPZbLlK2oZ/SzsWMovEAEz8LycLqjLIm8qacIkf4DwfTwu4T3fHg0znJRptUu57HCa3kc73QU=
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
Subject: [PATCH net-next 16/17] selftests: netfilter: nft_queue.sh: add test for disappearing listener
Date: Fri, 28 Jun 2024 18:05:04 +0200
Message-Id: <20240628160505.161283-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240628160505.161283-1-pablo@netfilter.org>
References: <20240628160505.161283-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

If userspace program exits while the queue its subscribed to has packets
those need to be discarded.

commit dc21c6cc3d69 ("netfilter: nfnetlink_queue: acquire rcu_read_lock()
in instance_destroy_rcu()") fixed a (harmless) rcu splat that could be
triggered in this case.

Add a test case to cover this.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/net/netfilter/nft_queue.sh      | 37 +++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index 8538f08c64c2..c61d23a8c88d 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -375,6 +375,42 @@ EOF
 	wait 2>/dev/null
 }
 
+test_queue_removal()
+{
+	read tainted_then < /proc/sys/kernel/tainted
+
+	ip netns exec "$ns1" nft -f - <<EOF
+flush ruleset
+table ip filter {
+	chain output {
+		type filter hook output priority 0; policy accept;
+		ip protocol icmp queue num 0
+	}
+}
+EOF
+	ip netns exec "$ns1" ./nf_queue -q 0 -d 30000 -t "$timeout" &
+	local nfqpid=$!
+
+	busywait "$BUSYWAIT_TIMEOUT" nf_queue_wait "$ns1" 0
+
+	ip netns exec "$ns1" ping -w 2 -f -c 10 127.0.0.1 -q >/dev/null
+	kill $nfqpid
+
+	ip netns exec "$ns1" nft flush ruleset
+
+	if [ "$tainted_then" -ne 0 ];then
+		return
+	fi
+
+	read tainted_now < /proc/sys/kernel/tainted
+	if [ "$tainted_now" -eq 0 ];then
+		echo "PASS: queue program exiting while packets queued"
+	else
+		echo "TAINT: queue program exiting while packets queued"
+		ret=1
+	fi
+}
+
 ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
@@ -413,5 +449,6 @@ test_tcp_localhost
 test_tcp_localhost_connectclose
 test_tcp_localhost_requeue
 test_icmp_vrf
+test_queue_removal
 
 exit $ret
-- 
2.30.2

