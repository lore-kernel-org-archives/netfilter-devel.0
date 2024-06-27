Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB8F115748E;
	Thu, 27 Jun 2024 11:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719487655; cv=none; b=t2aRivlPFFGKSbYlFYyESVh6zbkUaPDr6EnLaSdGlmpLlTCR9mJrtoytUNvyWJeFW8SeQKYogok3cC1Rdg7LsDGsE/8gcZWS4q5Jq/sQRlweaDQKS5L1U1inKwsqI1a9Ul1GAItGibgSv/O19gQ4b+4r5Zi0KCW/jY4XAt1wOH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719487655; c=relaxed/simple;
	bh=XFMjFeicxW2lgJEW1FJwriCUu96ZDzBtQwEpeDkA9uA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nU0g+PJhd5dViOkzNWAm9qDhK9x2DW/7b4nqpBuHpfjRtSNQO0OOctKn/FFfC9ddUlu5GCcmnj5f26V4ywaqCvy71jlCaHTTRktdQ+UZkQ5E8URGZ4uTPw8kMPIxhyS5nA6/AukKjHT/zP89JU3mzZtNZS2gtZBU+79ZBjSwVag=
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
Subject: [PATCH nf-next 18/19] selftests: netfilter: nft_queue.sh: add test for disappearing listener
Date: Thu, 27 Jun 2024 13:27:12 +0200
Message-Id: <20240627112713.4846-19-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240627112713.4846-1-pablo@netfilter.org>
References: <20240627112713.4846-1-pablo@netfilter.org>
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
index 288b3cc55ed7..7e210d75e738 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -449,6 +449,42 @@ EOF
 	wait "$rpid" && echo "PASS: sctp and nfqueue in output chain with GSO"
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
@@ -489,5 +525,6 @@ test_tcp_localhost_requeue
 test_icmp_vrf
 test_sctp_forward
 test_sctp_output
+test_queue_removal
 
 exit $ret
-- 
2.30.2

