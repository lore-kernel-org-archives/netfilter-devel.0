From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 15/32]: nf_conntrack_sip: parse SIP headers properly
Date: Tue, 25 Mar 2008 15:15:11 +0100 (MET)
Message-ID: <20080325141511.10539.44360.sendpatchset@localhost.localdomain>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32937 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbYCYOPN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:15:13 -0400
In-Reply-To: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: parse SIP headers properly

Introduce new function for SIP header parsing that properly deals with
continuation lines and whitespace in headers and use it.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0b864cf59cb6bfb74677aa9c631b7c8df53016a2
tree fa5dc291dbd565fc7167a3e2415e54f3aecdfd04
parent 6b8ae4462dcdaf5c0e28ea5750f391efb738fab1
author Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 12:45:00 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 14:09:55 +0100

 include/linux/netfilter/nf_conntrack_sip.h |   30 ++-
 net/ipv4/netfilter/nf_nat_sip.c            |   18 +-
 net/netfilter/nf_conntrack_sip.c           |  271 +++++++++++++---------------
 3 files changed, 151 insertions(+), 168 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index 480b26f..ccc7014 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -5,14 +5,6 @@
 #define SIP_PORT	5060
 #define SIP_TIMEOUT	3600
 
-enum sip_header_pos {
-	POS_FROM,
-	POS_TO,
-	POS_VIA,
-	POS_CONTACT,
-	POS_CONTENT,
-};
-
 struct sip_header {
 	const char	*name;
 	const char	*cname;
@@ -36,9 +28,20 @@ struct sip_header {
 	.match_len	= (__match),					\
 }
 
+#define SIP_HDR(__name, __cname, __search, __match) \
+	__SIP_HDR(__name, __cname, __search, __match)
+
 #define SDP_HDR(__name, __search, __match) \
 	__SIP_HDR(__name, NULL, __search, __match)
 
+enum sip_header_types {
+	SIP_HDR_FROM,
+	SIP_HDR_TO,
+	SIP_HDR_CONTACT,
+	SIP_HDR_VIA,
+	SIP_HDR_CONTENT_LENGTH,
+};
+
 enum sdp_header_types {
 	SDP_HDR_UNSPEC,
 	SDP_HDR_VERSION,
@@ -60,13 +63,10 @@ extern unsigned int (*nf_nat_sdp_hook)(struct sk_buff *skb,
 extern int ct_sip_parse_request(const struct nf_conn *ct,
 				const char *dptr, unsigned int datalen,
 				unsigned int *matchoff, unsigned int *matchlen);
-extern int ct_sip_get_info(const struct nf_conn *ct, const char *dptr,
-                           size_t dlen, unsigned int *matchoff,
-                           unsigned int *matchlen, enum sip_header_pos pos);
-extern int ct_sip_lnlen(const char *line, const char *limit);
-extern const char *ct_sip_search(const char *needle, const char *haystack,
-				 size_t needle_len, size_t haystack_len,
-				 int case_sensitive);
+extern int ct_sip_get_header(const struct nf_conn *ct, const char *dptr,
+			     unsigned int dataoff, unsigned int datalen,
+			     enum sip_header_types type,
+			     unsigned int *matchoff, unsigned int *matchlen);
 
 extern int ct_sip_get_sdp_header(const struct nf_conn *ct, const char *dptr,
 				 unsigned int dataoff, unsigned int datalen,
diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index 60151b5..c13e438 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -108,14 +108,14 @@ static int map_addr(struct sk_buff *skb,
 
 static int map_sip_addr(struct sk_buff *skb,
 			const char **dptr, unsigned int *datalen,
-			enum sip_header_pos pos, struct addr_map *map)
+			enum sip_header_types type, struct addr_map *map)
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	unsigned int matchlen, matchoff;
 
-	if (ct_sip_get_info(ct, *dptr, *datalen, &matchoff, &matchlen,
-			    pos) <= 0)
+	if (ct_sip_get_header(ct, *dptr, 0, *datalen, type,
+			      &matchoff, &matchlen) <= 0)
 		return 1;
 	return map_addr(skb, dptr, datalen, matchoff, matchlen, map);
 }
@@ -141,10 +141,10 @@ static unsigned int ip_nat_sip(struct sk_buff *skb,
 			return NF_DROP;
 	}
 
-	if (!map_sip_addr(skb, dptr, datalen, POS_FROM, &map) ||
-	    !map_sip_addr(skb, dptr, datalen, POS_TO, &map) ||
-	    !map_sip_addr(skb, dptr, datalen, POS_VIA, &map) ||
-	    !map_sip_addr(skb, dptr, datalen, POS_CONTACT, &map))
+	if (!map_sip_addr(skb, dptr, datalen, SIP_HDR_FROM, &map) ||
+	    !map_sip_addr(skb, dptr, datalen, SIP_HDR_TO, &map) ||
+	    !map_sip_addr(skb, dptr, datalen, SIP_HDR_VIA, &map) ||
+	    !map_sip_addr(skb, dptr, datalen, SIP_HDR_CONTACT, &map))
 		return NF_DROP;
 	return NF_ACCEPT;
 }
@@ -166,8 +166,8 @@ static int mangle_content_len(struct sk_buff *skb,
 	c_len = *datalen - matchoff + strlen("v=");
 
 	/* Now, update SDP length */
-	if (ct_sip_get_info(ct, *dptr, *datalen, &matchoff, &matchlen,
-			    POS_CONTENT) <= 0)
+	if (ct_sip_get_header(ct, *dptr, 0, *datalen, SIP_HDR_CONTENT_LENGTH,
+			      &matchoff, &matchlen) <= 0)
 		return 0;
 
 	buflen = sprintf(buffer, "%u", c_len);
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index bb43961..cbc9159 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -47,109 +47,6 @@ unsigned int (*nf_nat_sdp_hook)(struct sk_buff *skb,
 				struct nf_conntrack_expect *exp) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_sdp_hook);
 
-static int digits_len(const struct nf_conn *, const char *, const char *, int *);
-static int epaddr_len(const struct nf_conn *, const char *, const char *, int *);
-static int skp_digits_len(const struct nf_conn *, const char *, const char *, int *);
-static int skp_epaddr_len(const struct nf_conn *, const char *, const char *, int *);
-
-struct sip_header_nfo {
-	const char	*lname;
-	const char	*sname;
-	const char	*ln_str;
-	size_t		lnlen;
-	size_t		snlen;
-	size_t		ln_strlen;
-	int		case_sensitive;
-	int		(*match_len)(const struct nf_conn *, const char *,
-				     const char *, int *);
-};
-
-static const struct sip_header_nfo ct_sip_hdrs[] = {
-	[POS_FROM] = {		/* SIP From header */
-		.lname		= "From:",
-		.lnlen		= sizeof("From:") - 1,
-		.sname		= "\r\nf:",
-		.snlen		= sizeof("\r\nf:") - 1,
-		.ln_str		= "sip:",
-		.ln_strlen	= sizeof("sip:") - 1,
-		.match_len	= skp_epaddr_len,
-	},
-	[POS_TO] = {		/* SIP To header */
-		.lname		= "To:",
-		.lnlen		= sizeof("To:") - 1,
-		.sname		= "\r\nt:",
-		.snlen		= sizeof("\r\nt:") - 1,
-		.ln_str		= "sip:",
-		.ln_strlen	= sizeof("sip:") - 1,
-		.match_len	= skp_epaddr_len
-	},
-	[POS_VIA] = { 		/* SIP Via header */
-		.lname		= "Via:",
-		.lnlen		= sizeof("Via:") - 1,
-		.sname		= "\r\nv:",
-		.snlen		= sizeof("\r\nv:") - 1, /* rfc3261 "\r\n" */
-		.ln_str		= "UDP ",
-		.ln_strlen	= sizeof("UDP ") - 1,
-		.match_len	= epaddr_len,
-	},
-	[POS_CONTACT] = { 	/* SIP Contact header */
-		.lname		= "Contact:",
-		.lnlen		= sizeof("Contact:") - 1,
-		.sname		= "\r\nm:",
-		.snlen		= sizeof("\r\nm:") - 1,
-		.ln_str		= "sip:",
-		.ln_strlen	= sizeof("sip:") - 1,
-		.match_len	= skp_epaddr_len
-	},
-	[POS_CONTENT] = { 	/* SIP Content length header */
-		.lname		= "Content-Length:",
-		.lnlen		= sizeof("Content-Length:") - 1,
-		.sname		= "\r\nl:",
-		.snlen		= sizeof("\r\nl:") - 1,
-		.ln_str		= ":",
-		.ln_strlen	= sizeof(":") - 1,
-		.match_len	= skp_digits_len
-	},
-};
-
-/* get line length until first CR or LF seen. */
-int ct_sip_lnlen(const char *line, const char *limit)
-{
-	const char *k = line;
-
-	while ((line < limit) && (*line == '\r' || *line == '\n'))
-		line++;
-
-	while (line < limit) {
-		if (*line == '\r' || *line == '\n')
-			break;
-		line++;
-	}
-	return line - k;
-}
-EXPORT_SYMBOL_GPL(ct_sip_lnlen);
-
-/* Linear string search, case sensitive. */
-const char *ct_sip_search(const char *needle, const char *haystack,
-			  size_t needle_len, size_t haystack_len,
-			  int case_sensitive)
-{
-	const char *limit = haystack + (haystack_len - needle_len);
-
-	while (haystack < limit) {
-		if (case_sensitive) {
-			if (strncmp(haystack, needle, needle_len) == 0)
-				return haystack;
-		} else {
-			if (strnicmp(haystack, needle, needle_len) == 0)
-				return haystack;
-		}
-		haystack++;
-	}
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(ct_sip_search);
-
 static int string_len(const struct nf_conn *ct, const char *dptr,
 		      const char *limit, int *shift)
 {
@@ -173,16 +70,6 @@ static int digits_len(const struct nf_conn *ct, const char *dptr,
 	return len;
 }
 
-/* get digits length, skipping blank spaces. */
-static int skp_digits_len(const struct nf_conn *ct, const char *dptr,
-			  const char *limit, int *shift)
-{
-	for (; dptr < limit && *dptr == ' '; dptr++)
-		(*shift)++;
-
-	return digits_len(ct, dptr, limit, shift);
-}
-
 static int parse_addr(const struct nf_conn *ct, const char *cp,
                       const char **endp, union nf_inet_addr *addr,
                       const char *limit)
@@ -294,50 +181,146 @@ int ct_sip_parse_request(const struct nf_conn *ct,
 }
 EXPORT_SYMBOL_GPL(ct_sip_parse_request);
 
-/* Returns 0 if not found, -1 error parsing. */
-int ct_sip_get_info(const struct nf_conn *ct,
-		    const char *dptr, size_t dlen,
-		    unsigned int *matchoff,
-		    unsigned int *matchlen,
-		    enum sip_header_pos pos)
+/* SIP header parsing: SIP headers are located at the beginning of a line, but
+ * may span several lines, in which case the continuation lines begin with a
+ * whitespace character. RFC 2543 allows lines to be terminated with CR, LF or
+ * CRLF, RFC 3261 allows only CRLF, we support both.
+ *
+ * Headers are followed by (optionally) whitespace, a colon, again (optionally)
+ * whitespace and the values. Whitespace in this context means any amount of
+ * tabs, spaces and continuation lines, which are treated as a single whitespace
+ * character.
+ */
+static const struct sip_header ct_sip_hdrs[] = {
+	[SIP_HDR_FROM]			= SIP_HDR("From", "f", "sip:", skp_epaddr_len),
+	[SIP_HDR_TO]			= SIP_HDR("To", "t", "sip:", skp_epaddr_len),
+	[SIP_HDR_CONTACT]		= SIP_HDR("Contact", "m", "sip:", skp_epaddr_len),
+	[SIP_HDR_VIA]			= SIP_HDR("Via", "v", "UDP ", epaddr_len),
+	[SIP_HDR_CONTENT_LENGTH]	= SIP_HDR("Content-Length", "l", NULL, digits_len),
+};
+
+static const char *sip_follow_continuation(const char *dptr, const char *limit)
 {
-	const struct sip_header_nfo *hnfo = &ct_sip_hdrs[pos];
-	const char *limit, *aux, *k = dptr;
-	int shift = 0;
+	/* Walk past newline */
+	if (++dptr >= limit)
+		return NULL;
+
+	/* Skip '\n' in CR LF */
+	if (*(dptr - 1) == '\r' && *dptr == '\n') {
+		if (++dptr >= limit)
+			return NULL;
+	}
+
+	/* Continuation line? */
+	if (*dptr != ' ' && *dptr != '\t')
+		return NULL;
+
+	/* skip leading whitespace */
+	for (; dptr < limit; dptr++) {
+		if (*dptr != ' ' && *dptr != '\t')
+			break;
+	}
+	return dptr;
+}
+
+static const char *sip_skip_whitespace(const char *dptr, const char *limit)
+{
+	for (; dptr < limit; dptr++) {
+		if (*dptr == ' ')
+			continue;
+		if (*dptr != '\r' && *dptr != '\n')
+			break;
+		dptr = sip_follow_continuation(dptr, limit);
+		if (dptr == NULL)
+			return NULL;
+	}
+	return dptr;
+}
 
-	limit = dptr + (dlen - hnfo->lnlen);
+/* Search within a SIP header value, dealing with continuation lines */
+static const char *ct_sip_header_search(const char *dptr, const char *limit,
+					const char *needle, unsigned int len)
+{
+	for (limit -= len; dptr < limit; dptr++) {
+		if (*dptr == '\r' || *dptr == '\n') {
+			dptr = sip_follow_continuation(dptr, limit);
+			if (dptr == NULL)
+				break;
+			continue;
+		}
 
-	while (dptr < limit) {
-		if ((strncmp(dptr, hnfo->lname, hnfo->lnlen) != 0) &&
-		    (hnfo->sname == NULL ||
-		     strncmp(dptr, hnfo->sname, hnfo->snlen) != 0)) {
-			dptr++;
+		if (strnicmp(dptr, needle, len) == 0)
+			return dptr;
+	}
+	return NULL;
+}
+
+int ct_sip_get_header(const struct nf_conn *ct, const char *dptr,
+		      unsigned int dataoff, unsigned int datalen,
+		      enum sip_header_types type,
+		      unsigned int *matchoff, unsigned int *matchlen)
+{
+	const struct sip_header *hdr = &ct_sip_hdrs[type];
+	const char *start = dptr, *limit = dptr + datalen;
+	int shift = 0;
+
+	for (dptr += dataoff; dptr < limit; dptr++) {
+		/* Find beginning of line */
+		if (*dptr != '\r' && *dptr != '\n')
 			continue;
+		if (++dptr >= limit)
+			break;
+		if (*(dptr - 1) == '\r' && *dptr == '\n') {
+			if (++dptr >= limit)
+				break;
 		}
-		aux = ct_sip_search(hnfo->ln_str, dptr, hnfo->ln_strlen,
-				    ct_sip_lnlen(dptr, limit),
-				    hnfo->case_sensitive);
-		if (!aux) {
-			pr_debug("'%s' not found in '%s'.\n", hnfo->ln_str,
-				 hnfo->lname);
-			return -1;
+
+		/* Skip continuation lines */
+		if (*dptr == ' ' || *dptr == '\t')
+			continue;
+
+		/* Find header. Compact headers must be followed by a
+		 * non-alphabetic character to avoid mismatches. */
+		if (limit - dptr >= hdr->len &&
+		    strnicmp(dptr, hdr->name, hdr->len) == 0)
+			dptr += hdr->len;
+		else if (hdr->cname && limit - dptr >= hdr->clen + 1 &&
+			 strnicmp(dptr, hdr->cname, hdr->clen) == 0 &&
+			 !isalpha(*(dptr + hdr->clen + 1)))
+			dptr += hdr->clen;
+		else
+			continue;
+
+		/* Find and skip colon */
+		dptr = sip_skip_whitespace(dptr, limit);
+		if (dptr == NULL)
+			break;
+		if (*dptr != ':' || ++dptr >= limit)
+			break;
+
+		/* Skip whitespace after colon */
+		dptr = sip_skip_whitespace(dptr, limit);
+		if (dptr == NULL)
+			break;
+
+		*matchoff = dptr - start;
+		if (hdr->search) {
+			dptr = ct_sip_header_search(dptr, limit, hdr->search,
+						    hdr->slen);
+			if (!dptr)
+				return -1;
+			dptr += hdr->slen;
 		}
-		aux += hnfo->ln_strlen;
 
-		*matchlen = hnfo->match_len(ct, aux, limit, &shift);
+		*matchlen = hdr->match_len(ct, dptr, limit, &shift);
 		if (!*matchlen)
 			return -1;
-
-		*matchoff = (aux - k) + shift;
-
-		pr_debug("%s match succeeded! - len: %u\n", hnfo->lname,
-			 *matchlen);
+		*matchoff = dptr - start + shift;
 		return 1;
 	}
-	pr_debug("%s header not found.\n", hnfo->lname);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(ct_sip_get_info);
+EXPORT_SYMBOL_GPL(ct_sip_get_header);
 
 /* SDP header parsing: a SDP session description contains an ordered set of
  * headers, starting with a section containing general session parameters,
