Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D574457D0;
	Mon, 10 Aug 2026 19:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786390841; cv=none; b=QugE7YIUQmoQEL22twU+QxD+JR7WgTM26+yFcfuGxVRN7jwmcsaEcXVUW7KWoOYUyFqHFZs9GGctuSaO/fsjbdrn2c8wu4qAIzgXmrYD1X/wF9TjUA/P8e0RJjTt3qPlFdkIzvQCssRaurpRMXI/sbQ4JgQszrYkRI+j+3ZMhgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786390841; c=relaxed/simple;
	bh=uSfPAxQNra/Mp9/C1zsLSNEc2xA/UbD5izMyloHrycY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8dO3S/f27KMffmn+AbyrppKSX575xaHNMEz1tn/omjlPxDV2X8hsJJDAwoe7eKPvWjdtjmp74/y4h76smDvdglbErH/PwvfUfdpajQAx2yY86vz1hIRGpqpk8RHmrd25FDeuh3oSmd6bZisLO+wuusN/F5WK6hb2HlEaXe90YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dyvmZPvw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dyvmZPvw"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C5586601A2;
	Mon, 10 Aug 2026 21:40:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786390825;
	bh=3lpsYv/0S47/CG5LOgKkfoM3ZhusyzsYGHQlIG9w/fY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyvmZPvwhqLHUJDdPck/6RA+xSTLGs5pyh4IdOypbvaXdp+FYAAncDulE0wtKxCOO
	 BeNtMuWrKjaJt+5iEVpR1AoB/4JzOZ4+zTjlhEG0LQt4C3dtVKqy4XCQcdabWiTLEq
	 rJf4hG8zjU/DjduiX8kyZqTnpRDievE2A7H20BJ/wI2MfZ1vqrcivvd/Or1biCoBun
	 n+T4+aytqqz1ftxCvm0BY0TaPt6/C6FD/LelcfgUkVrwe4VPLnWXj3bE1su1I0mUOw
	 McjeffNnTN7/vvolSejaP1N8fuPf8DWYe9DK3snz936SEWmqq2SX5vWS31R9DuPaI+
	 e0JJ5SOat1w+w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 01/12] netfilter: add DEBUG_NET_WARN_ON_ONCE to skb_set_nfct()
Date: Mon, 10 Aug 2026 21:40:04 +0200
Message-ID: <20260810194015.932627-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260810194015.932627-1-pablo@netfilter.org>
References: <20260810194015.932627-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Trigger a warning if nf_ct_set() overlaps an existing ct object leading
to refcount leak. Add this warning to skb_set_nfct() whose only user is
nf_ct_set() instead.

Update existing nf_ct_set() callers to use nf_reset_ct() first to clean
up stale pointer to conntrack object which migh trigger false positive
warnings.

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/skbuff.h            |  1 +
 include/net/ip_vs.h               |  2 +-
 net/netfilter/nf_conntrack_core.c |  2 +-
 net/openvswitch/conntrack.c       | 12 +++---------
 net/sched/act_ct.c                |  6 +++---
 5 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 22eda1d54a0e..95184183180f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -5004,6 +5004,7 @@ static inline unsigned long skb_get_nfct(const struct sk_buff *skb)
 static inline void skb_set_nfct(struct sk_buff *skb, unsigned long nfct)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	DEBUG_NET_WARN_ON_ONCE(skb->_nfct & NFCT_PTRMASK);
 	skb->slow_gro |= !!nfct;
 	skb->_nfct = nfct;
 #endif
diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index b3bb228ad75c..3dca7d387dd0 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -2121,7 +2121,7 @@ static inline void ip_vs_notrack(struct sk_buff *skb)
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 
 	if (ct) {
-		nf_conntrack_put(&ct->ct_general);
+		nf_reset_ct(skb);
 		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 	}
 #endif
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 784bd1d7a9bf..d0d9e5ea84a0 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1031,7 +1031,7 @@ static int __nf_ct_resolve_clash(struct sk_buff *skb,
 		nf_conntrack_get(&ct->ct_general);
 
 		nf_ct_acct_merge(ct, ctinfo, loser_ct);
-		nf_ct_put(loser_ct);
+		nf_reset_ct(skb);
 		nf_ct_set(skb, ct, ctinfo);
 
 		NF_CT_STAT_INC(net, clash_resolve);
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 95697d4e16e6..4dd82c4e87d3 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -603,7 +603,7 @@ static bool skb_nfct_cached(struct net *net,
 		if (nf_ct_is_confirmed(ct))
 			nf_ct_delete(ct, 0, 0);
 
-		nf_ct_put(ct);
+		nf_reset_ct(skb);
 		nf_ct_set(skb, NULL, 0);
 		return false;
 	}
@@ -745,8 +745,7 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 
 		/* Associate skb with specified zone. */
 		if (tmpl) {
-			ct = nf_ct_get(skb, &ctinfo);
-			nf_ct_put(ct);
+			nf_reset_ct(skb);
 			nf_conntrack_get(&tmpl->ct_general);
 			nf_ct_set(skb, tmpl, IP_CT_NEW);
 		}
@@ -1075,12 +1074,7 @@ int ovs_ct_execute(struct net *net, struct sk_buff *skb,
 
 int ovs_ct_clear(struct sk_buff *skb, struct sw_flow_key *key)
 {
-	enum ip_conntrack_info ctinfo;
-	struct nf_conn *ct;
-
-	ct = nf_ct_get(skb, &ctinfo);
-
-	nf_ct_put(ct);
+	nf_reset_ct(skb);
 	nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 
 	if (key)
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 4ca7964e83c8..7f54fb4e4ec9 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -782,7 +782,7 @@ static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
 	return true;
 
 drop_ct:
-	nf_ct_put(ct);
+	nf_reset_ct(skb);
 	nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 
 	return false;
@@ -996,7 +996,7 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 		qdisc_skb_cb(skb)->post_ct = false;
 		ct = nf_ct_get(skb, &ctinfo);
 		if (ct) {
-			nf_ct_put(ct);
+			nf_reset_ct(skb);
 			nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 		}
 
@@ -1034,7 +1034,7 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 
 		/* Associate skb with specified zone. */
 		if (tmpl) {
-			nf_conntrack_put(skb_nfct(skb));
+			nf_reset_ct(skb);
 			nf_conntrack_get(&tmpl->ct_general);
 			nf_ct_set(skb, tmpl, IP_CT_NEW);
 		}
-- 
2.47.3

