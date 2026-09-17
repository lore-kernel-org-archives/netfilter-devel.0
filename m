Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13404517BB4
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 13:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650587; cv=none; b=a8Ijk3dzn8pI8ShV+1akMLBPDcbLdvwZ5pmhqBo41GDzDyJE0Mj+YyGxYy5Ym/a7zUdEJXpLAtpgZJpF4awNoMphOu75K+5dkhaO5fJh1b7x33PE9GGpp5Uftg0I4SKdDny68/7Cr/MZWowtfdot7d4WTUDWwddPLr9FDNky2VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650587; c=relaxed/simple;
	bh=BSpiGGP1C9WJcIYYKpOmPtqsuTBU8AB5Eh5rWFu/kmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHoljFjiUVaUlduhNUkehz2EbQT9ywa8S4PfciZ4u8/OFcPHhuP8q3H2tDM3NCKDAhbn9JrIUZpVd82xetKKEC2li4hAktVKcrU82/jNuJNuJLXR3wyegIe+4mBKZveRWVkc02Bwe7wDF6Bd7zBAsPFutuhVm0xZ4jE4QzT6gew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3C9006032B; Thu, 17 Sep 2026 15:09:38 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 2/6] netfilter: nf_conntrack: refactor helper call logic in nf_confirm()
Date: Thu, 17 Sep 2026 15:09:18 +0200
Message-ID: <20260917130922.17699-3-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917130922.17699-1-fw@strlen.de>
References: <20260917130922.17699-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current implementation of nf_confirm() handles several distinct
tasks: retrieving the connection, calculating protocol offsets for
different network families, and executing the associated helpers or
sequence adjustments.

Move functionality to extra functions:

1. nf_confirm_get_protoff(): Isolates the logic for determining the
   protocol offset (protoff) for IPv4 and IPv6 packets.
2. nf_ct_call_helper(): Encapsulates the decision-making process of
   whether to call a connection tracking helper or perform sequence
   adjustment, utilizing nf_confirm_get_protoff() to find the correct
   offset.

NF_CT_STAT_INC_ATOMIC() is now incremented for any NF_DROP, earlier
this was elided in some cases, IMO that was a bug all along.

Followup patches will extend these new functions with stricter checks.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_helper.h |   2 +
 net/netfilter/nf_conntrack_proto.c          | 113 +++++++++++++++-----
 2 files changed, 87 insertions(+), 28 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 335b8c43694f..4b5ee758cff3 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -124,6 +124,8 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 
 int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
 		 enum ip_conntrack_info ctinfo, u16 proto);
+int nf_ct_call_helper(struct sk_buff *skb, struct nf_conn *ct,
+		      enum ip_conntrack_info ctinfo);
 int nf_ct_add_helper(struct nf_conn *ct, const char *name, u8 family,
 		     u8 proto, bool nat, struct nf_conntrack_helper **hp);
 
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 7a40e4e0e33e..32f900c155de 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -131,36 +131,16 @@ static bool in_vrf_postrouting(const struct nf_hook_state *state)
 	return false;
 }
 
-unsigned int nf_confirm(void *priv,
-			struct sk_buff *skb,
-			const struct nf_hook_state *state)
+static bool nf_confirm_get_protoff(struct sk_buff *skb, struct net *net,
+				   struct nf_conn *ct,
+				   enum ip_conntrack_info ctinfo,
+				   unsigned int *protoffp)
 {
-	int (*helper_cb)(struct sk_buff *skb, unsigned int protoff,
-			 struct nf_conn *ct,
-			 enum ip_conntrack_info conntrackinfo);
-	const struct nf_conn_help *help;
-	enum ip_conntrack_info ctinfo;
 	unsigned int protoff;
-	struct nf_conn *ct;
-	bool seqadj_needed;
 	__be16 frag_off;
 	int start;
 	u8 pnum;
 
-	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct || in_vrf_postrouting(state))
-		return NF_ACCEPT;
-
-	help = nfct_help(ct);
-
-	seqadj_needed = test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) && !nf_is_loopback_packet(skb);
-	if (!help && !seqadj_needed)
-		return nf_conntrack_confirm(skb);
-
-	/* helper->help() do not expect ICMP packets */
-	if (ctinfo == IP_CT_RELATED_REPLY)
-		return nf_conntrack_confirm(skb);
-
 	switch (nf_ct_l3num(ct)) {
 	case NFPROTO_IPV4:
 		protoff = skb_network_offset(skb) + ip_hdrlen(skb);
@@ -169,16 +149,56 @@ unsigned int nf_confirm(void *priv,
 		pnum = ipv6_hdr(skb)->nexthdr;
 		start = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum, &frag_off);
 		if (start < 0 || (frag_off & htons(~0x7)) != 0)
-			return nf_conntrack_confirm(skb);
+			return false;
 
 		protoff = start;
 		break;
 	default:
-		return nf_conntrack_confirm(skb);
+		DEBUG_NET_WARN_ONCE(1, "helper invoked on non-IP family!");
+		return false;
 	}
 
+	*protoffp = protoff;
+	return true;
+}
+
+/**
+ * nf_ct_call_helper() - Invoke the connection tracking helper for a packet
+ * @skb:    The socket buffer containing the packet to be processed.
+ * @ct:     The connection tracking entry associated with this packet.
+ * @ctinfo: The current connection track information (state) of the packet.
+ *
+ * This function calls the l4 connection tracking helper (e.g. ftp, sip...) if
+ * one was assigned to the connection.
+ *
+ * Return: verdict (NF_ACCEPT, NF_DROP, ...)
+ */
+int nf_ct_call_helper(struct sk_buff *skb, struct nf_conn *ct,
+		      enum ip_conntrack_info ctinfo)
+{
+	struct net *net = nf_ct_net(ct);
+	const struct nf_conn_help *help;
+	bool seqadj_needed;
+	unsigned int protoff;
+
+	help = nfct_help(ct);
+
+	seqadj_needed = test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) && !nf_is_loopback_packet(skb);
+	if (!help && !seqadj_needed)
+		return NF_ACCEPT;
+
+	/* helper->help() do not expect ICMP packets */
+	if (ctinfo == IP_CT_RELATED_REPLY)
+		return NF_ACCEPT;
+
+	if (!nf_confirm_get_protoff(skb, net, ct, ctinfo, &protoff))
+		return NF_ACCEPT;
+
 	if (help) {
 		const struct nf_conntrack_helper *helper;
+		int (*helper_cb)(struct sk_buff *skb, unsigned int protoff,
+				 struct nf_conn *ct,
+				 enum ip_conntrack_info conntrackinfo);
 		int ret;
 
 		/* rcu_read_lock()ed by nf_hook */
@@ -195,9 +215,46 @@ unsigned int nf_confirm(void *priv,
 	}
 
 	if (seqadj_needed &&
-	    !nf_ct_seq_adjust(skb, ct, ctinfo, protoff)) {
-		NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
+	    !nf_ct_seq_adjust(skb, ct, ctinfo, protoff))
 		return NF_DROP;
+
+	return NF_ACCEPT;
+}
+
+/**
+ * nf_confirm - Confirm (commit) a connection tracking entry
+ * @priv: Private data from the netfilter hook registration (unused)
+ * @skb: Packet
+ * @state: Netfilter hook state containing context (netns, hooknum, in/out devices)
+ *
+ * This function is invoked as the final step of the connection tracking
+ * processing pipeline. It performs two main operations:
+ *
+ * 1. Invokes the associated conntrack helper (if registered) to allow
+ *    layer 7 specific parsing and NAT mangling.
+ *
+ * 2. Commits a new conntrack entry to the conntrack hash table, making it
+ *    globally visible and enabling future packet lookups for stateful tracking.
+ *
+ * Returns: A netfilter verdict, e.g. NF_ACCEPT or NF_DROP.
+ */
+unsigned int nf_confirm(void *priv,
+			struct sk_buff *skb,
+			const struct nf_hook_state *state)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+	int ret;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct || in_vrf_postrouting(state))
+		return NF_ACCEPT;
+
+	ret = nf_ct_call_helper(skb, ct, ctinfo);
+	if (unlikely(ret != NF_ACCEPT)) {
+		if (ret == NF_DROP)
+			NF_CT_STAT_INC_ATOMIC(state->net, drop);
+		return ret;
 	}
 
 	/* We've seen it coming out the other side: confirm it */
-- 
2.55.0

