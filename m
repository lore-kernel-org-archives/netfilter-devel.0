Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF99320B7EE
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Apr 2025 15:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743522045; cv=none; b=UC7TCQyWgPGF3yBUq06w11YrDXUlSZJv0wBhT5KWaTKHhKrKm6Z3ajwSk2hghfSwOcGfhobhyZwQS0gb9TInllyGKr2KWSgd6EooMNvgAQusPdEQxMq/NYRkKXdXUsUQgZNb+Oh0x3a2ouEWcNamnrwIbIkrCT1133bAW6r5ZiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743522045; c=relaxed/simple;
	bh=obbI6WhjDrpKvuaX/tPlpVRp4JJK2O7u7Dy314Nj45E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=H6NSQKmjxOGiL4T1UyucavEEtoQ8TTGy0w0Z87IFzifMx/R4VyCJAlNZA8HGutlWRBAfxJ1ZMjWSZNm0o1ee7Ka01UWvqvZvwy+GQEq0ID1nmboPwrkR5w1DIsUOc8zxQ2sO0rVnoKyijhlMG9JbuQJYZbUKGFZBrWpjpYuToSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TJu8Ahgf; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eEEi1fij; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TJu8Ahgf";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eEEi1fij"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0F0CC6039F; Tue,  1 Apr 2025 17:40:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743522040;
	bh=ofegZdM7ANwqr+Yvvqn6szbDrqvzAoPiVUA2tCBlxqw=;
	h=From:To:Cc:Subject:Date:From;
	b=TJu8AhgfSUKmkdD+Q0AXhro73sks+XIuBsxBaT56JHN6OMEGg9cEXwhN/fvEAj0L3
	 iFZTDIkMZ5T1XI4dA/tjxSgJ8kGOZFF1o8Snn6bVtIvrNzPJVhZBZ1etab1JMujoFD
	 v2pSkKN4TG4RYVtdPeiHItyFALimUn3QqEw+DLNfHFWyqiEmDPnZadxvvhsYHUKxyF
	 KNzOd0AcJ+UzVUmKLrMU6yuSH7GY9B84stAbwaKIklrqYhyhwBN4vKyBpugexnNreV
	 qzXCrPGqOaC14n+aWbWdXvKL8l5UUJJqNWh2lhlKdug7qswdpgy3Q+PuCicHNM/UUd
	 gH1s7aekeAo6Q==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 662B16039F;
	Tue,  1 Apr 2025 17:40:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743522039;
	bh=ofegZdM7ANwqr+Yvvqn6szbDrqvzAoPiVUA2tCBlxqw=;
	h=From:To:Cc:Subject:Date:From;
	b=eEEi1fij8K9HJwDAXXTm7d3trBpm/Re3OhzDIWdxPAuXJCXw2gicJpTLyfG1C0j/9
	 3WMOGdlq1vtBGSf6PxtsU15yUlxMXKnclg0tB0GXQf71M5761J2HQk9L4Lio/0Szjl
	 S9XcHBRFc1sYY9dc2KQbRyARQOB7hUwpdo8D68zJrwbAaBaJs8kArWLNGbmpKzqc8O
	 NJKI0aP0NQotqlwrYRhGQI16Z/aj+r1MDqQxr28SF3xeAODEoH4p68Xly8igGImCFf
	 UNA5iALqnSUQmJQSRaD+DVwSPbMR9Hetl7FnwBDUOAIB2wCpNviA877IdR4CZwIGYc
	 f4kGK1T675hvw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft] cache: prevent possible crash rule filter is NULL
Date: Tue,  1 Apr 2025 17:40:35 +0200
Message-Id: <20250401154035.1314871-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar to 3f0a47f9f00c ("cache: don't crash when filter is NULL").

No real crash observed but it is good to tigthen this.

Fixes: dbff26bfba83 ("cache: consolidate reset command")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index b75a5bf3283c..52f7c9abd741 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -714,6 +714,7 @@ static int rule_cache_dump(struct netlink_ctx *ctx, const struct handle *h,
 	const char *chain = NULL;
 	uint64_t rule_handle = 0;
 	int family = h->family;
+	bool reset = false;
 	bool dump = true;
 
 	if (filter) {
@@ -727,11 +728,12 @@ static int rule_cache_dump(struct netlink_ctx *ctx, const struct handle *h,
 		}
 		if (filter->list.family)
 			family = filter->list.family;
+
+		reset = filter->reset.rule;
 	}
 
 	rule_cache = mnl_nft_rule_dump(ctx, family,
-				       table, chain, rule_handle, dump,
-				       filter->reset.rule);
+				       table, chain, rule_handle, dump, reset);
 	if (rule_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
-- 
2.30.2

