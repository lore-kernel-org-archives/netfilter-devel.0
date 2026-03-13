Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E411E1C02
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Mar 2026 19:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773431580; cv=none; b=UJ8CIhY2317bcFOaz6WkonLW6FoS6C4BUruYRjSOxN21JgR+a0pMXGVuPGb+gYXh/IA+ef8NUyc8cxwIQZFxm3U9KEfCdN7Iba4zoQDndugEhfC/qjUoSIXHGEEWlXsQFMFn/H9i8k2Ft1oxYI2EE3AtwFCY7gK1a/+NADzfMH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773431580; c=relaxed/simple;
	bh=sZibJWE0HCqTUkIBkF0n6W5X0JjQhRSFWDZywKQo9cI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=mS0i26WfNMcgArWPXnAy4EwdkkZEIf8qggZSbukBCB/AftGMcCNsjFz3tOAOOfHyCjufhg/KJwypuCbIYQQgBMkouQGVrStjuXWunEtx5Ij4kq332Fz0JFUDyVjmHH7mupekXqUCvkakl3ZQqj6smiFc6Zl/x6IK7diisFZom8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AbCYRTVa; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AbCYRTVa"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-506bcb23a78so21417431cf.3
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Mar 2026 12:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773431577; x=1774036377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tg7D+p+O+2maaF7jwWb/fy7d1h+QUd3PiYZbn8v4whU=;
        b=AbCYRTVa+a9zQIiPVa+TcpblD2NHN8xZ+aLnAkKNe8jCZoTRig4kMbjD42leFaW6IA
         RRvVnzfc7v5LLXIlLPus/EPoUhE4Q3Ie8B7QIFGdySwH4evC0U8IYrLqE3bZZ0+XnRuO
         NMMw9bGnS04DyrfZ9BakTuKk7feilkjSRA3zBUwd8XckuxRxjjNnRvQvaUOzIn0pTtaq
         O9vyI5+To0VgBKevaC3jJsnHfVvfmZqeDc8t0uQB9mlcWCNoRALBz1iMgGv3kQPVsza3
         iP3xtBRWBjmPzhY736VGrxrP60eBv66hNRNboXK3SqLCe+w6BrcEbvm09YEb23Ou85Vw
         1hmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773431577; x=1774036377;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tg7D+p+O+2maaF7jwWb/fy7d1h+QUd3PiYZbn8v4whU=;
        b=RBqU7BYUS2FZitsqqF2slKtCmqGqq4F18+zzUcLLJVK/7SjCVQBa/ppXfI/oIJiER1
         ToISOWKBCOzcSwfaPcvCqOcls/0WqPtmoFsxlOQbPLTLEQ+RWpt9mTVjGSnsDxJbOzDr
         7JJUf7AW5CAEBDYJSOshBSGe8UIalamG1cqIgv7StsN85ebz6Q7itLxdSxvDOpSfan5L
         G2rECmmY6/o2+DYAmRx5SRV5jiWcQ+9W02rAyxnASMAzJz7THwdmge7KziEkGWKyEC9u
         5hJgqnP7lHIFCz1uLQpJyXk58CHRvq+kEVOj7OfpeWol5Fih6V+7CKzyMh6TAG+kKffj
         Fw5A==
X-Gm-Message-State: AOJu0YxHRJ3w6brrpIHnKfD2hnYKOh4CNZ7kDo5RwZ3YlXdPrNt08lv1
	WNc3+Z3bIXKLk2QUMVFpPz5UQGEp8/d9r3483uo8K6wAkOQbUAOJL4g/
X-Gm-Gg: ATEYQzz2LGsW8uTEdTY/mZnrSNpiRHaz1yWzRBidrc2jrW9V9WR99rdv2uqh9N3pK6I
	TxGJqDwUa4Ty0rZk4GK55udyufotTIQwS4SP3nr7H0AnGhe7MFL2GD1E1EQSc4GnHN5Vao+sUCF
	dfhyTbsTdZVgpVUVO12PEKJRixYoUaRNHfHjFcssfbYqij/KMtCc2cXjNKIoaWZNSKOPR2N9h+Y
	FSYzWGzXeYrtVjZvUe2OtfRXnJwrU9Fs6mwTzQvF2HqX+CkrL9YEvoyJf39PTpPa+L1zpBuQsMp
	/Z0UtEafWX3aO8M5aVDypYeyiqUKc4DdfRTIiydmhqZZ0JNfeSIyLWMjjZ9O0/jK7A8JnHY01ur
	cTOuAv9zbsMaE8w/OTNaAfX0GIrNpXJ/gjY7arZ4beSyNOOPizsTM72xH9WUFhLd0H1whWC81N0
	9Mk7n/paFvHafokadGzz/2ubxWFNM/+hBf/RYwCg1tY90I
X-Received: by 2002:ac8:5703:0:b0:509:1579:7c3b with SMTP id d75a77b69052e-50957e1b5f7mr57344381cf.51.1773431576786;
        Fri, 13 Mar 2026 12:52:56 -0700 (PDT)
Received: from 192-222-50-213.ll.local ([192.222.50.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5093a14725fsm60605541cf.32.2026.03.13.12.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 12:52:56 -0700 (PDT)
From: Jenny Guanni Qu <qguanni@gmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org
Cc: netfilter-devel@vger.kernel.org,
	fw@strlen.de,
	klaudia@vidocsecurity.com,
	dawid@vidocsecurity.com,
	Jenny Guanni Qu <qguanni@gmail.com>
Subject: [PATCH v2] netfilter: nf_conntrack_sip: add bounds-checked port parsing helper
Date: Fri, 13 Mar 2026 19:52:56 +0000
Message-Id: <20260313195256.2783257-1-qguanni@gmail.com>
X-Mailer: git-send-email 2.34.1
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

Based on a suggestion by Florian Westphal.

Fixes: 05e3ced297fe ("[NETFILTER]: nf_conntrack_sip: introduce SIP-URI parsing helper")
Reported-by: Klaudia Kloc <klaudia@vidocsecurity.com>
Reported-by: Dawid Moczadło <dawid@vidocsecurity.com>
Suggested-by: Florian Westphal <fw@strlen.de>
Tested-by: Jenny Guanni Qu <qguanni@gmail.com>
Signed-off-by: Jenny Guanni Qu <qguanni@gmail.com>
---
 net/netfilter/nf_conntrack_sip.c | 80 +++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index d0eac27f6ba0..00ecb5df5b5d 100644
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
+	if (port) {
+		if (p < 1024 || p > 65535)
+			return false;
+		*port = htons(p);
+	}
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
2.34.1

