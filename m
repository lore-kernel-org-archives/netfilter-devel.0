From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/3] netfilter: conntrack: add and use nf_l4proto_log_invalid
Date: Wed, 11 Oct 2017 10:47:40 +0200
Message-ID: <20171011084742.25989-2-fw@strlen.de>
References: <20171011084742.25989-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39182 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756569AbdJKIr2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 04:47:28 -0400
In-Reply-To: <20171011084742.25989-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We currently pass down the l4 protocol to the conntrack ->packet()
function, but the only user of this is the debug info decision.

Same information can be derived from struct nf_conn.
As a first step, add and use a new log function for this, similar to
nf_ct_helper_log().

Add __cold annotation -- invalid packets should be infrequent so
gcc can consider all call paths that lead to such a function as
unlikely.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_l4proto.h   | 10 +++++++
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   | 18 ++++++------
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c | 14 +++++----
 net/netfilter/nf_conntrack_proto.c             | 24 ++++++++++++++++
 net/netfilter/nf_conntrack_proto_dccp.c        |  3 +-
 net/netfilter/nf_conntrack_proto_sctp.c        |  3 +-
 net/netfilter/nf_conntrack_proto_tcp.c         | 22 +++++++-------
 net/netfilter/nf_conntrack_proto_udp.c         | 40 ++++++++++++--------------
 8 files changed, 82 insertions(+), 52 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 738a0307a96b..6d79a061d360 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -152,8 +152,18 @@ extern const struct nla_policy nf_ct_port_nla_policy[];
 #define LOG_INVALID(net, proto)				\
 	((net)->ct.sysctl_log_invalid == (proto) ||	\
 	 (net)->ct.sysctl_log_invalid == IPPROTO_RAW)
+
+__printf(5, 6) __cold
+void nf_l4proto_log_invalid(const struct sk_buff *skb,
+			    struct net *net,
+			    u16 pf, u8 protonum,
+			    const char *fmt, ...);
 #else
 static inline int LOG_INVALID(struct net *net, int proto) { return 0; }
+
+static inline __printf(5, 6) __cold
+void nf_l4proto_log_invalid(const struct sk_buff *skb, struct net *net,
+			    u16 pf, u8 protonum, const char *fmt, ...) {}
 #endif /* CONFIG_SYSCTL */
 
 #endif /*_NF_CONNTRACK_PROTOCOL_H*/
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index a046c298413a..7281a7b77a0e 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -165,6 +165,12 @@ icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 	return NF_ACCEPT;
 }
 
+static void icmp_error_log(const struct sk_buff *skb, struct net *net,
+			   u8 pf, const char *msg)
+{
+	nf_l4proto_log_invalid(skb, net, pf, IPPROTO_ICMP, "%s", msg);
+}
+
 /* Small and modified version of icmp_rcv */
 static int
 icmp_error(struct net *net, struct nf_conn *tmpl,
@@ -177,18 +183,14 @@ icmp_error(struct net *net, struct nf_conn *tmpl,
 	/* Not enough header? */
 	icmph = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_ih), &_ih);
 	if (icmph == NULL) {
-		if (LOG_INVALID(net, IPPROTO_ICMP))
-			nf_log_packet(net, PF_INET, 0, skb, NULL, NULL,
-				      NULL, "nf_ct_icmp: short packet ");
+		icmp_error_log(skb, net, pf, "short packet");
 		return -NF_ACCEPT;
 	}
 
 	/* See ip_conntrack_proto_tcp.c */
 	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
 	    nf_ip_checksum(skb, hooknum, dataoff, 0)) {
-		if (LOG_INVALID(net, IPPROTO_ICMP))
-			nf_log_packet(net, PF_INET, 0, skb, NULL, NULL, NULL,
-				      "nf_ct_icmp: bad HW ICMP checksum ");
+		icmp_error_log(skb, net, pf, "bad hw icmp checksum");
 		return -NF_ACCEPT;
 	}
 
@@ -199,9 +201,7 @@ icmp_error(struct net *net, struct nf_conn *tmpl,
 	 *		  discarded.
 	 */
 	if (icmph->type > NR_ICMP_TYPES) {
-		if (LOG_INVALID(net, IPPROTO_ICMP))
-			nf_log_packet(net, PF_INET, 0, skb, NULL, NULL, NULL,
-				      "nf_ct_icmp: invalid ICMP type ");
+		icmp_error_log(skb, net, pf, "invalid icmp type");
 		return -NF_ACCEPT;
 	}
 
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index a9e1fd1a8536..0f227ca4a5a2 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -176,6 +176,12 @@ icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 	return NF_ACCEPT;
 }
 
+static void icmpv6_error_log(const struct sk_buff *skb, struct net *net,
+			     u8 pf, const char *msg)
+{
+	nf_l4proto_log_invalid(skb, net, pf, IPPROTO_ICMPV6, "%s", msg);
+}
+
 static int
 icmpv6_error(struct net *net, struct nf_conn *tmpl,
 	     struct sk_buff *skb, unsigned int dataoff,
@@ -187,17 +193,13 @@ icmpv6_error(struct net *net, struct nf_conn *tmpl,
 
 	icmp6h = skb_header_pointer(skb, dataoff, sizeof(_ih), &_ih);
 	if (icmp6h == NULL) {
-		if (LOG_INVALID(net, IPPROTO_ICMPV6))
-			nf_log_packet(net, PF_INET6, 0, skb, NULL, NULL, NULL,
-			      "nf_ct_icmpv6: short packet ");
+		icmpv6_error_log(skb, net, pf, "short packet");
 		return -NF_ACCEPT;
 	}
 
 	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
 	    nf_ip6_checksum(skb, hooknum, dataoff, IPPROTO_ICMPV6)) {
-		if (LOG_INVALID(net, IPPROTO_ICMPV6))
-			nf_log_packet(net, PF_INET6, 0, skb, NULL, NULL, NULL,
-				      "nf_ct_icmpv6: ICMPv6 checksum failed ");
+		icmpv6_error_log(skb, net, pf, "ICMPv6 checksum failed");
 		return -NF_ACCEPT;
 	}
 
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index b3e489c859ec..bcd3ee270d75 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -27,6 +27,7 @@
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_log.h>
 
 static struct nf_conntrack_l4proto __rcu **nf_ct_protos[NFPROTO_NUMPROTO] __read_mostly;
 struct nf_conntrack_l3proto __rcu *nf_ct_l3protos[NFPROTO_NUMPROTO] __read_mostly;
@@ -63,6 +64,29 @@ nf_ct_unregister_sysctl(struct ctl_table_header **header,
 	*header = NULL;
 	*table = NULL;
 }
+
+__printf(5, 6)
+void nf_l4proto_log_invalid(const struct sk_buff *skb,
+			    struct net *net,
+			    u16 pf, u8 protonum,
+			    const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	if (net->ct.sysctl_log_invalid != protonum ||
+	    net->ct.sysctl_log_invalid != IPPROTO_RAW)
+		return;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
+		      "nf_ct_proto_%d: %pV ", protonum, &vaf);
+	va_end(args);
+}
+EXPORT_SYMBOL_GPL(nf_l4proto_log_invalid);
 #endif
 
 const struct nf_conntrack_l4proto *
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 0f5a4d79f6b8..ef501c7edb96 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -604,8 +604,7 @@ static int dccp_error(struct net *net, struct nf_conn *tmpl,
 	return NF_ACCEPT;
 
 out_invalid:
-	if (LOG_INVALID(net, IPPROTO_DCCP))
-		nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL, "%s", msg);
+	nf_l4proto_log_invalid(skb, net, pf, IPPROTO_DCCP, "%s", msg);
 	return -NF_ACCEPT;
 }
 
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 6303a88af12b..aa630c561361 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -522,8 +522,7 @@ static int sctp_error(struct net *net, struct nf_conn *tpl, struct sk_buff *skb,
 	}
 	return NF_ACCEPT;
 out_invalid:
-	if (LOG_INVALID(net, IPPROTO_SCTP))
-		nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL, "%s", logmsg);
+	nf_l4proto_log_invalid(skb, net, pf, IPPROTO_SCTP, "%s", logmsg);
 	return -NF_ACCEPT;
 }
 
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index cba1c6ffe51a..14198b2a2e2c 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -738,6 +738,12 @@ static const u8 tcp_valid_flags[(TCPHDR_FIN|TCPHDR_SYN|TCPHDR_RST|TCPHDR_ACK|
 	[TCPHDR_ACK|TCPHDR_URG]			= 1,
 };
 
+static void tcp_error_log(const struct sk_buff *skb, struct net *net,
+			  u8 pf, const char *msg)
+{
+	nf_l4proto_log_invalid(skb, net, pf, IPPROTO_TCP, "%s", msg);
+}
+
 /* Protect conntrack agaist broken packets. Code taken from ipt_unclean.c.  */
 static int tcp_error(struct net *net, struct nf_conn *tmpl,
 		     struct sk_buff *skb,
@@ -753,17 +759,13 @@ static int tcp_error(struct net *net, struct nf_conn *tmpl,
 	/* Smaller that minimal TCP header? */
 	th = skb_header_pointer(skb, dataoff, sizeof(_tcph), &_tcph);
 	if (th == NULL) {
-		if (LOG_INVALID(net, IPPROTO_TCP))
-			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-				"nf_ct_tcp: short packet ");
+		tcp_error_log(skb, net, pf, "short packet");
 		return -NF_ACCEPT;
 	}
 
 	/* Not whole TCP header or malformed packet */
 	if (th->doff*4 < sizeof(struct tcphdr) || tcplen < th->doff*4) {
-		if (LOG_INVALID(net, IPPROTO_TCP))
-			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-				"nf_ct_tcp: truncated/malformed packet ");
+		tcp_error_log(skb, net, pf, "truncated packet");
 		return -NF_ACCEPT;
 	}
 
@@ -774,18 +776,14 @@ static int tcp_error(struct net *net, struct nf_conn *tmpl,
 	/* FIXME: Source route IP option packets --RR */
 	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
 	    nf_checksum(skb, hooknum, dataoff, IPPROTO_TCP, pf)) {
-		if (LOG_INVALID(net, IPPROTO_TCP))
-			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-				  "nf_ct_tcp: bad TCP checksum ");
+		tcp_error_log(skb, net, pf, "bad checksum");
 		return -NF_ACCEPT;
 	}
 
 	/* Check TCP flags. */
 	tcpflags = (tcp_flag_byte(th) & ~(TCPHDR_ECE|TCPHDR_CWR|TCPHDR_PSH));
 	if (!tcp_valid_flags[tcpflags]) {
-		if (LOG_INVALID(net, IPPROTO_TCP))
-			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-				  "nf_ct_tcp: invalid TCP flag combination ");
+		tcp_error_log(skb, net, pf, "invalid tcp flag combination");
 		return -NF_ACCEPT;
 	}
 
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 8af734cd1a94..fc20cf430251 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -99,6 +99,12 @@ static bool udp_new(struct nf_conn *ct, const struct sk_buff *skb,
 }
 
 #ifdef CONFIG_NF_CT_PROTO_UDPLITE
+static void udplite_error_log(const struct sk_buff *skb, struct net *net,
+			      u8 pf, const char *msg)
+{
+	nf_l4proto_log_invalid(skb, net, pf, IPPROTO_UDPLITE, "%s", msg);
+}
+
 static int udplite_error(struct net *net, struct nf_conn *tmpl,
 			 struct sk_buff *skb,
 			 unsigned int dataoff,
@@ -112,9 +118,7 @@ static int udplite_error(struct net *net, struct nf_conn *tmpl,
 	/* Header is too small? */
 	hdr = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
 	if (!hdr) {
-		if (LOG_INVALID(net, IPPROTO_UDPLITE))
-			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-				      "nf_ct_udplite: short packet ");
+		udplite_error_log(skb, net, pf, "short packet");
 		return -NF_ACCEPT;
 	}
 
@@ -122,17 +126,13 @@ static int udplite_error(struct net *net, struct nf_conn *tmpl,
 	if (cscov == 0) {
 		cscov = udplen;
 	} else if (cscov < sizeof(*hdr) || cscov > udplen) {
-		if (LOG_INVALID(net, IPPROTO_UDPLITE))
-			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-				      "nf_ct_udplite: invalid checksum coverage ");
+		udplite_error_log(skb, net, pf, "invalid checksum coverage");
 		return -NF_ACCEPT;
 	}
 
 	/* UDPLITE mandates checksums */
 	if (!hdr->check) {
-		if (LOG_INVALID(net, IPPROTO_UDPLITE))
-			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-				      "nf_ct_udplite: checksum missing ");
+		udplite_error_log(skb, net, pf, "checksum missing");
 		return -NF_ACCEPT;
 	}
 
@@ -140,9 +140,7 @@ static int udplite_error(struct net *net, struct nf_conn *tmpl,
 	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
 	    nf_checksum_partial(skb, hooknum, dataoff, cscov, IPPROTO_UDP,
 				pf)) {
-		if (LOG_INVALID(net, IPPROTO_UDPLITE))
-			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-				      "nf_ct_udplite: bad UDPLite checksum ");
+		udplite_error_log(skb, net, pf, "bad checksum");
 		return -NF_ACCEPT;
 	}
 
@@ -150,6 +148,12 @@ static int udplite_error(struct net *net, struct nf_conn *tmpl,
 }
 #endif
 
+static void udp_error_log(const struct sk_buff *skb, struct net *net,
+			  u8 pf, const char *msg)
+{
+	nf_l4proto_log_invalid(skb, net, pf, IPPROTO_UDP, "%s", msg);
+}
+
 static int udp_error(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 		     unsigned int dataoff,
 		     u_int8_t pf,
@@ -162,17 +166,13 @@ static int udp_error(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 	/* Header is too small? */
 	hdr = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
 	if (hdr == NULL) {
-		if (LOG_INVALID(net, IPPROTO_UDP))
-			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-				      "nf_ct_udp: short packet ");
+		udp_error_log(skb, net, pf, "short packet");
 		return -NF_ACCEPT;
 	}
 
 	/* Truncated/malformed packets */
 	if (ntohs(hdr->len) > udplen || ntohs(hdr->len) < sizeof(*hdr)) {
-		if (LOG_INVALID(net, IPPROTO_UDP))
-			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-				"nf_ct_udp: truncated/malformed packet ");
+		udp_error_log(skb, net, pf, "truncated/malformed packet");
 		return -NF_ACCEPT;
 	}
 
@@ -186,9 +186,7 @@ static int udp_error(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 	 * FIXME: Source route IP option packets --RR */
 	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
 	    nf_checksum(skb, hooknum, dataoff, IPPROTO_UDP, pf)) {
-		if (LOG_INVALID(net, IPPROTO_UDP))
-			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-				"nf_ct_udp: bad UDP checksum ");
+		udp_error_log(skb, net, pf, "bad checksum");
 		return -NF_ACCEPT;
 	}
 
-- 
2.13.6

