Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792763924;
	b=PsBwRZIMnjZr2yW7ru2qiDfToTzl1tlgWLu3e5CMDBlaUhSgOjySeHB/veBJBf04kz4y
	 /MG08qr2AKE4zom0Vs1TvwjN0pI2fJh3igcFm/Dm64RGXveu42utzPNOdtGvN8J7KuWH0
	 iCrPvNW9CeQ7K+EKzo/+Qg8GnRzMflg0oqpjCdL8aBZhxlKPbMqaEfwBWOekOxrWdhKA5
	 hRgB1hXisKfnQLcrCFl+m4j0QP2k7nFyEiNy66lv2MYhJzM5iC7LcWQhoF8JA7jhELuNo
	 JcqQJBOz2Ji6NgnatzgjmQUJwuTEIr4uSo5a++kIYcQePYBncZyW6jE2Wd2NiYYyV3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792763924;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=YPxBi3Vqxd3Ic6ZcIhyuXJVsyxzhS7zl20HxoI3pRO8=;
	b=nMDPIkLZ/tI3wkJ6gAMSXkXqxWZZPoRTj9wBGwVGL/41bJUViSsq/Of7Uc8gCd8Fgqmt
	 UQUYxSnYrbms38h5TCiRoto30Xrbn9GSsvj7sGtsRZHuQcqbVAEoK4kRrT0EZh3xNVNOn
	 JuUZDoEuJfOE8q0WA5lc3Ucqvfk5PsNqDMOgkBEKAGiMZxFoom3tgdqhC+ecHG6rolAaS
	 1sWgnKk24I0QRYKkYRZl2uA5iBSWHV9tLxuvT0ob3j2CR8icJ0BGotYgwohrYdL1xsMSO
	 2T9s0L6LUqh/GF8PT8dNnv7vmEveKmqfA+mViwImhZ8CCl/WSTJrxO9Sg6HOezVNxEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31650606A31A
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 13:58:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31650606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9B1C960796; Fri, 23 Oct 2026 15:58:42 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 6/7] src: utils: keep old name if strndup fails
Date: Fri, 23 Oct 2026 15:58:05 +0200
Message-ID: <20261023135806.7259-7-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261023135806.7259-1-fw@strlen.de>
References: <20261023135806.7259-1-fw@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

LLM finding: flag/pointer state inconsistency on allocation failure.

In practice, strndup should never fail for any realistic scenario, however,
its clearly a bug.

Free old value after allocation succeded, not before.

nftnl_parse_str_attr has the same issue, delegate to the fixed function
instead of open-coding.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/utils.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/src/utils.c b/src/utils.c
index bbe44b4d532d..ec15f9bc8646 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -139,13 +139,15 @@ void __noreturn __abi_breakage(const char *file, int line, const char *reason)
 int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
 		       uint16_t attr, const void *data, uint32_t data_len)
 {
-	if (*flags & (1 << attr))
-		xfree(*dptr);
+	char *new = strndup(data, data_len);
 
-	*dptr = strndup(data, data_len);
-	if (!*dptr)
+	if (!new)
 		return -1;
 
+	if (*flags & (1 << attr))
+		xfree(*dptr);
+
+	*dptr = new;
 	*flags |= (1 << attr);
 	return 0;
 }
@@ -196,14 +198,14 @@ char *nftnl_attr_get_ifname(const struct nlattr *attr)
 int nftnl_parse_str_attr(const struct nlattr *tb, int attr,
 			 const char **field, uint32_t *flags)
 {
+	const char *s;
+	uint32_t len;
+
 	if (!tb)
 		return 0;
 
-	if (*flags & (1 << attr))
-		xfree(*field);
-	*field = strdup(mnl_attr_get_str(tb));
-	if (!*field)
-		return -1;
-	*flags |= (1 << attr);
-	return 0;
+	len = mnl_attr_get_payload_len(tb);
+	s = mnl_attr_get_str(tb);
+
+	return nftnl_set_str_attr(field, flags, attr, s, len);
 }
-- 
2.55.0

