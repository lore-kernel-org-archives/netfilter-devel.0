Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0DC15B0FD;
	Fri,  7 Jun 2024 08:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717749380; cv=none; b=S1Tu5qzI6UfbKTV5VLIxbe+nUd9Gpy6zrvmeC8c9HF52n3g6TsNF4wGqJw8ZBXdOFRFH8izl2KfgF8me4KzsNiazXd1q7CyuEHI4/AYlV7Qvm7ZF9kvXfvEhMeuOf0WlEiKLB+ipvskt5zEOpBU5i+Xj5VjyVjDMuHmsBACeFAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717749380; c=relaxed/simple;
	bh=hgsSJxS1/vsOleGAUDIYBRn2jwWsd5sSpm1Q205lcc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDbrmM0wYQ4ZtM3bNrqt69mX3bCqhD07baEW5wRJGwxULVy1jmnWbIt0ixdOF8xODbGhM7PJpHe+ONGN/Av3c456R1Ou4pApU0IGWc1T2r0e4Dr1sH7vNVNINOqd1rj4EQhLHUxVi6Hbv+2VG/KXg+uKsynDW878oBeiIrigL/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sFV54-0001pG-RX; Fri, 07 Jun 2024 10:36:14 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org,
	willemb@google.com,
	Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH net-next 1/2] net: add and use skb_get_hash_net
Date: Fri,  7 Jun 2024 10:31:59 +0200
Message-ID: <20240607083205.3000-2-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240607083205.3000-1-fw@strlen.de>
References: <20240607083205.3000-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Years ago flow dissector gained ability to delegate flow dissection
to a bpf program, scoped per netns.

Unfortunately, skb_get_hash() only gets an sk_buff argument instead
of both net+skb.  This means the flow dissector needs to obtain the
netns pointer from somewhere else.

The netns is derived from skb->dev, and if that is not available, from
skb->sk.  If neither is set, we hit a (benign) WARN_ON_ONCE().

Trying both dev and sk covers most cases, but not all, as recently
reported by Christoph Paasch.

In case of nf-generated tcp reset, both sk and dev are NULL:

WARNING: .. net/core/flow_dissector.c:1104
 skb_flow_dissect_flow_keys include/linux/skbuff.h:1536 [inline]
 skb_get_hash include/linux/skbuff.h:1578 [inline]
 nft_trace_init+0x7d/0x120 net/netfilter/nf_tables_trace.c:320
 nft_do_chain+0xb26/0xb90 net/netfilter/nf_tables_core.c:268
 nft_do_chain_ipv4+0x7a/0xa0 net/netfilter/nft_chain_filter.c:23
 nf_hook_slow+0x57/0x160 net/netfilter/core.c:626
 __ip_local_out+0x21d/0x260 net/ipv4/ip_output.c:118
 ip_local_out+0x26/0x1e0 net/ipv4/ip_output.c:127
 nf_send_reset+0x58c/0x700 net/ipv4/netfilter/nf_reject_ipv4.c:308
 nft_reject_ipv4_eval+0x53/0x90 net/ipv4/netfilter/nft_reject_ipv4.c:30
 [..]

syzkaller did something like this:
table inet filter {
  chain input {
    type filter hook input priority filter; policy accept;
    meta nftrace set 1			# calls skb_get_hash
    tcp dport 42 reject with tcp reset  # emits skb with NULL skb dev/sk
   }
   chain output {
    type filter hook output priority filter; policy accept;
    # empty chain is enough
   }
}

... then sends a tcp packet to port 42.

Initial attempt to simply set skb->dev from nf_reject_ipv4 doesn't cover
all cases: skbs generated via ipv4 igmp_send_report trigger similar splat.

Moreover, Pablo Neira found that nft_hash.c uses __skb_get_hash_symmetric()
which would trigger same warn splat for such skbs.

Lets allow callers to pass the current netns explicitly.
The nf_trace infrastructure is adjusted to use the new helper.

__skb_get_hash_symmetric is handled in the next patch.

Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/494
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/skbuff.h          | 12 ++++++++++--
 net/core/flow_dissector.c       | 14 ++++++++++----
 net/netfilter/nf_tables_trace.c |  2 +-
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index fe7d8dbef77e..6e78019f899a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1498,7 +1498,7 @@ __skb_set_sw_hash(struct sk_buff *skb, __u32 hash, bool is_l4)
 	__skb_set_hash(skb, hash, true, is_l4);
 }
 
-void __skb_get_hash(struct sk_buff *skb);
+void __skb_get_hash_net(const struct net *net, struct sk_buff *skb);
 u32 __skb_get_hash_symmetric(const struct sk_buff *skb);
 u32 skb_get_poff(const struct sk_buff *skb);
 u32 __skb_get_poff(const struct sk_buff *skb, const void *data,
@@ -1578,10 +1578,18 @@ void skb_flow_dissect_hash(const struct sk_buff *skb,
 			   struct flow_dissector *flow_dissector,
 			   void *target_container);
 
+static inline __u32 skb_get_hash_net(const struct net *net, struct sk_buff *skb)
+{
+	if (!skb->l4_hash && !skb->sw_hash)
+		__skb_get_hash_net(net, skb);
+
+	return skb->hash;
+}
+
 static inline __u32 skb_get_hash(struct sk_buff *skb)
 {
 	if (!skb->l4_hash && !skb->sw_hash)
-		__skb_get_hash(skb);
+		__skb_get_hash_net(NULL, skb);
 
 	return skb->hash;
 }
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 59fe46077b3c..32454181be60 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1860,7 +1860,7 @@ u32 __skb_get_hash_symmetric(const struct sk_buff *skb)
 EXPORT_SYMBOL_GPL(__skb_get_hash_symmetric);
 
 /**
- * __skb_get_hash: calculate a flow hash
+ * __skb_get_hash_net: calculate a flow hash
  * @skb: sk_buff to calculate flow hash from
  *
  * This function calculates a flow hash based on src/dst addresses
@@ -1868,18 +1868,24 @@ EXPORT_SYMBOL_GPL(__skb_get_hash_symmetric);
  * on success, zero indicates no valid hash.  Also, sets l4_hash in skb
  * if hash is a canonical 4-tuple hash over transport ports.
  */
-void __skb_get_hash(struct sk_buff *skb)
+void __skb_get_hash_net(const struct net *net, struct sk_buff *skb)
 {
 	struct flow_keys keys;
 	u32 hash;
 
+	memset(&keys, 0, sizeof(keys));
+
+	__skb_flow_dissect(net, skb, &flow_keys_dissector,
+			   &keys, NULL, 0, 0, 0,
+			   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
+
 	__flow_hash_secret_init();
 
-	hash = ___skb_get_hash(skb, &keys, &hashrnd);
+	hash = __flow_hash_from_keys(&keys, &hashrnd);
 
 	__skb_set_sw_hash(skb, hash, flow_keys_have_l4(&keys));
 }
-EXPORT_SYMBOL(__skb_get_hash);
+EXPORT_SYMBOL(__skb_get_hash_net);
 
 __u32 skb_get_hash_perturb(const struct sk_buff *skb,
 			   const siphash_key_t *perturb)
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index a83637e3f455..580c55268f65 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -317,7 +317,7 @@ void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
 	net_get_random_once(&trace_key, sizeof(trace_key));
 
 	info->skbid = (u32)siphash_3u32(hash32_ptr(skb),
-					skb_get_hash(skb),
+					skb_get_hash_net(nft_net(pkt), skb),
 					skb->skb_iif,
 					&trace_key);
 }
-- 
2.44.2

