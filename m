Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B147E42125A
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 13:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792069886; cv=none; b=qDqqoFVtqiyPDx3OQ/xOG1HVN/2pqiKw+EGh5UQU4mHVZJcnVfhMbeHM4Ju7eZTNn/SKMwZNC2gjlOBbD3p5WVy3Xtsl8Tni1LvPyKVW+o5wP4Azb0Vggb/kyZ54ukkpEVnG2/fPtItE6EIAl3CYZcXbHiKnNZHkPdckQ2h1vX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792069886; c=relaxed/simple;
	bh=8PC5AyTsk0SEPtSaQq+iW2D0MyTvgO++6SdmVTraexU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c4oKyWIysmAHrUwoJqZlvuElITacGaboc3vs9zJrojN8eqxS9xVXXmuJ4xZTFLKGesZJTByhwPc4VGPdjoAtTuSY7h4CxsSXtevOANI4rp/yfkfqXJqasrrUWKrpFRQAoenK3uyPSxXTL25zH5nDYI81muazg3Phumlf065YFjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9BB6E606E2; Thu, 15 Oct 2026 15:11:22 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: ipvs: avoid passing skb->sk to route_me_harder
Date: Thu, 15 Oct 2026 15:11:12 +0200
Message-ID: <20261015131116.1314-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

skb->sk refers to the original socket and in most cases state->sk and
skb->sk are the same address.

However, when a packet moves through a tunnel, then skb->sk can be the
wrong socket type (e.g. ipv4 instead of ipv6).

Pass the state pointer to IPVS output and ICMP-response helpers in place
of the bare hook number.  This fixes an alleged NULL deref when handling
ipv4 -> ipv6 encap, ip6_route_me_harder calls into ip6 routing code
which assume sk is an ipv6 socket.

Link: https://sashiko.dev/#/patchset/20261011215953.1334630-1-pablo%40netfilter.org
Assisted-by: LLM
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Better solution than
 https://patchwork.ozlabs.org/project/netfilter-devel/patch/20261001120625.29659-3-fw@strlen.de/

 On could argue that we should still do stronger checks in
 route_me_harder APIs too (but then it should stricly check that its ipv4
 resp. ipv6 sk, not 'inet').  It would also be good to review other
 skb->sk use in netfilter/ipvs, there might be other cases where we
 potentially pass AF_PACKET (or whatever) sk down into ip/ip6 output engine.

 net/netfilter/ipvs/ip_vs_core.c | 36 +++++++++++++++++----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index ba0957798bad..dd741df38fec 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -895,24 +895,25 @@ static inline int ip_vs_gather_frags(struct netns_ipvs *ipvs,
 }
 
 static int ip_vs_route_me_harder(struct netns_ipvs *ipvs, int af,
-				 struct sk_buff *skb, unsigned int hooknum)
+				 struct sk_buff *skb,
+				 const struct nf_hook_state *state)
 {
 	if (!sysctl_snat_reroute(ipvs))
 		return 0;
 	/* Reroute replies only to remote clients (FORWARD and LOCAL_OUT) */
-	if (NF_INET_LOCAL_IN == hooknum)
+	if (NF_INET_LOCAL_IN == state->hook)
 		return 0;
 #ifdef CONFIG_IP_VS_IPV6
 	if (af == AF_INET6) {
 		struct dst_entry *dst = skb_dst(skb);
 
 		if (dst->dev && !(dst->dev->flags & IFF_LOOPBACK) &&
-		    ip6_route_me_harder(ipvs->net, skb->sk, skb) != 0)
+		    ip6_route_me_harder(ipvs->net, state->sk, skb) != 0)
 			return 1;
 	} else
 #endif
 		if (!(skb_rtable(skb)->rt_flags & RTCF_LOCAL) &&
-		    ip_route_me_harder(ipvs->net, skb->sk, skb, RTN_LOCAL) != 0)
+		    ip_route_me_harder(ipvs->net, state->sk, skb, RTN_LOCAL) != 0)
 			return 1;
 
 	return 0;
@@ -1029,7 +1030,8 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
 				struct ip_vs_conn *cp,
 				struct ip_vs_protocol *pp,
 				struct ip_vs_iphdr *ciph,
-				unsigned int toff, unsigned int hooknum)
+				unsigned int toff,
+				const struct nf_hook_state *state)
 {
 	int iproto = af == AF_INET6 ? IPPROTO_ICMPV6 : IPPROTO_ICMP;
 	unsigned int verdict = NF_DROP;
@@ -1063,7 +1065,7 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
 		if (!ip_vs_nat_icmp(skb, pp, cp, 1, toff, has_ports, ciph))
 			goto out;
 
-	if (ip_vs_route_me_harder(cp->ipvs, af, skb, hooknum))
+	if (ip_vs_route_me_harder(cp->ipvs, af, skb, state))
 		goto out;
 
 after_nat:
@@ -1089,7 +1091,7 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
  *	Currently handles error types - unreachable, quench, ttl exceeded.
  */
 static int ip_vs_out_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb,
-			  int *related, unsigned int hooknum,
+			  int *related, const struct nf_hook_state *state,
 			  struct ip_vs_iphdr *ipvsh)
 {
 	struct icmphdr	_icmph, *ic;
@@ -1104,7 +1106,7 @@ static int ip_vs_out_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb,
 
 	/* reassemble IP fragments */
 	if (ip_is_fragment(ip_hdr(skb))) {
-		if (ip_vs_gather_frags(ipvs, skb, ip_vs_defrag_user(hooknum)))
+		if (ip_vs_gather_frags(ipvs, skb, ip_vs_defrag_user(state->hook)))
 			return NF_STOLEN;
 		if (!ip_vs_fill_iph_skb(AF_INET, skb, false, ipvsh))
 			return NF_ACCEPT;
@@ -1162,12 +1164,12 @@ static int ip_vs_out_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb,
 
 	snet.ip = ipvsh->saddr.ip;
 	return handle_response_icmp(AF_INET, skb, &snet, cp, pp, &ciph,
-				    ipvsh->len, hooknum);
+				    ipvsh->len, state);
 }
 
 #ifdef CONFIG_IP_VS_IPV6
 static int ip_vs_out_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
-			     int *related,  unsigned int hooknum,
+			     int *related, const struct nf_hook_state *state,
 			     struct ip_vs_iphdr *ipvsh)
 {
 	struct icmp6hdr	_icmph, *ic;
@@ -1222,7 +1224,7 @@ static int ip_vs_out_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
 
 	snet.in6 = ciph.saddr.in6;
 	return handle_response_icmp(AF_INET6, skb, &snet, cp, pp, &ciph,
-				    ipvsh->len, hooknum);
+				    ipvsh->len, state);
 }
 #endif
 
@@ -1437,7 +1439,7 @@ static struct ip_vs_conn *__ip_vs_rs_conn_out(unsigned int hooknum,
 static unsigned int
 handle_response(int af, struct sk_buff *skb, struct ip_vs_proto_data *pd,
 		struct ip_vs_conn *cp, struct ip_vs_iphdr *iph,
-		unsigned int hooknum)
+		const struct nf_hook_state *state)
 {
 	struct ip_vs_protocol *pp = pd->pp;
 
@@ -1479,7 +1481,7 @@ handle_response(int af, struct sk_buff *skb, struct ip_vs_proto_data *pd,
 	 * if it came from this machine itself.  So re-compute
 	 * the routing information.
 	 */
-	if (ip_vs_route_me_harder(cp->ipvs, af, skb, hooknum))
+	if (ip_vs_route_me_harder(cp->ipvs, af, skb, state))
 		goto drop;
 
 	IP_VS_DBG_PKT(10, af, pp, skb, iph->off, "After SNAT");
@@ -1539,7 +1541,7 @@ ip_vs_out_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *stat
 		if (unlikely(iph.protocol == IPPROTO_ICMPV6)) {
 			int related;
 			int verdict = ip_vs_out_icmp_v6(ipvs, skb, &related,
-							hooknum, &iph);
+							state, &iph);
 
 			if (related)
 				return verdict;
@@ -1549,7 +1551,7 @@ ip_vs_out_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *stat
 		if (unlikely(iph.protocol == IPPROTO_ICMP)) {
 			int related;
 			int verdict = ip_vs_out_icmp(ipvs, skb, &related,
-						     hooknum, &iph);
+						     state, &iph);
 
 			if (related)
 				return verdict;
@@ -1579,7 +1581,7 @@ ip_vs_out_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *stat
 			     ipvs, af, skb, &iph);
 
 	if (likely(cp))
-		return handle_response(af, skb, pd, cp, &iph, hooknum);
+		return handle_response(af, skb, pd, cp, &iph, state);
 
 	/* Check for real-server-started requests */
 	if (atomic_read(&ipvs->conn_out_counter[ip_vs_af_index(af)])) {
@@ -1592,7 +1594,7 @@ ip_vs_out_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *stat
 			cp = __ip_vs_rs_conn_out(hooknum, ipvs, af, skb, &iph);
 			if (likely(cp))
 				return handle_response(af, skb, pd, cp, &iph,
-						       hooknum);
+						       state);
 		}
 	}
 
-- 
2.55.0

