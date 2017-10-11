From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/3] netfilter: conntrack: remove pf argument from l4 packet functions
Date: Wed, 11 Oct 2017 10:47:42 +0200
Message-ID: <20171011084742.25989-4-fw@strlen.de>
References: <20171011084742.25989-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39188 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757174AbdJKIrf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 04:47:35 -0400
In-Reply-To: <20171011084742.25989-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

not needed/used anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_l4proto.h   | 1 -
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   | 1 -
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c | 1 -
 net/netfilter/nf_conntrack_core.c              | 2 +-
 net/netfilter/nf_conntrack_proto_dccp.c        | 1 -
 net/netfilter/nf_conntrack_proto_generic.c     | 1 -
 net/netfilter/nf_conntrack_proto_gre.c         | 1 -
 net/netfilter/nf_conntrack_proto_sctp.c        | 1 -
 net/netfilter/nf_conntrack_proto_tcp.c         | 6 ++----
 net/netfilter/nf_conntrack_proto_udp.c         | 1 -
 10 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 5d51255b5bfb..e06518874144 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -42,7 +42,6 @@ struct nf_conntrack_l4proto {
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
-		      u_int8_t pf,
 		      unsigned int *timeouts);
 
 	/* Called when a new connection for this protocol found;
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 7281a7b77a0e..8969420cecc3 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -81,7 +81,6 @@ static int icmp_packet(struct nf_conn *ct,
 		       const struct sk_buff *skb,
 		       unsigned int dataoff,
 		       enum ip_conntrack_info ctinfo,
-		       u_int8_t pf,
 		       unsigned int *timeout)
 {
 	/* Do not immediately delete the connection after the first
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 0f227ca4a5a2..dca921df28e1 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -94,7 +94,6 @@ static int icmpv6_packet(struct nf_conn *ct,
 		       const struct sk_buff *skb,
 		       unsigned int dataoff,
 		       enum ip_conntrack_info ctinfo,
-		       u_int8_t pf,
 		       unsigned int *timeout)
 {
 	/* Do not immediately delete the connection after the first
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 01130392b7c0..28e675150853 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1419,7 +1419,7 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 	/* Decide what timeout policy we want to apply to this flow. */
 	timeouts = nf_ct_timeout_lookup(net, ct, l4proto);
 
-	ret = l4proto->packet(ct, skb, dataoff, ctinfo, pf, timeouts);
+	ret = l4proto->packet(ct, skb, dataoff, ctinfo, timeouts);
 	if (ret <= 0) {
 		/* Invalid: inverse of the return code tells
 		 * the netfilter core what to do */
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 49e0abcdc6f4..2a446f4a554c 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -467,7 +467,6 @@ static unsigned int *dccp_get_timeouts(struct net *net)
 
 static int dccp_packet(struct nf_conn *ct, const struct sk_buff *skb,
 		       unsigned int dataoff, enum ip_conntrack_info ctinfo,
-		       u_int8_t pf,
 		       unsigned int *timeouts)
 {
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 9cd40700842e..1f86ddf6649a 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -60,7 +60,6 @@ static int generic_packet(struct nf_conn *ct,
 			  const struct sk_buff *skb,
 			  unsigned int dataoff,
 			  enum ip_conntrack_info ctinfo,
-			  u_int8_t pf,
 			  unsigned int *timeout)
 {
 	nf_ct_refresh_acct(ct, ctinfo, skb, *timeout);
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 09a90484c27d..a2503005d80b 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -244,7 +244,6 @@ static int gre_packet(struct nf_conn *ct,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
-		      u_int8_t pf,
 		      unsigned int *timeouts)
 {
 	/* If we've seen traffic both ways, this is a GRE connection.
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index aa630c561361..80faf04ddf15 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -306,7 +306,6 @@ static int sctp_packet(struct nf_conn *ct,
 		       const struct sk_buff *skb,
 		       unsigned int dataoff,
 		       enum ip_conntrack_info ctinfo,
-		       u_int8_t pf,
 		       unsigned int *timeouts)
 {
 	enum sctp_conntrack new_state, old_state;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index dced574f6006..8f283294d70f 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -493,8 +493,7 @@ static bool tcp_in_window(const struct nf_conn *ct,
 			  unsigned int index,
 			  const struct sk_buff *skb,
 			  unsigned int dataoff,
-			  const struct tcphdr *tcph,
-			  u_int8_t pf)
+			  const struct tcphdr *tcph)
 {
 	struct net *net = nf_ct_net(ct);
 	struct nf_tcp_net *tn = tcp_pernet(net);
@@ -801,7 +800,6 @@ static int tcp_packet(struct nf_conn *ct,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
-		      u_int8_t pf,
 		      unsigned int *timeouts)
 {
 	struct net *net = nf_ct_net(ct);
@@ -1013,7 +1011,7 @@ static int tcp_packet(struct nf_conn *ct,
 	}
 
 	if (!tcp_in_window(ct, &ct->proto.tcp, dir, index,
-			   skb, dataoff, th, pf)) {
+			   skb, dataoff, th)) {
 		spin_unlock_bh(&ct->lock);
 		return -NF_ACCEPT;
 	}
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index fc20cf430251..3a5f727103af 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -73,7 +73,6 @@ static int udp_packet(struct nf_conn *ct,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
-		      u_int8_t pf,
 		      unsigned int *timeouts)
 {
 	/* If we've seen traffic both ways, this is some kind of UDP
-- 
2.13.6

