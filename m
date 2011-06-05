From: pablo@netfilter.org
Subject: [PATCH 15/20] ipvs: Avoid undefined order of evaluation in assignments to struct nf_conn *
Date: Mon,  6 Jun 2011 01:09:05 +0200
Message-ID: <1307315350-17782-15-git-send-email-pablo@netfilter.org>
References: <1307315350-17782-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Jesper Juhl <jj@chaosbits.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52235 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756491Ab1FEXJs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jun 2011 19:09:48 -0400
In-Reply-To: <1307315350-17782-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jesper Juhl <jj@chaosbits.net>

In net/netfilter/ipvs/ip_vs_nfct.c::ip_vs_update_conntrack(),
net/netfilter/ipvs/ip_vs_xmit.c::ip_vs_nat_xmit(),
net/netfilter/ipvs/ip_vs_xmit.c::ip_vs_nat_xmit_v6(),
net/netfilter/ipvs/ip_vs_xmit.c::ip_vs_icmp_xmit)()
net/netfilter/ipvs/ip_vs_xmit.c::and ip_vs_icmp_xmit_v6() we do this:
	...
	struct nf_conn *ct = ct = nf_ct_get(skb, &ctinfo);
	...

Since '=' is not a sequence point the order of these assignments happening
is undefined. Luckily it's easy to avoid by just doing what is obviously
the intended thing:
	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_nfct.c |    2 +-
 net/netfilter/ipvs/ip_vs_xmit.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_nfct.c b/net/netfilter/ipvs/ip_vs_nfct.c
index f454c80..a3d86c2 100644
--- a/net/netfilter/ipvs/ip_vs_nfct.c
+++ b/net/netfilter/ipvs/ip_vs_nfct.c
@@ -82,7 +82,7 @@ void
 ip_vs_update_conntrack(struct sk_buff *skb, struct ip_vs_conn *cp, int outin)
 {
 	enum ip_conntrack_info ctinfo;
-	struct nf_conn *ct = ct = nf_ct_get(skb, &ctinfo);
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	struct nf_conntrack_tuple new_tuple;
 
 	if (ct == NULL || nf_ct_is_confirmed(ct) || nf_ct_is_untracked(ct) ||
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index ee319a4..16d129e 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -544,7 +544,7 @@ ip_vs_nat_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	if (cp->flags & IP_VS_CONN_F_SYNC && local) {
 		enum ip_conntrack_info ctinfo;
-		struct nf_conn *ct = ct = nf_ct_get(skb, &ctinfo);
+		struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 
 		if (ct && !nf_ct_is_untracked(ct)) {
 			IP_VS_DBG_RL_PKT(10, AF_INET, pp, skb, 0,
@@ -661,7 +661,7 @@ ip_vs_nat_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	if (cp->flags & IP_VS_CONN_F_SYNC && local) {
 		enum ip_conntrack_info ctinfo;
-		struct nf_conn *ct = ct = nf_ct_get(skb, &ctinfo);
+		struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 
 		if (ct && !nf_ct_is_untracked(ct)) {
 			IP_VS_DBG_RL_PKT(10, AF_INET6, pp, skb, 0,
@@ -1176,7 +1176,7 @@ ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	if (cp->flags & IP_VS_CONN_F_SYNC && local) {
 		enum ip_conntrack_info ctinfo;
-		struct nf_conn *ct = ct = nf_ct_get(skb, &ctinfo);
+		struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 
 		if (ct && !nf_ct_is_untracked(ct)) {
 			IP_VS_DBG(10, "%s(): "
@@ -1296,7 +1296,7 @@ ip_vs_icmp_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	if (cp->flags & IP_VS_CONN_F_SYNC && local) {
 		enum ip_conntrack_info ctinfo;
-		struct nf_conn *ct = ct = nf_ct_get(skb, &ctinfo);
+		struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 
 		if (ct && !nf_ct_is_untracked(ct)) {
 			IP_VS_DBG(10, "%s(): "
-- 
1.7.2.5

