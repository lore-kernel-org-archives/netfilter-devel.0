Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83EB5B5D3
	for <netfilter-devel@vger.kernel.org>; Tue, 14 May 2024 10:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683504; cv=none; b=D0ktOl2tx3qANp4pfpEox4aIyBQrzewn/hP8n3BcRbISWLynbt0R9kqspdCvUEmZh+QSCGuXCYKPDpj+Of0TadXrAaRMAfvhJ/VhWp4eyaz+/SeVWX/pm+/u5G7JxiEFOl6B0DErT9mnsZi+WARFr1NCTk0mwuKB3DJj+UkEdzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683504; c=relaxed/simple;
	bh=zPkk1x3KMgQyt3bd3AbdKd/zaA9NEGTIBL7RE6l0WJk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dNVkbajtTM3JubVYzg8ZShNuC6AsFJm4JBjlBjK6jdB4rOtWN4G6PIRW9SlfkRT5qy+iymqcCXXeL2T+mSFZQG1H0k6arQWzZRm+NWADjfPbrdSuPLc9MSS9RU1KE+tcBo3hFxk7TBReUgBt86y9z2nFAN41qwKIh8tx7PptZIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1s6peQ-0000Tv-5d; Tue, 14 May 2024 12:44:54 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Yi Chen <yiche@redhat.com>
Subject: [PATCH nf] netfilter: nfnetlink_queue: fix rcu splat on program exit
Date: Tue, 14 May 2024 12:31:30 +0200
Message-ID: <20240514103133.2784-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If userspace program exits while the queue its subscribed to has packets
available we get following (harmless) RCU splat:

 net/netfilter/nfnetlink_queue.c:261 suspicious rcu_dereference_check() usage!
 other info that might help us debug this:
 rcu_scheduler_active = 2, debug_locks = 1
 2 locks held by swapper/0/0:
  #0: (rcu_callback){....}-{0:0}, at: rcu_core
  #1: (&inst->lock){+.-.}-{3:3}, at: instance_destroy_rcu
 [..] Call Trace:
  lockdep_rcu_suspicious+0x1ab/0x250
  nfqnl_reinject+0x5d3/0xfb0
  instance_destroy_rcu+0x1b5/0x220
  rcu_core+0xe32 [..]

This is harmless because the incorrectly-obtained pointer will not be
dereferenced in case nfqnl_reinject is called with NF_DROP verdict.

Fix this by open-coding skb+entry release without going through
nfqnl_reinject().  kfree_skb+release_ref is exactly what nfql_reinject
ends up doing when called with NF_DROP, except that it also does a
truckload of other things that are irrelevant for DROP.

A similar warning can be triggered by flushing the ruleset while
packets are being reinjected.

This is harmless as well, the WARN_ON_ONCE() should be removed.

Reported-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Due to MR cloed this patch is actually vs nf-next tree.
 It will also conflict with the pending sctp checksum patch
 from Antonio Ojea (nft_queue.sh), I can resend if needed once
 Antonios patch is applied (conflict resulution is simple: use
 both changes).

 net/netfilter/nfnetlink_queue.c               | 12 ++++--
 .../selftests/net/netfilter/nft_queue.sh      | 37 +++++++++++++++++++
 2 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 00f4bd21c59b..812117d837a7 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -323,7 +323,7 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	hooks = nf_hook_entries_head(net, pf, entry->state.hook);
 
 	i = entry->hook_index;
-	if (WARN_ON_ONCE(!hooks || i >= hooks->num_hook_entries)) {
+	if (!hooks || i >= hooks->num_hook_entries) {
 		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
 		nf_queue_entry_free(entry);
 		return;
@@ -401,16 +401,22 @@ static void
 nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn, unsigned long data)
 {
 	struct nf_queue_entry *entry, *next;
+	LIST_HEAD(head);
 
 	spin_lock_bh(&queue->lock);
 	list_for_each_entry_safe(entry, next, &queue->queue_list, list) {
 		if (!cmpfn || cmpfn(entry, data)) {
-			list_del(&entry->list);
+			list_move(&entry->list, &head);
 			queue->queue_total--;
-			nfqnl_reinject(entry, NF_DROP);
 		}
 	}
 	spin_unlock_bh(&queue->lock);
+
+	list_for_each_entry_safe(entry, next, &head, list) {
+		list_del(&entry->list);
+		kfree_skb_reason(entry->skb, SKB_DROP_REASON_NETFILTER_DROP);
+		nf_queue_entry_free(entry);
+	}
 }
 
 static int
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
2.43.2

