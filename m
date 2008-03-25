From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 28/32]: nf_conntrack_sip: create RTCP expectations
Date: Tue, 25 Mar 2008 15:15:30 +0100 (MET)
Message-ID: <20080325141529.10539.8933.sendpatchset@localhost.localdomain>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32982 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbYCYOPb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:15:31 -0400
In-Reply-To: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: create RTCP expectations

Create expectations for the RTCP connections in addition to RTP connections.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit bd085bafc458c50d639e3997fdff52fc457173ba
tree a4874ee96d70bb10f8dfadd1838065616dad240c
parent 61ca069c85c8b4a110143b1a1ae3263d6dd60945
author Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 12:45:20 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 14:09:58 +0100

 include/linux/netfilter/nf_conntrack_sip.h |    3 +
 net/ipv4/netfilter/nf_nat_sip.c            |   42 +++++++++++++-------
 net/netfilter/nf_conntrack_sip.c           |   58 ++++++++++++++++++----------
 3 files changed, 66 insertions(+), 37 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index 7cc84ed..6ddf95f 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -96,7 +96,8 @@ extern unsigned int (*nf_nat_sip_expect_hook)(struct sk_buff *skb,
 extern unsigned int (*nf_nat_sdp_hook)(struct sk_buff *skb,
 				       const char **dptr,
 				       unsigned int *datalen,
-				       struct nf_conntrack_expect *exp);
+				       struct nf_conntrack_expect *rtp_exp,
+				       struct nf_conntrack_expect *rtcp_exp);
 
 extern int ct_sip_parse_request(const struct nf_conn *ct,
 				const char *dptr, unsigned int datalen,
diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index 4b85e21..f73ab48 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -364,7 +364,8 @@ static unsigned int mangle_sdp(struct sk_buff *skb,
    Mangle it, and change the expectation to match the new version. */
 static unsigned int ip_nat_sdp(struct sk_buff *skb,
 			       const char **dptr, unsigned int *datalen,
-			       struct nf_conntrack_expect *exp)
+			       struct nf_conntrack_expect *rtp_exp,
+			       struct nf_conntrack_expect *rtcp_exp)
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
@@ -375,31 +376,40 @@ static unsigned int ip_nat_sdp(struct sk_buff *skb,
 	/* Connection will come from reply */
 	if (ct->tuplehash[dir].tuple.src.u3.ip ==
 	    ct->tuplehash[!dir].tuple.dst.u3.ip)
-		newip = exp->tuple.dst.u3.ip;
+		newip = rtp_exp->tuple.dst.u3.ip;
 	else
 		newip = ct->tuplehash[!dir].tuple.dst.u3.ip;
 
-	exp->saved_ip = exp->tuple.dst.u3.ip;
-	exp->tuple.dst.u3.ip = newip;
-	exp->saved_proto.udp.port = exp->tuple.dst.u.udp.port;
-	exp->dir = !dir;
-
-	/* When you see the packet, we need to NAT it the same as the
-	   this one. */
-	exp->expectfn = ip_nat_sip_expected;
-
-	/* Try to get same port: if not, try to change it. */
-	for (port = ntohs(exp->saved_proto.udp.port); port != 0; port++) {
-		exp->tuple.dst.u.udp.port = htons(port);
-		if (nf_ct_expect_related(exp) == 0)
+	rtp_exp->saved_ip = rtp_exp->tuple.dst.u3.ip;
+	rtp_exp->tuple.dst.u3.ip = newip;
+	rtp_exp->saved_proto.udp.port = rtp_exp->tuple.dst.u.udp.port;
+	rtp_exp->dir = !dir;
+	rtp_exp->expectfn = ip_nat_sip_expected;
+
+	rtcp_exp->saved_ip = rtcp_exp->tuple.dst.u3.ip;
+	rtcp_exp->tuple.dst.u3.ip = newip;
+	rtcp_exp->saved_proto.udp.port = rtcp_exp->tuple.dst.u.udp.port;
+	rtcp_exp->dir = !dir;
+	rtcp_exp->expectfn = ip_nat_sip_expected;
+
+	/* Try to get same pair of ports: if not, try to change them. */
+	for (port = ntohs(rtp_exp->tuple.dst.u.udp.port);
+	     port != 0; port += 2) {
+		rtp_exp->tuple.dst.u.udp.port = htons(port);
+		if (nf_ct_expect_related(rtp_exp) != 0)
+			continue;
+		rtcp_exp->tuple.dst.u.udp.port = htons(port + 1);
+		if (nf_ct_expect_related(rtcp_exp) == 0)
 			break;
+		nf_ct_unexpect_related(rtp_exp);
 	}
 
 	if (port == 0)
 		return NF_DROP;
 
 	if (!mangle_sdp(skb, ctinfo, ct, newip, port, dptr, datalen)) {
-		nf_ct_unexpect_related(exp);
+		nf_ct_unexpect_related(rtp_exp);
+		nf_ct_unexpect_related(rtcp_exp);
 		return NF_DROP;
 	}
 	return NF_ACCEPT;
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 813aa8c..217262e 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -63,7 +63,9 @@ EXPORT_SYMBOL_GPL(nf_nat_sip_expect_hook);
 unsigned int (*nf_nat_sdp_hook)(struct sk_buff *skb,
 				const char **dptr,
 				unsigned int *datalen,
-				struct nf_conntrack_expect *exp) __read_mostly;
+				struct nf_conntrack_expect *rtp_exp,
+				struct nf_conntrack_expect *rtcp_exp)
+				__read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_sdp_hook);
 
 static int string_len(const struct nf_conn *ct, const char *dptr,
@@ -659,18 +661,20 @@ static void flush_expectations(struct nf_conn *ct, bool media)
 	spin_unlock_bh(&nf_conntrack_lock);
 }
 
-static int set_expected_rtp(struct sk_buff *skb,
-			    const char **dptr, unsigned int *datalen,
-			    union nf_inet_addr *daddr, __be16 port)
+static int set_expected_rtp_rtcp(struct sk_buff *skb,
+				 const char **dptr, unsigned int *datalen,
+				 union nf_inet_addr *daddr, __be16 port)
 {
-	struct nf_conntrack_expect *exp;
+	struct nf_conntrack_expect *exp, *rtp_exp, *rtcp_exp;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	union nf_inet_addr *saddr;
 	struct nf_conntrack_tuple tuple;
 	int family = ct->tuplehash[!dir].tuple.src.l3num;
-	int skip_expect = 0, ret;
+	int skip_expect = 0, ret = NF_DROP;
+	u_int16_t base_port;
+	__be16 rtp_port, rtcp_port;
 	typeof(nf_nat_sdp_hook) nf_nat_sdp;
 
 	saddr = NULL;
@@ -704,23 +708,37 @@ static int set_expected_rtp(struct sk_buff *skb,
 	if (skip_expect)
 		return NF_ACCEPT;
 
-	exp = nf_ct_expect_alloc(ct);
-	if (exp == NULL)
-		return NF_DROP;
-	nf_ct_expect_init(exp, SIP_EXPECT_AUDIO, family, saddr, daddr,
-			  IPPROTO_UDP, NULL, &port);
+	base_port = ntohs(tuple.dst.u.udp.port) & ~1;
+	rtp_port = htons(base_port);
+	rtcp_port = htons(base_port + 1);
+
+	rtp_exp = nf_ct_expect_alloc(ct);
+	if (rtp_exp == NULL)
+		goto err1;
+	nf_ct_expect_init(rtp_exp, SIP_EXPECT_AUDIO, family, saddr, daddr,
+			  IPPROTO_UDP, NULL, &rtp_port);
+
+	rtcp_exp = nf_ct_expect_alloc(ct);
+	if (rtcp_exp == NULL)
+		goto err2;
+	nf_ct_expect_init(rtcp_exp, SIP_EXPECT_AUDIO, family, saddr, daddr,
+			  IPPROTO_UDP, NULL, &rtcp_port);
 
 	nf_nat_sdp = rcu_dereference(nf_nat_sdp_hook);
 	if (nf_nat_sdp && ct->status & IPS_NAT_MASK)
-		ret = nf_nat_sdp(skb, dptr, datalen, exp);
+		ret = nf_nat_sdp(skb, dptr, datalen, rtp_exp, rtcp_exp);
 	else {
-		if (nf_ct_expect_related(exp) != 0)
-			ret = NF_DROP;
-		else
-			ret = NF_ACCEPT;
+		if (nf_ct_expect_related(rtp_exp) == 0) {
+			if (nf_ct_expect_related(rtcp_exp) != 0)
+				nf_ct_unexpect_related(rtp_exp);
+			else
+				ret = NF_ACCEPT;
+		}
 	}
-	nf_ct_expect_put(exp);
-
+	nf_ct_expect_put(rtcp_exp);
+err2:
+	nf_ct_expect_put(rtp_exp);
+err1:
 	return ret;
 }
 
@@ -758,7 +776,7 @@ static int process_sdp(struct sk_buff *skb,
 	if (port < 1024 || port > 65535)
 		return NF_DROP;
 
-	return set_expected_rtp(skb, dptr, datalen, &addr, htons(port));
+	return set_expected_rtp_rtcp(skb, dptr, datalen, &addr, htons(port));
 }
 static int process_invite_response(struct sk_buff *skb,
 				   const char **dptr, unsigned int *datalen,
@@ -1101,7 +1119,7 @@ static const struct nf_conntrack_expect_policy sip_exp_policy[SIP_EXPECT_MAX + 1
 		.timeout	= 3 * 60,
 	},
 	[SIP_EXPECT_AUDIO] = {
-		.max_expected	= IP_CT_DIR_MAX,
+		.max_expected	= 2 * IP_CT_DIR_MAX,
 		.timeout	= 3 * 60,
 	},
 };
