From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 12/32]: nf_conntrack_sip: remove redundant function arguments
Date: Thu, 28 Feb 2008 13:00:13 +0100 (MET)
Message-ID: <20080228120004.29267.15539.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49989 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291AbYB1MAO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:14 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: remove redundant function arguments

The conntrack reference and ctinfo can be derived from the packet.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ee0b2a3c7a34c1c09e96b5601d8e8ce46861e808
tree 24a0edb6ab5bf59ea318ec94e41077f49a9d30f8
parent 42d7af9859d42d9c1b51a076146eb75ec837a1dc
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:19 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:19 +0100

 include/linux/netfilter/nf_conntrack_sip.h |    7 +---
 net/ipv4/netfilter/nf_nat_sip.c            |   49 ++++++++++++++--------------
 net/netfilter/nf_conntrack_sip.c           |   24 ++++++--------
 3 files changed, 37 insertions(+), 43 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index c1d0eed..d773c61 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -28,15 +28,12 @@ enum sip_header_pos {
 };
 
 extern unsigned int (*nf_nat_sip_hook)(struct sk_buff *skb,
-				       enum ip_conntrack_info ctinfo,
-				       struct nf_conn *ct,
 				       const char **dptr,
 				       unsigned int *datalen);
 extern unsigned int (*nf_nat_sdp_hook)(struct sk_buff *skb,
-				       enum ip_conntrack_info ctinfo,
-				       struct nf_conntrack_expect *exp,
 				       const char **dptr,
-				       unsigned int *datalen);
+				       unsigned int *datalen,
+				       struct nf_conntrack_expect *exp);
 
 extern int ct_sip_get_info(const struct nf_conn *ct, const char *dptr,
                            size_t dlen, unsigned int *matchoff,
diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index e77122e..acaa7d4 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -78,11 +78,12 @@ static unsigned int mangle_packet(struct sk_buff *skb,
 	return 1;
 }
 
-static int map_sip_addr(struct sk_buff *skb, enum ip_conntrack_info ctinfo,
-			struct nf_conn *ct,
+static int map_sip_addr(struct sk_buff *skb,
 			const char **dptr, unsigned int *datalen,
 			enum sip_header_pos pos, struct addr_map *map)
 {
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	unsigned int matchlen, matchoff, addrlen;
 	char *addr;
@@ -109,10 +110,10 @@ static int map_sip_addr(struct sk_buff *skb, enum ip_conntrack_info ctinfo,
 }
 
 static unsigned int ip_nat_sip(struct sk_buff *skb,
-			       enum ip_conntrack_info ctinfo,
-			       struct nf_conn *ct,
 			       const char **dptr, unsigned int *datalen)
 {
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	enum sip_header_pos pos;
 	struct addr_map map;
 
@@ -134,25 +135,25 @@ static unsigned int ip_nat_sip(struct sk_buff *skb,
 		else
 			pos = POS_REQ_URI;
 
-		if (!map_sip_addr(skb, ctinfo, ct, dptr, datalen, pos, &map))
+		if (!map_sip_addr(skb, dptr, datalen, pos, &map))
 			return NF_DROP;
 	}
 
-	if (!map_sip_addr(skb, ctinfo, ct, dptr, datalen, POS_FROM, &map) ||
-	    !map_sip_addr(skb, ctinfo, ct, dptr, datalen, POS_TO, &map) ||
-	    !map_sip_addr(skb, ctinfo, ct, dptr, datalen, POS_VIA, &map) ||
-	    !map_sip_addr(skb, ctinfo, ct, dptr, datalen, POS_CONTACT, &map))
+	if (!map_sip_addr(skb, dptr, datalen, POS_FROM, &map) ||
+	    !map_sip_addr(skb, dptr, datalen, POS_TO, &map) ||
+	    !map_sip_addr(skb, dptr, datalen, POS_VIA, &map) ||
+	    !map_sip_addr(skb, dptr, datalen, POS_CONTACT, &map))
 		return NF_DROP;
 	return NF_ACCEPT;
 }
 
 static unsigned int mangle_sip_packet(struct sk_buff *skb,
-				      enum ip_conntrack_info ctinfo,
-				      struct nf_conn *ct,
 				      const char **dptr, unsigned int *datalen,
 				      char *buffer, int bufflen,
 				      enum sip_header_pos pos)
 {
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	unsigned int matchlen, matchoff;
 
 	if (ct_sip_get_info(ct, *dptr, *datalen, &matchoff, &matchlen,
@@ -164,10 +165,10 @@ static unsigned int mangle_sip_packet(struct sk_buff *skb,
 }
 
 static int mangle_content_len(struct sk_buff *skb,
-			      enum ip_conntrack_info ctinfo,
-			      struct nf_conn *ct,
 			      const char **dptr, unsigned int *datalen)
 {
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	unsigned int matchoff, matchlen;
 	char buffer[sizeof("65536")];
 	int bufflen;
@@ -204,21 +205,21 @@ static unsigned int mangle_sdp(struct sk_buff *skb,
 
 	/* Mangle owner and contact info. */
 	bufflen = sprintf(buffer, "%u.%u.%u.%u", NIPQUAD(newip));
-	if (!mangle_sip_packet(skb, ctinfo, ct, dptr, datalen,
-			       buffer, bufflen, POS_OWNER_IP4))
+	if (!mangle_sip_packet(skb, dptr, datalen, buffer, bufflen,
+			       POS_OWNER_IP4))
 		return 0;
 
-	if (!mangle_sip_packet(skb, ctinfo, ct, dptr, datalen,
-			       buffer, bufflen, POS_CONNECTION_IP4))
+	if (!mangle_sip_packet(skb, dptr, datalen, buffer, bufflen,
+			       POS_CONNECTION_IP4))
 		return 0;
 
 	/* Mangle media port. */
 	bufflen = sprintf(buffer, "%u", port);
-	if (!mangle_sip_packet(skb, ctinfo, ct, dptr, datalen,
-			       buffer, bufflen, POS_MEDIA))
+	if (!mangle_sip_packet(skb, dptr, datalen, buffer, bufflen,
+			       POS_MEDIA))
 		return 0;
 
-	return mangle_content_len(skb, ctinfo, ct, dptr, datalen);
+	return mangle_content_len(skb, dptr, datalen);
 }
 
 static void ip_nat_sdp_expect(struct nf_conn *ct,
@@ -245,11 +246,11 @@ static void ip_nat_sdp_expect(struct nf_conn *ct,
 /* So, this packet has hit the connection tracking matching code.
    Mangle it, and change the expectation to match the new version. */
 static unsigned int ip_nat_sdp(struct sk_buff *skb,
-			       enum ip_conntrack_info ctinfo,
-			       struct nf_conntrack_expect *exp,
-			       const char **dptr, unsigned int *datalen)
+			       const char **dptr, unsigned int *datalen,
+			       struct nf_conntrack_expect *exp)
 {
-	struct nf_conn *ct = exp->master;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	__be32 newip;
 	u_int16_t port;
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index d0a651b..b273225 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -37,17 +37,14 @@ module_param(sip_timeout, uint, 0600);
 MODULE_PARM_DESC(sip_timeout, "timeout for the master SIP session");
 
 unsigned int (*nf_nat_sip_hook)(struct sk_buff *skb,
-				enum ip_conntrack_info ctinfo,
-				struct nf_conn *ct,
 				const char **dptr,
 				unsigned int *datalen) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_sip_hook);
 
 unsigned int (*nf_nat_sdp_hook)(struct sk_buff *skb,
-				enum ip_conntrack_info ctinfo,
-				struct nf_conntrack_expect *exp,
 				const char **dptr,
-				unsigned int *datalen) __read_mostly;
+				unsigned int *datalen,
+				struct nf_conntrack_expect *exp) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_sdp_hook);
 
 static int digits_len(const struct nf_conn *, const char *, const char *, int *);
@@ -376,13 +373,12 @@ int ct_sip_get_info(const struct nf_conn *ct,
 EXPORT_SYMBOL_GPL(ct_sip_get_info);
 
 static int set_expected_rtp(struct sk_buff *skb,
-			    struct nf_conn *ct,
-			    enum ip_conntrack_info ctinfo,
-			    union nf_inet_addr *addr,
-			    __be16 port,
-			    const char **dptr, unsigned int *datalen)
+			    const char **dptr, unsigned int *datalen,
+			    union nf_inet_addr *addr, __be16 port)
 {
 	struct nf_conntrack_expect *exp;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	int family = ct->tuplehash[!dir].tuple.src.l3num;
 	int ret;
@@ -397,7 +393,7 @@ static int set_expected_rtp(struct sk_buff *skb,
 
 	nf_nat_sdp = rcu_dereference(nf_nat_sdp_hook);
 	if (nf_nat_sdp && ct->status & IPS_NAT_MASK)
-		ret = nf_nat_sdp(skb, ctinfo, exp, dptr, datalen);
+		ret = nf_nat_sdp(skb, dptr, datalen, exp);
 	else {
 		if (nf_ct_expect_related(exp) != 0)
 			ret = NF_DROP;
@@ -440,7 +436,7 @@ static int sip_help(struct sk_buff *skb,
 
 	nf_nat_sip = rcu_dereference(nf_nat_sip_hook);
 	if (nf_nat_sip && ct->status & IPS_NAT_MASK) {
-		if (!nf_nat_sip(skb, ctinfo, ct, &dptr, &datalen)) {
+		if (!nf_nat_sip(skb, &dptr, &datalen)) {
 			ret = NF_DROP;
 			goto out;
 		}
@@ -476,8 +472,8 @@ static int sip_help(struct sk_buff *skb,
 				ret = NF_DROP;
 				goto out;
 			}
-			ret = set_expected_rtp(skb, ct, ctinfo, &addr,
-					       htons(port), &dptr, &datalen);
+			ret = set_expected_rtp(skb, &dptr, &datalen,
+					       &addr, htons(port));
 		}
 	}
 out:
