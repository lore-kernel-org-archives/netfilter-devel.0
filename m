From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 11/32]: nf_conntrack_sip: adjust dptr and datalen after packet mangling
Date: Thu, 28 Feb 2008 13:00:11 +0100 (MET)
Message-ID: <20080228120002.29267.3615.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49987 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270AbYB1MAM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:12 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: adjust dptr and datalen after packet mangling

After mangling the packet, the pointer to the data and the length of the data
portion may change and need to be adjusted.

Use double data pointers and a pointer to the length everywhere and add a
helper function to the NAT helper for performing the adjustments.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 42d7af9859d42d9c1b51a076146eb75ec837a1dc
tree bfa0df703d0bce2126493a51ecc921cc8c709710
parent 2b495a3c3db1a1e4149e5d8d7b26868660c9d9dd
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:18 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:18 +0100

 include/linux/netfilter/nf_conntrack_sip.h |    6 +-
 net/ipv4/netfilter/nf_nat_sip.c            |   91 +++++++++++++++-------------
 net/netfilter/nf_conntrack_sip.c           |   14 ++--
 3 files changed, 60 insertions(+), 51 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index a58d6a3..c1d0eed 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -30,11 +30,13 @@ enum sip_header_pos {
 extern unsigned int (*nf_nat_sip_hook)(struct sk_buff *skb,
 				       enum ip_conntrack_info ctinfo,
 				       struct nf_conn *ct,
-				       const char **dptr);
+				       const char **dptr,
+				       unsigned int *datalen);
 extern unsigned int (*nf_nat_sdp_hook)(struct sk_buff *skb,
 				       enum ip_conntrack_info ctinfo,
 				       struct nf_conntrack_expect *exp,
-				       const char *dptr);
+				       const char **dptr,
+				       unsigned int *datalen);
 
 extern int ct_sip_get_info(const struct nf_conn *ct, const char *dptr,
                            size_t dlen, unsigned int *matchoff,
diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index 84d8b49..e77122e 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -60,15 +60,35 @@ static void addr_map_init(const struct nf_conn *ct, struct addr_map *map)
 	}
 }
 
+static unsigned int mangle_packet(struct sk_buff *skb,
+				  const char **dptr, unsigned int *datalen,
+				  unsigned int matchoff, unsigned int matchlen,
+				  const char *buffer, unsigned int buflen)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+
+	if (!nf_nat_mangle_udp_packet(skb, ct, ctinfo, matchoff, matchlen,
+				      buffer, buflen))
+		return 0;
+
+	/* Reload data pointer and adjust datalen value */
+	*dptr = skb->data + ip_hdrlen(skb) + sizeof(struct udphdr);
+	*datalen += buflen - matchlen;
+	return 1;
+}
+
 static int map_sip_addr(struct sk_buff *skb, enum ip_conntrack_info ctinfo,
-			struct nf_conn *ct, const char **dptr, size_t dlen,
+			struct nf_conn *ct,
+			const char **dptr, unsigned int *datalen,
 			enum sip_header_pos pos, struct addr_map *map)
 {
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	unsigned int matchlen, matchoff, addrlen;
 	char *addr;
 
-	if (ct_sip_get_info(ct, *dptr, dlen, &matchoff, &matchlen, pos) <= 0)
+	if (ct_sip_get_info(ct, *dptr, *datalen, &matchoff, &matchlen,
+			    pos) <= 0)
 		return 1;
 
 	if ((matchlen == map->addr[dir].srciplen ||
@@ -84,26 +104,19 @@ static int map_sip_addr(struct sk_buff *skb, enum ip_conntrack_info ctinfo,
 	} else
 		return 1;
 
-	if (!nf_nat_mangle_udp_packet(skb, ct, ctinfo,
-				      matchoff, matchlen, addr, addrlen))
-		return 0;
-	*dptr = skb->data + ip_hdrlen(skb) + sizeof(struct udphdr);
-	return 1;
-
+	return mangle_packet(skb, dptr, datalen, matchoff, matchlen,
+			     addr, addrlen);
 }
 
 static unsigned int ip_nat_sip(struct sk_buff *skb,
 			       enum ip_conntrack_info ctinfo,
 			       struct nf_conn *ct,
-			       const char **dptr)
+			       const char **dptr, unsigned int *datalen)
 {
 	enum sip_header_pos pos;
 	struct addr_map map;
-	int dataoff, datalen;
 
-	dataoff = ip_hdrlen(skb) + sizeof(struct udphdr);
-	datalen = skb->len - dataoff;
-	if (datalen < sizeof("SIP/2.0") - 1)
+	if (*datalen < sizeof("SIP/2.0") - 1)
 		return NF_ACCEPT;
 
 	addr_map_init(ct, &map);
@@ -115,7 +128,7 @@ static unsigned int ip_nat_sip(struct sk_buff *skb,
 		 * The "userinfo" and "@" components of the SIP URI MUST NOT
 		 * be present.
 		 */
-		if (datalen >= sizeof("REGISTER") - 1 &&
+		if (*datalen >= sizeof("REGISTER") - 1 &&
 		    strncmp(*dptr, "REGISTER", sizeof("REGISTER") - 1) == 0)
 			pos = POS_REG_REQ_URI;
 		else
@@ -136,51 +149,45 @@ static unsigned int ip_nat_sip(struct sk_buff *skb,
 static unsigned int mangle_sip_packet(struct sk_buff *skb,
 				      enum ip_conntrack_info ctinfo,
 				      struct nf_conn *ct,
-				      const char **dptr, size_t dlen,
+				      const char **dptr, unsigned int *datalen,
 				      char *buffer, int bufflen,
 				      enum sip_header_pos pos)
 {
 	unsigned int matchlen, matchoff;
 
-	if (ct_sip_get_info(ct, *dptr, dlen, &matchoff, &matchlen, pos) <= 0)
-		return 0;
-
-	if (!nf_nat_mangle_udp_packet(skb, ct, ctinfo,
-				      matchoff, matchlen, buffer, bufflen))
+	if (ct_sip_get_info(ct, *dptr, *datalen, &matchoff, &matchlen,
+			    pos) <= 0)
 		return 0;
 
-	/* We need to reload this. Thanks Patrick. */
-	*dptr = skb->data + ip_hdrlen(skb) + sizeof(struct udphdr);
-	return 1;
+	return mangle_packet(skb, dptr, datalen, matchoff, matchlen,
+			     buffer, bufflen);
 }
 
 static int mangle_content_len(struct sk_buff *skb,
 			      enum ip_conntrack_info ctinfo,
 			      struct nf_conn *ct,
-			      const char *dptr)
+			      const char **dptr, unsigned int *datalen)
 {
-	unsigned int dataoff, matchoff, matchlen;
+	unsigned int matchoff, matchlen;
 	char buffer[sizeof("65536")];
 	int bufflen;
 
-	dataoff = ip_hdrlen(skb) + sizeof(struct udphdr);
-
 	/* Get actual SDP length */
-	if (ct_sip_get_info(ct, dptr, skb->len - dataoff, &matchoff,
+	if (ct_sip_get_info(ct, *dptr, *datalen, &matchoff,
 			    &matchlen, POS_SDP_HEADER) > 0) {
 
 		/* since ct_sip_get_info() give us a pointer passing 'v='
 		   we need to add 2 bytes in this count. */
-		int c_len = skb->len - dataoff - matchoff + 2;
+		int c_len = *datalen - matchoff + 2;
 
 		/* Now, update SDP length */
-		if (ct_sip_get_info(ct, dptr, skb->len - dataoff, &matchoff,
+		if (ct_sip_get_info(ct, *dptr, *datalen, &matchoff,
 				    &matchlen, POS_CONTENT) > 0) {
 
 			bufflen = sprintf(buffer, "%u", c_len);
-			return nf_nat_mangle_udp_packet(skb, ct, ctinfo,
-							matchoff, matchlen,
-							buffer, bufflen);
+			return mangle_packet(skb, dptr, datalen,
+					     matchoff, matchlen,
+					     buffer, bufflen);
 		}
 	}
 	return 0;
@@ -190,30 +197,28 @@ static unsigned int mangle_sdp(struct sk_buff *skb,
 			       enum ip_conntrack_info ctinfo,
 			       struct nf_conn *ct,
 			       __be32 newip, u_int16_t port,
-			       const char *dptr)
+			       const char **dptr, unsigned int *datalen)
 {
 	char buffer[sizeof("nnn.nnn.nnn.nnn")];
-	unsigned int dataoff, bufflen;
-
-	dataoff = ip_hdrlen(skb) + sizeof(struct udphdr);
+	unsigned int bufflen;
 
 	/* Mangle owner and contact info. */
 	bufflen = sprintf(buffer, "%u.%u.%u.%u", NIPQUAD(newip));
-	if (!mangle_sip_packet(skb, ctinfo, ct, &dptr, skb->len - dataoff,
+	if (!mangle_sip_packet(skb, ctinfo, ct, dptr, datalen,
 			       buffer, bufflen, POS_OWNER_IP4))
 		return 0;
 
-	if (!mangle_sip_packet(skb, ctinfo, ct, &dptr, skb->len - dataoff,
+	if (!mangle_sip_packet(skb, ctinfo, ct, dptr, datalen,
 			       buffer, bufflen, POS_CONNECTION_IP4))
 		return 0;
 
 	/* Mangle media port. */
 	bufflen = sprintf(buffer, "%u", port);
-	if (!mangle_sip_packet(skb, ctinfo, ct, &dptr, skb->len - dataoff,
+	if (!mangle_sip_packet(skb, ctinfo, ct, dptr, datalen,
 			       buffer, bufflen, POS_MEDIA))
 		return 0;
 
-	return mangle_content_len(skb, ctinfo, ct, dptr);
+	return mangle_content_len(skb, ctinfo, ct, dptr, datalen);
 }
 
 static void ip_nat_sdp_expect(struct nf_conn *ct,
@@ -242,7 +247,7 @@ static void ip_nat_sdp_expect(struct nf_conn *ct,
 static unsigned int ip_nat_sdp(struct sk_buff *skb,
 			       enum ip_conntrack_info ctinfo,
 			       struct nf_conntrack_expect *exp,
-			       const char *dptr)
+			       const char **dptr, unsigned int *datalen)
 {
 	struct nf_conn *ct = exp->master;
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
@@ -275,7 +280,7 @@ static unsigned int ip_nat_sdp(struct sk_buff *skb,
 	if (port == 0)
 		return NF_DROP;
 
-	if (!mangle_sdp(skb, ctinfo, ct, newip, port, dptr)) {
+	if (!mangle_sdp(skb, ctinfo, ct, newip, port, dptr, datalen)) {
 		nf_ct_unexpect_related(exp);
 		return NF_DROP;
 	}
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index d3aaeab..d0a651b 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -39,13 +39,15 @@ MODULE_PARM_DESC(sip_timeout, "timeout for the master SIP session");
 unsigned int (*nf_nat_sip_hook)(struct sk_buff *skb,
 				enum ip_conntrack_info ctinfo,
 				struct nf_conn *ct,
-				const char **dptr) __read_mostly;
+				const char **dptr,
+				unsigned int *datalen) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_sip_hook);
 
 unsigned int (*nf_nat_sdp_hook)(struct sk_buff *skb,
 				enum ip_conntrack_info ctinfo,
 				struct nf_conntrack_expect *exp,
-				const char *dptr) __read_mostly;
+				const char **dptr,
+				unsigned int *datalen) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_sdp_hook);
 
 static int digits_len(const struct nf_conn *, const char *, const char *, int *);
@@ -378,7 +380,7 @@ static int set_expected_rtp(struct sk_buff *skb,
 			    enum ip_conntrack_info ctinfo,
 			    union nf_inet_addr *addr,
 			    __be16 port,
-			    const char *dptr)
+			    const char **dptr, unsigned int *datalen)
 {
 	struct nf_conntrack_expect *exp;
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
@@ -395,7 +397,7 @@ static int set_expected_rtp(struct sk_buff *skb,
 
 	nf_nat_sdp = rcu_dereference(nf_nat_sdp_hook);
 	if (nf_nat_sdp && ct->status & IPS_NAT_MASK)
-		ret = nf_nat_sdp(skb, ctinfo, exp, dptr);
+		ret = nf_nat_sdp(skb, ctinfo, exp, dptr, datalen);
 	else {
 		if (nf_ct_expect_related(exp) != 0)
 			ret = NF_DROP;
@@ -438,7 +440,7 @@ static int sip_help(struct sk_buff *skb,
 
 	nf_nat_sip = rcu_dereference(nf_nat_sip_hook);
 	if (nf_nat_sip && ct->status & IPS_NAT_MASK) {
-		if (!nf_nat_sip(skb, ctinfo, ct, &dptr)) {
+		if (!nf_nat_sip(skb, ctinfo, ct, &dptr, &datalen)) {
 			ret = NF_DROP;
 			goto out;
 		}
@@ -475,7 +477,7 @@ static int sip_help(struct sk_buff *skb,
 				goto out;
 			}
 			ret = set_expected_rtp(skb, ct, ctinfo, &addr,
-					       htons(port), dptr);
+					       htons(port), &dptr, &datalen);
 		}
 	}
 out:
