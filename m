From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 30/32]: nf_nat_sip: split up SDP mangling
Date: Thu, 28 Feb 2008 13:00:37 +0100 (MET)
Message-ID: <20080228120028.29267.92608.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50037 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757695AbYB1MAi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:38 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat_sip: split up SDP mangling

The SDP connection addresses may be contained in the payload multiple
times (in the session description and/or once per media description),
currently only the session description is properly updated. Split up
SDP mangling so the function setting up expectations only updates the
media port, update connection addresses from media descriptions while
parsing them and at the end update the session description when the
final addresses are known.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9661c24d47ff1e8f17663146f3d57761fd810f5f
tree 942c4df06b044550a29af9cf24bce8a74e08621b
parent 6205c1de4eb35932089b86a74914ffb1d6cff650
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:36 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:36 +0100

 include/linux/netfilter/nf_conntrack_sip.h |   25 ++++-
 net/ipv4/netfilter/nf_nat_sip.c            |  121 +++++++++++++++++-------
 net/netfilter/nf_conntrack_sip.c           |  142 +++++++++++++++++++++++-----
 3 files changed, 219 insertions(+), 69 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index 6ddf95f..eca3ad3 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -93,11 +93,26 @@ extern unsigned int (*nf_nat_sip_expect_hook)(struct sk_buff *skb,
 					      struct nf_conntrack_expect *exp,
 					      unsigned int matchoff,
 					      unsigned int matchlen);
-extern unsigned int (*nf_nat_sdp_hook)(struct sk_buff *skb,
-				       const char **dptr,
-				       unsigned int *datalen,
-				       struct nf_conntrack_expect *rtp_exp,
-				       struct nf_conntrack_expect *rtcp_exp);
+extern unsigned int (*nf_nat_sdp_addr_hook)(struct sk_buff *skb,
+					    const char **dptr,
+					    unsigned int dataoff,
+					    unsigned int *datalen,
+					    enum sdp_header_types type,
+					    enum sdp_header_types term,
+					    const union nf_inet_addr *addr);
+extern unsigned int (*nf_nat_sdp_session_hook)(struct sk_buff *skb,
+					       const char **dptr,
+					       unsigned int dataoff,
+					       unsigned int *datalen,
+					       const union nf_inet_addr *addr);
+extern unsigned int (*nf_nat_sdp_media_hook)(struct sk_buff *skb,
+					     const char **dptr,
+					     unsigned int *datalen,
+					     struct nf_conntrack_expect *rtp_exp,
+					     struct nf_conntrack_expect *rtcp_exp,
+					     unsigned int mediaoff,
+					     unsigned int medialen,
+					     union nf_inet_addr *rtp_addr);
 
 extern int ct_sip_parse_request(const struct nf_conn *ct,
 				const char *dptr, unsigned int datalen,
diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index f73ab48..4429069 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -316,45 +316,77 @@ static int mangle_content_len(struct sk_buff *skb,
 			     buffer, buflen);
 }
 
-static unsigned mangle_sdp_packet(struct sk_buff *skb,
-				  const char **dptr, unsigned int *datalen,
+static unsigned mangle_sdp_packet(struct sk_buff *skb, const char **dptr,
+				  unsigned int dataoff, unsigned int *datalen,
 				  enum sdp_header_types type,
+				  enum sdp_header_types term,
 				  char *buffer, int buflen)
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	unsigned int matchlen, matchoff;
 
-	if (ct_sip_get_sdp_header(ct, *dptr, 0, *datalen, type, SDP_HDR_UNSPEC,
+	if (ct_sip_get_sdp_header(ct, *dptr, dataoff, *datalen, type, term,
 				  &matchoff, &matchlen) <= 0)
 		return 0;
 	return mangle_packet(skb, dptr, datalen, matchoff, matchlen,
 			     buffer, buflen);
 }
 
-static unsigned int mangle_sdp(struct sk_buff *skb,
-			       enum ip_conntrack_info ctinfo,
-			       struct nf_conn *ct,
-			       __be32 newip, u_int16_t port,
-			       const char **dptr, unsigned int *datalen)
+static unsigned int ip_nat_sdp_addr(struct sk_buff *skb, const char **dptr,
+				    unsigned int dataoff,
+				    unsigned int *datalen,
+				    enum sdp_header_types type,
+				    enum sdp_header_types term,
+				    const union nf_inet_addr *addr)
 {
 	char buffer[sizeof("nnn.nnn.nnn.nnn")];
-	unsigned int bufflen;
+	unsigned int buflen;
 
-	/* Mangle owner and contact info. */
-	bufflen = sprintf(buffer, "%u.%u.%u.%u", NIPQUAD(newip));
-	if (!mangle_sdp_packet(skb, dptr, datalen, SDP_HDR_OWNER_IP4,
-			       buffer, bufflen))
+	buflen = sprintf(buffer, NIPQUAD_FMT, NIPQUAD(addr->ip));
+	if (!mangle_sdp_packet(skb, dptr, dataoff, datalen, type, term,
+			       buffer, buflen))
 		return 0;
 
-	if (!mangle_sdp_packet(skb, dptr, datalen, SDP_HDR_CONNECTION_IP4,
-			       buffer, bufflen))
+	return mangle_content_len(skb, dptr, datalen);
+}
+
+static unsigned int ip_nat_sdp_port(struct sk_buff *skb,
+				    const char **dptr,
+				    unsigned int *datalen,
+				    unsigned int matchoff,
+				    unsigned int matchlen,
+				    u_int16_t port)
+{
+	char buffer[sizeof("nnnnn")];
+	unsigned int buflen;
+
+	buflen = sprintf(buffer, "%u", port);
+	if (!mangle_packet(skb, dptr, datalen, matchoff, matchlen,
+			   buffer, buflen))
 		return 0;
 
-	/* Mangle media port. */
-	bufflen = sprintf(buffer, "%u", port);
-	if (!mangle_sdp_packet(skb, dptr, datalen, SDP_HDR_MEDIA,
-			       buffer, bufflen))
+	return mangle_content_len(skb, dptr, datalen);
+}
+
+static unsigned int ip_nat_sdp_session(struct sk_buff *skb, const char **dptr,
+				       unsigned int dataoff,
+				       unsigned int *datalen,
+				       const union nf_inet_addr *addr)
+{
+	char buffer[sizeof("nnn.nnn.nnn.nnn")];
+	unsigned int buflen;
+
+	/* Mangle session description owner and contact addresses */
+	buflen = sprintf(buffer, "%u.%u.%u.%u", NIPQUAD(addr->ip));
+	if (!mangle_sdp_packet(skb, dptr, dataoff, datalen,
+			       SDP_HDR_OWNER_IP4, SDP_HDR_MEDIA,
+			       buffer, buflen))
+		return 0;
+
+	if (!mangle_sdp_packet(skb, dptr, dataoff, datalen,
+			       SDP_HDR_CONNECTION_IP4, SDP_HDR_MEDIA,
+			       buffer, buflen))
 		return 0;
 
 	return mangle_content_len(skb, dptr, datalen);
@@ -362,32 +394,35 @@ static unsigned int mangle_sdp(struct sk_buff *skb,
 
 /* So, this packet has hit the connection tracking matching code.
    Mangle it, and change the expectation to match the new version. */
-static unsigned int ip_nat_sdp(struct sk_buff *skb,
-			       const char **dptr, unsigned int *datalen,
-			       struct nf_conntrack_expect *rtp_exp,
-			       struct nf_conntrack_expect *rtcp_exp)
+static unsigned int ip_nat_sdp_media(struct sk_buff *skb,
+				     const char **dptr,
+				     unsigned int *datalen,
+				     struct nf_conntrack_expect *rtp_exp,
+				     struct nf_conntrack_expect *rtcp_exp,
+				     unsigned int mediaoff,
+				     unsigned int medialen,
+				     union nf_inet_addr *rtp_addr)
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-	__be32 newip;
 	u_int16_t port;
 
 	/* Connection will come from reply */
 	if (ct->tuplehash[dir].tuple.src.u3.ip ==
 	    ct->tuplehash[!dir].tuple.dst.u3.ip)
-		newip = rtp_exp->tuple.dst.u3.ip;
+		rtp_addr->ip = rtp_exp->tuple.dst.u3.ip;
 	else
-		newip = ct->tuplehash[!dir].tuple.dst.u3.ip;
+		rtp_addr->ip = ct->tuplehash[!dir].tuple.dst.u3.ip;
 
 	rtp_exp->saved_ip = rtp_exp->tuple.dst.u3.ip;
-	rtp_exp->tuple.dst.u3.ip = newip;
+	rtp_exp->tuple.dst.u3.ip = rtp_addr->ip;
 	rtp_exp->saved_proto.udp.port = rtp_exp->tuple.dst.u.udp.port;
 	rtp_exp->dir = !dir;
 	rtp_exp->expectfn = ip_nat_sip_expected;
 
 	rtcp_exp->saved_ip = rtcp_exp->tuple.dst.u3.ip;
-	rtcp_exp->tuple.dst.u3.ip = newip;
+	rtcp_exp->tuple.dst.u3.ip = rtp_addr->ip;
 	rtcp_exp->saved_proto.udp.port = rtcp_exp->tuple.dst.u.udp.port;
 	rtcp_exp->dir = !dir;
 	rtcp_exp->expectfn = ip_nat_sip_expected;
@@ -405,21 +440,29 @@ static unsigned int ip_nat_sdp(struct sk_buff *skb,
 	}
 
 	if (port == 0)
-		return NF_DROP;
+		goto err1;
+
+	/* Update media port. */
+	if (rtp_exp->tuple.dst.u.udp.port != rtp_exp->saved_proto.udp.port &&
+	    !ip_nat_sdp_port(skb, dptr, datalen, mediaoff, medialen, port))
+		goto err2;
 
-	if (!mangle_sdp(skb, ctinfo, ct, newip, port, dptr, datalen)) {
-		nf_ct_unexpect_related(rtp_exp);
-		nf_ct_unexpect_related(rtcp_exp);
-		return NF_DROP;
-	}
 	return NF_ACCEPT;
+
+err2:
+	nf_ct_unexpect_related(rtp_exp);
+	nf_ct_unexpect_related(rtcp_exp);
+err1:
+	return NF_DROP;
 }
 
 static void __exit nf_nat_sip_fini(void)
 {
 	rcu_assign_pointer(nf_nat_sip_hook, NULL);
 	rcu_assign_pointer(nf_nat_sip_expect_hook, NULL);
-	rcu_assign_pointer(nf_nat_sdp_hook, NULL);
+	rcu_assign_pointer(nf_nat_sdp_addr_hook, NULL);
+	rcu_assign_pointer(nf_nat_sdp_session_hook, NULL);
+	rcu_assign_pointer(nf_nat_sdp_media_hook, NULL);
 	synchronize_rcu();
 }
 
@@ -427,10 +470,14 @@ static int __init nf_nat_sip_init(void)
 {
 	BUG_ON(nf_nat_sip_hook != NULL);
 	BUG_ON(nf_nat_sip_expect_hook != NULL);
-	BUG_ON(nf_nat_sdp_hook != NULL);
+	BUG_ON(nf_nat_sdp_addr_hook != NULL);
+	BUG_ON(nf_nat_sdp_session_hook != NULL);
+	BUG_ON(nf_nat_sdp_media_hook != NULL);
 	rcu_assign_pointer(nf_nat_sip_hook, ip_nat_sip);
 	rcu_assign_pointer(nf_nat_sip_expect_hook, ip_nat_sip_expect);
-	rcu_assign_pointer(nf_nat_sdp_hook, ip_nat_sdp);
+	rcu_assign_pointer(nf_nat_sdp_addr_hook, ip_nat_sdp_addr);
+	rcu_assign_pointer(nf_nat_sdp_session_hook, ip_nat_sdp_session);
+	rcu_assign_pointer(nf_nat_sdp_media_hook, ip_nat_sdp_media);
 	return 0;
 }
 
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 7b51ab7..9ced70f 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -60,13 +60,34 @@ unsigned int (*nf_nat_sip_expect_hook)(struct sk_buff *skb,
 				       unsigned int matchlen) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_sip_expect_hook);
 
-unsigned int (*nf_nat_sdp_hook)(struct sk_buff *skb,
-				const char **dptr,
-				unsigned int *datalen,
-				struct nf_conntrack_expect *rtp_exp,
-				struct nf_conntrack_expect *rtcp_exp)
-				__read_mostly;
-EXPORT_SYMBOL_GPL(nf_nat_sdp_hook);
+unsigned int (*nf_nat_sdp_addr_hook)(struct sk_buff *skb,
+				     const char **dptr,
+				     unsigned int dataoff,
+				     unsigned int *datalen,
+				     enum sdp_header_types type,
+				     enum sdp_header_types term,
+				     const union nf_inet_addr *addr)
+				     __read_mostly;
+EXPORT_SYMBOL_GPL(nf_nat_sdp_addr_hook);
+
+unsigned int (*nf_nat_sdp_session_hook)(struct sk_buff *skb,
+					const char **dptr,
+					unsigned int dataoff,
+					unsigned int *datalen,
+					const union nf_inet_addr *addr)
+					__read_mostly;
+EXPORT_SYMBOL_GPL(nf_nat_sdp_session_hook);
+
+unsigned int (*nf_nat_sdp_media_hook)(struct sk_buff *skb,
+				      const char **dptr,
+				      unsigned int *datalen,
+				      struct nf_conntrack_expect *rtp_exp,
+				      struct nf_conntrack_expect *rtcp_exp,
+				      unsigned int mediaoff,
+				      unsigned int medialen,
+				      union nf_inet_addr *rtp_addr)
+				      __read_mostly;
+EXPORT_SYMBOL_GPL(nf_nat_sdp_media_hook);
 
 static int string_len(const struct nf_conn *ct, const char *dptr,
 		      const char *limit, int *shift)
@@ -622,6 +643,26 @@ int ct_sip_get_sdp_header(const struct nf_conn *ct, const char *dptr,
 }
 EXPORT_SYMBOL_GPL(ct_sip_get_sdp_header);
 
+static int ct_sip_parse_sdp_addr(const struct nf_conn *ct, const char *dptr,
+				 unsigned int dataoff, unsigned int datalen,
+				 enum sdp_header_types type,
+				 enum sdp_header_types term,
+				 unsigned int *matchoff, unsigned int *matchlen,
+				 union nf_inet_addr *addr)
+{
+	int ret;
+
+	ret = ct_sip_get_sdp_header(ct, dptr, dataoff, datalen, type, term,
+				    matchoff, matchlen);
+	if (ret <= 0)
+		return ret;
+
+	if (!parse_addr(ct, dptr + *matchoff, NULL, addr,
+			dptr + *matchoff + *matchlen))
+		return -1;
+	return 1;
+}
+
 static int refresh_signalling_expectation(struct nf_conn *ct,
 					  union nf_inet_addr *addr,
 					  __be16 port,
@@ -672,7 +713,8 @@ static void flush_expectations(struct nf_conn *ct, int media)
 
 static int set_expected_rtp_rtcp(struct sk_buff *skb,
 				 const char **dptr, unsigned int *datalen,
-				 union nf_inet_addr *daddr, __be16 port)
+				 union nf_inet_addr *daddr, __be16 port,
+				 unsigned int mediaoff, unsigned int medialen)
 {
 	struct nf_conntrack_expect *exp, *rtp_exp, *rtcp_exp;
 	enum ip_conntrack_info ctinfo;
@@ -684,7 +726,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb,
 	int skip_expect = 0, ret = NF_DROP;
 	u_int16_t base_port;
 	__be16 rtp_port, rtcp_port;
-	typeof(nf_nat_sdp_hook) nf_nat_sdp;
+	typeof(nf_nat_sdp_media_hook) nf_nat_sdp_media;
 
 	saddr = NULL;
 	if (sip_direct_media) {
@@ -733,9 +775,10 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb,
 	nf_ct_expect_init(rtcp_exp, SIP_EXPECT_AUDIO, family, saddr, daddr,
 			  IPPROTO_UDP, NULL, &rtcp_port);
 
-	nf_nat_sdp = rcu_dereference(nf_nat_sdp_hook);
-	if (nf_nat_sdp && ct->status & IPS_NAT_MASK)
-		ret = nf_nat_sdp(skb, dptr, datalen, rtp_exp, rtcp_exp);
+	nf_nat_sdp_media = rcu_dereference(nf_nat_sdp_media_hook);
+	if (nf_nat_sdp_media && ct->status & IPS_NAT_MASK)
+		ret = nf_nat_sdp_media(skb, dptr, datalen, rtp_exp, rtcp_exp,
+				       mediaoff, medialen, daddr);
 	else {
 		if (nf_ct_expect_related(rtp_exp) == 0) {
 			if (nf_ct_expect_related(rtcp_exp) != 0)
@@ -759,33 +802,78 @@ static int process_sdp(struct sk_buff *skb,
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	unsigned int matchoff, matchlen;
-	union nf_inet_addr addr;
+	unsigned int mediaoff, medialen;
+	unsigned int sdpoff;
+	unsigned int caddr_len, maddr_len;
+	union nf_inet_addr caddr, maddr, rtp_addr;
 	unsigned int port;
-	enum sdp_header_types type;
+	enum sdp_header_types c_hdr;
+	int ret;
+	typeof(nf_nat_sdp_addr_hook) nf_nat_sdp_addr;
+	typeof(nf_nat_sdp_session_hook) nf_nat_sdp_session;
 
-	/* Get address and port from SDP packet. */
-	type = family == AF_INET ? SDP_HDR_CONNECTION_IP4 :
-				   SDP_HDR_CONNECTION_IP6;
+	c_hdr = family == AF_INET ? SDP_HDR_CONNECTION_IP4 :
+				    SDP_HDR_CONNECTION_IP6;
 
+	/* Find beginning of session description */
 	if (ct_sip_get_sdp_header(ct, *dptr, 0, *datalen,
-				  type, SDP_HDR_UNSPEC,
+				  SDP_HDR_VERSION, SDP_HDR_UNSPEC,
 				  &matchoff, &matchlen) <= 0)
 		return NF_ACCEPT;
-
-	/* We'll drop only if there are parse problems. */
-	if (!parse_addr(ct, *dptr + matchoff, NULL, &addr, *dptr + *datalen))
-		return NF_DROP;
-
-	if (ct_sip_get_sdp_header(ct, *dptr, 0, *datalen,
+	sdpoff = matchoff;
+
+	/* The connection information is contained in the session description
+	 * and/or once per media description. The first media description marks
+	 * the end of the session description. */
+	caddr_len = 0;
+	if (ct_sip_parse_sdp_addr(ct, *dptr, sdpoff, *datalen,
+				  c_hdr, SDP_HDR_MEDIA,
+				  &matchoff, &matchlen, &caddr) > 0)
+		caddr_len = matchlen;
+
+	if (ct_sip_get_sdp_header(ct, *dptr, sdpoff, *datalen,
 				  SDP_HDR_MEDIA, SDP_HDR_UNSPEC,
-				  &matchoff, &matchlen) <= 0)
+				  &mediaoff, &medialen) <= 0)
 		return NF_ACCEPT;
 
-	port = simple_strtoul(*dptr + matchoff, NULL, 10);
+	port = simple_strtoul(*dptr + mediaoff, NULL, 10);
 	if (port < 1024 || port > 65535)
 		return NF_DROP;
 
-	return set_expected_rtp_rtcp(skb, dptr, datalen, &addr, htons(port));
+	/* The media description overrides the session description. */
+	maddr_len = 0;
+	if (ct_sip_parse_sdp_addr(ct, *dptr, mediaoff, *datalen,
+				  c_hdr, SDP_HDR_MEDIA,
+				  &matchoff, &matchlen, &maddr) > 0) {
+		maddr_len = matchlen;
+		memcpy(&rtp_addr, &maddr, sizeof(rtp_addr));
+	} else if (caddr_len)
+		memcpy(&rtp_addr, &caddr, sizeof(rtp_addr));
+	else
+		return NF_DROP;
+
+	ret = set_expected_rtp_rtcp(skb, dptr, datalen, &rtp_addr, htons(port),
+				    mediaoff, medialen);
+	if (ret != NF_ACCEPT)
+		return ret;
+
+	/* Update media connection address if present */
+	if (maddr_len) {
+		nf_nat_sdp_addr = rcu_dereference(nf_nat_sdp_addr_hook);
+		if (nf_nat_sdp_addr && ct->status & IPS_NAT_MASK) {
+			ret = nf_nat_sdp_addr(skb, dptr, mediaoff, datalen,
+					      c_hdr, SDP_HDR_MEDIA, &rtp_addr);
+			if (ret != NF_ACCEPT)
+				return ret;
+		}
+	}
+
+	/* Update session connection and owner addresses */
+	nf_nat_sdp_session = rcu_dereference(nf_nat_sdp_session_hook);
+	if (nf_nat_sdp_session && ct->status & IPS_NAT_MASK)
+		ret = nf_nat_sdp_session(skb, dptr, sdpoff, datalen, &rtp_addr);
+
+	return ret;
 }
 static int process_invite_response(struct sk_buff *skb,
 				   const char **dptr, unsigned int *datalen,
