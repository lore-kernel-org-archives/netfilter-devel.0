Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A043A1C861D
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2026 00:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776903566; cv=none; b=BYM2f0C8SmeNJbN9FfbFhck7KJ5uhfq889BZ+kbnTDjZvEdPRcShYKn9CcU3CZBvK1gWPE9qSjYu3eIVOVYnFya/MC0KhYUgiys0LtXGLevarFv+cocN3kd/UMbWz9FQJ4me80G7tWrrURMW2Ef4ibkktmN1mIwETbOnxoHdjPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776903566; c=relaxed/simple;
	bh=D/ATxCSnpLSF0a+6xu8rJyds86Y1suNQGi65Hdj3vNY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Sg9sdt0e6G4JuYJTrRUeC/BC4LebmEiSTs6kz8qBcoIYgADCYwapItFBJU3jFsDY+m9vqv1d9VDTFGvilBoRGAGKZJU1YjHJI53DVpXJpvnDSqP3K6DD++CPC51C5AJVyXbHzYcHfOp4LJLHmT7MVr9OcLKeJm+vE07YYSDqMBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0AB53606C8; Thu, 23 Apr 2026 02:19:22 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf v3] netfilter: nf_conntrack_sip: don't use simple_strtoul
Date: Thu, 23 Apr 2026 02:19:11 +0200
Message-ID: <20260423001915.22838-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Replace unsafe port parsing in epaddr_len(), ct_sip_parse_header_uri(),
and ct_sip_parse_request() with a new sip_parse_port() helper that
validates each digit against the buffer limit, eliminating the use of
simple_strtoul() which assumes NUL-terminated strings.

The previous code dereferenced pointers without bounds checks after
sip_parse_addr() and relied on simple_strtoul() on non-NUL-terminated
skb data. A port that reaches the buffer limit without a trailing
character is also rejected as malformed.

Also get rid of all simple_strtoul() usage in conntrack, prefer a
stricter version instead.  There are intentional changes:

- Bail out if number is > UINT_MAX and indicate a failure, same for
  too long sequences.
  While we do accept 05535 as port 5535, we will not accept e.g.
  'sip:10.0.0.1:005060'.  While its syntactically valid under RFC 3261,
  we should restrict this to not waste cycles when presented with
  malformed packets with 64k '0' characters.

- Force base 10 in ct_sip_parse_numerical_param(). This is used to fetch
  'expire=' and 'rports='; both are expected to use base-10.

- In nf_nat_sip.c, only accept the parsed value if its within the 1k-64k
  range.

- epaddr_len now returns 0 if the port is invalid, as it already does
  for invalid ip addresses.  This is intentional. nf_conntrack_sip
  performs lots of guesswork to find the right parts of the message
  to parse.  Being stricter could break existing setups.
  Connection tracking helpers are designed to allow traffic to
  pass, not to block it.

Based on an earlier patch from Jenny Guanni Qu <qguanni@gmail.com>.

Fixes: 05e3ced297fe ("[NETFILTER]: nf_conntrack_sip: introduce SIP-URI parsing helper")
Reported-by: Klaudia Kloc <klaudia@vidocsecurity.com>
Reported-by: Dawid Moczadło <dawid@vidocsecurity.com>
Reported-by: Jenny Guanni Qu <qguanni@gmail.com>.
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v3: too many inflight patches and I lose sight of the local
 branches: Fix the strlen() bug *again*.
 Replace '!seq && *(*dptr + matchoff) != '0'
 with a test on dptr == end to detect unparseable cseq.
 I do not plan to address other AI results, I do not want
 to mangle this parser more than necessary.
 In particular this patch should not muck with parsing
 of expiry or alter control flow too much.
 If anyting it should be done in a distinct patch.

 net/netfilter/nf_conntrack_sip.c | 152 ++++++++++++++++++++++++-------
 net/netfilter/nf_nat_sip.c       |   1 +
 2 files changed, 119 insertions(+), 34 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 182cfb119448..1eb55907d470 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -181,6 +181,57 @@ static int sip_parse_addr(const struct nf_conn *ct, const char *cp,
 	return 1;
 }
 
+/* Parse optional port number after IP address.
+ * Returns false on malformed input, true otherwise.
+ * If port is non-NULL, stores parsed port in network byte order.
+ * If no port is present, sets *port to default SIP port.
+ */
+static bool sip_parse_port(const char *dptr, const char **endp,
+			   const char *limit, __be16 *port)
+{
+	unsigned int p = 0;
+	int len = 0;
+
+	if (dptr >= limit)
+		return false;
+
+	if (*dptr != ':') {
+		if (port)
+			*port = htons(SIP_PORT);
+		if (endp)
+			*endp = dptr;
+		return true;
+	}
+
+	dptr++; /* skip ':' */
+
+	while (dptr < limit && isdigit(*dptr)) {
+		p = p * 10 + (*dptr - '0');
+		dptr++;
+		len++;
+		if (len > 5) /* max "65535" */
+			return false;
+	}
+
+	if (len == 0)
+		return false;
+
+	/* reached limit while parsing port */
+	if (dptr >= limit)
+		return false;
+
+	if (p < 1024 || p > 65535)
+		return false;
+
+	if (port)
+		*port = htons(p);
+
+	if (endp)
+		*endp = dptr;
+
+	return true;
+}
+
 /* skip ip address. returns its length. */
 static int epaddr_len(const struct nf_conn *ct, const char *dptr,
 		      const char *limit, int *shift)
@@ -193,11 +244,8 @@ static int epaddr_len(const struct nf_conn *ct, const char *dptr,
 		return 0;
 	}
 
-	/* Port number */
-	if (*dptr == ':') {
-		dptr++;
-		dptr += digits_len(ct, dptr, limit, shift);
-	}
+	if (!sip_parse_port(dptr, &dptr, limit, NULL))
+		return 0;
 	return dptr - aux;
 }
 
@@ -228,6 +276,51 @@ static int skp_epaddr_len(const struct nf_conn *ct, const char *dptr,
 	return epaddr_len(ct, dptr, limit, shift);
 }
 
+/* simple_strtoul stops after first non-number character.
+ * But as we're not dealing with c-strings, we can't rely on
+ * hitting \r,\n,\0 etc. before moving past end of buffer.
+ *
+ * This is a variant of simple_strtoul, but doesn't require
+ * a c-string.
+ *
+ * If value exceeds UINT_MAX, 0 is returned.
+ */
+static unsigned int sip_strtouint(const char *cp, unsigned int len, char **endp)
+{
+	const unsigned int max = sizeof("4294967295");
+	unsigned int olen = len;
+	const char *s = cp;
+	u64 result = 0;
+
+	if (len > max)
+		len = max;
+
+	while (olen > 0 && isdigit(*s)) {
+		unsigned int value;
+
+		if (len == 0)
+			goto err;
+
+		value = *s - '0';
+		result = result * 10 + value;
+
+		if (result > UINT_MAX)
+			goto err;
+		s++;
+		len--;
+		olen--;
+	}
+
+	if (endp)
+		*endp = (char *)s;
+
+	return result;
+err:
+	if (endp)
+		*endp = (char *)cp;
+	return 0;
+}
+
 /* Parse a SIP request line of the form:
  *
  * Request-Line = Method SP Request-URI SP SIP-Version CRLF
@@ -241,7 +334,6 @@ int ct_sip_parse_request(const struct nf_conn *ct,
 {
 	const char *start = dptr, *limit = dptr + datalen, *end;
 	unsigned int mlen;
-	unsigned int p;
 	int shift = 0;
 
 	/* Skip method and following whitespace */
@@ -267,14 +359,8 @@ int ct_sip_parse_request(const struct nf_conn *ct,
 
 	if (!sip_parse_addr(ct, dptr, &end, addr, limit, true))
 		return -1;
-	if (end < limit && *end == ':') {
-		end++;
-		p = simple_strtoul(end, (char **)&end, 10);
-		if (p < 1024 || p > 65535)
-			return -1;
-		*port = htons(p);
-	} else
-		*port = htons(SIP_PORT);
+	if (!sip_parse_port(end, &end, limit, port))
+		return -1;
 
 	if (end == dptr)
 		return 0;
@@ -509,7 +595,6 @@ int ct_sip_parse_header_uri(const struct nf_conn *ct, const char *dptr,
 			    union nf_inet_addr *addr, __be16 *port)
 {
 	const char *c, *limit = dptr + datalen;
-	unsigned int p;
 	int ret;
 
 	ret = ct_sip_walk_headers(ct, dptr, dataoff ? *dataoff : 0, datalen,
@@ -520,14 +605,8 @@ int ct_sip_parse_header_uri(const struct nf_conn *ct, const char *dptr,
 
 	if (!sip_parse_addr(ct, dptr + *matchoff, &c, addr, limit, true))
 		return -1;
-	if (*c == ':') {
-		c++;
-		p = simple_strtoul(c, (char **)&c, 10);
-		if (p < 1024 || p > 65535)
-			return -1;
-		*port = htons(p);
-	} else
-		*port = htons(SIP_PORT);
+	if (!sip_parse_port(c, &c, limit, port))
+		return -1;
 
 	if (dataoff)
 		*dataoff = c - dptr;
@@ -609,7 +688,7 @@ int ct_sip_parse_numerical_param(const struct nf_conn *ct, const char *dptr,
 		return 0;
 
 	start += strlen(name);
-	*val = simple_strtoul(start, &end, 0);
+	*val = sip_strtouint(start, limit - start, (char **)&end);
 	if (start == end)
 		return -1;
 	if (matchoff && matchlen) {
@@ -1064,6 +1143,8 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
 
 	mediaoff = sdpoff;
 	for (i = 0; i < ARRAY_SIZE(sdp_media_types); ) {
+		char *end;
+
 		if (ct_sip_get_sdp_header(ct, *dptr, mediaoff, *datalen,
 					  SDP_HDR_MEDIA, SDP_HDR_UNSPEC,
 					  &mediaoff, &medialen) <= 0)
@@ -1079,8 +1160,8 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
 		mediaoff += t->len;
 		medialen -= t->len;
 
-		port = simple_strtoul(*dptr + mediaoff, NULL, 10);
-		if (port == 0)
+		port = sip_strtouint(*dptr + mediaoff, *datalen - mediaoff, (char **)&end);
+		if (port == 0 || *dptr + mediaoff == end)
 			continue;
 		if (port < 1024 || port > 65535) {
 			nf_ct_helper_log(skb, ct, "wrong port %u", port);
@@ -1254,7 +1335,7 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 	 */
 	if (ct_sip_get_header(ct, *dptr, 0, *datalen, SIP_HDR_EXPIRES,
 			      &matchoff, &matchlen) > 0)
-		expires = simple_strtoul(*dptr + matchoff, NULL, 10);
+		expires = sip_strtouint(*dptr + matchoff, *datalen - matchoff, NULL);
 
 	ret = ct_sip_parse_header_uri(ct, *dptr, NULL, *datalen,
 				      SIP_HDR_CONTACT, NULL,
@@ -1358,7 +1439,7 @@ static int process_register_response(struct sk_buff *skb, unsigned int protoff,
 
 	if (ct_sip_get_header(ct, *dptr, 0, *datalen, SIP_HDR_EXPIRES,
 			      &matchoff, &matchlen) > 0)
-		expires = simple_strtoul(*dptr + matchoff, NULL, 10);
+		expires = sip_strtouint(*dptr + matchoff, *datalen - matchoff, NULL);
 
 	while (1) {
 		unsigned int c_expires = expires;
@@ -1418,10 +1499,12 @@ static int process_sip_response(struct sk_buff *skb, unsigned int protoff,
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	unsigned int matchoff, matchlen, matchend;
 	unsigned int code, cseq, i;
+	char *end;
 
 	if (*datalen < strlen("SIP/2.0 200"))
 		return NF_ACCEPT;
-	code = simple_strtoul(*dptr + strlen("SIP/2.0 "), NULL, 10);
+	code = sip_strtouint(*dptr + strlen("SIP/2.0 "),
+			     *datalen - strlen("SIP/2.0 "), NULL);
 	if (!code) {
 		nf_ct_helper_log(skb, ct, "cannot get code");
 		return NF_DROP;
@@ -1432,8 +1515,8 @@ static int process_sip_response(struct sk_buff *skb, unsigned int protoff,
 		nf_ct_helper_log(skb, ct, "cannot parse cseq");
 		return NF_DROP;
 	}
-	cseq = simple_strtoul(*dptr + matchoff, NULL, 10);
-	if (!cseq && *(*dptr + matchoff) != '0') {
+	cseq = sip_strtouint(*dptr + matchoff, *datalen - matchoff, (char **)&end);
+	if (*dptr + matchoff == end) {
 		nf_ct_helper_log(skb, ct, "cannot get cseq");
 		return NF_DROP;
 	}
@@ -1482,6 +1565,7 @@ static int process_sip_request(struct sk_buff *skb, unsigned int protoff,
 
 	for (i = 0; i < ARRAY_SIZE(sip_handlers); i++) {
 		const struct sip_handler *handler;
+		char *end;
 
 		handler = &sip_handlers[i];
 		if (handler->request == NULL)
@@ -1498,8 +1582,8 @@ static int process_sip_request(struct sk_buff *skb, unsigned int protoff,
 			nf_ct_helper_log(skb, ct, "cannot parse cseq");
 			return NF_DROP;
 		}
-		cseq = simple_strtoul(*dptr + matchoff, NULL, 10);
-		if (!cseq && *(*dptr + matchoff) != '0') {
+		cseq = sip_strtouint(*dptr + matchoff, *datalen - matchoff, (char **)&end);
+		if (*dptr + matchoff == end) {
 			nf_ct_helper_log(skb, ct, "cannot get cseq");
 			return NF_DROP;
 		}
@@ -1575,7 +1659,7 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
 				      &matchoff, &matchlen) <= 0)
 			break;
 
-		clen = simple_strtoul(dptr + matchoff, (char **)&end, 10);
+		clen = sip_strtouint(dptr + matchoff, datalen - matchoff, (char **)&end);
 		if (dptr + matchoff == end)
 			break;
 
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index c845b6d1a2bd..9fbfc6bff0c2 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -246,6 +246,7 @@ static unsigned int nf_nat_sip(struct sk_buff *skb, unsigned int protoff,
 		if (ct_sip_parse_numerical_param(ct, *dptr, matchend, *datalen,
 						 "rport=", &poff, &plen,
 						 &n) > 0 &&
+		    n >= 1024 && n <= 65535 &&
 		    htons(n) == ct->tuplehash[dir].tuple.dst.u.udp.port &&
 		    htons(n) != ct->tuplehash[!dir].tuple.src.u.udp.port) {
 			__be16 p = ct->tuplehash[!dir].tuple.src.u.udp.port;
-- 
2.53.0

