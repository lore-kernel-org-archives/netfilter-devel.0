Received: from out-93wp-a34.jellyfish.systems (out-93wp-a34.jellyfish.systems [104.207.68.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED14634B40F
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 20:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.207.68.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790628556; cv=none; b=VUmu0UpVot8/wWghb+uYmDE2D66OFoQ9wRXPq3hcuLcgjpcW/nyKUVozvLA27jHr0iz11kBnEtVcSzv74E4oo76Txbv0m4CIE/W+U+kDoWcVOI4oHh1wOcIAZQnALrgDVzHMPXDjiINmwe8rrW4OdqC25SnlJWiMF2MBGrbpf74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790628556; c=relaxed/simple;
	bh=5M6QjMNqJvQSS95Jj03HrLnqtgFcgUhJ8JkDOGCqW+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBK5jadsuaG9TQY2MHjMQuUBNBj4ZHEbhdWQRTQNQm7eUx+GXEFGZ6/N8/SeybmsTWOSuXbVcFW6Tx1TIWFV/+rwl9o79WB1/oDOwu9vJ2F6B0UdAiVA0o+CgCvP7B6FWJcUrsqNu6v3Yit1DQxxdq4VfRJJ7MmfKZ+rraRjPf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=BC6Oxz8J reason="key not found in DNS"; arc=none smtp.client-ip=104.207.68.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="BC6Oxz8J"
Received: from research-box.ec2.internal (ec2-3-80-226-50.compute-1.amazonaws.com [3.80.226.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4htthL3ZfJz2x99;
	Mon, 28 Sep 2026 20:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1790628547;
	bh=bs/79qfpGoSWJ7Dn8JekcUQWRfZCEzCTzs3m2yBFoGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BC6Oxz8J2CLmyy1p/HSPa73gUsLDSk5ZrAASrByxCqxpnjJc7Nr8xKyccWYWiMC9G
	 WJx2xqK4D8JrwhXv58Oe7ESNrzCO8+QJW4H7Zj5BwlTvIPWcjBOCNO7TGnoV/qEl7o
	 4HsUfLJrA+x1Gu7YxbIfsNRxYlPPpOtUkGyFl7ec0/G83MMEYl+w7yTZLwkOEQBI7K
	 XNKfvxVeKDMKluQRlAm41Chwit/SSnprwUnvRxyZZBAXBT5mH/MeMojiIOVAq/PBZU
	 XySViyMW7m1chjiVWrC7PypL+dUX+tEFHaQC5DJFEi9MaK+klWDlXv2aTEUtL6mfy0
	 XaltVCHSIYTgA==
From: Rahul Chandelkar <rc@rexion.ai>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	Rahul Chandelkar <rc@rexion.ai>
Subject: [PATCH nf-next v5 4/4] netfilter: nf_conntrack_sip: use shared helper parsers
Date: Mon, 28 Sep 2026 20:49:05 +0000
Message-ID: <4c502fdf5a929e1dfd04f7b1be9e20cb19f54bfa.1790596690.git.rc@rexion.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1790596690.git.rc@rexion.ai>
References: <cover.1790596690.git.rc@rexion.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

nf_conntrack_sip has its own bounded integer parser, sip_strtouint(),
and its own digit loop in sip_parse_port().  Equivalent parsers now
live in the conntrack helper core, so drop the private copies:

  - sip_strtouint() is removed and its callers use
    nf_ct_helper_parse_uint(), which has the same body.  Call sites
    that no longer fit in 80 columns are rewrapped.

  - sip_parse_port() uses nf_ct_helper_parse_port() for the numeric
    part, keeping the SIP-specific handling of the ':' separator, the
    default SIP_PORT and the minimum port of 1024.  The shared parser
    rejects the same inputs as the old loop: no digits, more than five
    digits and values above 65535.

No functional change intended.  The old and new sip_parse_port(), taken
from the kernel source, were compared in a userspace harness on three
million random inputs with no difference in result, port or end
pointer.

Assisted-by: Claude-Code:claude-opus-5-5 sparse
Signed-off-by: Rahul Chandelkar <rc@rexion.ai>
---
 net/netfilter/nf_conntrack_sip.c | 93 +++++++++-----------------------
 1 file changed, 25 insertions(+), 68 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 64bc440b1181..1264e77720a8 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -183,8 +183,8 @@ static int sip_parse_addr(const struct nf_conn *ct, const char *cp,
 static bool sip_parse_port(const char *dptr, const char **endp,
 			   const char *limit, __be16 *port)
 {
-	unsigned int p = 0;
-	int len = 0;
+	char *end;
+	u16 p;
 
 	if (dptr >= limit)
 		return false;
@@ -199,29 +199,22 @@ static bool sip_parse_port(const char *dptr, const char **endp,
 
 	dptr++; /* skip ':' */
 
-	while (dptr < limit && isdigit(*dptr)) {
-		p = p * 10 + (*dptr - '0');
-		dptr++;
-		len++;
-		if (len > 5) /* max "65535" */
-			return false;
-	}
-
-	if (len == 0)
+	if (nf_ct_helper_parse_port(dptr, limit - dptr, &p, &end))
 		return false;
 
 	/* reached limit while parsing port */
-	if (dptr >= limit)
+	if (end >= limit)
 		return false;
 
-	if (p < 1024 || p > 65535)
+	/* SIP ports below 1024 are not accepted */
+	if (p < 1024)
 		return false;
 
 	if (port)
 		*port = htons(p);
 
 	if (endp)
-		*endp = dptr;
+		*endp = end;
 
 	return true;
 }
@@ -270,51 +263,6 @@ static int skp_epaddr_len(const struct nf_conn *ct, const char *dptr,
 	return epaddr_len(ct, dptr, limit, shift);
 }
 
-/* simple_strtoul stops after first non-number character.
- * But as we're not dealing with c-strings, we can't rely on
- * hitting \r,\n,\0 etc. before moving past end of buffer.
- *
- * This is a variant of simple_strtoul, but doesn't require
- * a c-string.
- *
- * If value exceeds UINT_MAX, 0 is returned.
- */
-static unsigned int sip_strtouint(const char *cp, unsigned int len, char **endp)
-{
-	const unsigned int max = sizeof("4294967295");
-	unsigned int olen = len;
-	const char *s = cp;
-	u64 result = 0;
-
-	if (len > max)
-		len = max;
-
-	while (olen > 0 && isdigit(*s)) {
-		unsigned int value;
-
-		if (len == 0)
-			goto err;
-
-		value = *s - '0';
-		result = result * 10 + value;
-
-		if (result > UINT_MAX)
-			goto err;
-		s++;
-		len--;
-		olen--;
-	}
-
-	if (endp)
-		*endp = (char *)s;
-
-	return result;
-err:
-	if (endp)
-		*endp = (char *)cp;
-	return 0;
-}
-
 /* Parse a SIP request line of the form:
  *
  * Request-Line = Method SP Request-URI SP SIP-Version CRLF
@@ -682,7 +630,7 @@ int ct_sip_parse_numerical_param(const struct nf_conn *ct, const char *dptr,
 		return 0;
 
 	start += strlen(name);
-	*val = sip_strtouint(start, limit - start, (char **)&end);
+	*val = nf_ct_helper_parse_uint(start, limit - start, (char **)&end);
 	if (start == end)
 		return -1;
 	if (matchoff && matchlen) {
@@ -1166,7 +1114,9 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
 		mediaoff += t->len;
 		medialen -= t->len;
 
-		port = sip_strtouint(*dptr + mediaoff, *datalen - mediaoff, (char **)&end);
+		port = nf_ct_helper_parse_uint(*dptr + mediaoff,
+					       *datalen - mediaoff,
+					       (char **)&end);
 		if (port == 0 || *dptr + mediaoff == end)
 			continue;
 		if (port < 1024 || port > 65535) {
@@ -1357,7 +1307,8 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 	 */
 	if (ct_sip_get_header(ct, *dptr, 0, *datalen, SIP_HDR_EXPIRES,
 			      &matchoff, &matchlen) > 0)
-		expires = sip_strtouint(*dptr + matchoff, *datalen - matchoff, NULL);
+		expires = nf_ct_helper_parse_uint(*dptr + matchoff,
+						  *datalen - matchoff, NULL);
 
 	ret = ct_sip_parse_header_uri(ct, *dptr, NULL, *datalen,
 				      SIP_HDR_CONTACT, NULL,
@@ -1467,7 +1418,8 @@ static int process_register_response(struct sk_buff *skb, unsigned int protoff,
 
 	if (ct_sip_get_header(ct, *dptr, 0, *datalen, SIP_HDR_EXPIRES,
 			      &matchoff, &matchlen) > 0)
-		expires = sip_strtouint(*dptr + matchoff, *datalen - matchoff, NULL);
+		expires = nf_ct_helper_parse_uint(*dptr + matchoff,
+						  *datalen - matchoff, NULL);
 
 	while (1) {
 		unsigned int c_expires = expires;
@@ -1531,8 +1483,8 @@ static int process_sip_response(struct sk_buff *skb, unsigned int protoff,
 
 	if (*datalen < strlen("SIP/2.0 200"))
 		return NF_ACCEPT;
-	code = sip_strtouint(*dptr + strlen("SIP/2.0 "),
-			     *datalen - strlen("SIP/2.0 "), NULL);
+	code = nf_ct_helper_parse_uint(*dptr + strlen("SIP/2.0 "),
+				       *datalen - strlen("SIP/2.0 "), NULL);
 	if (!code) {
 		nf_ct_helper_log(skb, ct, "cannot get code");
 		return NF_DROP;
@@ -1543,7 +1495,8 @@ static int process_sip_response(struct sk_buff *skb, unsigned int protoff,
 		nf_ct_helper_log(skb, ct, "cannot parse cseq");
 		return NF_DROP;
 	}
-	cseq = sip_strtouint(*dptr + matchoff, *datalen - matchoff, (char **)&end);
+	cseq = nf_ct_helper_parse_uint(*dptr + matchoff, *datalen - matchoff,
+				       (char **)&end);
 	if (*dptr + matchoff == end) {
 		nf_ct_helper_log(skb, ct, "cannot get cseq");
 		return NF_DROP;
@@ -1613,7 +1566,9 @@ static int process_sip_request(struct sk_buff *skb, unsigned int protoff,
 			nf_ct_helper_log(skb, ct, "cannot parse cseq");
 			return NF_DROP;
 		}
-		cseq = sip_strtouint(*dptr + matchoff, *datalen - matchoff, (char **)&end);
+		cseq = nf_ct_helper_parse_uint(*dptr + matchoff,
+					       *datalen - matchoff,
+					       (char **)&end);
 		if (*dptr + matchoff == end) {
 			nf_ct_helper_log(skb, ct, "cannot get cseq");
 			return NF_DROP;
@@ -1690,7 +1645,9 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
 				      &matchoff, &matchlen) <= 0)
 			break;
 
-		clen = sip_strtouint(dptr + matchoff, datalen - matchoff, (char **)&end);
+		clen = nf_ct_helper_parse_uint(dptr + matchoff,
+					       datalen - matchoff,
+					       (char **)&end);
 		if (dptr + matchoff == end)
 			break;
 
-- 
2.43.0

