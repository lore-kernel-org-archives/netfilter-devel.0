From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: conntrack: remove unused hooknum arg from packet functions
Date: Thu, 24 Aug 2017 17:42:25 +0200
Message-ID: <20170824154225.30763-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36482 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752984AbdHXPmH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 11:42:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Don't see where this is used; passed allmodconfig build.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_l4proto.h   | 1 -
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   | 1 -
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c | 6 ++----
 net/netfilter/nf_conntrack_core.c              | 2 +-
 net/netfilter/nf_conntrack_proto_dccp.c        | 2 +-
 net/netfilter/nf_conntrack_proto_generic.c     | 1 -
 net/netfilter/nf_conntrack_proto_gre.c         | 1 -
 net/netfilter/nf_conntrack_proto_sctp.c        | 1 -
 net/netfilter/nf_conntrack_proto_tcp.c         | 1 -
 net/netfilter/nf_conntrack_proto_udp.c         | 1 -
 10 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index b6e27cafb1d9..37d5e3e984e7 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -43,7 +43,6 @@ struct nf_conntrack_l4proto {
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
 		      u_int8_t pf,
-		      unsigned int hooknum,
 		      unsigned int *timeouts);
 
 	/* Called when a new connection for this protocol found;
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 73c591d8a9a8..302ef5a38d69 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -92,7 +92,6 @@ static int icmp_packet(struct nf_conn *ct,
 		       unsigned int dataoff,
 		       enum ip_conntrack_info ctinfo,
 		       u_int8_t pf,
-		       unsigned int hooknum,
 		       unsigned int *timeout)
 {
 	/* Do not immediately delete the connection after the first
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index d5f028e33f65..413c4a0093da 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -105,7 +105,6 @@ static int icmpv6_packet(struct nf_conn *ct,
 		       unsigned int dataoff,
 		       enum ip_conntrack_info ctinfo,
 		       u_int8_t pf,
-		       unsigned int hooknum,
 		       unsigned int *timeout)
 {
 	/* Do not immediately delete the connection after the first
@@ -144,8 +143,7 @@ static bool icmpv6_new(struct nf_conn *ct, const struct sk_buff *skb,
 static int
 icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 		     struct sk_buff *skb,
-		     unsigned int icmp6off,
-		     unsigned int hooknum)
+		     unsigned int icmp6off)
 {
 	struct nf_conntrack_tuple intuple, origtuple;
 	const struct nf_conntrack_tuple_hash *h;
@@ -229,7 +227,7 @@ icmpv6_error(struct net *net, struct nf_conn *tmpl,
 	if (icmp6h->icmp6_type >= 128)
 		return NF_ACCEPT;
 
-	return icmpv6_error_message(net, tmpl, skb, dataoff, hooknum);
+	return icmpv6_error_message(net, tmpl, skb, dataoff);
 }
 
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f2f00eaf217d..92faa72bc55e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1414,7 +1414,7 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 	/* Decide what timeout policy we want to apply to this flow. */
 	timeouts = nf_ct_timeout_lookup(net, ct, l4proto);
 
-	ret = l4proto->packet(ct, skb, dataoff, ctinfo, pf, hooknum, timeouts);
+	ret = l4proto->packet(ct, skb, dataoff, ctinfo, pf, timeouts);
 	if (ret <= 0) {
 		/* Invalid: inverse of the return code tells
 		 * the netfilter core what to do */
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 4707d997558a..81bfd4399616 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -469,7 +469,7 @@ static unsigned int *dccp_get_timeouts(struct net *net)
 
 static int dccp_packet(struct nf_conn *ct, const struct sk_buff *skb,
 		       unsigned int dataoff, enum ip_conntrack_info ctinfo,
-		       u_int8_t pf, unsigned int hooknum,
+		       u_int8_t pf,
 		       unsigned int *timeouts)
 {
 	struct net *net = nf_ct_net(ct);
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index d5868bad33a7..cb14a292becc 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -79,7 +79,6 @@ static int generic_packet(struct nf_conn *ct,
 			  unsigned int dataoff,
 			  enum ip_conntrack_info ctinfo,
 			  u_int8_t pf,
-			  unsigned int hooknum,
 			  unsigned int *timeout)
 {
 	nf_ct_refresh_acct(ct, ctinfo, skb, *timeout);
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 87bb40a3feb5..ee45df00a95f 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -252,7 +252,6 @@ static int gre_packet(struct nf_conn *ct,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
 		      u_int8_t pf,
-		      unsigned int hooknum,
 		      unsigned int *timeouts)
 {
 	/* If we've seen traffic both ways, this is a GRE connection.
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 6eef29d2eec4..9361e91b6615 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -314,7 +314,6 @@ static int sctp_packet(struct nf_conn *ct,
 		       unsigned int dataoff,
 		       enum ip_conntrack_info ctinfo,
 		       u_int8_t pf,
-		       unsigned int hooknum,
 		       unsigned int *timeouts)
 {
 	enum sctp_conntrack new_state, old_state;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 9758a7dfd83e..4d516e5d3547 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -810,7 +810,6 @@ static int tcp_packet(struct nf_conn *ct,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
 		      u_int8_t pf,
-		      unsigned int hooknum,
 		      unsigned int *timeouts)
 {
 	struct net *net = nf_ct_net(ct);
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index f6ebce6178ca..092fd87954ed 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -83,7 +83,6 @@ static int udp_packet(struct nf_conn *ct,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
 		      u_int8_t pf,
-		      unsigned int hooknum,
 		      unsigned int *timeouts)
 {
 	/* If we've seen traffic both ways, this is some kind of UDP
-- 
2.13.0

