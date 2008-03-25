From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 31/32]: nf_conntrack_sip: RTP routing optimization
Date: Tue, 25 Mar 2008 15:15:34 +0100 (MET)
Message-ID: <20080325141534.10539.18455.sendpatchset@localhost.localdomain>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32984 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbYCYOPf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:15:35 -0400
In-Reply-To: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: RTP routing optimization

Optimize call routing between NATed endpoints: when an external
registrar sends a media description that contains an existing RTP
expectation from a different SNATed connection, the gatekeeper
is trying to route the call directly between the two endpoints.

We assume both endpoints can reach each other directly and
"un-NAT" the addresses, which makes the media stream go between
the two endpoints directly.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5b4954e2047534f6f4347597a68cb7f09a3389ea
tree 22ea8eda5dde1d76c2a11adc273c16691fcfdb90
parent 1c04320897b232a4b7dd89c123469f6c6de911ae
author Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 12:45:25 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 14:09:59 +0100

 include/linux/netfilter/nf_conntrack_sip.h |    6 +++
 net/ipv4/netfilter/nf_nat_sip.c            |    3 +
 net/netfilter/nf_conntrack_sip.c           |   59 +++++++++++++++++++++++-----
 3 files changed, 58 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index 71fa3eb..5da04e5 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -114,6 +114,12 @@ extern unsigned int (*nf_nat_sdp_addr_hook)(struct sk_buff *skb,
 					    enum sdp_header_types type,
 					    enum sdp_header_types term,
 					    const union nf_inet_addr *addr);
+extern unsigned int (*nf_nat_sdp_port_hook)(struct sk_buff *skb,
+					    const char **dptr,
+					    unsigned int *datalen,
+					    unsigned int matchoff,
+					    unsigned int matchlen,
+					    u_int16_t port);
 extern unsigned int (*nf_nat_sdp_session_hook)(struct sk_buff *skb,
 					       const char **dptr,
 					       unsigned int dataoff,
diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index 4429069..bcddccd 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -461,6 +461,7 @@ static void __exit nf_nat_sip_fini(void)
 	rcu_assign_pointer(nf_nat_sip_hook, NULL);
 	rcu_assign_pointer(nf_nat_sip_expect_hook, NULL);
 	rcu_assign_pointer(nf_nat_sdp_addr_hook, NULL);
+	rcu_assign_pointer(nf_nat_sdp_port_hook, NULL);
 	rcu_assign_pointer(nf_nat_sdp_session_hook, NULL);
 	rcu_assign_pointer(nf_nat_sdp_media_hook, NULL);
 	synchronize_rcu();
@@ -471,11 +472,13 @@ static int __init nf_nat_sip_init(void)
 	BUG_ON(nf_nat_sip_hook != NULL);
 	BUG_ON(nf_nat_sip_expect_hook != NULL);
 	BUG_ON(nf_nat_sdp_addr_hook != NULL);
+	BUG_ON(nf_nat_sdp_port_hook != NULL);
 	BUG_ON(nf_nat_sdp_session_hook != NULL);
 	BUG_ON(nf_nat_sdp_media_hook != NULL);
 	rcu_assign_pointer(nf_nat_sip_hook, ip_nat_sip);
 	rcu_assign_pointer(nf_nat_sip_expect_hook, ip_nat_sip_expect);
 	rcu_assign_pointer(nf_nat_sdp_addr_hook, ip_nat_sdp_addr);
+	rcu_assign_pointer(nf_nat_sdp_port_hook, ip_nat_sdp_port);
 	rcu_assign_pointer(nf_nat_sdp_session_hook, ip_nat_sdp_session);
 	rcu_assign_pointer(nf_nat_sdp_media_hook, ip_nat_sdp_media);
 	return 0;
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index f40a525..57de22c 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -70,6 +70,14 @@ unsigned int (*nf_nat_sdp_addr_hook)(struct sk_buff *skb,
 				     __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_sdp_addr_hook);
 
+unsigned int (*nf_nat_sdp_port_hook)(struct sk_buff *skb,
+				     const char **dptr,
+				     unsigned int *datalen,
+				     unsigned int matchoff,
+				     unsigned int matchlen,
+				     u_int16_t port) __read_mostly;
+EXPORT_SYMBOL_GPL(nf_nat_sdp_port_hook);
+
 unsigned int (*nf_nat_sdp_session_hook)(struct sk_buff *skb,
 					const char **dptr,
 					unsigned int dataoff,
@@ -730,9 +738,10 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb,
 	union nf_inet_addr *saddr;
 	struct nf_conntrack_tuple tuple;
 	int family = ct->tuplehash[!dir].tuple.src.l3num;
-	int skip_expect = 0, ret = NF_DROP;
+	int direct_rtp = 0, skip_expect = 0, ret = NF_DROP;
 	u_int16_t base_port;
 	__be16 rtp_port, rtcp_port;
+	typeof(nf_nat_sdp_port_hook) nf_nat_sdp_port;
 	typeof(nf_nat_sdp_media_hook) nf_nat_sdp_media;
 
 	saddr = NULL;
@@ -746,6 +755,14 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb,
 	 * to register it since we can see the same media description multiple
 	 * times on different connections in case multiple endpoints receive
 	 * the same call.
+	 *
+	 * RTP optimization: if we find a matching media channel expectation
+	 * and both the expectation and this connection are SNATed, we assume
+	 * both sides can reach each other directly and use the final
+	 * destination address from the expectation. We still need to keep
+	 * the NATed expectations for media that might arrive from the
+	 * outside, and additionally need to expect the direct RTP stream
+	 * in case it passes through us even without NAT.
 	 */
 	memset(&tuple, 0, sizeof(tuple));
 	if (saddr)
@@ -756,20 +773,42 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb,
 	tuple.dst.u.udp.port	= port;
 
 	rcu_read_lock();
-	exp = __nf_ct_expect_find(&tuple);
-	if (exp && exp->master != ct &&
-	    nfct_help(exp->master)->helper == nfct_help(ct)->helper &&
-	    exp->class == class)
-		skip_expect = 1;
-	rcu_read_unlock();
+	do {
+		exp = __nf_ct_expect_find(&tuple);
 
-	if (skip_expect)
-		return NF_ACCEPT;
+		if (!exp || exp->master == ct ||
+		    nfct_help(exp->master)->helper != nfct_help(ct)->helper ||
+		    exp->class != class)
+			break;
+
+		if (exp->tuple.src.l3num == AF_INET && !direct_rtp &&
+		    (exp->saved_ip != exp->tuple.dst.u3.ip ||
+		     exp->saved_proto.udp.port != exp->tuple.dst.u.udp.port) &&
+		    ct->status & IPS_NAT_MASK) {
+			daddr->ip		= exp->saved_ip;
+			tuple.dst.u3.ip		= exp->saved_ip;
+			tuple.dst.u.udp.port	= exp->saved_proto.udp.port;
+			direct_rtp = 1;
+		} else
+			skip_expect = 1;
+	} while (!skip_expect);
+	rcu_read_unlock();
 
 	base_port = ntohs(tuple.dst.u.udp.port) & ~1;
 	rtp_port = htons(base_port);
 	rtcp_port = htons(base_port + 1);
 
+	if (direct_rtp) {
+		nf_nat_sdp_port = rcu_dereference(nf_nat_sdp_port_hook);
+		if (nf_nat_sdp_port &&
+		    !nf_nat_sdp_port(skb, dptr, datalen,
+				     mediaoff, medialen, ntohs(rtp_port)))
+			goto err1;
+	}
+
+	if (skip_expect)
+		return NF_ACCEPT;
+
 	rtp_exp = nf_ct_expect_alloc(ct);
 	if (rtp_exp == NULL)
 		goto err1;
@@ -783,7 +822,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb,
 			  IPPROTO_UDP, NULL, &rtcp_port);
 
 	nf_nat_sdp_media = rcu_dereference(nf_nat_sdp_media_hook);
-	if (nf_nat_sdp_media && ct->status & IPS_NAT_MASK)
+	if (nf_nat_sdp_media && ct->status & IPS_NAT_MASK && !direct_rtp)
 		ret = nf_nat_sdp_media(skb, dptr, datalen, rtp_exp, rtcp_exp,
 				       mediaoff, medialen, daddr);
 	else {
