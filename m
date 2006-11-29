From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 23/33]: sip conntrack: better NAT handling
Date: Wed, 29 Nov 2006 03:09:20 +0100 (MET)
Message-ID: <20061129020919.21082.20170.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: sip conntrack: better NAT handling

The NAT handling of the SIP helper has a few problems:

- Request headers are only mangled in the reply direction, From/To headers
  not at all, which can lead to authentication failures with DNAT in case
  the authentication domain is the IP address

- Contact headers in responses are only mangled for REGISTER responses

- Headers may be mangled even though they contain addresses not
  participating in the connection, like alternative addresses

- Packets are droppen when domain names are used where the helper expects
  IP addresses

This patch takes a different approach, instead of fixed rules what field
to mangle to what content, it adds symetric mapping of From/To/Via/Contact
headers, which allows to deal properly with echoed addresses in responses
and foreign addresses not belonging to the connection.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f344b5c94ce31b63c1c2c31ea04512bc9e3929c5
tree 3f86f114a21a92efc2f117d380ae98ae64a2f3cc
parent 69e5ca0b3c45fc0831ca7d401bba4d791681e92b
author Patrick McHardy <kaber@trash.net> Tue, 28 Nov 2006 23:13:32 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 29 Nov 2006 02:32:50 +0100

 include/linux/netfilter_ipv4/ip_conntrack_sip.h |    5 +
 net/ipv4/netfilter/ip_conntrack_sip.c           |   29 ++++
 net/ipv4/netfilter/ip_nat_sip.c                 |  171 ++++++++++++++---------
 3 files changed, 135 insertions(+), 70 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_conntrack_sip.h b/include/linux/netfilter_ipv4/ip_conntrack_sip.h
index 51c65ac..bef6c64 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack_sip.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack_sip.h
@@ -6,7 +6,10 @@ #define SIP_PORT	5060
 #define SIP_TIMEOUT	3600
 
 enum sip_header_pos {
-	POS_REQ_HEADER,
+	POS_REG_REQ_URI,
+	POS_REQ_URI,
+	POS_FROM,
+	POS_TO,
 	POS_VIA,
 	POS_CONTACT,
 	POS_CONTENT,
diff --git a/net/ipv4/netfilter/ip_conntrack_sip.c b/net/ipv4/netfilter/ip_conntrack_sip.c
index 0a6a13c..3a26d63 100644
--- a/net/ipv4/netfilter/ip_conntrack_sip.c
+++ b/net/ipv4/netfilter/ip_conntrack_sip.c
@@ -69,13 +69,38 @@ struct sip_header_nfo {
 };
 
 static struct sip_header_nfo ct_sip_hdrs[] = {
-	[POS_REQ_HEADER] = { 	/* SIP Requests headers */
+	[POS_REG_REQ_URI] = { 	/* SIP REGISTER request URI */
+		.lname		= "sip:",
+		.lnlen		= sizeof("sip:") - 1,
+		.ln_str		= ":",
+		.ln_strlen	= sizeof(":") - 1,
+		.match_len	= epaddr_len
+	},
+	[POS_REQ_URI] = { 	/* SIP request URI */
 		.lname		= "sip:",
 		.lnlen		= sizeof("sip:") - 1,
 		.ln_str		= "@",
 		.ln_strlen	= sizeof("@") - 1,
 		.match_len	= epaddr_len
 	},
+	[POS_FROM] = {		/* SIP From header */
+		.lname		= "From:",
+		.lnlen		= sizeof("From:") - 1,
+		.sname		= "\r\nf:",
+		.snlen		= sizeof("\r\nf:") - 1,
+		.ln_str		= "sip:",
+		.ln_strlen	= sizeof("sip:") - 1,
+		.match_len	= skp_epaddr_len,
+	},
+	[POS_TO] = {		/* SIP To header */
+		.lname		= "To:",
+		.lnlen		= sizeof("To:") - 1,
+		.sname		= "\r\nt:",
+		.snlen		= sizeof("\r\nt:") - 1,
+		.ln_str		= "sip:",
+		.ln_strlen	= sizeof("sip:") - 1,
+		.match_len	= skp_epaddr_len,
+	},
 	[POS_VIA] = { 		/* SIP Via header */
 		.lname		= "Via:",
 		.lnlen		= sizeof("Via:") - 1,
@@ -284,7 +309,7 @@ int ct_sip_get_info(const char *dptr, si
 
 	while (dptr <= limit) {
 		if ((strncmp(dptr, hnfo->lname, hnfo->lnlen) != 0) &&
-		    (hinfo->sname == NULL ||
+		    (hnfo->sname == NULL ||
 		     strncmp(dptr, hnfo->sname, hnfo->snlen) != 0)) {
 			dptr++;
 			continue;
diff --git a/net/ipv4/netfilter/ip_nat_sip.c b/net/ipv4/netfilter/ip_nat_sip.c
index e16604c..6223abc 100644
--- a/net/ipv4/netfilter/ip_nat_sip.c
+++ b/net/ipv4/netfilter/ip_nat_sip.c
@@ -29,25 +29,70 @@ #else
 #define DEBUGP(format, args...)
 #endif
 
-static unsigned int mangle_sip_packet(struct sk_buff **pskb,
-				      enum ip_conntrack_info ctinfo,
-				      struct ip_conntrack *ct,
-				      const char **dptr, size_t dlen,
-				      char *buffer, int bufflen,
-				      enum sip_header_pos pos)
+struct addr_map {
+	struct {
+		char		src[sizeof("nnn.nnn.nnn.nnn:nnnnn")];
+		char		dst[sizeof("nnn.nnn.nnn.nnn:nnnnn")];
+		unsigned int	srclen, srciplen;
+		unsigned int	dstlen, dstiplen;
+	} addr[IP_CT_DIR_MAX];
+};
+
+static void addr_map_init(struct ip_conntrack *ct, struct addr_map *map)
 {
-	unsigned int matchlen, matchoff;
+	struct ip_conntrack_tuple *t;
+	enum ip_conntrack_dir dir;
+	unsigned int n;
+
+	for (dir = 0; dir < IP_CT_DIR_MAX; dir++) {
+		t = &ct->tuplehash[dir].tuple;
+
+		n = sprintf(map->addr[dir].src, "%u.%u.%u.%u",
+			    NIPQUAD(t->src.ip));
+		map->addr[dir].srciplen = n;
+		n += sprintf(map->addr[dir].src + n, ":%u",
+			     ntohs(t->src.u.udp.port));
+		map->addr[dir].srclen = n;
+
+		n = sprintf(map->addr[dir].dst, "%u.%u.%u.%u",
+			    NIPQUAD(t->dst.ip));
+		map->addr[dir].dstiplen = n;
+		n += sprintf(map->addr[dir].dst + n, ":%u",
+			     ntohs(t->dst.u.udp.port));
+		map->addr[dir].dstlen = n;
+	}
+}
+
+static int map_sip_addr(struct sk_buff **pskb, enum ip_conntrack_info ctinfo,
+			struct ip_conntrack *ct, const char **dptr, size_t dlen,
+			enum sip_header_pos pos, struct addr_map *map)
+{
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+	unsigned int matchlen, matchoff, addrlen;
+	char *addr;
 
 	if (ct_sip_get_info(*dptr, dlen, &matchoff, &matchlen, pos) <= 0)
-		return 0;
+		return 1;
+
+	if ((matchlen == map->addr[dir].srciplen ||
+	     matchlen == map->addr[dir].srclen) &&
+	    memcmp(*dptr + matchoff, map->addr[dir].src, matchlen) == 0) {
+		addr    = map->addr[!dir].dst;
+		addrlen = map->addr[!dir].dstlen;
+	} else if ((matchlen == map->addr[dir].dstiplen ||
+		    matchlen == map->addr[dir].dstlen) &&
+		   memcmp(*dptr + matchoff, map->addr[dir].dst, matchlen) == 0) {
+		addr    = map->addr[!dir].src;
+		addrlen = map->addr[!dir].srclen;
+	} else
+		return 1;
 
 	if (!ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
-	                              matchoff, matchlen, buffer, bufflen))
+	                              matchoff, matchlen, addr, addrlen))
 		return 0;
-
-	/* We need to reload this. Thanks Patrick. */
 	*dptr = (*pskb)->data + (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);
 	return 1;
+
 }
 
 static unsigned int ip_nat_sip(struct sk_buff **pskb,
@@ -55,69 +100,61 @@ static unsigned int ip_nat_sip(struct sk
 			       struct ip_conntrack *ct,
 			       const char **dptr)
 {
-	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-	char buffer[sizeof("nnn.nnn.nnn.nnn:nnnnn")];
-	unsigned int bufflen, dataoff;
-	__be32 ip;
-	__be16 port;
+	enum sip_header_pos pos;
+	struct addr_map map;
+	int dataoff, datalen;
 
 	dataoff = (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);
+	datalen = (*pskb)->len - dataoff;
+	if (datalen < sizeof("SIP/2.0") - 1)
+		return NF_DROP;
+
+	addr_map_init(ct, &map);
+
+	/* Basic rules: requests and responses. */
+	if (strncmp(*dptr, "SIP/2.0", sizeof("SIP/2.0") - 1) != 0) {
+		/* 10.2: Constructing the REGISTER Request:
+		 *
+		 * The "userinfo" and "@" components of the SIP URI MUST NOT
+		 * be present.
+		 */
+		if (datalen >= sizeof("REGISTER") - 1 &&
+		    strncmp(*dptr, "REGISTER", sizeof("REGISTER") - 1) == 0)
+			pos = POS_REG_REQ_URI;
+		else
+			pos = POS_REQ_URI;
+
+		if (!map_sip_addr(pskb, ctinfo, ct, dptr, datalen, pos, &map))
+			return NF_DROP;
+	}
 
-	ip   = ct->tuplehash[!dir].tuple.dst.ip;
-	port = ct->tuplehash[!dir].tuple.dst.u.udp.port;
-	bufflen = sprintf(buffer, "%u.%u.%u.%u:%u", NIPQUAD(ip), ntohs(port));
+	if (!map_sip_addr(pskb, ctinfo, ct, dptr, datalen, POS_FROM, &map) ||
+	    !map_sip_addr(pskb, ctinfo, ct, dptr, datalen, POS_TO, &map) ||
+	    !map_sip_addr(pskb, ctinfo, ct, dptr, datalen, POS_VIA, &map) ||
+	    !map_sip_addr(pskb, ctinfo, ct, dptr, datalen, POS_CONTACT, &map))
+		return NF_DROP;
+	return NF_ACCEPT;
+}
+
+static unsigned int mangle_sip_packet(struct sk_buff **pskb,
+				      enum ip_conntrack_info ctinfo,
+				      struct ip_conntrack *ct,
+				      const char **dptr, size_t dlen,
+				      char *buffer, int bufflen,
+				      enum sip_header_pos pos)
+{
+	unsigned int matchlen, matchoff;
 
-	/* short packet ? */
-	if (((*pskb)->len - dataoff) < (sizeof("SIP/2.0") - 1))
+	if (ct_sip_get_info(*dptr, dlen, &matchoff, &matchlen, pos) <= 0)
 		return 0;
 
-	/* Basic rules: requests and responses. */
-	if (memcmp(*dptr, "SIP/2.0", sizeof("SIP/2.0") - 1) == 0) {
-		const char *aux;
-
-		if ((ctinfo) < IP_CT_IS_REPLY) {
-			mangle_sip_packet(pskb, ctinfo, ct, dptr,
-			                  (*pskb)->len - dataoff,
-			                  buffer, bufflen, POS_CONTACT);
-			return 1;
-		}
+	if (!ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
+	                              matchoff, matchlen, buffer, bufflen))
+		return 0;
 
-		if (!mangle_sip_packet(pskb, ctinfo, ct, dptr,
-				       (*pskb)->len - dataoff,
-		                       buffer, bufflen, POS_VIA))
-			return 0;
-
-		aux = ct_sip_search("CSeq:", *dptr, sizeof("CSeq:") - 1,
-		                    (*pskb)->len - dataoff, 0);
-		if (!aux)
-			return 0;
-
-		if (!ct_sip_search("REGISTER", aux, sizeof("REGISTER"),
-				   ct_sip_lnlen(aux,
-				   		*dptr + (*pskb)->len - dataoff),
-				   1))
-			return 1;
-
-		return mangle_sip_packet(pskb, ctinfo, ct, dptr,
-					 (*pskb)->len - dataoff,
-		                         buffer, bufflen, POS_CONTACT);
-	}
-	if ((ctinfo) < IP_CT_IS_REPLY) {
-		if (!mangle_sip_packet(pskb, ctinfo, ct, dptr,
-				       (*pskb)->len - dataoff,
-		                       buffer, bufflen, POS_VIA))
-			return 0;
-
-		/* Mangle Contact if exists only. - watch udp_nat_mangle()! */
-		mangle_sip_packet(pskb, ctinfo, ct, dptr, (*pskb)->len - dataoff,
-		                  buffer, bufflen, POS_CONTACT);
-		return 1;
-	}
-	/* This mangle requests headers. */
-	return mangle_sip_packet(pskb, ctinfo, ct, dptr,
-	                         ct_sip_lnlen(*dptr,
-				              *dptr + (*pskb)->len - dataoff),
-	                         buffer, bufflen, POS_REQ_HEADER);
+	/* We need to reload this. Thanks Patrick. */
+	*dptr = (*pskb)->data + (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);
+	return 1;
 }
 
 static int mangle_content_len(struct sk_buff **pskb,
