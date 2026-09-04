Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B834A1F4634
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2026 17:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788543253; cv=none; b=I5UhBa2Ym6yoVuw80hlbHvyXLqXIyX4UHlQa2gkNIFNJKMbFnWYU+5f+aqcF1MSOLP7J7oK9WAHfcl1yH+FksfOfPdBncffqiMAYjRVsGlut5Pmd+OD6ksLACDwTolMVYS9qRLvwFrYmGaml78TxnK3nectI3O7cdaYIxb62w5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788543253; c=relaxed/simple;
	bh=q6g0iRDGfUkmM8AGPcbHgGlDpLoe6UU6DOYnE7l90vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cz1PDTLIDxrKEf0yd1aUsp+bqmm5v+Apc/dLyA3p9GMMYYjE4Q19WuFUoSsylp0E+E3XtAxwXGbTVraG3jwc1pRMmFhicSLsyXOjpv7pU7/dACSvO+CUOInUZ2+FzHEldRBCx05zqH2tRojtGhHC+au3AXZ75rBy3Ln1PHiLgLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=b3vG+d+d; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="b3vG+d+d"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-459281bc13bso988597fac.2
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Sep 2026 10:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788543250; x=1789148050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nBAIhB6mUWEiC6BEtbsmZb+5G7JKr6t4mMZJzD68LbI=;
        b=b3vG+d+dQZO+ZKg4NgKmzxt2Cv2XeWPgtmMe2anSXIFgz9SYXMuLthEAEGhZEBYr4T
         ddGMp3b8JiC9LZ983wiQfHK9utNIjxehJasR1A7dnH05D9jCcRSVHk1/yPxkVQYIWD/Y
         4Rwd/WMUp9Azbp2zN/z8GjI3zZRCkn3qHPMUNdv+N6R1oAVaecxJpDcdccOmAC/jCjUn
         wt+Kw92EUO2ff1xAjbUZgethk5tkEW4+EQ/xC/Ub6ZMhIUscNsoM1lsfhWU6EMzFJWe5
         GJIP4KyfkaA9VPy9+6NrMLFvNHJfBu9yrIO3NrOanh0cvF7qOd355Og46qYJ0F3NUsKX
         16nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788543250; x=1789148050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nBAIhB6mUWEiC6BEtbsmZb+5G7JKr6t4mMZJzD68LbI=;
        b=YgsRTeFitDY4bdyoDwx/a1h7H8jbebZcrTSojvnnPKKhyd4cOEco72cbz1fo2vqWJ2
         Km9DdveRvB9i/TiaUHWZM8+hVXWH1W7xrq5MGD8qLhoj+votH0XsYGBMBpDrvAJMcVvZ
         AEQrex4rMtkKovNzK4rHkXlZ1izJxtx/iUh2w/PNUzs2r8WrJkKYS4bfMO197bkMHbU9
         gSxam6Xo8BYrZCa/8U/PMKVlC5LKeDBUKgTbixyIQM7TopuYPPIkPkseeCWNra4ncTEs
         ZF/FYtQJhhjQcpaQ6o2N/7EyPB+zeeOB9ho6td9lCGpd/wUP+a7Zv6nFVWR7yFlZNmjN
         aWLA==
X-Gm-Message-State: AFuF++kKjAlNhpWv0BsUfg7sZfjMachivyQrJ20oFfO0iMoi5bdx4RiQ
	gncIxH7JCx6/jgQKjPcCflz3Q6/UZbUEdXXYLmR9jA8kVKajLeWtZjbgUScLKMVgFOLieAEu06W
	qfYlb5VAX
X-Gm-Gg: AYBFou1yofN1n4iuX8y8epi9rw0t6Dj+4GOFkOdvDx77iR9n93rS9lzwCfMAZDmuIO7
	ubqx0bnnqBNYitFeOMYhTwKlJq3lqIEJh4VJFPoL0Ziu/uCAloP9HwsdafvEBH1FUfqdAD+YonM
	IdH4fDxq2QTmfjJGBexDN0Yae9NkoFb/TxST9R3lcGFukiXRCRMM6Eouk2G91DB9gC3l+Wmu3h8
	gf4uUTKxMNoQWCztjZBVvTJ1nDuyhhkM9+Y+W4CaV9FJWV73a6wQUEk5enkmcTV83QZj6ZkxRq/
	CS3YUgfDiN4FQGzIgRyixpmMh+YQkPQK+f6m6x0he7eCM3yeUhiSeNm93EzFR3rhHr64oH+W9LB
	ov4EcUxM8CY7qRFG2pHPWWQB4nq9h/Sd0OamBRd05IPqb20RsPGahQlnIlhbDhQ35+LFEfgRzjo
	BZNrhmvQHD1uenn8gUwDbcjo+MW0i8kE7xbUiWVaCVlt8r/wCRXs2ZYbWMElFDXBF86L8FEg==
X-Received: by 2002:a05:6820:c86:b0:6b1:4806:f218 with SMTP id 006d021491bc7-6b6fb0deac6mr6049350eaf.14.1788543250308;
        Fri, 04 Sep 2026 10:34:10 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([165.232.167.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1432435648esm9761830c88.5.2026.09.04.10.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 10:34:09 -0700 (PDT)
From: Ren Wei <weir@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	vega@nebusec.ai,
	rakukuip@gmail.com,
	weir@nebusec.ai
Subject: [PATCH nf 1/1] netfilter: ip6t_rt: fix zero-address non-strict match out-of-bounds read
Date: Sat,  5 Sep 2026 01:33:53 +0800
Message-ID: <902c0940944fc2401aafed55dbb356056ec8ecbb.1788337633.git.rakukuip@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1788337633.git.rakukuip@gmail.com>
References: <cover.1788337633.git.rakukuip@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luxiao Xu <rakukuip@gmail.com>

rt_mt6_check() allows rules to be configured with rtinfo->addrnr == 0.
In the IP6T_RT_FST_NSTRICT path, rt_mt6() enters the routing-address loop
and compares each packet address with rtinfo->addrs[i] before checking
whether i has already reached addrnr.

When addrnr is 0, if the first packet address matches rtinfo->addrs[0],
i is incremented to 1. Because i is now strictly greater than addrnr (0),
the loop termination condition (i == rtinfo->addrnr) is bypassed and can
never be met.

A crafted IPv6 packet with consecutive matching routing header addresses
can advance i up to and beyond IP6T_RT_HOPS (16). The subsequent call to
ipv6_addr_equal() accesses rtinfo->addrs[i], resulting in an out-of-bounds
read past struct ip6t_rt into adjacent xtables memory, triggering UBSAN /
KASAN warnings and kernel panics.

Additionally, this logic error causes packets to fail rule matching when
the first address matches, allowing traffic to evade firewall rules.

Fix this by properly validating rtinfo->addrnr in rt_mt6_check() /
handling zero addrnr in rt_mt6().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
---
 net/ipv6/netfilter/ip6t_rt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 8051425213dd..cab169b5563a 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -162,6 +162,12 @@ static int rt_mt6_check(const struct xt_mtchk_param *par)
 		pr_info_ratelimited("too many addresses specified\n");
 		return -EINVAL;
 	}
+
+	if ((rtinfo->flags & IP6T_RT_FST_MASK) && !rtinfo->addrnr) {
+		pr_info_ratelimited("address list match requested but addrnr is 0\n");
+		return -EINVAL;
+	}
+
 	if ((rtinfo->flags & (IP6T_RT_RES | IP6T_RT_FST_MASK)) &&
 	    (!(rtinfo->flags & IP6T_RT_TYP) ||
 	     (rtinfo->rt_type != 0) ||
-- 
2.43.0
