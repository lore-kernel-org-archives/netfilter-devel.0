From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 47/51] netfilter: nf_nat: remove unused ct arg from lookup functions
Date: Mon,  7 May 2018 00:47:05 +0200
Message-ID: <20180506224709.29100-48-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat_l3proto.h   | 24 ++++++++----------------
 net/ipv4/netfilter/iptable_nat.c         |  3 +--
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c | 14 +++++---------
 net/ipv4/netfilter/nft_chain_nat_ipv4.c  |  3 +--
 net/ipv6/netfilter/ip6table_nat.c        |  3 +--
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c | 14 +++++---------
 net/ipv6/netfilter/nft_chain_nat_ipv6.c  |  3 +--
 7 files changed, 22 insertions(+), 42 deletions(-)

diff --git a/include/net/netfilter/nf_nat_l3proto.h b/include/net/netfilter/nf_nat_l3proto.h
index ac47098a61dc..8bad2560576f 100644
--- a/include/net/netfilter/nf_nat_l3proto.h
+++ b/include/net/netfilter/nf_nat_l3proto.h
@@ -48,30 +48,26 @@ unsigned int nf_nat_ipv4_in(void *priv, struct sk_buff *skb,
 			    const struct nf_hook_state *state,
 			    unsigned int (*do_chain)(void *priv,
 						     struct sk_buff *skb,
-						     const struct nf_hook_state *state,
-						     struct nf_conn *ct));
+						     const struct nf_hook_state *state));
 
 unsigned int nf_nat_ipv4_out(void *priv, struct sk_buff *skb,
 			     const struct nf_hook_state *state,
 			     unsigned int (*do_chain)(void *priv,
 						      struct sk_buff *skb,
-						      const struct nf_hook_state *state,
-						      struct nf_conn *ct));
+						      const struct nf_hook_state *state));
 
 unsigned int nf_nat_ipv4_local_fn(void *priv,
 				  struct sk_buff *skb,
 				  const struct nf_hook_state *state,
 				  unsigned int (*do_chain)(void *priv,
 							   struct sk_buff *skb,
-							   const struct nf_hook_state *state,
-							   struct nf_conn *ct));
+							   const struct nf_hook_state *state));
 
 unsigned int nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
 			    const struct nf_hook_state *state,
 			    unsigned int (*do_chain)(void *priv,
 						     struct sk_buff *skb,
-						     const struct nf_hook_state *state,
-						     struct nf_conn *ct));
+						     const struct nf_hook_state *state));
 
 int nf_nat_icmpv6_reply_translation(struct sk_buff *skb, struct nf_conn *ct,
 				    enum ip_conntrack_info ctinfo,
@@ -81,29 +77,25 @@ unsigned int nf_nat_ipv6_in(void *priv, struct sk_buff *skb,
 			    const struct nf_hook_state *state,
 			    unsigned int (*do_chain)(void *priv,
 						     struct sk_buff *skb,
-						     const struct nf_hook_state *state,
-						     struct nf_conn *ct));
+						     const struct nf_hook_state *state));
 
 unsigned int nf_nat_ipv6_out(void *priv, struct sk_buff *skb,
 			     const struct nf_hook_state *state,
 			     unsigned int (*do_chain)(void *priv,
 						      struct sk_buff *skb,
-						      const struct nf_hook_state *state,
-						      struct nf_conn *ct));
+						      const struct nf_hook_state *state));
 
 unsigned int nf_nat_ipv6_local_fn(void *priv,
 				  struct sk_buff *skb,
 				  const struct nf_hook_state *state,
 				  unsigned int (*do_chain)(void *priv,
 							   struct sk_buff *skb,
-							   const struct nf_hook_state *state,
-							   struct nf_conn *ct));
+							   const struct nf_hook_state *state));
 
 unsigned int nf_nat_ipv6_fn(void *priv, struct sk_buff *skb,
 			    const struct nf_hook_state *state,
 			    unsigned int (*do_chain)(void *priv,
 						     struct sk_buff *skb,
-						     const struct nf_hook_state *state,
-						     struct nf_conn *ct));
+						     const struct nf_hook_state *state));
 
 #endif /* _NF_NAT_L3PROTO_H */
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index 0f7255cc65ee..529d89ec31e8 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -33,8 +33,7 @@ static const struct xt_table nf_nat_ipv4_table = {
 
 static unsigned int iptable_nat_do_chain(void *priv,
 					 struct sk_buff *skb,
-					 const struct nf_hook_state *state,
-					 struct nf_conn *ct)
+					 const struct nf_hook_state *state)
 {
 	return ipt_do_table(skb, state, state->net->ipv4.nat_table);
 }
diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
index 4346336cee4c..325e02956bf5 100644
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
@@ -246,8 +246,7 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
 	       const struct nf_hook_state *state,
 	       unsigned int (*do_chain)(void *priv,
 					struct sk_buff *skb,
-					const struct nf_hook_state *state,
-					struct nf_conn *ct))
+					const struct nf_hook_state *state))
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
@@ -285,7 +284,7 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
 		if (!nf_nat_initialized(ct, maniptype)) {
 			unsigned int ret;
 
-			ret = do_chain(priv, skb, state, ct);
+			ret = do_chain(priv, skb, state);
 			if (ret != NF_ACCEPT)
 				return ret;
 
@@ -326,8 +325,7 @@ nf_nat_ipv4_in(void *priv, struct sk_buff *skb,
 	       const struct nf_hook_state *state,
 	       unsigned int (*do_chain)(void *priv,
 					 struct sk_buff *skb,
-					 const struct nf_hook_state *state,
-					 struct nf_conn *ct))
+					 const struct nf_hook_state *state))
 {
 	unsigned int ret;
 	__be32 daddr = ip_hdr(skb)->daddr;
@@ -346,8 +344,7 @@ nf_nat_ipv4_out(void *priv, struct sk_buff *skb,
 		const struct nf_hook_state *state,
 		unsigned int (*do_chain)(void *priv,
 					  struct sk_buff *skb,
-					  const struct nf_hook_state *state,
-					  struct nf_conn *ct))
+					  const struct nf_hook_state *state))
 {
 #ifdef CONFIG_XFRM
 	const struct nf_conn *ct;
@@ -383,8 +380,7 @@ nf_nat_ipv4_local_fn(void *priv, struct sk_buff *skb,
 		     const struct nf_hook_state *state,
 		     unsigned int (*do_chain)(void *priv,
 					       struct sk_buff *skb,
-					       const struct nf_hook_state *state,
-					       struct nf_conn *ct))
+					       const struct nf_hook_state *state))
 {
 	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
diff --git a/net/ipv4/netfilter/nft_chain_nat_ipv4.c b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
index b5464a3f253b..285baccfbdea 100644
--- a/net/ipv4/netfilter/nft_chain_nat_ipv4.c
+++ b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
@@ -28,8 +28,7 @@
 
 static unsigned int nft_nat_do_chain(void *priv,
 				      struct sk_buff *skb,
-				      const struct nf_hook_state *state,
-				      struct nf_conn *ct)
+				      const struct nf_hook_state *state)
 {
 	struct nft_pktinfo pkt;
 
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index 47306e45a80a..2bf554e18af8 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -35,8 +35,7 @@ static const struct xt_table nf_nat_ipv6_table = {
 
 static unsigned int ip6table_nat_do_chain(void *priv,
 					  struct sk_buff *skb,
-					  const struct nf_hook_state *state,
-					  struct nf_conn *ct)
+					  const struct nf_hook_state *state)
 {
 	return ip6t_do_table(skb, state, state->net->ipv6.ip6table_nat);
 }
diff --git a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
index 56d75eb5448f..f1582b6f9588 100644
--- a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
@@ -257,8 +257,7 @@ nf_nat_ipv6_fn(void *priv, struct sk_buff *skb,
 	       const struct nf_hook_state *state,
 	       unsigned int (*do_chain)(void *priv,
 					struct sk_buff *skb,
-					const struct nf_hook_state *state,
-					struct nf_conn *ct))
+					const struct nf_hook_state *state))
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
@@ -303,7 +302,7 @@ nf_nat_ipv6_fn(void *priv, struct sk_buff *skb,
 		if (!nf_nat_initialized(ct, maniptype)) {
 			unsigned int ret;
 
-			ret = do_chain(priv, skb, state, ct);
+			ret = do_chain(priv, skb, state);
 			if (ret != NF_ACCEPT)
 				return ret;
 
@@ -343,8 +342,7 @@ nf_nat_ipv6_in(void *priv, struct sk_buff *skb,
 	       const struct nf_hook_state *state,
 	       unsigned int (*do_chain)(void *priv,
 					struct sk_buff *skb,
-					const struct nf_hook_state *state,
-					struct nf_conn *ct))
+					const struct nf_hook_state *state))
 {
 	unsigned int ret;
 	struct in6_addr daddr = ipv6_hdr(skb)->daddr;
@@ -363,8 +361,7 @@ nf_nat_ipv6_out(void *priv, struct sk_buff *skb,
 		const struct nf_hook_state *state,
 		unsigned int (*do_chain)(void *priv,
 					 struct sk_buff *skb,
-					 const struct nf_hook_state *state,
-					 struct nf_conn *ct))
+					 const struct nf_hook_state *state))
 {
 #ifdef CONFIG_XFRM
 	const struct nf_conn *ct;
@@ -400,8 +397,7 @@ nf_nat_ipv6_local_fn(void *priv, struct sk_buff *skb,
 		     const struct nf_hook_state *state,
 		     unsigned int (*do_chain)(void *priv,
 					      struct sk_buff *skb,
-					      const struct nf_hook_state *state,
-					      struct nf_conn *ct))
+					      const struct nf_hook_state *state))
 {
 	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
diff --git a/net/ipv6/netfilter/nft_chain_nat_ipv6.c b/net/ipv6/netfilter/nft_chain_nat_ipv6.c
index 3557b114446c..100a6bd1046a 100644
--- a/net/ipv6/netfilter/nft_chain_nat_ipv6.c
+++ b/net/ipv6/netfilter/nft_chain_nat_ipv6.c
@@ -26,8 +26,7 @@
 
 static unsigned int nft_nat_do_chain(void *priv,
 				     struct sk_buff *skb,
-				     const struct nf_hook_state *state,
-				     struct nf_conn *ct)
+				     const struct nf_hook_state *state)
 {
 	struct nft_pktinfo pkt;
 
-- 
2.11.0
