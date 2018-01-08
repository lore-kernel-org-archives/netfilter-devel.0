From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/52] netfilter: ipvs: Remove useless ipvsh param of frag_safe_skb_hp
Date: Mon,  8 Jan 2018 21:19:14 +0100
Message-ID: <20180108202000.12989-7-pablo@netfilter.org>
References: <20180108202000.12989-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180108202000.12989-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Gao Feng <gfree.wind@vip.163.com>

The param of frag_safe_skb_hp, ipvsh, isn't used now. So remove it and
update the callers' codes too.

Signed-off-by: Gao Feng <gfree.wind@vip.163.com>
Acked-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h             |  3 +--
 net/netfilter/ipvs/ip_vs_conn.c |  2 +-
 net/netfilter/ipvs/ip_vs_core.c | 12 ++++++------
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index ff68cf288f9b..eb0bec043c96 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -69,8 +69,7 @@ struct ip_vs_iphdr {
 };
 
 static inline void *frag_safe_skb_hp(const struct sk_buff *skb, int offset,
-				      int len, void *buffer,
-				      const struct ip_vs_iphdr *ipvsh)
+				      int len, void *buffer)
 {
 	return skb_header_pointer(skb, offset, len, buffer);
 }
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 3e053cb30070..f489b8db2406 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -322,7 +322,7 @@ ip_vs_conn_fill_param_proto(struct netns_ipvs *ipvs,
 {
 	__be16 _ports[2], *pptr;
 
-	pptr = frag_safe_skb_hp(skb, iph->len, sizeof(_ports), _ports, iph);
+	pptr = frag_safe_skb_hp(skb, iph->len, sizeof(_ports), _ports);
 	if (pptr == NULL)
 		return 1;
 
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 5cb7cac9177d..5f6f73cf2174 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -433,7 +433,7 @@ ip_vs_schedule(struct ip_vs_service *svc, struct sk_buff *skb,
 	/*
 	 * IPv6 frags, only the first hit here.
 	 */
-	pptr = frag_safe_skb_hp(skb, iph->len, sizeof(_ports), _ports, iph);
+	pptr = frag_safe_skb_hp(skb, iph->len, sizeof(_ports), _ports);
 	if (pptr == NULL)
 		return NULL;
 
@@ -566,7 +566,7 @@ int ip_vs_leave(struct ip_vs_service *svc, struct sk_buff *skb,
 	struct netns_ipvs *ipvs = svc->ipvs;
 	struct net *net = ipvs->net;
 
-	pptr = frag_safe_skb_hp(skb, iph->len, sizeof(_ports), _ports, iph);
+	pptr = frag_safe_skb_hp(skb, iph->len, sizeof(_ports), _ports);
 	if (!pptr)
 		return NF_DROP;
 	dport = likely(!ip_vs_iph_inverse(iph)) ? pptr[1] : pptr[0];
@@ -982,7 +982,7 @@ static int ip_vs_out_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
 	unsigned int offset;
 
 	*related = 1;
-	ic = frag_safe_skb_hp(skb, ipvsh->len, sizeof(_icmph), &_icmph, ipvsh);
+	ic = frag_safe_skb_hp(skb, ipvsh->len, sizeof(_icmph), &_icmph);
 	if (ic == NULL)
 		return NF_DROP;
 
@@ -1214,7 +1214,7 @@ static struct ip_vs_conn *__ip_vs_rs_conn_out(unsigned int hooknum,
 		return NULL;
 
 	pptr = frag_safe_skb_hp(skb, iph->len,
-				sizeof(_ports), _ports, iph);
+				sizeof(_ports), _ports);
 	if (!pptr)
 		return NULL;
 
@@ -1407,7 +1407,7 @@ ip_vs_out(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, in
 		__be16 _ports[2], *pptr;
 
 		pptr = frag_safe_skb_hp(skb, iph.len,
-					 sizeof(_ports), _ports, &iph);
+					 sizeof(_ports), _ports);
 		if (pptr == NULL)
 			return NF_ACCEPT;	/* Not for me */
 		if (ip_vs_has_real_service(ipvs, af, iph.protocol, &iph.saddr,
@@ -1741,7 +1741,7 @@ static int ip_vs_in_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
 
 	*related = 1;
 
-	ic = frag_safe_skb_hp(skb, iph->len, sizeof(_icmph), &_icmph, iph);
+	ic = frag_safe_skb_hp(skb, iph->len, sizeof(_icmph), &_icmph);
 	if (ic == NULL)
 		return NF_DROP;
 
-- 
2.11.0
