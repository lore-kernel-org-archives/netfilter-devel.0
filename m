From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 15/32]: nf_conntrack_sip: kill request URI "header" definitions
Date: Thu, 28 Feb 2008 13:00:17 +0100 (MET)
Message-ID: <20080228120008.29267.45005.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49998 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270AbYB1MAS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:18 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: kill request URI "header" definitions

The request URI is not a header and needs to be treated differently than
real SIP headers. Add a seperate function for parsing it and get rid of
the POS_REQ_URI/POS_REG_REQ_URI definitions.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5c32e869153429dda7acaa55eb609138af7f6f01
tree 5d858f2c5cbfddef3739a2c7da68ef4d80406cc2
parent a29bdbd3963e34a5eea23c7136491a8b35cfb7a8
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:22 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:22 +0100

 include/linux/netfilter/nf_conntrack_sip.h |    5 +-
 net/ipv4/netfilter/nf_nat_sip.c            |   46 +++++++++++---------
 net/netfilter/nf_conntrack_sip.c           |   64 ++++++++++++++++++++++------
 3 files changed, 77 insertions(+), 38 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index 3aaf795..9b96e17 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -12,8 +12,6 @@ enum sip_expectation_classes {
 #define SIP_EXPECT_MAX	(__SIP_EXPECT_MAX - 1)
 
 enum sip_header_pos {
-	POS_REG_REQ_URI,
-	POS_REQ_URI,
 	POS_FROM,
 	POS_TO,
 	POS_VIA,
@@ -65,6 +63,9 @@ extern unsigned int (*nf_nat_sdp_hook)(struct sk_buff *skb,
 				       unsigned int *datalen,
 				       struct nf_conntrack_expect *exp);
 
+extern int ct_sip_parse_request(const struct nf_conn *ct,
+				const char *dptr, unsigned int datalen,
+				unsigned int *matchoff, unsigned int *matchlen);
 extern int ct_sip_get_info(const struct nf_conn *ct, const char *dptr,
                            size_t dlen, unsigned int *matchoff,
                            unsigned int *matchlen, enum sip_header_pos pos);
diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index aa8a4f4..60151b5 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -78,20 +78,17 @@ static unsigned int mangle_packet(struct sk_buff *skb,
 	return 1;
 }
 
-static int map_sip_addr(struct sk_buff *skb,
-			const char **dptr, unsigned int *datalen,
-			enum sip_header_pos pos, struct addr_map *map)
+static int map_addr(struct sk_buff *skb,
+		    const char **dptr, unsigned int *datalen,
+		    unsigned int matchoff, unsigned int matchlen,
+		    struct addr_map *map)
 {
 	enum ip_conntrack_info ctinfo;
-	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+	struct nf_conn *ct __maybe_unused = nf_ct_get(skb, &ctinfo);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-	unsigned int matchlen, matchoff, addrlen;
+	unsigned int addrlen;
 	char *addr;
 
-	if (ct_sip_get_info(ct, *dptr, *datalen, &matchoff, &matchlen,
-			    pos) <= 0)
-		return 1;
-
 	if ((matchlen == map->addr[dir].srciplen ||
 	     matchlen == map->addr[dir].srclen) &&
 	    strncmp(*dptr + matchoff, map->addr[dir].src, matchlen) == 0) {
@@ -109,13 +106,27 @@ static int map_sip_addr(struct sk_buff *skb,
 			     addr, addrlen);
 }
 
+static int map_sip_addr(struct sk_buff *skb,
+			const char **dptr, unsigned int *datalen,
+			enum sip_header_pos pos, struct addr_map *map)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+	unsigned int matchlen, matchoff;
+
+	if (ct_sip_get_info(ct, *dptr, *datalen, &matchoff, &matchlen,
+			    pos) <= 0)
+		return 1;
+	return map_addr(skb, dptr, datalen, matchoff, matchlen, map);
+}
+
 static unsigned int ip_nat_sip(struct sk_buff *skb,
 			       const char **dptr, unsigned int *datalen)
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
-	enum sip_header_pos pos;
 	struct addr_map map;
+	unsigned int matchoff, matchlen;
 
 	if (*datalen < strlen("SIP/2.0"))
 		return NF_ACCEPT;
@@ -124,18 +135,9 @@ static unsigned int ip_nat_sip(struct sk_buff *skb,
 
 	/* Basic rules: requests and responses. */
 	if (strnicmp(*dptr, "SIP/2.0", strlen("SIP/2.0")) != 0) {
-		/* 10.2: Constructing the REGISTER Request:
-		 *
-		 * The "userinfo" and "@" components of the SIP URI MUST NOT
-		 * be present.
-		 */
-		if (*datalen >= strlen("REGISTER") &&
-		    strnicmp(*dptr, "REGISTER", strlen("REGISTER")) == 0)
-			pos = POS_REG_REQ_URI;
-		else
-			pos = POS_REQ_URI;
-
-		if (!map_sip_addr(skb, dptr, datalen, pos, &map))
+		if (ct_sip_parse_request(ct, *dptr, *datalen,
+					 &matchoff, &matchlen) > 0 &&
+		    !map_addr(skb, dptr, datalen, matchoff, matchlen, &map))
 			return NF_DROP;
 	}
 
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index c204e35..d79a6fc 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -65,20 +65,6 @@ struct sip_header_nfo {
 };
 
 static const struct sip_header_nfo ct_sip_hdrs[] = {
-	[POS_REG_REQ_URI] = { 	/* SIP REGISTER request URI */
-		.lname		= "sip:",
-		.lnlen		= sizeof("sip:") - 1,
-		.ln_str		= ":",
-		.ln_strlen	= sizeof(":") - 1,
-		.match_len	= epaddr_len,
-	},
-	[POS_REQ_URI] = { 	/* SIP request URI */
-		.lname		= "sip:",
-		.lnlen		= sizeof("sip:") - 1,
-		.ln_str		= "@",
-		.ln_strlen	= sizeof("@") - 1,
-		.match_len	= epaddr_len,
-	},
 	[POS_FROM] = {		/* SIP From header */
 		.lname		= "From:",
 		.lnlen		= sizeof("From:") - 1,
@@ -164,6 +150,18 @@ const char *ct_sip_search(const char *needle, const char *haystack,
 }
 EXPORT_SYMBOL_GPL(ct_sip_search);
 
+static int string_len(const struct nf_conn *ct, const char *dptr,
+		      const char *limit, int *shift)
+{
+	int len = 0;
+
+	while (dptr < limit && isalpha(*dptr)) {
+		dptr++;
+		len++;
+	}
+	return len;
+}
+
 static int digits_len(const struct nf_conn *ct, const char *dptr,
 		      const char *limit, int *shift)
 {
@@ -267,6 +265,44 @@ static int skp_epaddr_len(const struct nf_conn *ct, const char *dptr,
 	return epaddr_len(ct, dptr, limit, shift);
 }
 
+/* Parse a SIP request line of the form:
+ *
+ * Request-Line = Method SP Request-URI SP SIP-Version CRLF
+ *
+ * and return the offset and length of the address contained in the Request-URI.
+ */
+int ct_sip_parse_request(const struct nf_conn *ct,
+			 const char *dptr, unsigned int datalen,
+			 unsigned int *matchoff, unsigned int *matchlen)
+{
+	const char *start = dptr, *limit = dptr + datalen;
+	unsigned int mlen;
+	int shift = 0;
+
+	/* Skip method and following whitespace */
+	mlen = string_len(ct, dptr, limit, NULL);
+	if (!mlen)
+		return 0;
+	dptr += mlen;
+	if (++dptr >= limit)
+		return 0;
+
+	/* Find SIP URI */
+	limit -= strlen("sip:");
+	for (; dptr < limit; dptr++) {
+		if (*dptr == '\r' || *dptr == '\n')
+			return -1;
+		if (strnicmp(dptr, "sip:", strlen("sip:")) == 0)
+			break;
+	}
+	*matchlen = skp_epaddr_len(ct, dptr, limit, &shift);
+	if (!*matchlen)
+		return 0;
+	*matchoff = dptr - start + shift;
+	return 1;
+}
+EXPORT_SYMBOL_GPL(ct_sip_parse_request);
+
 /* Returns 0 if not found, -1 error parsing. */
 int ct_sip_get_info(const struct nf_conn *ct,
 		    const char *dptr, size_t dlen,
