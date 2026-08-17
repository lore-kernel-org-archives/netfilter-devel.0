Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0943B71B0
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 07:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786950880; cv=none; b=EfLVLEmrOsXU+4T6Z8OG1IEFyqnHc4PkDzjyUDURxvLrCqyN03q9p5WeWIoOlgK0ZSgvPNO+GoaYFaLvO/Co07wkPr+FnuFhEyZR7hxhO8kV3+fidJt2UdJzteIuVEDppmkF4AXLMpcUHW+dgfPjzz/yjq6nm0M7Q5zwaN/m0Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786950880; c=relaxed/simple;
	bh=Ifn6OQnRHmSsxgixo8MsCSBtwEbCzzopUABgiunYuSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQPISRTm8C0pfj8eJBR80KXikEpXwWjHRf1N9h9WiAbpclBH2WC7bBmk/TbSfySiycvkRbsUL9Qn0LIPubMli/lxO1/tf1ZRQzvaEG2+CZMugmytjYjpyM9+jplum2O1EZcxh2XBrzq/gPfXxkfNHhnqGmgQ0yL6SjTDkSnZ04k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=LCVpSXr2; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="LCVpSXr2"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-84f3ab8750cso1924675b3a.0
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 00:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1786950878; x=1787555678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kJu7dQTeNe6m5Lnp0IlHAvUypghyn4/ScR3/79E4HJ4=;
        b=LCVpSXr26L+RZLRBq6dEufg8otOKqOCfOETWGvkirt08QN7nUHsVQ9F4bsd2kMZzFS
         OsfW0bo1+pQ/iQvo71PZaZfEEKISdnj1k/N4gAyvl+J+/uP6iQ8j0XV4ZWL/vZ9WDqWO
         rkmpPES0iD47062BIHd3Hmc2R5z0lOS4L9JRcD6paa3/WwZa/gbBJ5pz6tW2EO/U/EIZ
         Ujlm2XgrzfllUVsblC+tMxyet1xGECd5i0ZvnyD63g4C22w0H7tOAYvLHqHnWhF1sotk
         bFlUoIABHE1kMY6ehmWYU5vX/1TAT4L4pPBUgoYaE4n8p0iWfhZ0+7A3DM2z+irwH+u1
         YeFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786950878; x=1787555678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kJu7dQTeNe6m5Lnp0IlHAvUypghyn4/ScR3/79E4HJ4=;
        b=cLGfbi1QPO0ez3Yrlu4a3bZyCZ8tefmvu0vU5+H8KqTp+xaMBjAE/hCoa7cVKOCbNW
         tNAUHw5OkPe2gr36KdHSUwS+paoyDjDvUT39DvTGcaJ5eJPyvjX6a5n2PHkXA7QXjSDq
         Vl3lMSj+QNo9KZjjSWD4GoqLWA8EMcCovkAFyo+6oqj1G5aMvjr4xL3NBLTWwI+xdiX7
         t04BqYSLBYPxKsgdWxGrp+WAzBC1hveHw9ij2vFlZKlV3FHh/8o8pPbvycia1/f9vRmd
         80T+LvqDyF8s8wArelFhAou7GGajpmOJQSClQR6CF3/sVAr+r0OvW9YetF8qnNkaCYOS
         31BA==
X-Forwarded-Encrypted: i=1; AHgh+RrjlUgKI7y/V5vQTzECJLQEXQilTGbIjAYsyLLCTGec6q8hiRrl1FgWjdjiPR3BnI9VNOS+s8A7OTwtRmTvIto=@vger.kernel.org
X-Gm-Message-State: AOJu0YzimFVKnbaBhXvrgKn3gqAvWNqIajzAYf/b0fk59k/Ct79M6qbY
	MYX0H2OsJnLw5w653ON/qyPfYr4bSVVBcXeuGv+9dCwrJy7znMaPL6fdu46e81bVEvy4
X-Gm-Gg: AR+sD10CP+u3B4f79ciqsOlzyb7a6Iib1LvBbnu9bk8hTSm+SMqM+p++lMkRRpVp1Tz
	Xpenc/tvsDE99+f4EHSacTrshLCQzuBskswpnZ6xEBkyGsZay9GHljnKJH2F0m+SGjobV1hQ1+4
	h3sQkwTr5xcQTb4fvkN7zNdoipkSyGXk4FwvbjFGLAij/qelLzmMH5iJKmKMu0qTyBgnOrlZXbg
	IFjNced8DehgQX0/jjXPy81srwgRqiXjuZGvtd2Nv8+qvx5RCyAQKTHdUKHt7yd4R3e4LhlgRaF
	2bkiLcAtn0FPZecT0LyOinzV+tRKNLdhBe0HUQwpQ6h9CDKy/S/d4zNDsUt5bZfVj5kdrFpXw0h
	ZfryRXFVwL0uZx2xLfNAIubSomlkPPeWR/HpHVTTbrRoIFumnpC7PJetaFtJVZIVZFlqXesCaBp
	biNIxmJymCMvSZH8CvYB2kx9x3/VgX73d1xykhIHs+30ddyBwJvh16a1kUBvzQPefOdHl0ZkBYD
	bgg9l/c3fHeBxs1lmPBvgbPgPpfV0LdlZ/oSTam5iRSeA==
X-Received: by 2002:a05:6a20:a126:b0:3c4:3112:3b with SMTP id adf61e73a8af0-3cc71ccf668mr24775404637.18.1786950877680;
        Mon, 17 Aug 2026 00:14:37 -0700 (PDT)
Received: from Roxy.localdomain (n220246089185.netvigator.com. [220.246.89.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc13bf0563esm272327a12.6.2026.08.17.00.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 00:14:36 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	ja@ssi.bg
Cc: horms@verge.net.au,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH nf v2 1/1] ipvs: bound LBLCR and LBLC cache growth
Date: Mon, 17 Aug 2026 15:14:22 +0800
Message-ID: <17cbb1d0649f4e19aa2e407ab4b528d42b8edac4.1786949472.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1786949472.git.zhilinz@nebusec.ai>
References: <cover.1786949472.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ip_vs_lblcr_new() and ip_vs_lblc_new() create cache entries for
every previously unseen destination address. The table max_size only
tells the periodic collector to reclaim entries after the cache has
already exceeded the limit. It does not reclaim entries that the
attacker continues to use.

Reject new cache entries once either table grows beyond max_size. The
existing scheduler fallback continues to use the selected destination
when cache creation fails, so new traffic stays serviceable without
growing the tables further.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
---
changes in v2:
- Change the LBLCR limit check from >= max_size to > max_size.
- Apply the same cache growth bound to LBLC.
- Add Suggested-by: Julian Anastasov <ja@ssi.bg>.
- v1 Link: https://lore.kernel.org/all/62790a9f94ac5318f107a1811cff5a1f2fc7e0bf.1786884824.git.zhilinz@nebusec.ai/

 net/netfilter/ipvs/ip_vs_lblc.c  | 3 +++
 net/netfilter/ipvs/ip_vs_lblcr.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index 693bcc82ccb77..106eae24d3111 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -204,6 +204,9 @@ ip_vs_lblc_new(struct ip_vs_lblc_table *tbl, const union nf_inet_addr *daddr,
 			return en;
 		ip_vs_lblc_del(en);
 	}
+	if (atomic_read(&tbl->entries) > tbl->max_size)
+		return NULL;
+
 	en = kmalloc_obj(*en, GFP_ATOMIC);
 	if (!en)
 		return NULL;
diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
index f53f05ceea36f..6e76808063d69 100644
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -363,6 +363,9 @@ ip_vs_lblcr_new(struct ip_vs_lblcr_table *tbl, const union nf_inet_addr *daddr,
 
 	en = ip_vs_lblcr_get(af, tbl, daddr);
 	if (!en) {
+		if (atomic_read(&tbl->entries) > tbl->max_size)
+			return NULL;
+
 		en = kmalloc_obj(*en, GFP_ATOMIC);
 		if (!en)
 			return NULL;
-- 
2.43.0
