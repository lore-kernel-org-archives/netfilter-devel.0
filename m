From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 26/32]: nf_conntrack_sip: create signalling expectations
Date: Tue, 25 Mar 2008 15:15:27 +0100 (MET)
Message-ID: <20080325141527.10539.27830.sendpatchset@localhost.localdomain>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32973 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbYCYOP3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:15:29 -0400
In-Reply-To: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: create signalling expectations

Create expectations for incoming signalling connections when seeing
a REGISTER request. This is needed when the registrar uses a
different source port number for signalling messages and for receiving
incoming calls from other endpoints than the registrar.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ddd1dea3c44ea5bfd6d63048ad5013f27c76136a
tree 71939d7d4cc84e8a28b4510ebe0f4e15a3e7011e
parent 8f15ab436de825574920db877a18917979712df4
author Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 12:45:17 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 14:09:58 +0100

 include/linux/netfilter/nf_conntrack_sip.h |   18 ++
 include/net/netfilter/nf_conntrack.h       |    4 
 net/ipv4/netfilter/nf_nat_sip.c            |  111 +++++++++++--
 net/netfilter/nf_conntrack_sip.c           |  232 +++++++++++++++++++++++++++-
 4 files changed, 332 insertions(+), 33 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index 87e4028..7cc84ed 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -5,6 +5,17 @@
 #define SIP_PORT	5060
 #define SIP_TIMEOUT	3600
 
+struct nf_ct_sip_master {
+	unsigned int	register_cseq;
+};
+
+enum sip_expectation_classes {
+	SIP_EXPECT_SIGNALLING,
+	SIP_EXPECT_AUDIO,
+	__SIP_EXPECT_MAX
+};
+#define SIP_EXPECT_MAX	(__SIP_EXPECT_MAX - 1)
+
 struct sip_handler {
 	const char	*method;
 	unsigned int	len;
@@ -59,6 +70,7 @@ enum sip_header_types {
 	SIP_HDR_TO,
 	SIP_HDR_CONTACT,
 	SIP_HDR_VIA,
+	SIP_HDR_EXPIRES,
 	SIP_HDR_CONTENT_LENGTH,
 };
 
@@ -75,6 +87,12 @@ enum sdp_header_types {
 extern unsigned int (*nf_nat_sip_hook)(struct sk_buff *skb,
 				       const char **dptr,
 				       unsigned int *datalen);
+extern unsigned int (*nf_nat_sip_expect_hook)(struct sk_buff *skb,
+					      const char **dptr,
+					      unsigned int *datalen,
+					      struct nf_conntrack_expect *exp,
+					      unsigned int matchoff,
+					      unsigned int matchlen);
 extern unsigned int (*nf_nat_sdp_hook)(struct sk_buff *skb,
 				       const char **dptr,
 				       unsigned int *datalen,
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 9228771..4a4f870 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -46,6 +46,7 @@ union nf_conntrack_expect_proto {
 #include <linux/netfilter/nf_conntrack_pptp.h>
 #include <linux/netfilter/nf_conntrack_h323.h>
 #include <linux/netfilter/nf_conntrack_sane.h>
+#include <linux/netfilter/nf_conntrack_sip.h>
 
 /* per conntrack: application helper private data */
 union nf_conntrack_help {
@@ -54,6 +55,7 @@ union nf_conntrack_help {
 	struct nf_ct_pptp_master ct_pptp_info;
 	struct nf_ct_h323_master ct_h323_info;
 	struct nf_ct_sane_master ct_sane_info;
+	struct nf_ct_sip_master ct_sip_info;
 };
 
 #include <linux/types.h>
@@ -76,7 +78,7 @@ do {									\
 struct nf_conntrack_helper;
 
 /* Must be kept in sync with the classes defined by helpers */
-#define NF_CT_MAX_EXPECT_CLASSES	1
+#define NF_CT_MAX_EXPECT_CLASSES	2
 
 /* nf_conn feature for connections that have a helper */
 struct nf_conn_help {
diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index b443618..4b85e21 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -205,6 +205,91 @@ next:
 	return NF_ACCEPT;
 }
 
+/* Handles expected signalling connections and media streams */
+static void ip_nat_sip_expected(struct nf_conn *ct,
+				struct nf_conntrack_expect *exp)
+{
+	struct nf_nat_range range;
+
+	/* This must be a fresh one. */
+	BUG_ON(ct->status & IPS_NAT_DONE_MASK);
+
+	/* For DST manip, map port here to where it's expected. */
+	range.flags = (IP_NAT_RANGE_MAP_IPS | IP_NAT_RANGE_PROTO_SPECIFIED);
+	range.min = range.max = exp->saved_proto;
+	range.min_ip = range.max_ip = exp->saved_ip;
+	nf_nat_setup_info(ct, &range, IP_NAT_MANIP_DST);
+
+	/* Change src to where master sends to, but only if the connection
+	 * actually came from the same source. */
+	if (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip ==
+	    ct->master->tuplehash[exp->dir].tuple.src.u3.ip) {
+		range.flags = IP_NAT_RANGE_MAP_IPS;
+		range.min_ip = range.max_ip
+			= ct->master->tuplehash[!exp->dir].tuple.dst.u3.ip;
+		nf_nat_setup_info(ct, &range, IP_NAT_MANIP_SRC);
+	}
+}
+
+static unsigned int ip_nat_sip_expect(struct sk_buff *skb,
+				      const char **dptr, unsigned int *datalen,
+				      struct nf_conntrack_expect *exp,
+				      unsigned int matchoff,
+				      unsigned int matchlen)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+	__be32 newip;
+	u_int16_t port;
+	char buffer[sizeof("nnn.nnn.nnn.nnn:nnnnn")];
+	unsigned buflen;
+
+	/* Connection will come from reply */
+	if (ct->tuplehash[dir].tuple.src.u3.ip == ct->tuplehash[!dir].tuple.dst.u3.ip)
+		newip = exp->tuple.dst.u3.ip;
+	else
+		newip = ct->tuplehash[!dir].tuple.dst.u3.ip;
+
+	/* If the signalling port matches the connection's source port in the
+	 * original direction, try to use the destination port in the opposite
+	 * direction. */
+	if (exp->tuple.dst.u.udp.port ==
+	    ct->tuplehash[dir].tuple.src.u.udp.port)
+		port = ntohs(ct->tuplehash[!dir].tuple.dst.u.udp.port);
+	else
+		port = ntohs(exp->tuple.dst.u.udp.port);
+
+	exp->saved_ip = exp->tuple.dst.u3.ip;
+	exp->tuple.dst.u3.ip = newip;
+	exp->saved_proto.udp.port = exp->tuple.dst.u.udp.port;
+	exp->dir = !dir;
+	exp->expectfn = ip_nat_sip_expected;
+
+	for (; port != 0; port++) {
+		exp->tuple.dst.u.udp.port = htons(port);
+		if (nf_ct_expect_related(exp) == 0)
+			break;
+	}
+
+	if (port == 0)
+		return NF_DROP;
+
+	if (exp->tuple.dst.u3.ip != exp->saved_ip ||
+	    exp->tuple.dst.u.udp.port != exp->saved_proto.udp.port) {
+		buflen = sprintf(buffer, "%u.%u.%u.%u:%u",
+				 NIPQUAD(newip), port);
+		if (!mangle_packet(skb, dptr, datalen, matchoff, matchlen,
+				   buffer, buflen))
+			goto err;
+	}
+	return NF_ACCEPT;
+
+err:
+	nf_ct_unexpect_related(exp);
+	return NF_DROP;
+}
+
 static int mangle_content_len(struct sk_buff *skb,
 			      const char **dptr, unsigned int *datalen)
 {
@@ -275,27 +360,6 @@ static unsigned int mangle_sdp(struct sk_buff *skb,
 	return mangle_content_len(skb, dptr, datalen);
 }
 
-static void ip_nat_sdp_expect(struct nf_conn *ct,
-			      struct nf_conntrack_expect *exp)
-{
-	struct nf_nat_range range;
-
-	/* This must be a fresh one. */
-	BUG_ON(ct->status & IPS_NAT_DONE_MASK);
-
-	/* For DST manip, map port here to where it's expected. */
-	range.flags = (IP_NAT_RANGE_MAP_IPS | IP_NAT_RANGE_PROTO_SPECIFIED);
-	range.min = range.max = exp->saved_proto;
-	range.min_ip = range.max_ip = exp->saved_ip;
-	nf_nat_setup_info(ct, &range, IP_NAT_MANIP_DST);
-
-	/* Change src to where master sends to */
-	range.flags = IP_NAT_RANGE_MAP_IPS;
-	range.min_ip = range.max_ip
-		= ct->master->tuplehash[!exp->dir].tuple.dst.u3.ip;
-	nf_nat_setup_info(ct, &range, IP_NAT_MANIP_SRC);
-}
-
 /* So, this packet has hit the connection tracking matching code.
    Mangle it, and change the expectation to match the new version. */
 static unsigned int ip_nat_sdp(struct sk_buff *skb,
@@ -322,7 +386,7 @@ static unsigned int ip_nat_sdp(struct sk_buff *skb,
 
 	/* When you see the packet, we need to NAT it the same as the
 	   this one. */
-	exp->expectfn = ip_nat_sdp_expect;
+	exp->expectfn = ip_nat_sip_expected;
 
 	/* Try to get same port: if not, try to change it. */
 	for (port = ntohs(exp->saved_proto.udp.port); port != 0; port++) {
@@ -344,6 +408,7 @@ static unsigned int ip_nat_sdp(struct sk_buff *skb,
 static void __exit nf_nat_sip_fini(void)
 {
 	rcu_assign_pointer(nf_nat_sip_hook, NULL);
+	rcu_assign_pointer(nf_nat_sip_expect_hook, NULL);
 	rcu_assign_pointer(nf_nat_sdp_hook, NULL);
 	synchronize_rcu();
 }
@@ -351,8 +416,10 @@ static void __exit nf_nat_sip_fini(void)
 static int __init nf_nat_sip_init(void)
 {
 	BUG_ON(nf_nat_sip_hook != NULL);
+	BUG_ON(nf_nat_sip_expect_hook != NULL);
 	BUG_ON(nf_nat_sdp_hook != NULL);
 	rcu_assign_pointer(nf_nat_sip_hook, ip_nat_sip);
+	rcu_assign_pointer(nf_nat_sip_expect_hook, ip_nat_sip_expect);
 	rcu_assign_pointer(nf_nat_sdp_hook, ip_nat_sdp);
 	return 0;
 }
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 126f308..043aa55 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -37,11 +37,24 @@ static unsigned int sip_timeout __read_mostly = SIP_TIMEOUT;
 module_param(sip_timeout, uint, 0600);
 MODULE_PARM_DESC(sip_timeout, "timeout for the master SIP session");
 
+static int sip_direct_signalling __read_mostly = 1;
+module_param(sip_direct_signalling, int, 0600);
+MODULE_PARM_DESC(sip_direct_signalling, "expect incoming calls from registrar "
+					"only (default 1)");
+
 unsigned int (*nf_nat_sip_hook)(struct sk_buff *skb,
 				const char **dptr,
 				unsigned int *datalen) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_sip_hook);
 
+unsigned int (*nf_nat_sip_expect_hook)(struct sk_buff *skb,
+				       const char **dptr,
+				       unsigned int *datalen,
+				       struct nf_conntrack_expect *exp,
+				       unsigned int matchoff,
+				       unsigned int matchlen) __read_mostly;
+EXPORT_SYMBOL_GPL(nf_nat_sip_expect_hook);
+
 unsigned int (*nf_nat_sdp_hook)(struct sk_buff *skb,
 				const char **dptr,
 				unsigned int *datalen,
@@ -218,6 +231,7 @@ static const struct sip_header ct_sip_hdrs[] = {
 	[SIP_HDR_TO]			= SIP_HDR("To", "t", "sip:", skp_epaddr_len),
 	[SIP_HDR_CONTACT]		= SIP_HDR("Contact", "m", "sip:", skp_epaddr_len),
 	[SIP_HDR_VIA]			= SIP_HDR("Via", "v", "UDP ", epaddr_len),
+	[SIP_HDR_EXPIRES]		= SIP_HDR("Expires", NULL, NULL, digits_len),
 	[SIP_HDR_CONTENT_LENGTH]	= SIP_HDR("Content-Length", "l", NULL, digits_len),
 };
 
@@ -592,18 +606,50 @@ int ct_sip_get_sdp_header(const struct nf_conn *ct, const char *dptr,
 }
 EXPORT_SYMBOL_GPL(ct_sip_get_sdp_header);
 
-static void flush_expectations(struct nf_conn *ct)
+static int refresh_signalling_expectation(struct nf_conn *ct,
+					  union nf_inet_addr *addr,
+					  __be16 port,
+					  unsigned int expires)
 {
 	struct nf_conn_help *help = nfct_help(ct);
 	struct nf_conntrack_expect *exp;
 	struct hlist_node *n, *next;
+	int found = 0;
 
 	spin_lock_bh(&nf_conntrack_lock);
 	hlist_for_each_entry_safe(exp, n, next, &help->expectations, lnode) {
+		if (exp->class != SIP_EXPECT_SIGNALLING ||
+		    !nf_inet_addr_cmp(&exp->tuple.dst.u3, addr) ||
+		    exp->tuple.dst.u.udp.port != port)
+			continue;
+		if (!del_timer(&exp->timeout))
+			continue;
+		exp->flags &= ~NF_CT_EXPECT_INACTIVE;
+		exp->timeout.expires = jiffies + expires * HZ;
+		add_timer(&exp->timeout);
+		found = 1;
+		break;
+	}
+	spin_unlock_bh(&nf_conntrack_lock);
+	return found;
+}
+
+static void flush_expectations(struct nf_conn *ct, bool media)
+{
+	struct nf_conn_help *help = nfct_help(ct);
+	struct nf_conntrack_expect *exp;
+	struct hlist_node *n, *next;
+
+	spin_lock_bh(&nf_conntrack_lock);
+	hlist_for_each_entry_safe(exp, n, next, &help->expectations, lnode) {
+		if ((exp->class != SIP_EXPECT_SIGNALLING) ^ media)
+			continue;
 		if (!del_timer(&exp->timeout))
 			continue;
 		nf_ct_unlink_expect(exp);
 		nf_ct_expect_put(exp);
+		if (!media)
+			break;
 	}
 	spin_unlock_bh(&nf_conntrack_lock);
 }
@@ -623,7 +669,7 @@ static int set_expected_rtp(struct sk_buff *skb,
 	exp = nf_ct_expect_alloc(ct);
 	if (exp == NULL)
 		return NF_DROP;
-	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, family,
+	nf_ct_expect_init(exp, SIP_EXPECT_AUDIO, family,
 			  &ct->tuplehash[!dir].tuple.src.u3, addr,
 			  IPPROTO_UDP, NULL, &port);
 
@@ -688,7 +734,7 @@ static int process_invite_response(struct sk_buff *skb,
 	    (code >= 200 && code <= 299))
 		return process_sdp(skb, dptr, datalen, cseq);
 	else {
-		flush_expectations(ct);
+		flush_expectations(ct, true);
 		return NF_ACCEPT;
 	}
 }
@@ -704,7 +750,7 @@ static int process_update_response(struct sk_buff *skb,
 	    (code >= 200 && code <= 299))
 		return process_sdp(skb, dptr, datalen, cseq);
 	else {
-		flush_expectations(ct);
+		flush_expectations(ct, true);
 		return NF_ACCEPT;
 	}
 }
@@ -720,7 +766,7 @@ static int process_prack_response(struct sk_buff *skb,
 	    (code >= 200 && code <= 299))
 		return process_sdp(skb, dptr, datalen, cseq);
 	else {
-		flush_expectations(ct);
+		flush_expectations(ct, true);
 		return NF_ACCEPT;
 	}
 }
@@ -732,7 +778,165 @@ static int process_bye_request(struct sk_buff *skb,
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 
-	flush_expectations(ct);
+	flush_expectations(ct, true);
+	return NF_ACCEPT;
+}
+
+/* Parse a REGISTER request and create a permanent expectation for incoming
+ * signalling connections. The expectation is marked inactive and is activated
+ * when receiving a response indicating success from the registrar.
+ */
+static int process_register_request(struct sk_buff *skb,
+				    const char **dptr, unsigned int *datalen,
+				    unsigned int cseq)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+	struct nf_conn_help *help = nfct_help(ct);
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+	unsigned int matchoff, matchlen;
+	struct nf_conntrack_expect *exp;
+	union nf_inet_addr *saddr, daddr;
+	__be16 port;
+	unsigned int expires = 0;
+	int ret;
+	typeof(nf_nat_sip_expect_hook) nf_nat_sip_expect;
+
+	/* Expected connections can not register again. */
+	if (ct->status & IPS_EXPECTED)
+		return NF_ACCEPT;
+
+	/* We must check the expiration time: a value of zero signals the
+	 * registrar to release the binding. We'll remove our expectation
+	 * when receiving the new bindings in the response, but we don't
+	 * want to create new ones.
+	 *
+	 * The expiration time may be contained in Expires: header, the
+	 * Contact: header parameters or the URI parameters.
+	 */
+	if (ct_sip_get_header(ct, *dptr, 0, *datalen, SIP_HDR_EXPIRES,
+			      &matchoff, &matchlen) > 0)
+		expires = simple_strtoul(*dptr + matchoff, NULL, 10);
+
+	ret = ct_sip_parse_header_uri(ct, *dptr, NULL, *datalen,
+				      SIP_HDR_CONTACT, NULL,
+				      &matchoff, &matchlen, &daddr, &port);
+	if (ret < 0)
+		return NF_DROP;
+	else if (ret == 0)
+		return NF_ACCEPT;
+
+	/* We don't support third-party registrations */
+	if (!nf_inet_addr_cmp(&ct->tuplehash[dir].tuple.src.u3, &daddr))
+		return NF_ACCEPT;
+
+	if (ct_sip_parse_numerical_param(ct, *dptr,
+					 matchoff + matchlen, *datalen,
+					 "expires=", NULL, NULL, &expires) < 0)
+		return NF_DROP;
+
+	if (expires == 0) {
+		ret = NF_ACCEPT;
+		goto store_cseq;
+	}
+
+	exp = nf_ct_expect_alloc(ct);
+	if (!exp)
+		return NF_DROP;
+
+	saddr = NULL;
+	if (sip_direct_signalling)
+		saddr = &ct->tuplehash[!dir].tuple.src.u3;
+
+	nf_ct_expect_init(exp, SIP_EXPECT_SIGNALLING, family, saddr, &daddr,
+			  IPPROTO_UDP, NULL, &port);
+	exp->timeout.expires = sip_timeout * HZ;
+	exp->helper = nfct_help(ct)->helper;
+	exp->flags = NF_CT_EXPECT_PERMANENT | NF_CT_EXPECT_INACTIVE;
+
+	nf_nat_sip_expect = rcu_dereference(nf_nat_sip_expect_hook);
+	if (nf_nat_sip_expect && ct->status & IPS_NAT_MASK)
+		ret = nf_nat_sip_expect(skb, dptr, datalen, exp,
+					matchoff, matchlen);
+	else {
+		if (nf_ct_expect_related(exp) != 0)
+			ret = NF_DROP;
+		else
+			ret = NF_ACCEPT;
+	}
+	nf_ct_expect_put(exp);
+
+store_cseq:
+	if (ret == NF_ACCEPT)
+		help->help.ct_sip_info.register_cseq = cseq;
+	return ret;
+}
+
+static int process_register_response(struct sk_buff *skb,
+				     const char **dptr, unsigned int *datalen,
+				     unsigned int cseq, unsigned int code)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+	struct nf_conn_help *help = nfct_help(ct);
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+	union nf_inet_addr addr;
+	__be16 port;
+	unsigned int matchoff, matchlen, dataoff = 0;
+	unsigned int expires = 0;
+	int in_contact = 0, ret;
+
+	/* According to RFC 3261, "UAs MUST NOT send a new registration until
+	 * they have received a final response from the registrar for the
+	 * previous one or the previous REGISTER request has timed out".
+	 *
+	 * However, some servers fail to detect retransmissions and send late
+	 * responses, so we store the sequence number of the last valid
+	 * request and compare it here.
+	 */
+	if (help->help.ct_sip_info.register_cseq != cseq)
+		return NF_ACCEPT;
+
+	if (code >= 100 && code <= 199)
+		return NF_ACCEPT;
+	if (code < 200 || code > 299)
+		goto flush;
+
+	if (ct_sip_get_header(ct, *dptr, 0, *datalen, SIP_HDR_EXPIRES,
+			      &matchoff, &matchlen) > 0)
+		expires = simple_strtoul(*dptr + matchoff, NULL, 10);
+
+	while (1) {
+		unsigned int c_expires = expires;
+
+		ret = ct_sip_parse_header_uri(ct, *dptr, &dataoff, *datalen,
+					      SIP_HDR_CONTACT, &in_contact,
+					      &matchoff, &matchlen,
+					      &addr, &port);
+		if (ret < 0)
+			return NF_DROP;
+		else if (ret == 0)
+			break;
+
+		/* We don't support third-party registrations */
+		if (!nf_inet_addr_cmp(&ct->tuplehash[dir].tuple.dst.u3, &addr))
+			continue;
+
+		ret = ct_sip_parse_numerical_param(ct, *dptr,
+						   matchoff + matchlen,
+						   *datalen, "expires=",
+						   NULL, NULL, &c_expires);
+		if (ret < 0)
+			return NF_DROP;
+		if (c_expires == 0)
+			break;
+		if (refresh_signalling_expectation(ct, &addr, port, c_expires))
+			return NF_ACCEPT;
+	}
+
+flush:
+	flush_expectations(ct, false);
 	return NF_ACCEPT;
 }
 
@@ -742,6 +946,7 @@ static const struct sip_handler sip_handlers[] = {
 	SIP_HANDLER("ACK", process_sdp, NULL),
 	SIP_HANDLER("PRACK", process_sdp, process_prack_response),
 	SIP_HANDLER("BYE", process_bye_request, NULL),
+	SIP_HANDLER("REGISTER", process_register_request, process_register_response),
 };
 
 static int process_sip_response(struct sk_buff *skb,
@@ -853,9 +1058,15 @@ static int sip_help(struct sk_buff *skb,
 static struct nf_conntrack_helper sip[MAX_PORTS][2] __read_mostly;
 static char sip_names[MAX_PORTS][2][sizeof("sip-65535")] __read_mostly;
 
-static const struct nf_conntrack_expect_policy sip_exp_policy = {
-	.max_expected	= 2,
-	.timeout	= 3 * 60,
+static const struct nf_conntrack_expect_policy sip_exp_policy[SIP_EXPECT_MAX + 1] = {
+	[SIP_EXPECT_SIGNALLING] = {
+		.max_expected	= 1,
+		.timeout	= 3 * 60,
+	},
+	[SIP_EXPECT_AUDIO] = {
+		.max_expected	= IP_CT_DIR_MAX,
+		.timeout	= 3 * 60,
+	},
 };
 
 static void nf_conntrack_sip_fini(void)
@@ -887,7 +1098,8 @@ static int __init nf_conntrack_sip_init(void)
 		for (j = 0; j < 2; j++) {
 			sip[i][j].tuple.dst.protonum = IPPROTO_UDP;
 			sip[i][j].tuple.src.u.udp.port = htons(ports[i]);
-			sip[i][j].expect_policy = &sip_exp_policy;
+			sip[i][j].expect_policy = sip_exp_policy;
+			sip[i][j].expect_class_max = SIP_EXPECT_MAX;
 			sip[i][j].me = THIS_MODULE;
 			sip[i][j].help = sip_help;
 
