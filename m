From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/6] netfilter: nf_tproxy: fix possible non-linear access to transport header
Date: Mon,  9 Jul 2018 19:19:00 +0200
Message-ID: <20180709171904.2460-3-pablo@netfilter.org>
References: <20180709171904.2460-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180709171904.2460-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Máté Eckl <ecklm94@gmail.com>

This patch fixes a silent out-of-bound read possibility that was present
because of the misuse of this function.

Mostly it was called with a struct udphdr *hp which had only the udphdr
part linearized by the skb_header_pointer, however
nf_tproxy_get_sock_v{4,6} uses it as a tcphdr pointer, so some reads for
tcp specific attributes may be invalid.

Fixes: a583636a83ea ("inet: refactor inet[6]_lookup functions to take skb")
Signed-off-by: Máté Eckl <ecklm94@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tproxy.h   |  4 ++--
 net/ipv4/netfilter/nf_tproxy_ipv4.c | 18 ++++++++++++------
 net/ipv6/netfilter/nf_tproxy_ipv6.c | 18 ++++++++++++------
 net/netfilter/xt_TPROXY.c           |  8 ++++----
 4 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/include/net/netfilter/nf_tproxy.h b/include/net/netfilter/nf_tproxy.h
index 9754a50ecde9..4cc64c8446eb 100644
--- a/include/net/netfilter/nf_tproxy.h
+++ b/include/net/netfilter/nf_tproxy.h
@@ -64,7 +64,7 @@ nf_tproxy_handle_time_wait4(struct net *net, struct sk_buff *skb,
  * belonging to established connections going through that one.
  */
 struct sock *
-nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb, void *hp,
+nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb,
 		      const u8 protocol,
 		      const __be32 saddr, const __be32 daddr,
 		      const __be16 sport, const __be16 dport,
@@ -103,7 +103,7 @@ nf_tproxy_handle_time_wait6(struct sk_buff *skb, int tproto, int thoff,
 			    struct sock *sk);
 
 struct sock *
-nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff, void *hp,
+nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 		      const u8 protocol,
 		      const struct in6_addr *saddr, const struct in6_addr *daddr,
 		      const __be16 sport, const __be16 dport,
diff --git a/net/ipv4/netfilter/nf_tproxy_ipv4.c b/net/ipv4/netfilter/nf_tproxy_ipv4.c
index 805e83ec3ad9..164714104965 100644
--- a/net/ipv4/netfilter/nf_tproxy_ipv4.c
+++ b/net/ipv4/netfilter/nf_tproxy_ipv4.c
@@ -37,7 +37,7 @@ nf_tproxy_handle_time_wait4(struct net *net, struct sk_buff *skb,
 		 * to a listener socket if there's one */
 		struct sock *sk2;
 
-		sk2 = nf_tproxy_get_sock_v4(net, skb, hp, iph->protocol,
+		sk2 = nf_tproxy_get_sock_v4(net, skb, iph->protocol,
 					    iph->saddr, laddr ? laddr : iph->daddr,
 					    hp->source, lport ? lport : hp->dest,
 					    skb->dev, NF_TPROXY_LOOKUP_LISTENER);
@@ -71,7 +71,7 @@ __be32 nf_tproxy_laddr4(struct sk_buff *skb, __be32 user_laddr, __be32 daddr)
 EXPORT_SYMBOL_GPL(nf_tproxy_laddr4);
 
 struct sock *
-nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb, void *hp,
+nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb,
 		      const u8 protocol,
 		      const __be32 saddr, const __be32 daddr,
 		      const __be16 sport, const __be16 dport,
@@ -79,16 +79,21 @@ nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb, void *hp,
 		      const enum nf_tproxy_lookup_t lookup_type)
 {
 	struct sock *sk;
-	struct tcphdr *tcph;
 
 	switch (protocol) {
-	case IPPROTO_TCP:
+	case IPPROTO_TCP: {
+		struct tcphdr _hdr, *hp;
+
+		hp = skb_header_pointer(skb, ip_hdrlen(skb),
+					sizeof(struct tcphdr), &_hdr);
+		if (hp == NULL)
+			return NULL;
+
 		switch (lookup_type) {
 		case NF_TPROXY_LOOKUP_LISTENER:
-			tcph = hp;
 			sk = inet_lookup_listener(net, &tcp_hashinfo, skb,
 						    ip_hdrlen(skb) +
-						      __tcp_hdrlen(tcph),
+						      __tcp_hdrlen(hp),
 						    saddr, sport,
 						    daddr, dport,
 						    in->ifindex, 0);
@@ -110,6 +115,7 @@ nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb, void *hp,
 			BUG();
 		}
 		break;
+		}
 	case IPPROTO_UDP:
 		sk = udp4_lib_lookup(net, saddr, sport, daddr, dport,
 				     in->ifindex);
diff --git a/net/ipv6/netfilter/nf_tproxy_ipv6.c b/net/ipv6/netfilter/nf_tproxy_ipv6.c
index bf1d6c421e3b..5dfd33af6451 100644
--- a/net/ipv6/netfilter/nf_tproxy_ipv6.c
+++ b/net/ipv6/netfilter/nf_tproxy_ipv6.c
@@ -55,7 +55,7 @@ nf_tproxy_handle_time_wait6(struct sk_buff *skb, int tproto, int thoff,
 		 * to a listener socket if there's one */
 		struct sock *sk2;
 
-		sk2 = nf_tproxy_get_sock_v6(net, skb, thoff, hp, tproto,
+		sk2 = nf_tproxy_get_sock_v6(net, skb, thoff, tproto,
 					    &iph->saddr,
 					    nf_tproxy_laddr6(skb, laddr, &iph->daddr),
 					    hp->source,
@@ -72,7 +72,7 @@ nf_tproxy_handle_time_wait6(struct sk_buff *skb, int tproto, int thoff,
 EXPORT_SYMBOL_GPL(nf_tproxy_handle_time_wait6);
 
 struct sock *
-nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff, void *hp,
+nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 		      const u8 protocol,
 		      const struct in6_addr *saddr, const struct in6_addr *daddr,
 		      const __be16 sport, const __be16 dport,
@@ -80,15 +80,20 @@ nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff, void *hp,
 		      const enum nf_tproxy_lookup_t lookup_type)
 {
 	struct sock *sk;
-	struct tcphdr *tcph;
 
 	switch (protocol) {
-	case IPPROTO_TCP:
+	case IPPROTO_TCP: {
+		struct tcphdr _hdr, *hp;
+
+		hp = skb_header_pointer(skb, thoff,
+					sizeof(struct tcphdr), &_hdr);
+		if (hp == NULL)
+			return NULL;
+
 		switch (lookup_type) {
 		case NF_TPROXY_LOOKUP_LISTENER:
-			tcph = hp;
 			sk = inet6_lookup_listener(net, &tcp_hashinfo, skb,
-						   thoff + __tcp_hdrlen(tcph),
+						   thoff + __tcp_hdrlen(hp),
 						   saddr, sport,
 						   daddr, ntohs(dport),
 						   in->ifindex, 0);
@@ -110,6 +115,7 @@ nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff, void *hp,
 			BUG();
 		}
 		break;
+		}
 	case IPPROTO_UDP:
 		sk = udp6_lib_lookup(net, saddr, sport, daddr, dport,
 				     in->ifindex);
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 58fce4e749a9..d76550a8b642 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -61,7 +61,7 @@ tproxy_tg4(struct net *net, struct sk_buff *skb, __be32 laddr, __be16 lport,
 	 * addresses, this happens if the redirect already happened
 	 * and the current packet belongs to an already established
 	 * connection */
-	sk = nf_tproxy_get_sock_v4(net, skb, hp, iph->protocol,
+	sk = nf_tproxy_get_sock_v4(net, skb, iph->protocol,
 				   iph->saddr, iph->daddr,
 				   hp->source, hp->dest,
 				   skb->dev, NF_TPROXY_LOOKUP_ESTABLISHED);
@@ -77,7 +77,7 @@ tproxy_tg4(struct net *net, struct sk_buff *skb, __be32 laddr, __be16 lport,
 	else if (!sk)
 		/* no, there's no established connection, check if
 		 * there's a listener on the redirected addr/port */
-		sk = nf_tproxy_get_sock_v4(net, skb, hp, iph->protocol,
+		sk = nf_tproxy_get_sock_v4(net, skb, iph->protocol,
 					   iph->saddr, laddr,
 					   hp->source, lport,
 					   skb->dev, NF_TPROXY_LOOKUP_LISTENER);
@@ -150,7 +150,7 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
 	 * addresses, this happens if the redirect already happened
 	 * and the current packet belongs to an already established
 	 * connection */
-	sk = nf_tproxy_get_sock_v6(xt_net(par), skb, thoff, hp, tproto,
+	sk = nf_tproxy_get_sock_v6(xt_net(par), skb, thoff, tproto,
 				   &iph->saddr, &iph->daddr,
 				   hp->source, hp->dest,
 				   xt_in(par), NF_TPROXY_LOOKUP_ESTABLISHED);
@@ -171,7 +171,7 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
 	else if (!sk)
 		/* no there's no established connection, check if
 		 * there's a listener on the redirected addr/port */
-		sk = nf_tproxy_get_sock_v6(xt_net(par), skb, thoff, hp,
+		sk = nf_tproxy_get_sock_v6(xt_net(par), skb, thoff,
 					   tproto, &iph->saddr, laddr,
 					   hp->source, lport,
 					   xt_in(par), NF_TPROXY_LOOKUP_LISTENER);
-- 
2.11.0
