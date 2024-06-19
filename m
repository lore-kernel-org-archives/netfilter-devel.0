Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFBB159204
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2024 20:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718829407; cv=none; b=GtzyiFgzQYM0kP787dk1sFRlB+RJCsjUB6+DMS6t3E1ScmnRs0Mr9dsJJXCtwD9sDICmUcY2YlELc5fniZAhuwLr1ijlyUWpGXJhhEXG4AQ9LUlPQFarkAJrXnGpgN7iSRWLvEcwCRXOWlYIsw3OtBPsCkgOvsSNVnPzluNNohE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718829407; c=relaxed/simple;
	bh=PKPTPQeuN3+8nTzcDvGYYfFUGoWxiQ8cx9mtFzf4o9U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MvmUPluMb9E1kO12O9MFSD7crfyIUXUD6gwlplOMrEQJvLTRdAeMafP3uua7ixeWA/QJElWx9AZ+i3MvXYlrx6/KbpzKRRCD7ECET+TfXC947SPvBzBuKm993BX6P3GpaR5KgFqYji01TzaDfdWAO0mNUioZoAWTdTem6Z2X06M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sK22t-0002cd-I4; Wed, 19 Jun 2024 22:36:43 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] selftests: netfilter: nft_queue.sh: add test for disappearing listener
Date: Wed, 19 Jun 2024 22:31:48 +0200
Message-ID: <20240619203154.20146-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If userspace program exits while the queue its subscribed to has packets
those need to be discarded.

commit dc21c6cc3d69 ("netfilter: nfnetlink_queue: acquire rcu_read_lock()
in instance_destroy_rcu()") fixed a (harmless) rcu splat that could be
triggered in this case.

Add a test case to cover this.

Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.44.2

