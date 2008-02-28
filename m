From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 18/32]: nf_nat_sip: get rid of text based header translation
Date: Thu, 28 Feb 2008 13:00:21 +0100 (MET)
Message-ID: <20080228120012.29267.86875.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50010 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284AbYB1MAW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:22 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat_sip: get rid of text based header translation

Use the URI parsing helper to get the numerical addresses and get rid of the
text based header translation.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 302ab099bf8a1f162642dd3c949117d852e3e57a
tree a66259227f8ac4a0ac31be8d0956f0310c42b5c0
parent 517cd32eee04d9bdcfe97160bfd9ecb3a636439b
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:24 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:24 +0100

 include/linux/netfilter/nf_conntrack_sip.h |    3 +
 net/ipv4/netfilter/nf_nat_sip.c            |  100 +++++++++++-----------------
 net/netfilter/nf_conntrack_sip.c           |   27 ++++++--
 3 files changed, 62 insertions(+), 68 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index 080b2a2..1f518d3 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -68,7 +68,8 @@ extern unsigned int (*nf_nat_sdp_hook)(struct sk_buff *skb,
 
 extern int ct_sip_parse_request(const struct nf_conn *ct,
 				const char *dptr, unsigned int datalen,
-				unsigned int *matchoff, unsigned int *matchlen);
+				unsigned int *matchoff, unsigned int *matchlen,
+				union nf_inet_addr *addr, __be16 *port);
 extern int ct_sip_get_header(const struct nf_conn *ct, const char *dptr,
 			     unsigned int dataoff, unsigned int datalen,
 			     enum sip_header_types type,
diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index c13e438..5b4a5cd 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -26,39 +26,6 @@ MODULE_AUTHOR("Christian Hentschel <chentschel@arnet.com.ar>");
 MODULE_DESCRIPTION("SIP NAT helper");
 MODULE_ALIAS("ip_nat_sip");
 
-struct addr_map {
-	struct {
-		char		src[sizeof("nnn.nnn.nnn.nnn:nnnnn")];
-		char		dst[sizeof("nnn.nnn.nnn.nnn:nnnnn")];
-		unsigned int	srclen, srciplen;
-		unsigned int	dstlen, dstiplen;
-	} addr[IP_CT_DIR_MAX];
-};
-
-static void addr_map_init(const struct nf_conn *ct, struct addr_map *map)
-{
-	const struct nf_conntrack_tuple *t;
-	enum ip_conntrack_dir dir;
-	unsigned int n;
-
-	for (dir = 0; dir < IP_CT_DIR_MAX; dir++) {
-		t = &ct->tuplehash[dir].tuple;
-
-		n = sprintf(map->addr[dir].src, "%u.%u.%u.%u",
-			    NIPQUAD(t->src.u3.ip));
-		map->addr[dir].srciplen = n;
-		n += sprintf(map->addr[dir].src + n, ":%u",
-			     ntohs(t->src.u.udp.port));
-		map->addr[dir].srclen = n;
-
-		n = sprintf(map->addr[dir].dst, "%u.%u.%u.%u",
-			    NIPQUAD(t->dst.u3.ip));
-		map->addr[dir].dstiplen = n;
-		n += sprintf(map->addr[dir].dst + n, ":%u",
-			     ntohs(t->dst.u.udp.port));
-		map->addr[dir].dstlen = n;
-	}
-}
 
 static unsigned int mangle_packet(struct sk_buff *skb,
 				  const char **dptr, unsigned int *datalen,
@@ -81,43 +48,51 @@ static unsigned int mangle_packet(struct sk_buff *skb,
 static int map_addr(struct sk_buff *skb,
 		    const char **dptr, unsigned int *datalen,
 		    unsigned int matchoff, unsigned int matchlen,
-		    struct addr_map *map)
+		    union nf_inet_addr *addr, __be16 port)
 {
 	enum ip_conntrack_info ctinfo;
-	struct nf_conn *ct __maybe_unused = nf_ct_get(skb, &ctinfo);
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-	unsigned int addrlen;
-	char *addr;
-
-	if ((matchlen == map->addr[dir].srciplen ||
-	     matchlen == map->addr[dir].srclen) &&
-	    strncmp(*dptr + matchoff, map->addr[dir].src, matchlen) == 0) {
-		addr    = map->addr[!dir].dst;
-		addrlen = map->addr[!dir].dstlen;
-	} else if ((matchlen == map->addr[dir].dstiplen ||
-		    matchlen == map->addr[dir].dstlen) &&
-		   strncmp(*dptr + matchoff, map->addr[dir].dst, matchlen) == 0) {
-		addr    = map->addr[!dir].src;
-		addrlen = map->addr[!dir].srclen;
+	char buffer[sizeof("nnn.nnn.nnn.nnn:nnnnn")];
+	unsigned int buflen;
+	__be32 newaddr;
+	__be16 newport;
+
+	if (ct->tuplehash[dir].tuple.src.u3.ip == addr->ip &&
+	    ct->tuplehash[dir].tuple.src.u.udp.port == port) {
+		newaddr = ct->tuplehash[!dir].tuple.dst.u3.ip;
+		newport = ct->tuplehash[!dir].tuple.dst.u.udp.port;
+	} else if (ct->tuplehash[dir].tuple.dst.u3.ip == addr->ip &&
+		   ct->tuplehash[dir].tuple.dst.u.udp.port == port) {
+		newaddr = ct->tuplehash[!dir].tuple.src.u3.ip;
+		newport = ct->tuplehash[!dir].tuple.src.u.udp.port;
 	} else
 		return 1;
 
+	if (newaddr == addr->ip && newport == port)
+		return 1;
+
+	buflen = sprintf(buffer, "%u.%u.%u.%u:%u",
+			 NIPQUAD(newaddr), ntohs(newport));
+
 	return mangle_packet(skb, dptr, datalen, matchoff, matchlen,
-			     addr, addrlen);
+			     buffer, buflen);
 }
 
 static int map_sip_addr(struct sk_buff *skb,
 			const char **dptr, unsigned int *datalen,
-			enum sip_header_types type, struct addr_map *map)
+			enum sip_header_types type)
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	unsigned int matchlen, matchoff;
+	union nf_inet_addr addr;
+	__be16 port;
 
-	if (ct_sip_get_header(ct, *dptr, 0, *datalen, type,
-			      &matchoff, &matchlen) <= 0)
+	if (ct_sip_parse_header_uri(ct, *dptr, NULL, *datalen, type, NULL,
+				    &matchoff, &matchlen, &addr, &port) <= 0)
 		return 1;
-	return map_addr(skb, dptr, datalen, matchoff, matchlen, map);
+	return map_addr(skb, dptr, datalen, matchoff, matchlen, &addr, port);
 }
 
 static unsigned int ip_nat_sip(struct sk_buff *skb,
@@ -125,26 +100,27 @@ static unsigned int ip_nat_sip(struct sk_buff *skb,
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
-	struct addr_map map;
 	unsigned int matchoff, matchlen;
+	union nf_inet_addr addr;
+	__be16 port;
 
 	if (*datalen < strlen("SIP/2.0"))
 		return NF_ACCEPT;
 
-	addr_map_init(ct, &map);
-
 	/* Basic rules: requests and responses. */
 	if (strnicmp(*dptr, "SIP/2.0", strlen("SIP/2.0")) != 0) {
 		if (ct_sip_parse_request(ct, *dptr, *datalen,
-					 &matchoff, &matchlen) > 0 &&
-		    !map_addr(skb, dptr, datalen, matchoff, matchlen, &map))
+					 &matchoff, &matchlen,
+					 &addr, &port) > 0 &&
+		    !map_addr(skb, dptr, datalen, matchoff, matchlen,
+			      &addr, port))
 			return NF_DROP;
 	}
 
-	if (!map_sip_addr(skb, dptr, datalen, SIP_HDR_FROM, &map) ||
-	    !map_sip_addr(skb, dptr, datalen, SIP_HDR_TO, &map) ||
-	    !map_sip_addr(skb, dptr, datalen, SIP_HDR_VIA, &map) ||
-	    !map_sip_addr(skb, dptr, datalen, SIP_HDR_CONTACT, &map))
+	if (!map_sip_addr(skb, dptr, datalen, SIP_HDR_FROM) ||
+	    !map_sip_addr(skb, dptr, datalen, SIP_HDR_TO) ||
+	    !map_sip_addr(skb, dptr, datalen, SIP_HDR_VIA) ||
+	    !map_sip_addr(skb, dptr, datalen, SIP_HDR_CONTACT))
 		return NF_DROP;
 	return NF_ACCEPT;
 }
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 5454ab1..1f0db36 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -160,10 +160,12 @@ static int skp_epaddr_len(const struct nf_conn *ct, const char *dptr,
  */
 int ct_sip_parse_request(const struct nf_conn *ct,
 			 const char *dptr, unsigned int datalen,
-			 unsigned int *matchoff, unsigned int *matchlen)
+			 unsigned int *matchoff, unsigned int *matchlen,
+			 union nf_inet_addr *addr, __be16 *port)
 {
-	const char *start = dptr, *limit = dptr + datalen;
+	const char *start = dptr, *limit = dptr + datalen, *end;
 	unsigned int mlen;
+	unsigned int p;
 	int shift = 0;
 
 	/* Skip method and following whitespace */
@@ -182,10 +184,25 @@ int ct_sip_parse_request(const struct nf_conn *ct,
 		if (strnicmp(dptr, "sip:", strlen("sip:")) == 0)
 			break;
 	}
-	*matchlen = skp_epaddr_len(ct, dptr, limit, &shift);
-	if (!*matchlen)
+	if (!skp_epaddr_len(ct, dptr, limit, &shift))
+		return 0;
+	dptr += shift;
+
+	if (!parse_addr(ct, dptr, &end, addr, limit))
+		return -1;
+	if (end < limit && *end == ':') {
+		end++;
+		p = simple_strtoul(end, (char **)&end, 10);
+		if (p < 1024 || p > 65535)
+			return -1;
+		*port = htons(p);
+	} else
+		*port = htons(SIP_PORT);
+
+	if (end == dptr)
 		return 0;
-	*matchoff = dptr - start + shift;
+	*matchoff = dptr - start;
+	*matchlen = end - dptr;
 	return 1;
 }
 EXPORT_SYMBOL_GPL(ct_sip_parse_request);
