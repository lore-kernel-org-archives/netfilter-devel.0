Received: from out-2uec-a118.jellyfish.systems (out-2uec-a118.jellyfish.systems [63.250.43.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C4C36B92D
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 17:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.250.43.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790183722; cv=none; b=kz5JgVz2U5IdiVK3+yioOdhOqeJO90lEpxdn646/r0yjfM1VUAOFPqQV3c20AysnL9CZJeFTYlFQiYuLr8TA8Cv1Zfh/nTGApLCEcTri5ynA/MGjDsR7+o+h9IZ5zWarYS3VKDw0rHMe/PnFgvnYF04tMEda+n/DiyatUH4W0Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790183722; c=relaxed/simple;
	bh=+yAObyg9AjPPHU0YWZS9QF6DR36gmQbDBSAXhaVXN70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrROhkQdKhiX2/9AQC/C6xgXYU+hQPH0l7E8XhmXkHnU2RKCNKWGK1owBxSDeUpBb9AGswv9CEZsWnFbdO/2lZlfgVGL7b96RTbExdUaEbIJwzKEFWJ70j8gYDJI21+U92h2T/urqST5HP869g/qR373HZ+oiPKlngwnTZUHX9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=LAcvf41B reason="key not found in DNS"; arc=none smtp.client-ip=63.250.43.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="LAcvf41B"
Received: from research-box.ec2.internal (ec2-3-80-226-50.compute-1.amazonaws.com [3.80.226.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hqk9d73PYz8sWw;
	Wed, 23 Sep 2026 17:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1790183703;
	bh=HaQLWqTSErHKY3W1YmD+/JWmiBIitU4a23n6Bxbj3LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LAcvf41Bynije6rsV+60ZzzlYrN4MIMAWHI9hrqwBM5K3c2Ofubnv2iMw3qHwE5uf
	 f85YRi3N5I7IYZJk8rKrTcbMrGzxMBUCn3vXre5PXA6jwXfdIFjI9dw5YIbElYGHlW
	 PdhtW17yLnkdpV/FSG2HJyCaqr7u19zPsTfGaIFdhUdnS/Ulx8WhlE0MrwuZKA5ig1
	 zTiDCN0xudClzF2g1Ozy25lq8p/ONXO3+ffGncK4Hd4m2MhG2vENVD9qWeBHs8Cl5k
	 4ypAsDpJcCDUGBM6wpRmzrhnH1PWty+7Bm5iXVC6a0P6i9VAEDje1t/he5KHD8LA0w
	 ay4cyURZZ0Rrg==
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
Subject: [PATCH nf-next v4 4/4] netfilter: nf_conntrack_sip: use shared helper parsers
Date: Wed, 23 Sep 2026 17:15:01 +0000
Message-ID: <20260923171501.3254823-1-rc@rexion.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260923091608.2617604-1-rc@rexion.ai>
References: <20260923091608.2617604-1-rc@rexion.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

nf_conntrack_sip open-coded its own bounded integer parser
(sip_strtouint()) and its own digit loop in sip_parse_port().  Now that
equivalent parsers live in the conntrack helper core, drop the private
copies:

  - sip_strtouint() is replaced by nf_ct_helper_parse_uint() (same
    signature and semantics) at all call sites and removed.

  - sip_parse_port() uses nf_ct_helper_parse_port() for the numeric part,
    keeping the SIP-specific handling of the ':' separator, the default
    SIP_PORT and the minimum port of 1024.

No functional change intended.

Signed-off-by: Rahul Chandelkar <rc@rexion.ai>
---
 net/netfilter/nf_conntrack_sip.c | 86 +++++++-------------------------
 1 file changed, 18 insertions(+), 68 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 64bc440b1181..0e12426227a8 100644
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
@@ -1166,7 +1114,8 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
 		mediaoff += t->len;
 		medialen -= t->len;
 
-		port = sip_strtouint(*dptr + mediaoff, *datalen - mediaoff, (char **)&end);
+		port = nf_ct_helper_parse_uint(*dptr + mediaoff, *datalen - mediaoff,
+					       (char **)&end);
 		if (port == 0 || *dptr + mediaoff == end)
 			continue;
 		if (port < 1024 || port > 65535) {
@@ -1357,7 +1306,7 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 	 */
 	if (ct_sip_get_header(ct, *dptr, 0, *datalen, SIP_HDR_EXPIRES,
 			      &matchoff, &matchlen) > 0)
-		expires = sip_strtouint(*dptr + matchoff, *datalen - matchoff, NULL);
+		expires = nf_ct_helper_parse_uint(*dptr + matchoff, *datalen - matchoff, NULL);
 
 	ret = ct_sip_parse_header_uri(ct, *dptr, NULL, *datalen,
 				      SIP_HDR_CONTACT, NULL,
@@ -1467,7 +1416,7 @@ static int process_register_response(struct sk_buff *skb, unsigned int protoff,
 
 	if (ct_sip_get_header(ct, *dptr, 0, *datalen, SIP_HDR_EXPIRES,
 			      &matchoff, &matchlen) > 0)
-		expires = sip_strtouint(*dptr + matchoff, *datalen - matchoff, NULL);
+		expires = nf_ct_helper_parse_uint(*dptr + matchoff, *datalen - matchoff, NULL);
 
 	while (1) {
 		unsigned int c_expires = expires;
@@ -1531,8 +1480,8 @@ static int process_sip_response(struct sk_buff *skb, unsigned int protoff,
 
 	if (*datalen < strlen("SIP/2.0 200"))
 		return NF_ACCEPT;
-	code = sip_strtouint(*dptr + strlen("SIP/2.0 "),
-			     *datalen - strlen("SIP/2.0 "), NULL);
+	code = nf_ct_helper_parse_uint(*dptr + strlen("SIP/2.0 "),
+				       *datalen - strlen("SIP/2.0 "), NULL);
 	if (!code) {
 		nf_ct_helper_log(skb, ct, "cannot get code");
 		return NF_DROP;
@@ -1543,7 +1492,7 @@ static int process_sip_response(struct sk_buff *skb, unsigned int protoff,
 		nf_ct_helper_log(skb, ct, "cannot parse cseq");
 		return NF_DROP;
 	}
-	cseq = sip_strtouint(*dptr + matchoff, *datalen - matchoff, (char **)&end);
+	cseq = nf_ct_helper_parse_uint(*dptr + matchoff, *datalen - matchoff, (char **)&end);
 	if (*dptr + matchoff == end) {
 		nf_ct_helper_log(skb, ct, "cannot get cseq");
 		return NF_DROP;
@@ -1613,7 +1562,8 @@ static int process_sip_request(struct sk_buff *skb, unsigned int protoff,
 			nf_ct_helper_log(skb, ct, "cannot parse cseq");
 			return NF_DROP;
 		}
-		cseq = sip_strtouint(*dptr + matchoff, *datalen - matchoff, (char **)&end);
+		cseq = nf_ct_helper_parse_uint(*dptr + matchoff, *datalen - matchoff,
+					       (char **)&end);
 		if (*dptr + matchoff == end) {
 			nf_ct_helper_log(skb, ct, "cannot get cseq");
 			return NF_DROP;
@@ -1690,7 +1640,7 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
 				      &matchoff, &matchlen) <= 0)
 			break;
 
-		clen = sip_strtouint(dptr + matchoff, datalen - matchoff, (char **)&end);
+		clen = nf_ct_helper_parse_uint(dptr + matchoff, datalen - matchoff, (char **)&end);
 		if (dptr + matchoff == end)
 			break;
 
-- 
2.43.0

