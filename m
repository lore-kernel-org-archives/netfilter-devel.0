Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D8A21B905;
	Thu, 16 Apr 2026 01:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776303073; cv=none; b=eBGatmiP9hU7kZP60tG2hFWU+AcJn2o8S/7fDPezD219IZ2yRADO3fXMa9YBhPFgOxQrq7INrEOM406/5MnmuOEvGaFRstf0jVeEReN3h4Y61GQqoLGTwsgAf/u5RgD8IVAt+bqaRiHWm+A9KHHJ0lQsaxYG+mFKl0IuovFaabo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776303073; c=relaxed/simple;
	bh=h9dzILytnraSyC4jJF1+qQRHVZdhYM7t0Dx8tdod588=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cQssngOSgshxodKC80AkIzhzl21b+unrri4AgblXjfeSIozREleMA8Gh32jD7l/O6bj5wHA2SwP9ZILJ+GsSx/WoeuHzkr5Cill31w47OAp4gig+7PgG32c44iGY/hV/1Uw4rpy4pkBD1+KqWFJEqNplVF88O0r0msd+upVSo18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vjthiwsb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vjthiwsb"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A0C1660180;
	Thu, 16 Apr 2026 03:31:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776303070;
	bh=eOKSVAkAUvqYwcEXVIlJ9lnNgAS+udtzZX7xRvXm5eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vjthiwsbOhu/Hig3/XgSqdPV1Mh11ZzuUFjoPc1VLtO+YP3MZlrX1gbBa/1EJdlXN
	 S4wITuwRYJCtIfK42YWWpfbSVNeZDioJUw/qQMbjRZdLPoFn+yZ7yMoS5/TkVe6q4N
	 3/fdQ33p9LFCOEYhdCPxyJyZ4rxEuKxeMiKiRHTeywgJEwW9b9bL77Y7ZOFpBgJC1L
	 zWkSjby37I+6YMvTsm6Cg4vKymw6v9KWGzpNLib3Ycp4IwyG9fWB4elp1S+mrj6kEy
	 dRdR9Y6CLtISQH9RLhdcZMab/d9m8x5bGwrxUaIRs2IluqRYsv8k8i4GPR61x7QiFG
	 lFZ6Qr9zXQ07Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 02/14] netfilter: nf_conntrack_sip: add bounds-checked port parsing helper
Date: Thu, 16 Apr 2026 03:30:49 +0200
Message-ID: <20260416013101.221555-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260416013101.221555-1-pablo@netfilter.org>
References: <20260416013101.221555-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jenny Guanni Qu <qguanni@gmail.com>

Replace unsafe port parsing in epaddr_len(), ct_sip_parse_header_uri(),
and ct_sip_parse_request() with a new sip_parse_port() helper that
validates each digit against the buffer limit, eliminating the use of
simple_strtoul() which assumes NUL-terminated strings.

The previous code dereferenced pointers without bounds checks after
sip_parse_addr() and relied on simple_strtoul() on non-NUL-terminated
skb data. A port that reaches the buffer limit without a trailing
character is also rejected as malformed.

Based on a suggestion by Florian Westphal.

[ fw@strlen.de: make port range check unconditional ]

Fixes: 05e3ced297fe ("[NETFILTER]: nf_conntrack_sip: introduce SIP-URI parsing helper")
Reported-by: Klaudia Kloc <klaudia@vidocsecurity.com>
Reported-by: Dawid Moczadło <dawid@vidocsecurity.com>
Suggested-by: Florian Westphal <fw@strlen.de>
Tested-by: Jenny Guanni Qu <qguanni@gmail.com>
Tested-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Jenny Guanni Qu <qguanni@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_sip.c | 80 +++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 939502ff7c87..38a55a3b3d19 100644
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
 
@@ -241,7 +289,6 @@ int ct_sip_parse_request(const struct nf_conn *ct,
 {
 	const char *start = dptr, *limit = dptr + datalen, *end;
 	unsigned int mlen;
-	unsigned int p;
 	int shift = 0;
 
 	/* Skip method and following whitespace */
@@ -267,14 +314,8 @@ int ct_sip_parse_request(const struct nf_conn *ct,
 
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
@@ -509,7 +550,6 @@ int ct_sip_parse_header_uri(const struct nf_conn *ct, const char *dptr,
 			    union nf_inet_addr *addr, __be16 *port)
 {
 	const char *c, *limit = dptr + datalen;
-	unsigned int p;
 	int ret;
 
 	ret = ct_sip_walk_headers(ct, dptr, dataoff ? *dataoff : 0, datalen,
@@ -520,14 +560,8 @@ int ct_sip_parse_header_uri(const struct nf_conn *ct, const char *dptr,
 
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
-- 
2.47.3

