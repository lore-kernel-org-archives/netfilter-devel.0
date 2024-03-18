Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85E982E62A
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Mar 2024 09:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710754771; cv=none; b=W4wnUmo80PHzOJrn/oeqZAb6iWMFzdrNwoNLLc9jWbzGouSMHer3GNrFla7lUItwT9dkAuSJW2c9zwoQmA+bqLxIzxMUsjmL1qwSLpXk00OAekXaYLyYKbq/PUPtobOLPs/xSwOYBvZPolLl5BoR9x71C5qHVadYtnJLe/cz12o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710754771; c=relaxed/simple;
	bh=N1ceTfz1QOY++5XnfzyKYV/UqdfRQeApynZtJBPxpsQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GT8s0b1GzgCzW90JhHu6f/kTEdODqeB+1PLWBxN+/KzPBgqdVYPXqnOkkMHRocVs68QOn3jJfzQQPx7BQlbcl2eqlr4iLkVIaOcWIqLqHLQFnf+DFzj0ACL2n/m+BN5aqzq5Y8WWbGe9iSXf3BmsuWhZsEWM58UQPguwFkXrpw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: sven.auhagen@voleatech.de,
	cratiu@nvidia.com,
	ozsh@nvidia.com,
	vladbu@nvidia.com,
	gal@nvidia.com,
	fw@strlen.de
Subject: [PATCH nf] netfilter: flowtable: infer TCP state and timeout before flow teardown
Date: Mon, 18 Mar 2024 10:39:15 +0100
Message-Id: <20240318093915.10358-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case that either FIN or RST packet is seen, infer current TCP state
based on the TCP packet flags before setting the _TEARDOWN flag:

- FIN packets result in TCP_CONNTRACK_FIN_WAIT which uses a default
  timeout of 2 minutes.
- RST packets lead to tcp_state TCP_CONNTRACK_CLOSE of 10 seconds.

Therefore, TCP established state with a low timeout is not used anymore
when handing over the flow to the classic conntrack path, otherwise a
FIN packet coming in the reply direction could re-offload this flow
again.

If flow teardown is required for other reasons, eg. no traffic seen
after NF_FLOW_TIMEOUT, then use TCP established state but set timeout to
TCP_CONNTRACK_UNACK state which is used in conntrack to pick up
connections from the middle (default is 5 minutes).

Fixes: e5eaac2beb54 ("netfilter: flowtable: fix TCP flow teardown")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Compile-tested only.

 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_flow_table_core.c    | 45 +++++++++++++++++++++------
 net/netfilter/nf_flow_table_ip.c      |  2 +-
 3 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index a763dd327c6e..924f3720143f 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -293,6 +293,7 @@ int nf_flow_table_init(struct nf_flowtable *flow_table);
 void nf_flow_table_free(struct nf_flowtable *flow_table);
 
 void flow_offload_teardown(struct flow_offload *flow);
+void flow_offload_teardown_tcp(struct flow_offload *flow, bool fin);
 
 void nf_flow_snat_port(const struct flow_offload *flow,
 		       struct sk_buff *skb, unsigned int thoff,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index a0571339239c..481fe3d96bbc 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -165,10 +165,22 @@ void flow_offload_route_init(struct flow_offload *flow,
 }
 EXPORT_SYMBOL_GPL(flow_offload_route_init);
 
-static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
+static s32 flow_offload_fixup_tcp(struct net *net, struct nf_conn *ct,
+				  enum tcp_conntrack tcp_state)
 {
-	tcp->seen[0].td_maxwin = 0;
-	tcp->seen[1].td_maxwin = 0;
+	struct nf_tcp_net *tn = nf_tcp_pernet(net);
+
+	ct->proto.tcp.state = tcp_state;
+	ct->proto.tcp.seen[0].td_maxwin = 0;
+	ct->proto.tcp.seen[1].td_maxwin = 0;
+
+	/* Similar to mid-connection pickup with loose=1.
+	 * Avoid large ESTABLISHED timeout.
+	 */
+	if (tcp_state == TCP_CONNTRACK_ESTABLISHED)
+		return tn->timeouts[TCP_CONNTRACK_UNACK];
+
+	return tn->timeouts[tcp_state];
 }
 
 static void flow_offload_fixup_ct(struct nf_conn *ct)
@@ -178,12 +190,8 @@ static void flow_offload_fixup_ct(struct nf_conn *ct)
 	s32 timeout;
 
 	if (l4num == IPPROTO_TCP) {
-		struct nf_tcp_net *tn = nf_tcp_pernet(net);
-
-		flow_offload_fixup_tcp(&ct->proto.tcp);
-
-		timeout = tn->timeouts[ct->proto.tcp.state];
-		timeout -= tn->offload_timeout;
+		timeout = flow_offload_fixup_tcp(net, ct,
+						 TCP_CONNTRACK_ESTABLISHED);
 	} else if (l4num == IPPROTO_UDP) {
 		struct nf_udp_net *tn = nf_udp_pernet(net);
 		enum udp_conntrack state =
@@ -346,12 +354,29 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 
 void flow_offload_teardown(struct flow_offload *flow)
 {
+	flow_offload_fixup_ct(flow->ct);
+	smp_mb__before_atomic();
 	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
 	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
-	flow_offload_fixup_ct(flow->ct);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
+void flow_offload_teardown_tcp(struct flow_offload *flow, bool fin)
+{
+	enum tcp_conntrack tcp_state;
+
+	if (fin)
+		tcp_state = TCP_CONNTRACK_FIN_WAIT;
+	else /* rst */
+		tcp_state = TCP_CONNTRACK_CLOSE;
+
+	flow_offload_fixup_tcp(nf_ct_net(flow->ct), flow->ct, tcp_state);
+	smp_mb__before_atomic();
+	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
+	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
+}
+EXPORT_SYMBOL_GPL(flow_offload_teardown_tcp);
+
 struct flow_offload_tuple_rhash *
 flow_offload_lookup(struct nf_flowtable *flow_table,
 		    struct flow_offload_tuple *tuple)
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index e45fade76409..13b6c453d8bc 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -29,7 +29,7 @@ static int nf_flow_state_check(struct flow_offload *flow, int proto,
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
 	if (unlikely(tcph->fin || tcph->rst)) {
-		flow_offload_teardown(flow);
+		flow_offload_teardown_tcp(flow, tcph->fin);
 		return -1;
 	}
 
-- 
2.30.2

