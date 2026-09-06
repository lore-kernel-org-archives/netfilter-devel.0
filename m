Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86E225B08B
	for <netfilter-devel@vger.kernel.org>; Sun,  6 Sep 2026 13:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788701419; cv=none; b=QvA7u6so1EDvvZpw+WZW+Zpx+v30w4ON4EUInvAQuxxVfy8SrAFCsbwMyI3GLKYd4JdYm3AlcQLt8BR29qWJe6TDbehA7HjJqC5ZoHDXUaojcb0rEavsHsPhSaGUg4J7PRI5yG1wLcMGJ6fg6yu6HJ0HRENkaL6n1IyRFuDp57U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788701419; c=relaxed/simple;
	bh=QgLqDC8ceFh0N/U4qqnsuiNoO68fGeboa+IAzsj4CpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XG3WRmIEx20l1lkjSed4sE3WqHz+34dtXed6m/DkVJivhnPeD0eUr2/PAUGcZg3wKdG41AdMePOZzz1CYHPjUr0CshBBNku8DJVFTisy1NpxlXH33dgeT5GZN7hATgr3rla3lsUCIaR5hzb1iHM16xSN+of5eTywySVd/VYcPLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=TZcz4Mv/; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="TZcz4Mv/"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38759bcd877so2614119a91.2
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Sep 2026 06:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788701415; x=1789306215; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mf8iqB5QSUOF5dNhC5pZBehiD6kfWnst/UTBMFHxzHA=;
        b=TZcz4Mv/la1XrFtUExdfMTFlzdjm4OusMeRD0AfvKBt3ECTDWgRrc2ysmnJuKMbjwp
         ywuZb/ldJtcjyKzSC9BH9z3PzN5kn0wqXtWTTcDr/taIQimCTYGylGR/kOORz0x1W27r
         hQsrcW67ybJkVWQ7mgXtIH3hL9x/q3/ssoe1oPkPpXOwmyt8jAvrrk/pe3P9kko9g9O2
         K0U0fmMVJ7YhLfY+AlPZFR2mVx2ngc4XXFvFRmNJDblLsVZLSeAaJji5O2BA839fwkrM
         ZyszZJcpNUA1q/sTAW/FBSJMB7t1kh0IeMQnJaMfEFJJ1HpwYaRLPzRbOiUtZ6GcPWGK
         8JwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788701415; x=1789306215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mf8iqB5QSUOF5dNhC5pZBehiD6kfWnst/UTBMFHxzHA=;
        b=RHR+RiGA4yqdz+I4Ll07p2LtpcHscME0XtVddv+MoHUrSCcGZL3lmHol7/ateV9aF/
         hdKeqCWf0cHbZ0ItaQFAv7eXGNtvLaNMeiVs33XGlssFl1fdsUaj+D/K58uJhvOLqytj
         ljfkqBz0hzTsSGRaCLEkOMDexTXheUmEZl6Z8OT5H7ireszF2NmbagHKE9guYdzMObBS
         By49j72zIjG36BR1+UIwdBQFOUQWP5SemAMyndqbs7QGjuTAKo1lje1EENaBd+xvA147
         An5AhR7DEEvaJPxaEYWuR8POCPGlakQf3dq9vvC4d3KlhP6nqt3c4tlbnYs/YxMquKsq
         zrsA==
X-Gm-Message-State: AFuF++l/6D5dQxV3g0ECHsUBOJslgLLBdzZYfXgY28NLDcPNVCRYLwSh
	dyssURl1znNZRelAkablptKcVNlCYO44RgMhx7wCwCimE44ntllskzurNJJM+dHF6rd0EHPf/eb
	EYrBzXw==
X-Gm-Gg: AYBFou1P6NIcYZ2GXhnK0n85LJg/9aH1JRetPPzUSQzwT3C0I4mkDKnVWM8lUKeKK2z
	kLpRpnSJw4croudv7GAQ/yiHOv4VW56CbiDkkzx1jorz9jezAekBSBgng2r9LzWoKCqnDOqr2GD
	9a2/SQshNHgnYB3rGRB8NPyNULQypd/iySNkSJCg3AOnTL9t6mcm3E6EZz6LCcXhXys4zDZFQZu
	3TPfN2EPPG6v9ZovcBgW2d8sYtvEm/WidQ5UENlxuqmIq4rRQtwc+h6EJus6PKDQc9j5r1E3Y3p
	hVgGJKP1BJs6HIfQ8UAlFnxkEXG+xVV14yvUnS4ydcBKCEfuXTh0L0oAvID+kRaHPgxegihVUt5
	etcAkQRLX36kTk/aqalZAGzyAvN2sPZ0Ew0qJOIN9dfvRYFzJgyh9yO+rKxgOQgQiyjyfkoqSnO
	9gBO5p1H2d71+R5B3e7nhL3Dog2ENot+2z+XzI7eCaAQr1cuiALfUsbfdWE8dE0cJRIt4fDA==
X-Received: by 2002:a17:90b:498c:b0:38f:7f60:ba35 with SMTP id 98e67ed59e1d1-39b260d3351mr24571140a91.5.1788701414780;
        Sun, 06 Sep 2026 06:30:14 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([165.232.167.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b26123c99sm15017769a91.11.2026.09.06.06.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 06:30:14 -0700 (PDT)
From: Ren Wei <weir@nebusec.ai>
To: netfilter-devel@vger.kernel.org,
	fw@strlen.de
Cc: pablo@netfilter.org,
	phil@nwl.cc,
	vega@nebusec.ai,
	rakukuip@gmail.com,
	weir@nebusec.ai
Subject: [PATCH nf v2 1/1] netfilter: ip6t_rt: fix zero-address non-strict match  out-of-bounds read
Date: Sun,  6 Sep 2026 21:29:55 +0800
Message-ID: <d878e79bb3d3d45e9b8a343111d1a3bd927a115a.1788582542.git.rakukuip@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1788582542.git.rakukuip@gmail.com>
References: <cover.1788582542.git.rakukuip@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luxiao Xu <rakukuip@gmail.com>

rt_mt6_check() permits rules to be configured with rtinfo->addrnr == 0
even when address matching (IP6T_RT_FST_MASK) is requested.

In the IP6T_RT_FST_NSTRICT path, rt_mt6() evaluates packet routing
addresses against rtinfo->addrs[i] and terminates backwards at the bottom
of the loop:

    if (ipv6_addr_equal(ap, &rtinfo->addrs[i])) {
        i++;
    }
    if (i == rtinfo->addrnr)
        break;

When addrnr is 0, if the first packet address matches rtinfo->addrs[0],
i is incremented to 1. Because i is now strictly greater than addrnr (0),
the loop termination condition (i == rtinfo->addrnr) is bypassed and will
never be satisfied.

If a crafted IPv6 packet contains matching routing addresses, i will
advance past IP6T_RT_HOPS (16). The subsequent call to ipv6_addr_equal()
reads beyond struct ip6t_rt, triggering UBSAN/KASAN out-of-bounds warnings
or kernel panics.

Fix this by:
1. Rejecting rules in rt_mt6_check() where IP6T_RT_FST_MASK is set but
   rtinfo->addrnr is zero.
2. In rt_mt6(), moving the termination condition (i < rtinfo->addrnr)
   into the for-loop header condition and removing the backwards break
   at the end of the loop body.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Suggested-by: Florian Westphal <fw@strlen.de>
Assisted-by: LLM
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
---
v1 -> v2:
 - In rt_mt6(), check i < rtinfo->addrnr in the for-loop header and
   drop the backwards loop termination break at the end of the loop
   body (Florian Westphal).
 - v1 Link: https://lore.kernel.org/all/cover.1788337633.git.rakukuip@gmail.com/
---
 net/ipv6/netfilter/ip6t_rt.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 8051425213dd..9880faf3cc7d 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -96,7 +96,8 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 			unsigned int i = 0;
 
 			for (temp = 0;
-			     temp < (unsigned int)((hdrlen - 8) / 16);
+			     temp < (unsigned int)((hdrlen - 8) / 16) &&
+			     i < rtinfo->addrnr;
 			     temp++) {
 				ap = skb_header_pointer(skb,
 							ptr
@@ -112,8 +113,6 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 
 				if (ipv6_addr_equal(ap, &rtinfo->addrs[i]))
 					i++;
-				if (i == rtinfo->addrnr)
-					break;
 			}
 			if (i == rtinfo->addrnr)
 				return ret;
@@ -162,6 +161,12 @@ static int rt_mt6_check(const struct xt_mtchk_param *par)
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
