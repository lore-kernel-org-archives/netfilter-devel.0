Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97C73C871D
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 22:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792105033; cv=none; b=pD/6koXp79r4fAaC8djg70Ax3MpTRI8/VLBYkobDdq1rn1sQZmvojOcC+PlTINFbbUHxxCNH281Jg6sF+nqOepQ7A9G/DssQyHZOizjp5yZ1BWe4rwoei2RVA0/DTPOLLxUozggTUaWmcCrUUP/QTlrXRKS1pxJRj745aHwncWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792105033; c=relaxed/simple;
	bh=J9GfIl53l2esS6SI34y/N08YUl4A4Og2U7V1EDeSoYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAHrKk46V5fX9z/OLZjyrgE5Zbd1ucF2OBgh/Fd8boWFNl0fInsbFncXIJE+cW6hfNhsN8FEDeUwhZqKDwbGwzHF4l8cFNnr1+iRUZWeAoq7k0jui9sorUQqdHrb4wWYfQVd1vkOGEeQ7vUcZYbsAfTtvQVWs2esIyCF42elmXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bs8HmEhz; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bs8HmEhz"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93e635220b4so569423685a.1
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 15:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792105029; x=1792709829; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/YhvPX63WhKZhARuu1HmFY4xNJMDfXUK6E12n5qI6pw=;
        b=Bs8HmEhzN9+qHOaffGf5mZ8opg4ukFiLvPP3gqe4IpEqyxOb/j5PHa1PvgK3iAgOQF
         M4qjzIy9bXfAkoQBrPUXgb71QMvi2frQoao9y53nthE4CTwSihORVUEcjYli+BRMlSGS
         Qh3aQPJ55B9DHrF+7cvAyJfosAlKKKJBwBIVPxnnt10VFTeWihoFf9EJ/b1LFG+hKt4n
         NBMj+emkh4pR4JEb7DW5FgxOCGU5gsD33pU7MiyCuKu8AyYeitIka89c2HumsLDbwQBl
         WdbQWm9X2vegmSr/DTVtZNIcCvD4yRvENusxcYHLszeOsJt9QYXiqB/qVzkGKFKotRLx
         ar/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792105029; x=1792709829;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/YhvPX63WhKZhARuu1HmFY4xNJMDfXUK6E12n5qI6pw=;
        b=jX28zeAwAHZWUro5S/FrcAcfJq7YtK6kxnIW5+Y33lxBZLaV/M2SZwHkGEPUnGkuvb
         0wQTY3xx9kqmx7voUkZNuzYrr58aCWEqlPJamYKXXoA85Xlr9IxjE+ZLqQTqwfDAxwcI
         ORdKTzbM43ao1BRUrup/d2Pb9LXuepjCcRDcQSmteDoREPEStjJJvPsRfjKR0ToEghiS
         GOMz2G/3Fsn5zMv82XsP+axDyX/By3hAVZNiHo0/EV6r0AnS5A3mnGIY2afPNT5tJpa7
         jvDcJdaX367fKwrJaPEPUzGHsO5JYpAINwwcu1EwAtHoUtJ6CLMYkKdoR5D9GnJZlBsr
         7J8g==
X-Forwarded-Encrypted: i=1; AKwUvByx3gC6x0q7LCI/IBtnPMkzsovWEBMjmUEt0rIg3xbDCRgmkO4oPB1rwxIwSkTHwS/UMcfOHJmvW3N7O4CFjdY=@vger.kernel.org
X-Gm-Message-State: AFq9FYKJhkZl2yzNsRSrA+7t/DimwbrMM9jgWrQXEUR57OXFzi2S99rm
	2TdL87xMN8oYIVgxhFbtqFIyhaQ48bkgIKKM47Gcvo6sriYRwtdw/BHr
X-Gm-Gg: AYBFou2OH3BvWJ86MBxiso5rXXwRaJYu9jOCw/NLiqFnaDAQtGOIxIdD/n3gu0GZmXQ
	oL18eeDCxxusPN2u7iQF+3xPqRC5pPjtKnUjFM/poF54xNTM7Bx6h883FK4Ik6hIRey1I7JNU/m
	n+r1NE0HDooyJ3B/SkMBIpXrA5VgXd2HG9PBSHBJIdFBWQ+tM2Zr2Q0OWr+Rkn2Z39VX/AyDMVJ
	G+6RTl0W0Yk9ISxoQyvb3jcoJ1UxcYIACV1D7vJUJozNlWqLZOFsn8tV/7GA4tZNqsVRXJj2Dsw
	I59en5t2pkUMafXddBpEg1J+JHXIR+UVhGc7FElb8EfHljvC5XfKUjQQZGl3v4KFsFEDfi3qitg
	B0Imu0xyJPfLzNGJg4G/NVwQBblxs9TliqkjrcfRIkWXBOv794HmngHNDG+s09IhLXla7iFclfi
	WuSk0yhipQTgzK5Y6QlEDkqaUbqZH7ZL+fxzLyv8XVSXtgkxDp3G2JSmZbssAcLjvwDRAQKTlvQ
	Ccnf1SSRGmNNn7G+Ge837Vkz2FJlQyk4Qn3IpeQKrHiqNdD3SV+fqOQmZdCbQ1oQYsruh60f6Lr
	7d5zYyhpPMGjd0fUidIFit/UpkZ0aSiQIe65cSlYnIvMEFKwbWJ+PyDF/39OtffVEC0qbhRiJkF
	u1KznGmhr5KFvLT1dyJ4skFLMnxIOiafq0tmwAEXg+EfP9Hs=
X-Received: by 2002:a05:620a:6405:b0:93d:e031:5ad with SMTP id af79cd13be357-93ebd224911mr3171594785a.17.1792105029576;
        Thu, 15 Oct 2026 15:57:09 -0700 (PDT)
Received: from saif-MS-7E77.lan ([197.6.96.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a18510fsm53326485a.22.2026.10.15.15.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 15:57:09 -0700 (PDT)
From: SaifAllah benMassaoud <saifmassaoudi18@gmail.com>
To: pablo@netfilter.org
Cc: fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	security@kernel.org,
	SaifAllah benMassaoud <saifmassaoudi18@gmail.com>
Subject: [PATCH nf-next] netfilter: nft_limit: reject configurations that cause integer overflow
Date: Thu, 15 Oct 2026 23:57:05 +0100
Message-ID: <20261015225705.76031-1-saifmassaoudi18@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aswI8NBK6sLj-fdk@chamomile>
References: <aswI8NBK6sLj-fdk@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Byte-rate limits using long time units (e.g. bytes/week) can overflow
priv->nsecs * skb->len in the packet-path cost calculation, silently
defeating the configured rate limit.

Reject such configurations at rule-add time instead.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: SaifAllah benMassaoud <saifmassaoudi18@gmail.com>
---
 net/netfilter/nft_limit.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index 167d99b1447f..d92455fc8665 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -13,6 +13,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/gro.h>
 
 struct nft_limit {
 	spinlock_t	lock;
@@ -58,7 +59,7 @@ static inline bool nft_limit_eval(struct nft_limit_priv *priv, u64 cost)
 static int nft_limit_init(struct nft_limit_priv *priv,
 			  const struct nlattr * const tb[], bool pkts)
 {
-	u64 unit, tokens, rate_with_burst;
+	u64 unit, tmp, tokens, rate_with_burst;
 	bool invert = false;
 
 	if (tb[NFTA_LIMIT_RATE] == NULL ||
@@ -73,6 +74,10 @@ static int nft_limit_init(struct nft_limit_priv *priv,
 	if (check_mul_overflow(unit, NSEC_PER_SEC, &priv->nsecs))
 		return -EOVERFLOW;
 
+	if (!pkts &&
+	    check_mul_overflow(priv->nsecs, GRO_MAX_SIZE, &tmp))
+		return -EOVERFLOW;
+
 	if (tb[NFTA_LIMIT_BURST])
 		priv->burst = ntohl(nla_get_be32(tb[NFTA_LIMIT_BURST]));
 
-- 
2.53.0

