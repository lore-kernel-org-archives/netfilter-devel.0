From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 13/32]: nf_conntrack_sip: add seperate SDP header parsing function
Date: Tue, 25 Mar 2008 15:15:09 +0100 (MET)
Message-ID: <20080325141508.10539.9723.sendpatchset@localhost.localdomain>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32926 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbYCYOPK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:15:10 -0400
In-Reply-To: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: add seperate SDP header parsing function

SDP and SIP headers are quite different, SIP can have continuation lines,
leading and trailing whitespace after the colon and is mostly case-insensitive
while SDP headers always begin on a new line and are followed by an equal
sign and the value, without any whitespace.

Introduce new SDP header parsing function and convert all users that used
the SIP header parsing function. This will allow to properly deal with the
special SIP cases in the SIP header parsing function later.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3a7cda6054cd6374b0b18b72e71404b5ca7b2155
tree ff4c8e34c71a5151b9122f91b8bb5dc1334cc4f4
parent 7fc3c23d9817c4086c5bff587d614136ba5dfc80
author Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 12:44:57 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 14:09:54 +0100

 include/linux/netfilter/nf_conntrack_sip.h |   49 ++++++++-
 net/ipv4/netfilter/nf_nat_sip.c            |   69 ++++++------
 net/netfilter/nf_conntrack_sip.c           |  159 +++++++++++++++++-----------
 3 files changed, 169 insertions(+), 108 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index b94de3d..9131cbc 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -13,12 +13,42 @@ enum sip_header_pos {
 	POS_VIA,
 	POS_CONTACT,
 	POS_CONTENT,
-	POS_MEDIA,
-	POS_OWNER_IP4,
-	POS_CONNECTION_IP4,
-	POS_OWNER_IP6,
-	POS_CONNECTION_IP6,
-	POS_SDP_HEADER,
+};
+
+struct sip_header {
+	const char	*name;
+	const char	*cname;
+	const char	*search;
+	unsigned int	len;
+	unsigned int	clen;
+	unsigned int	slen;
+	int		(*match_len)(const struct nf_conn *ct,
+				     const char *dptr, const char *limit,
+				     int *shift);
+};
+
+#define __SIP_HDR(__name, __cname, __search, __match)			\
+{									\
+	.name		= (__name),					\
+	.len		= sizeof(__name) - 1,				\
+	.cname		= (__cname),					\
+	.clen		= (__cname) ? sizeof(__cname) - 1 : 0,		\
+	.search		= (__search),					\
+	.slen		= (__search) ? sizeof(__search) - 1 : 0,	\
+	.match_len	= (__match),					\
+}
+
+#define SDP_HDR(__name, __search, __match) \
+	__SIP_HDR(__name, NULL, __search, __match)
+
+enum sdp_header_types {
+	SDP_HDR_UNSPEC,
+	SDP_HDR_VERSION,
+	SDP_HDR_OWNER_IP4,
+	SDP_HDR_CONNECTION_IP4,
+	SDP_HDR_OWNER_IP6,
+	SDP_HDR_CONNECTION_IP6,
+	SDP_HDR_MEDIA,
 };
 
 extern unsigned int (*nf_nat_sip_hook)(struct sk_buff *skb,
@@ -36,5 +66,12 @@ extern int ct_sip_lnlen(const char *line, const char *limit);
 extern const char *ct_sip_search(const char *needle, const char *haystack,
 				 size_t needle_len, size_t haystack_len,
 				 int case_sensitive);
+
+extern int ct_sip_get_sdp_header(const struct nf_conn *ct, const char *dptr,
+				 unsigned int dataoff, unsigned int datalen,
+				 enum sdp_header_types type,
+				 enum sdp_header_types term,
+				 unsigned int *matchoff, unsigned int *matchlen);
+
 #endif /* __KERNEL__ */
 #endif /* __NF_CONNTRACK_SIP_H__ */
diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index dd1b2d8..aa8a4f4 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -147,51 +147,46 @@ static unsigned int ip_nat_sip(struct sk_buff *skb,
 	return NF_ACCEPT;
 }
 
-static unsigned int mangle_sip_packet(struct sk_buff *skb,
-				      const char **dptr, unsigned int *datalen,
-				      char *buffer, int bufflen,
-				      enum sip_header_pos pos)
+static int mangle_content_len(struct sk_buff *skb,
+			      const char **dptr, unsigned int *datalen)
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
-	unsigned int matchlen, matchoff;
+	unsigned int matchoff, matchlen;
+	char buffer[sizeof("65536")];
+	int buflen, c_len;
 
+	/* Get actual SDP length */
+	if (ct_sip_get_sdp_header(ct, *dptr, 0, *datalen,
+				  SDP_HDR_VERSION, SDP_HDR_UNSPEC,
+				  &matchoff, &matchlen) <= 0)
+		return 0;
+	c_len = *datalen - matchoff + strlen("v=");
+
+	/* Now, update SDP length */
 	if (ct_sip_get_info(ct, *dptr, *datalen, &matchoff, &matchlen,
-			    pos) <= 0)
+			    POS_CONTENT) <= 0)
 		return 0;
 
+	buflen = sprintf(buffer, "%u", c_len);
 	return mangle_packet(skb, dptr, datalen, matchoff, matchlen,
-			     buffer, bufflen);
+			     buffer, buflen);
 }
 
-static int mangle_content_len(struct sk_buff *skb,
-			      const char **dptr, unsigned int *datalen)
+static unsigned mangle_sdp_packet(struct sk_buff *skb,
+				  const char **dptr, unsigned int *datalen,
+				  enum sdp_header_types type,
+				  char *buffer, int buflen)
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
-	unsigned int matchoff, matchlen;
-	char buffer[sizeof("65536")];
-	int bufflen;
+	unsigned int matchlen, matchoff;
 
-	/* Get actual SDP length */
-	if (ct_sip_get_info(ct, *dptr, *datalen, &matchoff,
-			    &matchlen, POS_SDP_HEADER) > 0) {
-
-		/* since ct_sip_get_info() give us a pointer passing 'v='
-		   we need to add 2 bytes in this count. */
-		int c_len = *datalen - matchoff + 2;
-
-		/* Now, update SDP length */
-		if (ct_sip_get_info(ct, *dptr, *datalen, &matchoff,
-				    &matchlen, POS_CONTENT) > 0) {
-
-			bufflen = sprintf(buffer, "%u", c_len);
-			return mangle_packet(skb, dptr, datalen,
-					     matchoff, matchlen,
-					     buffer, bufflen);
-		}
-	}
-	return 0;
+	if (ct_sip_get_sdp_header(ct, *dptr, 0, *datalen, type, SDP_HDR_UNSPEC,
+				  &matchoff, &matchlen) <= 0)
+		return 0;
+	return mangle_packet(skb, dptr, datalen, matchoff, matchlen,
+			     buffer, buflen);
 }
 
 static unsigned int mangle_sdp(struct sk_buff *skb,
@@ -205,18 +200,18 @@ static unsigned int mangle_sdp(struct sk_buff *skb,
 
 	/* Mangle owner and contact info. */
 	bufflen = sprintf(buffer, "%u.%u.%u.%u", NIPQUAD(newip));
-	if (!mangle_sip_packet(skb, dptr, datalen, buffer, bufflen,
-			       POS_OWNER_IP4))
+	if (!mangle_sdp_packet(skb, dptr, datalen, SDP_HDR_OWNER_IP4,
+			       buffer, bufflen))
 		return 0;
 
-	if (!mangle_sip_packet(skb, dptr, datalen, buffer, bufflen,
-			       POS_CONNECTION_IP4))
+	if (!mangle_sdp_packet(skb, dptr, datalen, SDP_HDR_CONNECTION_IP4,
+			       buffer, bufflen))
 		return 0;
 
 	/* Mangle media port. */
 	bufflen = sprintf(buffer, "%u", port);
-	if (!mangle_sip_packet(skb, dptr, datalen, buffer, bufflen,
-			       POS_MEDIA))
+	if (!mangle_sdp_packet(skb, dptr, datalen, SDP_HDR_MEDIA,
+			       buffer, bufflen))
 		return 0;
 
 	return mangle_content_len(skb, dptr, datalen);
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index cf19a70..801fcb3 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -124,66 +124,6 @@ static const struct sip_header_nfo ct_sip_hdrs[] = {
 		.ln_strlen	= sizeof(":") - 1,
 		.match_len	= skp_digits_len
 	},
-	[POS_MEDIA] = {		/* SDP media info */
-		.case_sensitive	= 1,
-		.lname		= "\nm=",
-		.lnlen		= sizeof("\nm=") - 1,
-		.sname		= "\rm=",
-		.snlen		= sizeof("\rm=") - 1,
-		.ln_str		= "audio ",
-		.ln_strlen	= sizeof("audio ") - 1,
-		.match_len	= digits_len
-	},
-	[POS_OWNER_IP4] = {	/* SDP owner address*/
-		.case_sensitive	= 1,
-		.lname		= "\no=",
-		.lnlen		= sizeof("\no=") - 1,
-		.sname		= "\ro=",
-		.snlen		= sizeof("\ro=") - 1,
-		.ln_str		= "IN IP4 ",
-		.ln_strlen	= sizeof("IN IP4 ") - 1,
-		.match_len	= epaddr_len
-	},
-	[POS_CONNECTION_IP4] = {/* SDP connection info */
-		.case_sensitive	= 1,
-		.lname		= "\nc=",
-		.lnlen		= sizeof("\nc=") - 1,
-		.sname		= "\rc=",
-		.snlen		= sizeof("\rc=") - 1,
-		.ln_str		= "IN IP4 ",
-		.ln_strlen	= sizeof("IN IP4 ") - 1,
-		.match_len	= epaddr_len
-	},
-	[POS_OWNER_IP6] = {	/* SDP owner address*/
-		.case_sensitive	= 1,
-		.lname		= "\no=",
-		.lnlen		= sizeof("\no=") - 1,
-		.sname		= "\ro=",
-		.snlen		= sizeof("\ro=") - 1,
-		.ln_str		= "IN IP6 ",
-		.ln_strlen	= sizeof("IN IP6 ") - 1,
-		.match_len	= epaddr_len
-	},
-	[POS_CONNECTION_IP6] = {/* SDP connection info */
-		.case_sensitive	= 1,
-		.lname		= "\nc=",
-		.lnlen		= sizeof("\nc=") - 1,
-		.sname		= "\rc=",
-		.snlen		= sizeof("\rc=") - 1,
-		.ln_str		= "IN IP6 ",
-		.ln_strlen	= sizeof("IN IP6 ") - 1,
-		.match_len	= epaddr_len
-	},
-	[POS_SDP_HEADER] = { 	/* SDP version header */
-		.case_sensitive	= 1,
-		.lname		= "\nv=",
-		.lnlen		= sizeof("\nv=") - 1,
-		.sname		= "\rv=",
-		.snlen		= sizeof("\rv=") - 1,
-		.ln_str		= "=",
-		.ln_strlen	= sizeof("=") - 1,
-		.match_len	= digits_len
-	}
 };
 
 /* get line length until first CR or LF seen. */
@@ -363,6 +303,92 @@ int ct_sip_get_info(const struct nf_conn *ct,
 }
 EXPORT_SYMBOL_GPL(ct_sip_get_info);
 
+/* SDP header parsing: a SDP session description contains an ordered set of
+ * headers, starting with a section containing general session parameters,
+ * optionally followed by multiple media descriptions.
+ *
+ * SDP headers always start at the beginning of a line. According to RFC 2327:
+ * "The sequence CRLF (0x0d0a) is used to end a record, although parsers should
+ * be tolerant and also accept records terminated with a single newline
+ * character". We handle both cases.
+ */
+static const struct sip_header ct_sdp_hdrs[] = {
+	[SDP_HDR_VERSION]		= SDP_HDR("v=", NULL, digits_len),
+	[SDP_HDR_OWNER_IP4]		= SDP_HDR("o=", "IN IP4 ", epaddr_len),
+	[SDP_HDR_CONNECTION_IP4]	= SDP_HDR("c=", "IN IP4 ", epaddr_len),
+	[SDP_HDR_OWNER_IP6]		= SDP_HDR("o=", "IN IP6 ", epaddr_len),
+	[SDP_HDR_CONNECTION_IP6]	= SDP_HDR("c=", "IN IP6 ", epaddr_len),
+	[SDP_HDR_MEDIA]			= SDP_HDR("m=", "audio ", digits_len),
+};
+
+/* Linear string search within SDP header values */
+static const char *ct_sdp_header_search(const char *dptr, const char *limit,
+					const char *needle, unsigned int len)
+{
+	for (limit -= len; dptr < limit; dptr++) {
+		if (*dptr == '\r' || *dptr == '\n')
+			break;
+		if (strncmp(dptr, needle, len) == 0)
+			return dptr;
+	}
+	return NULL;
+}
+
+/* Locate a SDP header (optionally a substring within the header value),
+ * optionally stopping at the first occurence of the term header, parse
+ * it and return the offset and length of the data we're interested in.
+ */
+int ct_sip_get_sdp_header(const struct nf_conn *ct, const char *dptr,
+			  unsigned int dataoff, unsigned int datalen,
+			  enum sdp_header_types type,
+			  enum sdp_header_types term,
+			  unsigned int *matchoff, unsigned int *matchlen)
+{
+	const struct sip_header *hdr = &ct_sdp_hdrs[type];
+	const struct sip_header *thdr = &ct_sdp_hdrs[term];
+	const char *start = dptr, *limit = dptr + datalen;
+	int shift = 0;
+
+	for (dptr += dataoff; dptr < limit; dptr++) {
+		/* Find beginning of line */
+		if (*dptr != '\r' && *dptr != '\n')
+			continue;
+		if (++dptr >= limit)
+			break;
+		if (*(dptr - 1) == '\r' && *dptr == '\n') {
+			if (++dptr >= limit)
+				break;
+		}
+
+		if (term != SDP_HDR_UNSPEC &&
+		    limit - dptr >= thdr->len &&
+		    strnicmp(dptr, thdr->name, thdr->len) == 0)
+			break;
+		else if (limit - dptr >= hdr->len &&
+			 strnicmp(dptr, hdr->name, hdr->len) == 0)
+			dptr += hdr->len;
+		else
+			continue;
+
+		*matchoff = dptr - start;
+		if (hdr->search) {
+			dptr = ct_sdp_header_search(dptr, limit, hdr->search,
+						    hdr->slen);
+			if (!dptr)
+				return -1;
+			dptr += hdr->slen;
+		}
+
+		*matchlen = hdr->match_len(ct, dptr, limit, &shift);
+		if (!*matchlen)
+			return -1;
+		*matchoff = dptr - start + shift;
+		return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ct_sip_get_sdp_header);
+
 static int set_expected_rtp(struct sk_buff *skb,
 			    const char **dptr, unsigned int *datalen,
 			    union nf_inet_addr *addr, __be16 port)
@@ -408,7 +434,7 @@ static int sip_help(struct sk_buff *skb,
 	int ret = NF_ACCEPT;
 	unsigned int matchoff, matchlen;
 	u_int16_t port;
-	enum sip_header_pos pos;
+	enum sdp_header_types type;
 	typeof(nf_nat_sip_hook) nf_nat_sip;
 
 	/* No Data ? */
@@ -446,8 +472,10 @@ static int sip_help(struct sk_buff *skb,
 		goto out;
 	}
 	/* Get address and port from SDP packet. */
-	pos = family == AF_INET ? POS_CONNECTION_IP4 : POS_CONNECTION_IP6;
-	if (ct_sip_get_info(ct, dptr, datalen, &matchoff, &matchlen, pos) > 0) {
+	type = family == AF_INET ? SDP_HDR_CONNECTION_IP4 :
+				   SDP_HDR_CONNECTION_IP6;
+	if (ct_sip_get_sdp_header(ct, dptr, 0, datalen, type, SDP_HDR_UNSPEC,
+				  &matchoff, &matchlen) > 0) {
 
 		/* We'll drop only if there are parse problems. */
 		if (!parse_addr(ct, dptr + matchoff, NULL, &addr,
@@ -455,8 +483,9 @@ static int sip_help(struct sk_buff *skb,
 			ret = NF_DROP;
 			goto out;
 		}
-		if (ct_sip_get_info(ct, dptr, datalen, &matchoff, &matchlen,
-				    POS_MEDIA) > 0) {
+		if (ct_sip_get_sdp_header(ct, dptr, 0, datalen,
+					  SDP_HDR_MEDIA, SDP_HDR_UNSPEC,
+					  &matchoff, &matchlen) > 0) {
 
 			port = simple_strtoul(dptr + matchoff, NULL, 10);
 			if (port < 1024) {
