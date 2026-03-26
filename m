Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380282798ED;
	Thu, 26 Mar 2026 12:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774529525; cv=none; b=HhhyadEJ2FOnYd/z18ij/c/PpIgLFVzi3gSpsRuZrmFs5AL6a9hEy4vgeNNTX9oz+gkql7zVsJbeIK6BvzMttTq1iwrDLlkTStnxCd3sUyorAEvOFnbHiUh7DBmkWjF6RYiN/H0YjEGuxiRa3XaFHo57ue6JKzQvTiVI93cKKA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774529525; c=relaxed/simple;
	bh=3M8SeXoNHLSfSINMUuDheIWOSxvuF8h+a8P9Ia2Rlqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwZPxVW2VgUgwMdRD2yr0VMddUjUd/G7S4lDFkIEcQs/zaQrF8W+4B4vOQ8ElaE2DyCIjd0buIWfrrLMrp6y8L7R+2vJLJPBiLU/GxnrkGDDxS7PVmZiaHir6YbuB64zvlF9/vH8MYmLzbUNO+EpdQsGxC39aT2HRzefzjCl+9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rqC4uTyt; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rqC4uTyt"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2D19660272;
	Thu, 26 Mar 2026 13:52:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774529522;
	bh=GWPRWf1+yS2roJCPasyquMCXNaZuktYHTHQ8GKT903w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rqC4uTytLlUsw0OJOGg0IIe1fICqMoszoWr8hKbg2u5s5x7V2/VJKzcyTlLrr5wOB
	 wSUitWrFnkLTmOzuqVeqlmpN4fqOGfSDHv6sSXDwd9ql8pd6VSoY2nv6lCZfMIaQTq
	 K1J8m0fRLCn1oE1gW09KXCm/bjdE2s8Sbg4/J8Xm6LSXW5MIog7oMufPso0i0/Zcm+
	 6tH5nvKZTtwkqRuRsbfgocaxIVirSFZ/E6cPon3wyHjKg2PMst/FfZUL4O3zeplpMN
	 l0xkrDTGjbn3s/2YiQvAGmo4anAtYWKgLiuAOgFg+3Fpuu+VJAQa7MtkS208xtMKgt
	 WiW/+CpWGQCQA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 04/12] netfilter: ip6t_rt: reject oversized addrnr in rt_mt6_check()
Date: Thu, 26 Mar 2026 13:51:45 +0100
Message-ID: <20260326125153.685915-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326125153.685915-1-pablo@netfilter.org>
References: <20260326125153.685915-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ren Wei <n05ec@lzu.edu.cn>

Reject rt match rules whose addrnr exceeds IP6T_RT_HOPS.

rt_mt6() expects addrnr to stay within the bounds of rtinfo->addrs[].
Validate addrnr during rule installation so malformed rules are rejected
before the match logic can use an out-of-range value.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Yuhang Zheng <z1652074432@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/ip6t_rt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 4ad8b2032f1f..5561bd9cea81 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -157,6 +157,10 @@ static int rt_mt6_check(const struct xt_mtchk_param *par)
 		pr_debug("unknown flags %X\n", rtinfo->invflags);
 		return -EINVAL;
 	}
+	if (rtinfo->addrnr > IP6T_RT_HOPS) {
+		pr_debug("too many addresses specified\n");
+		return -EINVAL;
+	}
 	if ((rtinfo->flags & (IP6T_RT_RES | IP6T_RT_FST_MASK)) &&
 	    (!(rtinfo->flags & IP6T_RT_TYP) ||
 	     (rtinfo->rt_type != 0) ||
-- 
2.47.3

