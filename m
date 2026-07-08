Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAF01F7916;
	Wed,  8 Jul 2026 14:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783519462; cv=none; b=UU+uKKenjmDcaBEgIoHaAzv+rFqy9tAdtIypnvpEdHSRLKZ3I01MPTb3rYqUCnzMKjJ7IwJ4UissLZY4KbMoLxXBO5ZplNC5+G/xT0j+ydC3ltGgwUyCar/I6i/XtWcCUFroxL6FA3PBFXijHsNjjy1k+7rhKrKhtZ1MTuEtpMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783519462; c=relaxed/simple;
	bh=A+wTGpT8PMWKJtmhqvnxJsopxmXh9gCzc6Bj8wJLvCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2CIOnWu6Bi5tBcUflcV4D47Z2CoVEJTWU0N012q9uNEdmAGrX9YJrpHF4OYWn/b2kfxoSHVO5Ke8rJC1Z2nw/gSKL8gVX1qO0T5ZLvW6/YeG7tepUv0BkOCMnl/aJikXeZH3PrTTnEvSpw5LC/JlizLVEP5ds3BNI+DxZldm90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E960060E29; Wed, 08 Jul 2026 16:04:18 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 14/17] ipvs: pass parsed transport offset to state handlers
Date: Wed,  8 Jul 2026 16:03:06 +0200
Message-ID: <20260708140309.19633-15-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708140309.19633-1-fw@strlen.de>
References: <20260708140309.19633-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

IPVS callers already parse the packet into struct ip_vs_iphdr before
updating connection state. For IPv6 this records the real
transport-header offset after extension headers in iph.len.

Pass this parsed transport offset through ip_vs_set_state() and the
protocol state_transition() callback so protocol handlers can use the
same packet context as scheduling and NAT handling. This patch only
changes the common callback plumbing and adapts the protocol callback
signatures; TCP and SCTP start using the value in follow-up patches.

Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/ip_vs.h                   |  3 ++-
 net/netfilter/ipvs/ip_vs_core.c       | 10 +++++-----
 net/netfilter/ipvs/ip_vs_proto_sctp.c |  3 ++-
 net/netfilter/ipvs/ip_vs_proto_tcp.c  |  3 ++-
 net/netfilter/ipvs/ip_vs_proto_udp.c  |  3 ++-
 5 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 49297fec448a..417ff51f62fc 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -752,7 +752,8 @@ struct ip_vs_protocol {
 
 	void (*state_transition)(struct ip_vs_conn *cp, int direction,
 				 const struct sk_buff *skb,
-				 struct ip_vs_proto_data *pd);
+				 struct ip_vs_proto_data *pd,
+				 unsigned int iph_len);
 
 	int (*register_app)(struct netns_ipvs *ipvs, struct ip_vs_app *inc);
 
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 906f2c361676..f79c09869636 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -398,10 +398,10 @@ ip_vs_conn_stats(struct ip_vs_conn *cp, struct ip_vs_service *svc)
 static inline void
 ip_vs_set_state(struct ip_vs_conn *cp, int direction,
 		const struct sk_buff *skb,
-		struct ip_vs_proto_data *pd)
+		struct ip_vs_proto_data *pd, unsigned int iph_len)
 {
 	if (likely(pd->pp->state_transition))
-		pd->pp->state_transition(cp, direction, skb, pd);
+		pd->pp->state_transition(cp, direction, skb, pd, iph_len);
 }
 
 static inline int
@@ -803,7 +803,7 @@ int ip_vs_leave(struct ip_vs_service *svc, struct sk_buff *skb,
 		ip_vs_in_stats(cp, skb);
 
 		/* set state */
-		ip_vs_set_state(cp, IP_VS_DIR_INPUT, skb, pd);
+		ip_vs_set_state(cp, IP_VS_DIR_INPUT, skb, pd, iph->len);
 
 		/* transmit the first SYN packet */
 		ret = cp->packet_xmit(skb, cp, pd->pp, iph);
@@ -1484,7 +1484,7 @@ handle_response(int af, struct sk_buff *skb, struct ip_vs_proto_data *pd,
 
 after_nat:
 	ip_vs_out_stats(cp, skb);
-	ip_vs_set_state(cp, IP_VS_DIR_OUTPUT, skb, pd);
+	ip_vs_set_state(cp, IP_VS_DIR_OUTPUT, skb, pd, iph->len);
 	skb->ipvs_property = 1;
 	if (!(cp->flags & IP_VS_CONN_F_NFCT))
 		ip_vs_notrack(skb);
@@ -2233,7 +2233,7 @@ ip_vs_in_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *state
 	IP_VS_DBG_PKT(11, af, pp, skb, iph.off, "Incoming packet");
 
 	ip_vs_in_stats(cp, skb);
-	ip_vs_set_state(cp, IP_VS_DIR_INPUT, skb, pd);
+	ip_vs_set_state(cp, IP_VS_DIR_INPUT, skb, pd, iph.len);
 	if (cp->packet_xmit)
 		ret = cp->packet_xmit(skb, cp, pp, &iph);
 		/* do not touch skb anymore */
diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index 63c78a1f3918..394367b7b388 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -468,7 +468,8 @@ set_sctp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
 
 static void
 sctp_state_transition(struct ip_vs_conn *cp, int direction,
-		const struct sk_buff *skb, struct ip_vs_proto_data *pd)
+		const struct sk_buff *skb, struct ip_vs_proto_data *pd,
+		unsigned int iph_len)
 {
 	spin_lock_bh(&cp->lock);
 	set_sctp_state(pd, cp, direction, skb);
diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index 8cc0a8ce6241..2d3f6aeafe52 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -579,7 +579,8 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
 static void
 tcp_state_transition(struct ip_vs_conn *cp, int direction,
 		     const struct sk_buff *skb,
-		     struct ip_vs_proto_data *pd)
+		     struct ip_vs_proto_data *pd,
+		     unsigned int iph_len)
 {
 	struct tcphdr _tcph, *th;
 
diff --git a/net/netfilter/ipvs/ip_vs_proto_udp.c b/net/netfilter/ipvs/ip_vs_proto_udp.c
index f9de632e38cd..58f9e255927e 100644
--- a/net/netfilter/ipvs/ip_vs_proto_udp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_udp.c
@@ -444,7 +444,8 @@ static const char * udp_state_name(int state)
 static void
 udp_state_transition(struct ip_vs_conn *cp, int direction,
 		     const struct sk_buff *skb,
-		     struct ip_vs_proto_data *pd)
+		     struct ip_vs_proto_data *pd,
+		     unsigned int iph_len)
 {
 	if (unlikely(!pd)) {
 		pr_err("UDP no ns data\n");
-- 
2.54.0

