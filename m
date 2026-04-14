Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A04D2773F7
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 17:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776186852; cv=none; b=sxUDTSj4OAh6d20s4GqTws9xCmPhPM+mlLDjzdUoi6bVE/JE4bSHOOhSb0ke0qAlT6GLtjrKOBOgNZkAbO+jab11yePDWkHk/cIUr3+2HSnqHmsYMUNzTUMACkXTFE8HJyb+g3wVKxP1Tu6AjIae54AAPuSZHWsjPnniV3UognE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776186852; c=relaxed/simple;
	bh=pVk+bUqDXOHWJDOkoGosU4C74QU7W88WC3KXlxYwuTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ux1MHLDVR9/kELqJmnYzoZq0CIEKGd+UyqycULM0lc6TOBwyX3GudGkftl0Ym3PiFoLwxexi4Pn8STYadh8dlpinq/GhfDF6zdzxWJG7fkQpWqBG7JUXMPiahDpA8QQc6EolCFM0UUqRzQtYJuDNWjPRS1LryPB3uUsU7m7rXt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DEC7E608DB; Tue, 14 Apr 2026 19:14:09 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/2] netfilter: nf_conntrack_sip: don't use strtoul_simple
Date: Tue, 14 Apr 2026 19:13:47 +0200
Message-ID: <20260414171351.31212-2-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260414171351.31212-1-fw@strlen.de>
References: <20260414171351.31212-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Probably 'safe' because struct shinfo is stored at end of linear data area
and simple_strotul bails out on first character thats not a number.

Prefer a stricter version instead.  There are intentional changes:

- Bail out if number is > UINT_MAX and indicate a failure.
  We don't expect huge values here.

- Bail out if we get more characters than expected, we don't expect
  something like 'expires=9999999999999999999999999999999999'.

- In ct_sip_parse_numerical_param() base 10 is enforced. This is used
  to fetch 'expire=' and 'rports='; both are expected to be base-10 values.

- In nf_nat_sip.c, only accept the parsed value if its within the 1k-64k
  range.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Could be deferred to nf-next, but given we're in merge window I think nf is fine.

 net/netfilter/nf_conntrack_sip.c | 73 ++++++++++++++++++++++++++------
 net/netfilter/nf_nat_sip.c       |  1 +
 2 files changed, 62 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 939502ff7c87..02c65415f309 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -228,6 +228,51 @@ static int skp_epaddr_len(const struct nf_conn *ct, const char *dptr,
 	return epaddr_len(ct, dptr, limit, shift);
 }
 
+/* simple_stroul stops after first non-number character.
+ * But as we're not dealing with c-strings, we can't rely on
+ * hitting \r,\n,\0 etc. before moving past end of buffer.
+ *
+ * This is a variant of simple_stroul, but doesn't require
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
@@ -269,7 +314,7 @@ int ct_sip_parse_request(const struct nf_conn *ct,
 		return -1;
 	if (end < limit && *end == ':') {
 		end++;
-		p = simple_strtoul(end, (char **)&end, 10);
+		p = sip_strtouint(end, limit - end, (char **)&end);
 		if (p < 1024 || p > 65535)
 			return -1;
 		*port = htons(p);
@@ -522,7 +567,7 @@ int ct_sip_parse_header_uri(const struct nf_conn *ct, const char *dptr,
 		return -1;
 	if (*c == ':') {
 		c++;
-		p = simple_strtoul(c, (char **)&c, 10);
+		p = sip_strtouint(c, limit - c, (char **)&c);
 		if (p < 1024 || p > 65535)
 			return -1;
 		*port = htons(p);
@@ -609,7 +654,7 @@ int ct_sip_parse_numerical_param(const struct nf_conn *ct, const char *dptr,
 		return 0;
 
 	start += strlen(name);
-	*val = simple_strtoul(start, &end, 0);
+	*val = sip_strtouint(start, limit - start, (char **)&end);
 	if (start == end)
 		return -1;
 	if (matchoff && matchlen) {
@@ -1065,6 +1110,8 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
 
 	mediaoff = sdpoff;
 	for (i = 0; i < ARRAY_SIZE(sdp_media_types); ) {
+		char *end;
+
 		if (ct_sip_get_sdp_header(ct, *dptr, mediaoff, *datalen,
 					  SDP_HDR_MEDIA, SDP_HDR_UNSPEC,
 					  &mediaoff, &medialen) <= 0)
@@ -1080,8 +1127,8 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
 		mediaoff += t->len;
 		medialen -= t->len;
 
-		port = simple_strtoul(*dptr + mediaoff, NULL, 10);
-		if (port == 0)
+		port = sip_strtouint(*dptr + mediaoff, *datalen - mediaoff, (char **)&end);
+		if (port == 0 || *dptr + mediaoff == end)
 			continue;
 		if (port < 1024 || port > 65535) {
 			nf_ct_helper_log(skb, ct, "wrong port %u", port);
@@ -1255,7 +1302,7 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 	 */
 	if (ct_sip_get_header(ct, *dptr, 0, *datalen, SIP_HDR_EXPIRES,
 			      &matchoff, &matchlen) > 0)
-		expires = simple_strtoul(*dptr + matchoff, NULL, 10);
+		expires = sip_strtouint(*dptr + matchoff, *datalen - matchoff, NULL);
 
 	ret = ct_sip_parse_header_uri(ct, *dptr, NULL, *datalen,
 				      SIP_HDR_CONTACT, NULL,
@@ -1359,7 +1406,7 @@ static int process_register_response(struct sk_buff *skb, unsigned int protoff,
 
 	if (ct_sip_get_header(ct, *dptr, 0, *datalen, SIP_HDR_EXPIRES,
 			      &matchoff, &matchlen) > 0)
-		expires = simple_strtoul(*dptr + matchoff, NULL, 10);
+		expires = sip_strtouint(*dptr + matchoff, *datalen - matchoff, NULL);
 
 	while (1) {
 		unsigned int c_expires = expires;
@@ -1422,7 +1469,8 @@ static int process_sip_response(struct sk_buff *skb, unsigned int protoff,
 
 	if (*datalen < strlen("SIP/2.0 200"))
 		return NF_ACCEPT;
-	code = simple_strtoul(*dptr + strlen("SIP/2.0 "), NULL, 10);
+	code = sip_strtouint(*dptr + strlen("SIP/2.0 "),
+			     *datalen - strlen("SIP/2.0"), NULL);
 	if (!code) {
 		nf_ct_helper_log(skb, ct, "cannot get code");
 		return NF_DROP;
@@ -1433,7 +1481,7 @@ static int process_sip_response(struct sk_buff *skb, unsigned int protoff,
 		nf_ct_helper_log(skb, ct, "cannot parse cseq");
 		return NF_DROP;
 	}
-	cseq = simple_strtoul(*dptr + matchoff, NULL, 10);
+	cseq = sip_strtouint(*dptr + matchoff, *datalen - matchoff, NULL);
 	if (!cseq && *(*dptr + matchoff) != '0') {
 		nf_ct_helper_log(skb, ct, "cannot get cseq");
 		return NF_DROP;
@@ -1483,6 +1531,7 @@ static int process_sip_request(struct sk_buff *skb, unsigned int protoff,
 
 	for (i = 0; i < ARRAY_SIZE(sip_handlers); i++) {
 		const struct sip_handler *handler;
+		char *end;
 
 		handler = &sip_handlers[i];
 		if (handler->request == NULL)
@@ -1499,8 +1548,8 @@ static int process_sip_request(struct sk_buff *skb, unsigned int protoff,
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
@@ -1576,7 +1625,7 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
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
2.52.0

